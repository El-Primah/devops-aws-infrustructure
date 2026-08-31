import base64
import os
import re
import boto3
import json
import time

from botocore.signers import RequestSigner
from kubernetes import client
from kubernetes.client.api import core_v1_api
from kubernetes.client.rest import ApiException
from kubernetes.stream import stream

cluster_name = 'comp-tf-production'
aws_region = 'eu-west-1'
namespace = 'dfg'
service_name = 'meme-cloud'

def get_bearer_token():
    STS_TOKEN_EXPIRES_IN = 60
    session = boto3.session.Session(region_name=aws_region)
    client = session.client('sts')
    service_id = client.meta.service_model.service_id
    signer = RequestSigner(
        service_id, aws_region, 'sts', 'v4', session.get_credentials(), session.events
    )
    params = {
        'method': 'GET',
        'url': f'https://sts.{aws_region}.amazonaws.com/?Action=GetCallerIdentity&Version=2011-06-15',
        'body': {},
        'headers': {'x-k8s-aws-id': cluster_name},
        'context': {}
    }
    signed_url = signer.generate_presigned_url(params, region_name=aws_region, expires_in=STS_TOKEN_EXPIRES_IN, operation_name='')
    base64_url = base64.urlsafe_b64encode(signed_url.encode('utf-8')).decode('utf-8')
    return 'k8s-aws-v1.' + re.sub(r'=*', '', base64_url)


def create_corev1_api(cluster_endpoint, cert_authority):
    configuration = client.Configuration()
    configuration.api_key['authorization'] = get_bearer_token()
    configuration.api_key_prefix['authorization'] = 'Bearer'
    configuration.host = cluster_endpoint
    configuration.ssl_ca_cert = '/tmp/ca.crt'
    return core_v1_api.CoreV1Api(client.ApiClient(configuration))


def get_pods_by_service(api_instance, service_name, namespace):
    try:
        pods = api_instance.list_namespaced_pod(namespace)
        filtered_pods = [pod.metadata.name for pod in pods.items if pod.metadata.name.startswith(service_name)]
        return filtered_pods
    except ApiException as e:
        print(f"Error fetching pods: {e}")
        return []


def exec_command_in_pod(api_instance, pod_name, namespace, container_name, exec_command):
    print(f"api_instance type: {type(api_instance)}, pod_name: {pod_name}, namespace: {namespace}, container_name: {container_name}, exec_command: {exec_command}")
    try:
        resp = stream(api_instance.connect_get_namespaced_pod_exec,
                      pod_name,
                      namespace,
                      command=exec_command,
                      container=container_name,
                      stderr=True, stdin=True,
                      stdout=True, tty=True)
        print(f"Output from {pod_name}:\n{resp}")
        return f"Executed in {pod_name}: {resp}"
    except ApiException as e:
        return f"Error executing in {pod_name}: {e}"


def lambda_handler(event, context):
    execution_command = event.get('execution_command')
    service_name = event.get('service_name')
    eks = boto3.client('eks', region_name=aws_region)
    cluster_info = eks.describe_cluster(name=cluster_name)
    cluster_endpoint = cluster_info['cluster']['endpoint']
    cert_authority = cluster_info['cluster']['certificateAuthority']['data']

    with open('/tmp/ca.crt', 'wb') as f:
        f.write(base64.b64decode(cert_authority))

    api_instance = create_corev1_api(cluster_endpoint, cert_authority)
    pod_names = get_pods_by_service(api_instance, service_name, namespace)
    
    if not pod_names:
        return {'statusCode': 404, 'body': json.dumps(f"No pods found for service {service_name}")}
    
    results = [exec_command_in_pod(api_instance, pod, namespace, service_name, execution_command) for pod in pod_names]
    return {'statusCode': 200, 'body': json.dumps(results)}
