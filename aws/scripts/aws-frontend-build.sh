#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

source "$repo_root/aws/scripts/aws-common.sh"

api_base_url="${FITZBEACH_API_BASE_URL:-}"

if [[ -z "$api_base_url" ]]; then
  api_base_url="$(stack_output BackendFunctionUrl)"
fi

if [[ -z "$api_base_url" || "$api_base_url" == "None" ]]; then
  echo "Backend Function URL is not available. Deploy the stack first or set FITZBEACH_API_BASE_URL." >&2
  exit 1
fi

cd "$repo_root"
npm run clean
API_BASE_URL="$api_base_url" npm run build
