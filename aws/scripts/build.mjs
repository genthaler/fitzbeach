import {
  awsTemplatePath,
  backendDir,
  backendDockerfilePath,
} from "./lib/context.mjs";
import { awsCli } from "./lib/aws.mjs";
import { getAwsContext } from "./lib/env.mjs";
import { run } from "./lib/exec.mjs";

async function main() {
  const context = getAwsContext();

  await awsCli(context, [
    "cloudformation",
    "validate-template",
    "--template-body",
    `file://${awsTemplatePath}`,
  ], { stdout: "ignore" });

  await run("docker", [
    "build",
    "--platform",
    "linux/amd64",
    "--file",
    backendDockerfilePath,
    "--tag",
    "fitzbeach-backend-lambda:local",
    backendDir,
  ]);
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
