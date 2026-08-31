
import os
import subprocess
import yaml
import json

# Namespace in Kubernetes to check images
NAMESPACE = "dfg"

# Path to the Git repository (comp-infrastructure)
REPO_PATH = "/opt/comp-infrastructure"

# Environment name (default is "staging"), can be passed as ENV=prod python script.py
ENV = os.environ.get("ENV", "staging")

# Path to Helm values directory for the selected environment
VALUES_DIR = os.path.join(REPO_PATH, f"charts/values/environments/{ENV}")


def get_images_from_k8s(namespace):
    """
    Fetch all deployment images in the given namespace.
    If there are multiple containers in a deployment,
    take the one where container.name == deployment.name.
    Returns a dict {service_name: (repository, tag)}.
    """
    cmd = ["kubectl", "get", "deployments", "-n", namespace, "-o", "json"]
    result = subprocess.check_output(cmd).decode()
    deployments = json.loads(result)

    images = {}
    for item in deployments.get("items", []):
        service_name = item["metadata"]["name"]
        containers = item["spec"]["template"]["spec"]["containers"]

        repo, tag = None, None
        for container in containers:
            if container["name"] == service_name:
                if ":" in container["image"]:
                    repo, tag = container["image"].rsplit(":", 1)
                else:
                    repo, tag = container["image"], "latest"
                break

        # fallback: if no exact match, take first container
        if not repo and containers:
            if ":" in containers[0]["image"]:
                repo, tag = containers[0]["image"].rsplit(":", 1)
            else:
                repo, tag = containers[0]["image"], "latest"

        if repo and tag:
            images[service_name] = (repo, tag)

    return images


def update_yaml(values_file, new_tag):
    """
    Update the image.tag value in given values.yaml file if it differs.
    Returns True if a change was made.
    """
    if not os.path.exists(values_file):
        print(f"⚠️ File {values_file} not found")
        return False

    with open(values_file, "r") as f:
        data = yaml.safe_load(f)

    if "item" not in data:
        data["image"] = {}

    old_tag = data["image"].get("tag")
    if old_tag != new_tag:
        print(f"Updating {os.path.basename(values_file)}: tag {old_tag} → {new_tag}")
        data["image"]["tag"] = new_tag
        with open(values_file, "w") as f:
            yaml.dump(data, f, sort_keys=False)
        return True
    return False


def main():
    # Switch to repository directory
    os.chdir(REPO_PATH)

    # Configure git user for commits
    subprocess.run(["git", "config", "user.name", "item-puller"])
    subprocess.run(["git", "config", "user.email", "item-puller@local"])

    subprocess.run(["git", "pull"])

    # Get actual images from Kubernetes
    images = get_images_from_k8s(NAMESPACE)

    changed_files = []

    for service, (repo, tag) in images.items():        
        values_file = os.path.join(VALUES_DIR, f"{service}-values.yaml")

        if update_yaml(values_file, tag):
            changed_files.append(os.path.basename(values_file))

    # Commit only if changes were made
    if changed_files:
        subprocess.run(["git", "add", f"charts/"])
        commit_msg = f"chore: sync image.tag [{ENV}] ({', '.join(set(changed_files))})"
        subprocess.run(["git", "commit", "-m", commit_msg])
        subprocess.run(["git", "push"])
    else:
        print("✅ All image.tag values are up-to-date, no commit required.")


if __name__ == "__main__":
    main()
