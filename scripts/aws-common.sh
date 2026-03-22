#!/usr/bin/env bash

set -euo pipefail

STACK_NAME="${FITZBEACH_AWS_STACK_NAME:-fitzbeach-aws}"
PROJECT_NAME="${FITZBEACH_AWS_PROJECT_NAME:-fitzbeach}"
AWS_REGION="${AWS_REGION:-${FITZBEACH_AWS_REGION:-ap-southeast-2}}"
AWS_PROFILE="${AWS_PROFILE:-${FITZBEACH_AWS_PROFILE:-}}"

aws_args=(--region "$AWS_REGION")
sam_args=(--region "$AWS_REGION")

if [[ -n "$AWS_PROFILE" ]]; then
  aws_args+=(--profile "$AWS_PROFILE")
  sam_args+=(--profile "$AWS_PROFILE")
fi

aws_cli() {
  aws "${aws_args[@]}" "$@"
}

sam_validate() {
  sam validate "${sam_args[@]}" "$@"
}

stack_output() {
  aws_cli cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --query "Stacks[0].Outputs[?OutputKey=='$1'].OutputValue | [0]" \
    --output text
}
