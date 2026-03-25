#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

source "$repo_root/aws/scripts/aws-common.sh"

aws_cli cloudformation validate-template \
  --template-body "file://$repo_root/aws/infra/template.yaml" >/dev/null

docker build \
  --platform linux/amd64 \
  --file "$repo_root/backend/Dockerfile" \
  --tag fitzbeach-backend-lambda:local \
  "$repo_root/backend"
