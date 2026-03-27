import { frontendDistDir, repoRoot } from "./lib/context.mjs";
import { awsCli, stackOutput } from "./lib/aws.mjs";
import { getAwsContext } from "./lib/env.mjs";
import { npmCli } from "./lib/tools.mjs";

async function main() {
  const context = getAwsContext();

  await npmCli(["run", "-w", "aws", "build:frontend"], { cwd: repoRoot });

  const bucketName = await stackOutput(context, "FrontendBucketName");
  const distributionId = await stackOutput(context, "FrontendDistributionId");

  await awsCli(context, [
    "s3",
    "sync",
    `${frontendDistDir}/`,
    `s3://${bucketName}`,
    "--delete",
  ]);
  await awsCli(context, [
    "cloudfront",
    "create-invalidation",
    "--distribution-id",
    distributionId,
    "--paths",
    "/*",
  ], { stdout: "ignore" });
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
