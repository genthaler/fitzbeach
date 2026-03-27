import { capture, run } from "./exec.mjs";

function awsArgs(context) {
  const args = ["--region", context.region];

  if (context.profile) {
    args.push("--profile", context.profile);
  }

  return args;
}

export async function awsCli(context, args, options = {}) {
  return run("aws", [...awsArgs(context), ...args], options);
}

export async function awsCliCapture(context, args, options = {}) {
  return capture("aws", [...awsArgs(context), ...args], options);
}

export async function stackOutput(context, outputKey, options = {}) {
  const result = await awsCliCapture(
    context,
    [
      "cloudformation",
      "describe-stacks",
      "--stack-name",
      context.stackName,
      "--query",
      `Stacks[0].Outputs[?OutputKey=='${outputKey}'].OutputValue | [0]`,
      "--output",
      "text",
    ],
    options,
  );

  return result.stdout.trim();
}

export async function tryStackOutput(context, outputKey) {
  const result = await awsCliCapture(
    context,
    [
      "cloudformation",
      "describe-stacks",
      "--stack-name",
      context.stackName,
      "--query",
      `Stacks[0].Outputs[?OutputKey=='${outputKey}'].OutputValue | [0]`,
      "--output",
      "text",
    ],
    { allowFailure: true },
  );

  if (result.exitCode !== 0) {
    return "";
  }

  return result.stdout.trim();
}

export async function stackExists(context) {
  const result = await awsCliCapture(
    context,
    ["cloudformation", "describe-stacks", "--stack-name", context.stackName],
    { allowFailure: true },
  );

  return result.exitCode === 0;
}

export async function stackStatus(context) {
  const result = await awsCliCapture(
    context,
    [
      "cloudformation",
      "describe-stacks",
      "--stack-name",
      context.stackName,
      "--query",
      "Stacks[0].StackStatus",
      "--output",
      "text",
    ],
    { allowFailure: true },
  );

  if (result.exitCode !== 0) {
    return "";
  }

  return result.stdout.trim();
}

export async function currentAwsAccountId(context) {
  const result = await awsCliCapture(
    context,
    ["sts", "get-caller-identity", "--query", "Account", "--output", "text"],
    { allowFailure: true },
  );

  if (result.exitCode !== 0) {
    return "";
  }

  return result.stdout.trim();
}
