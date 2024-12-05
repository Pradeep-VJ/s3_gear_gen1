#!/bin/bash
# Bootstrap script for Terraform backend state management

STATE_BUCKET="terraform-state-bucket"
LOCK_TABLE="terraform-lock-table"
REGION="us-east-1"

# Check if AWS credentials are set
if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY" ]]; then
    echo "Error: AWS credentials not set. Exiting."
    exit 1
fi

# Check if the S3 state bucket exists
if aws s3api head-bucket --bucket "$STATE_BUCKET" 2>/dev/null; then
    echo "State bucket $STATE_BUCKET already exists."
else
    echo "Creating state bucket $STATE_BUCKET..."
    aws s3api create-bucket --bucket "$STATE_BUCKET" --region "$REGION" \
        --create-bucket-configuration LocationConstraint="$REGION"
    aws s3api put-bucket-versioning --bucket "$STATE_BUCKET" --versioning-configuration Status=Enabled
    echo "State bucket $STATE_BUCKET created successfully."
fi

# Check if the DynamoDB lock table exists
if aws dynamodb describe-table --table-name "$LOCK_TABLE" 2>/dev/null; then
    echo "DynamoDB lock table $LOCK_TABLE already exists."
else
    echo "Creating DynamoDB lock table $LOCK_TABLE..."
    aws dynamodb create-table --table-name "$LOCK_TABLE" \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --region "$REGION"
    echo "DynamoDB lock table $LOCK_TABLE created successfully."
fi
