#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

source "$repo_root/scripts/aws-common.sh"

"$repo_root/scripts/aws-frontend-build.sh"

bucket_name="$(stack_output FrontendBucketName)"
distribution_id="$(stack_output FrontendDistributionId)"

aws_cli s3 sync "$repo_root/frontend/dist/" "s3://$bucket_name" --delete
aws_cli cloudfront create-invalidation --distribution-id "$distribution_id" --paths "/*" >/dev/null
