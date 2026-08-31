#!/bin/bash



API_ID="12as123asd"
OUTPUT_FILE="apigw_import_data.txt"


echo "Checking API Gateway ID: $API_ID"
if ! aws apigateway get-rest-api --rest-api-id "$API_ID" --region eu-west-1 &> /dev/null; then
    echo "API Gateway с ID $API_ID not found"
    exit 1
fi

echo "API Gateway ID: $API_ID"
echo "Output file: $OUTPUT_FILE"
echo "========================================" > "$OUTPUT_FILE"


echo "Getting API..."
API_NAME=$(aws apigateway get-rest-api --rest-api-id "$API_ID" --query 'name' --region eu-west-1 --output text 2>/dev/null)
echo "API Gateway:" >> "$OUTPUT_FILE"
echo "  Name: $API_NAME" >> "$OUTPUT_FILE"
echo "  ID: $API_ID" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"


echo "Getting resources..."
echo "Resources:" >> "$OUTPUT_FILE"
resources=$(aws apigateway get-resources --rest-api-id "$API_ID" --region eu-west-1 --output json 2>/dev/null)


echo "$resources" | jq -c '.items[]' | while read -r resource; do
    resource_id=$(echo "$resource" | jq -r '.id')
    resource_path=$(echo "$resource" | jq -r '.path')
    
    echo "  Path: $resource_path" >> "$OUTPUT_FILE"
    echo "    ID: $resource_id" >> "$OUTPUT_FILE"
    

    methods=$(echo "$resource" | jq -r '.resourceMethods | keys[]?' 2>/dev/null)
    if [ -n "$methods" ] && [ "$methods" != "null" ]; then
        echo "    Methods:" >> "$OUTPUT_FILE"
        for method in $methods; do
            if [ "$method" != "null" ] && [ "$method" != "OPTIONS" ]; then
                echo "      $method" >> "$OUTPUT_FILE"
            fi
        done
    fi
    echo "" >> "$OUTPUT_FILE"
done


echo "Getting stage..."
echo "Stages:" >> "$OUTPUT_FILE"
stages=$(aws apigateway get-stages --rest-api-id "$API_ID" --region eu-west-1 --output json 2>/dev/null)
echo "$stages" | jq -c '.item[]' | while read -r stage; do
    stage_name=$(echo "$stage" | jq -r '.stageName')
    deployment_id=$(echo "$stage" | jq -r '.deploymentId')
    echo "  Stage Name: $stage_name" >> "$OUTPUT_FILE"
    echo "    Deployment ID: $deployment_id" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done


echo "Getting deployments..."
echo "Deployments:" >> "$OUTPUT_FILE"
deployments=$(aws apigateway get-deployments --rest-api-id "$API_ID" --region eu-west-1 --output json 2>/dev/null)
echo "$deployments" | jq -c '.items[]' | while read -r deployment; do
    deployment_id=$(echo "$deployment" | jq -r '.id')
    description=$(echo "$deployment" | jq -r '.description // \"No description\""')
    echo "  Deployment ID: $deployment_id" >> "$OUTPUT_FILE"
    echo "    Description: $description" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
done

echo "--- Done --"
echo "Output file: $OUTPUT_FILE"
