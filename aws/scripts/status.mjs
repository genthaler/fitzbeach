import { awsCliCapture, currentAwsAccountId } from "./lib/aws.mjs";
import { getAwsContext } from "./lib/env.mjs";

async function main() {
  const context = getAwsContext();
  const result = await awsCliCapture(
    context,
    [
      "cloudformation",
      "describe-stacks",
      "--stack-name",
      context.stackName,
      "--query",
      "Stacks[0].Outputs[].{Key:OutputKey,Value:OutputValue}",
      "--output",
      "table",
    ],
    { allowFailure: true },
  );

  if (result.exitCode === 0) {
    process.stdout.write(result.stdout);
    return;
  }

  const accountId = await currentAwsAccountId(context);

  if (accountId) {
    console.error(`Stack ${context.stackName} does not exist in AWS account ${accountId}.

Current AWS context:
- region: ${context.region}
- profile: ${context.profileLabel}

If the deployed stack lives in a different account or profile, switch that AWS context and retry.`);
  } else {
    console.error(`Unable to query AWS for stack ${context.stackName}.

Current AWS context:
- region: ${context.region}
- profile: ${context.profileLabel}

Run 'aws login' and retry.`);
  }

  process.exit(1);
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
