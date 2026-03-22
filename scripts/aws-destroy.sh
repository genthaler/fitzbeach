#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/scripts/aws-common.sh"

if aws_cli cloudformation describe-stacks --stack-name "$STACK_NAME" >/dev/null 2>&1; then
  bucket_name="$(stack_output FrontendBucketName)"

  if [[ "$bucket_name" != "None" && -n "$bucket_name" ]]; then
    aws_cli s3 rm "s3://$bucket_name" --recursive || true
  fi

  aws_cli cloudformation delete-stack --stack-name "$STACK_NAME"
  aws_cli cloudformation wait stack-delete-complete --stack-name "$STACK_NAME"
else
  echo "Stack $STACK_NAME does not exist."
fi
