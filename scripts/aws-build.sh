#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$repo_root/scripts/aws-common.sh"

sam_cli validate --template-file "$repo_root/infra/template.yaml"

docker build \
  --platform linux/amd64 \
  --file "$repo_root/backend/Dockerfile" \
  --tag fitzbeach-backend-lambda:local \
  "$repo_root/backend"
