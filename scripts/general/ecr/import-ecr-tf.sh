#!/bin/bash

REPOSITORIES=(
    "comp/ecr-repo"
)

echo "Begining imoport to Terraform state..."
echo "Total repo to import: ${#REPOSITORIES[@]}"
echo "==============================================="

for repo in "${REPOSITORIES[@]}"; do
    echo "Importing: $repo"
    terraform import aws_ecr_repository.imported["\"${repo}"\"] "$repo" >/dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✓ Import successfull: $repo"
    else
        echo "✗ Import ERROR: $repo"
    fi
    echo "----------------------------------------"
done

echo "==============================================="
echo "Import completed"
