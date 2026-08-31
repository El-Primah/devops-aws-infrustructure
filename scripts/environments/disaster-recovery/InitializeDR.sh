#!/bin/bash

TF_DIR="../../../terraform/environments/dr"
SNAPSHOT_TF_VAR="TF_VAR_snapshot_arn"
SNAPSHOT_EXPORTED="false"

DR_REGION="eu-central-1"

NUMBER_SNAPSHOTS_SHOW=5

# arn of snapshot, created from shared snapshot
snapshot_arn=""

if [ ! -d "$TF_DIR" ]; then
  echo "--- Dir $TF_DIR not found ---"
  exit 1
fi

echo "--- Preparing DR config ---"

echo
echo "--- Choose deployment option:"
echo "    1. f_item (default) - (API Gateway & Cognito will be disabled)"
echo "    2. f_item + abc - (enables API Gateway & Cognito)"
read -p "--- Enter your choice (1/2) [default: 1]: " deploy_choice

if [[ -z "$deploy_choice" ]]; then
    deploy_choice="1"
fi

until [[ "$deploy_choice" =~ ^[12]$ ]]; do
  read -p "Please enter 1 or 2 [default: 1]: " deploy_choice
  if [[ -z "$deploy_choice" ]]; then
      deploy_choice="1"
  fi
done


if [[ "${deploy_choice}" == "1" ]]; then
    echo "--- Deploying f_item ---"
    echo "--- Disabling API Gateway and Cognito ---"
    
    # Rename apigw-consumer.tf
    if [ -f "$TF_DIR/apigw-consumer.tf" ]; then
        mv "$TF_DIR/apigw-consumer.tf" "$TF_DIR/apigw-consumer.tf.disable"
        echo "--- Renamed apigw-consumer.tf to apigw-consumer.tf.disable ---"
    else
        echo "--- apigw-consumer.tf not found, skipping ---"
    fi
    
    # Rename apigw-cor_item.tf
    if [ -f "$TF_DIR/apigw-cor_item.tf" ]; then
        mv "$TF_DIR/apigw-cor_item.tf" "$TF_DIR/apigw-cor_item.tf.disable"
        echo "--- Renamed apigw-cor_item.tf to apigw-cor_item.tf.disable ---"
    else
        echo "--- apigw-cor_item.tf not found, skipping ---"
    fi
    
    # Rename cognito.tf
    if [ -f "$TF_DIR/cognito.tf" ]; then
        mv "$TF_DIR/cognito.tf" "$TF_DIR/cognito.tf.disable"
        echo "--- Renamed cognito.tf to cognito.tf.disable ---"
    else
        echo "--- cognito.tf not found, skipping ---"
    fi

    # Rename lambda-cognito.tf
    if [ -f "$TF_DIR/lambda-cognito.tf" ]; then
        mv "$TF_DIR/lambda-cognito.tf" "$TF_DIR/lambda-cognito.tf.disable"
        echo "--- Renamed cognito.tf to lambda-cognito.tf.disable ---"
    else
        echo "--- lambda-cognito.tf not found, skipping ---"
    fi

else
    echo "--- Deploying f_item+abc (API Gateway & Cognito) ---"
    
    if [ -f "$TF_DIR/apigw-consumer.tf.disable" ]; then
        mv "$TF_DIR/apigw-consumer.tf.disable" "$TF_DIR/apigw-consumer.tf"
        echo "--- Renamed apigw-consumer.tf.disable to apigw-consumer.tf ---"
    fi
    
    if [ -f "$TF_DIR/apigw-cor_item.tf.disable" ]; then
        mv "$TF_DIR/apigw-cor_item.tf.disable" "$TF_DIR/apigw-cor_item.tf"
        echo "--- Renamed apigw-cor_item.tf.disable to apigw-cor_item.tf ---"
    fi
    
    if [ -f "$TF_DIR/cognito.tf.disable" ]; then
        mv "$TF_DIR/cognito.tf.disable" "$TF_DIR/cognito.tf"
        echo "--- Renamed cognito.tf.disable to cognito.tf ---"
    fi
fi

echo "--- ARNs of 5 latest RDS snapshots:"
aws rds describe-db-snapshots \
  --snapshot-type manual \
  --query "reverse(sort_by(DBSnapshots, &SnapshotCreateTime))[:${NUMBER_SNAPSHOTS_SHOW}].DBSnapshotArn" \
  --region "${DR_REGION}" \
  --output json

# Creating RDS
while true; do
	echo
	read -p "--- Enter valid ARN of snapshot to create RDS from (or type 'no' to abort): " answer_rds
	answer_rds=$(echo "${answer_rds}" | tr '[:upper:]' '[:lower:]') 

	if [[ "${answer_rds}" == "no" ]]; then
		echo "--- Operation cancelled."
		break
	fi

	if [[ -z "${answer_rds}" ]]; then
		echo "--- ERROR. Snapshot ARN cannot be empty."
		continue
	fi

	aws rds describe-db-snapshots \
		--db-snapshot-identifier "${answer_rds}" \
		--region "${DR_REGION}" \
    > /dev/null 2>&1

	if [ $? -ne 0 ]; then
		echo "--- ERROR. Snapshot '${answer_rds}' doesn't exist"
	else
		echo "--- Snapshot exists ---"
		echo "--- Snapshot ${answer_rds} exported to var ${SNAPSHOT_TF_VAR}"
    export ${SNAPSHOT_TF_VAR}=${answer_rds}
    SNAPSHOT_EXPORTED="true"
    break
	fi
done

# Running tf plan
if [[ "${SNAPSHOT_EXPORTED}" =~ ^(true)$ ]]; then 
	echo
	read -p "--- Run terraform PLAN now? (yes/no): " answer_tf_plan
	answer_tf_plan=$(echo "${answer_tf_plan}" | tr '[:upper:]' '[:lower:]')
	
	until [[ "$answer_tf_plan" =~ ^(yes|no)$ ]]; do
	  read -p "Only yes/no will be accepted: " answer_tf_plan
	  answer_tf_plan=$(echo "${answer_tf_plan}" | tr '[:upper:]' '[:lower:]')
	done
fi

if [[ "${answer_tf_plan}" =~ ^(yes)$ ]]; then
  echo
  echo "--- Running terraform INIT ---"
  terraform -chdir="${TF_DIR}" init

  echo "--- Running terraform PLAN ---"
  terraform -chdir="${TF_DIR}" plan

  # Runnign tf apply
  read -p "--- Run terraform APPLY now? (yes/no): " answer_tf_apply
  answer_tf_apply=$(echo "${answer_tf_apply}" | tr '[:upper:]' '[:lower:]')

  until [[ "${answer_tf_apply}" =~ ^(yes|no)$ ]]; do
    read -p "Only yes/no will be accepted: " answer_tf_apply
    answer_tf_apply=$(echo "${answer_tf_apply}" | tr '[:upper:]' '[:lower:]')
  done

  if [[ "${answer_tf_apply}" =~ ^(yes)$ ]]; then
    echo
    echo "--- Running terraform APPLY ---"
    terraform -chdir="${TF_DIR}" apply --auto-approve
  fi
fi
