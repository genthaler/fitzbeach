#!/usr/bin/env bash

set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/aws/scripts/aws-common.sh"

if ! describe_output="$(aws_cli cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --query 'Stacks[0].Outputs[].{Key:OutputKey,Value:OutputValue}' \
  --output table 2>&1)"; then
  if account_id="$(aws_cli sts get-caller-identity --query Account --output text 2>/dev/null)"; then
    cat >&2 <<EOF
Stack $STACK_NAME does not exist in AWS account $account_id.

Current AWS context:
- region: $AWS_REGION
- profile: ${AWS_PROFILE:-<default>}

If the deployed stack lives in a different account or profile, switch that AWS context and retry.
EOF
  else
    cat >&2 <<EOF
Unable to query AWS for stack $STACK_NAME.

Current AWS context:
- region: $AWS_REGION
- profile: ${AWS_PROFILE:-<default>}

Run 'aws login' and retry.
EOF
  fi

  exit 1
fi

printf '%s\n' "$describe_output"
