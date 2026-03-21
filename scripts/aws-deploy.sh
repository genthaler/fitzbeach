#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$repo_root/scripts/aws-common.sh"

image_tag="${FITZBEACH_AWS_IMAGE_TAG:-$(date -u +%Y%m%d%H%M%S)}"

deploy_stack() {
  local backend_image_tag="$1"
  local parameter_overrides=("ProjectName=$PROJECT_NAME")

  if [[ -n "$backend_image_tag" ]]; then
    parameter_overrides+=("BackendImageTag=$backend_image_tag")
  fi

  sam_cli deploy \
    --template-file "$repo_root/infra/template.yaml" \
    --stack-name "$STACK_NAME" \
    --capabilities CAPABILITY_IAM \
    --no-confirm-changeset \
    --no-fail-on-empty-changeset \
    --parameter-overrides \
    "${parameter_overrides[@]}"
}

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
