#!/bin/bash

REPOSITORIES=(
    "comp/ecr-repo"
)

echo "Begining imoport to Terraform state..."
echo "Total repo policy  to import: ${#REPOSITORIES[@]}"
echo "==============================================="

for repo in "${REPOSITORIES[@]}"; do
    echo "Importing: $repo"
    terraform import aws_ecr_repository_policy.read_only["\"${repo}"\"] "$repo" >/dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✓ Import successfull: $repo"
    else
        echo "✗ Import ERROR: $repo"
    fi
    echo "----------------------------------------"
done

echo "==============================================="
echo "Import completed"
