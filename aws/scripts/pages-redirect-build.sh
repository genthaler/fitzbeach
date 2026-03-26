#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

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

mkdir -p "$repo_root/frontend/dist"
find "$repo_root/frontend/dist" -mindepth 1 -maxdepth 1 -exec rm -rf {} +

for redirect_page in "$repo_root/frontend/dist/index.html" "$repo_root/frontend/dist/404.html"; do
  cat > "$redirect_page" <<EOF
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Fitzbeach</title>
    <meta http-equiv="refresh" content="0; url=${redirect_url}" />
    <link rel="canonical" href="${redirect_url}" />
    <style>
      body {
        margin: 0;
        min-height: 100vh;
        display: grid;
        place-items: center;
        background: #f7f7f7;
        color: #333333;
        font: 16px/1.5 system-ui, sans-serif;
      }

      main {
        padding: 24px;
        text-align: center;
      }

      a {
        color: inherit;
      }
    </style>
  </head>
  <body>
    <main>
      <p>Redirecting to the deployed Fitzbeach app.</p>
      <p><a href="${redirect_url}">Continue</a></p>
    </main>
    <script>
      window.location.replace("${redirect_url}");
    </script>
  </body>
</html>
EOF
done
