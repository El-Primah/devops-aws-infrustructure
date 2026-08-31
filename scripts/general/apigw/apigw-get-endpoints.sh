#!/bin/bash

API_ID="12as123asd"
OUTPUT_FILE="apigw-full-endpoints.txt"

resources=$(aws apigateway get-resources --rest-api-id "$API_ID" --region eu-west-1 --output json)

echo "$resources" | jq -c '.items[]' | while read -r resource; do
    path=$(echo "$resource" | jq -r '.path')
    resource_id=$(echo "$resource" | jq -r '.id')
    
    methods=$(echo "$resource" | jq -r '.resourceMethods | keys[]?')
    
    if [ -n "$methods" ]; then
        echo "Path: $path" >> "$OUTPUT_FILE"
        echo "Resource ID: $resource_id" >> "$OUTPUT_FILE"
        
        for method in $methods; do
            if [ "$method" != "null" ] && [ "$method" != "OPTIONS" ]; then
                echo "  Method: $method" >> "$OUTPUT_FILE"
                
                method_details=$(aws apigateway get-method \
                    --rest-api-id "$API_ID" \
                    --resource-id "$resource_id" \
                    --region eu-west-1 \
                    --http-method "$method" 2>/dev/null)
                
                if [ $? -eq 0 ]; then
                    integration_type=$(echo "$method_details" | jq -r '.methodIntegration.type // "N/A"')
                    integration_uri=$(echo "$method_details" | jq -r '.methodIntegration.uri // "N/A"')
                    
                    echo "    Integration type: $integration_type" >> "$OUTPUT_FILE"
                    if [ "$integration_uri" != "N/A" ]; then
                        echo "    URI: $integration_uri" >> "$OUTPUT_FILE"
                    fi
                fi
                echo "" >> "$OUTPUT_FILE"
            fi
        done
        echo "========================" >> "$OUTPUT_FILE"
    fi
done

echo "Done, endpoints for $API_ID are written to: $OUTPUT_FILE"
