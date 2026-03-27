#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
template_path="$repo_root/frontend/redirect.html"

source "$repo_root/aws/scripts/aws-common.sh"

redirect_url="${FITZBEACH_PAGES_REDIRECT_URL:-}"

if [[ -z "$redirect_url" ]]; then
  redirect_url="$(stack_output FrontendUrl 2>/dev/null || true)"
fi

if [[ -z "$redirect_url" || "$redirect_url" == "None" ]]; then
  cat >&2 <<EOF
GitHub Pages redirect target is not available.

Provide one of:
- a working AWS session plus an existing stack so FrontendUrl can be read
- FITZBEACH_PAGES_REDIRECT_URL set to the deployed frontend URL

Current AWS context:
- stack: $STACK_NAME
- region: $AWS_REGION
- profile: ${AWS_PROFILE:-<default>}
EOF
  exit 1
fi

redirect_url="${redirect_url%/}/"
escaped_redirect_url="${redirect_url//&/\\&}"

if [[ ! -f "$template_path" ]]; then
  echo "Redirect template not found at $template_path." >&2
  exit 1
fi

mkdir -p "$repo_root/frontend/dist"
find "$repo_root/frontend/dist" -mindepth 1 -maxdepth 1 -exec rm -rf {} +

for redirect_page in "$repo_root/frontend/dist/index.html" "$repo_root/frontend/dist/404.html"; do
  sed "s|__REDIRECT_URL__|$escaped_redirect_url|g" "$template_path" > "$redirect_page"
done
