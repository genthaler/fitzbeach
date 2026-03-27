import { awsCli, stackExists, stackOutput } from "./lib/aws.mjs";
import { getAwsContext } from "./lib/env.mjs";

async function main() {
  const context = getAwsContext();

  if (!(await stackExists(context))) {
    console.log(`Stack ${context.stackName} does not exist.`);
    return;
  }

  const bucketName = await stackOutput(context, "FrontendBucketName");

  if (bucketName && bucketName !== "None") {
    await awsCli(context, ["s3", "rm", `s3://${bucketName}`, "--recursive"], {
      allowFailure: true,
    });
  }

  await awsCli(context, [
    "cloudformation",
    "delete-stack",
    "--stack-name",
    context.stackName,
  ]);
  await awsCli(context, [
    "cloudformation",
    "wait",
    "stack-delete-complete",
    "--stack-name",
    context.stackName,
  ]);
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
