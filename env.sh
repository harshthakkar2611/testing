#!/bin/bash

# Set AWS region and parameter path prefix
AWS_REGION="us-east-1"
PARAM_PREFIX="/newmaninstitute/mongo/dev"

# List of your parameters
PARAMS="url name"

echo "Generating .env file from Parameter Store..."

# Empty the existing .env or create new
> .env

# Fetch each parameter and write to .env
for param in $PARAMS; do
    value=$(aws ssm get-parameter \
        --name "$PARAM_PREFIX/$param" \
        --with-decryption \
        --region "$AWS_REGION" \
        --query "Parameter.Value" \
        --output text)
    
    echo "$param=$value" >> .env
done

echo ".env file generated:"
cat .env
