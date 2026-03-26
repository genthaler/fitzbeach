#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

source "$repo_root/aws/scripts/aws-common.sh"

image_tag="${FITZBEACH_AWS_IMAGE_TAG:-$(date -u +%Y%m%d%H%M%S)}"

stack_status() {
  aws_cli cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --query "Stacks[0].StackStatus" \
    --output text 2>/dev/null || true
}

reset_failed_stack_if_needed() {
  local current_status
  current_status="$(stack_status)"

  if [[ "$current_status" == "ROLLBACK_COMPLETE" ]]; then
    echo "Deleting stack $STACK_NAME in ROLLBACK_COMPLETE before redeploy"
    aws_cli cloudformation delete-stack --stack-name "$STACK_NAME"
    aws_cli cloudformation wait stack-delete-complete --stack-name "$STACK_NAME"
  fi
}

deploy_stack() {
  local backend_image_tag="$1"
  local deploy_args=(
    cloudformation
    deploy
    --template-file "$repo_root/aws/infra/template.yaml"
    --stack-name "$STACK_NAME"
    --capabilities CAPABILITY_IAM
    --no-fail-on-empty-changeset
    --parameter-overrides
    "ProjectName=$PROJECT_NAME"
  )

  if [[ -n "$backend_image_tag" ]]; then
    deploy_args+=("BackendImageTag=$backend_image_tag")
  fi

  aws_cli "${deploy_args[@]}"
}

reset_failed_stack_if_needed

deploy_stack ""

repository_uri="$(stack_output BackendRepositoryUri)"
registry_host="${repository_uri%%/*}"

aws_cli ecr get-login-password \
  | docker login --username AWS --password-stdin "$registry_host"

docker build \
  --platform linux/amd64 \
  --file "$repo_root/backend/Dockerfile" \
  --tag "$repository_uri:$image_tag" \
  "$repo_root/backend"

docker push "$repository_uri:$image_tag"

deploy_stack "$image_tag"

cd "$repo_root"
npm run aws:build:pages
npm exec gh-pages -d frontend/dist
