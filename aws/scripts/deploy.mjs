import { backendDir, backendDockerfilePath, frontendDistDir, repoRoot, awsTemplatePath } from "./lib/context.mjs";
import { awsCli, awsCliCapture, stackOutput, stackStatus } from "./lib/aws.mjs";
import { getAwsContext, getImageTag } from "./lib/env.mjs";
import { githubActionsGitEnv, mergeEnvs } from "./lib/git.mjs";
import { dockerCli, npmCli } from "./lib/tools.mjs";

async function deployStack(context, backendImageTag = "") {
  const args = [
    "cloudformation",
    "deploy",
    "--template-file",
    awsTemplatePath,
    "--stack-name",
    context.stackName,
    "--capabilities",
    "CAPABILITY_IAM",
    "--no-fail-on-empty-changeset",
    "--parameter-overrides",
    `ProjectName=${context.projectName}`,
  ];

  if (backendImageTag) {
    args.push(`BackendImageTag=${backendImageTag}`);
  }

  await awsCli(context, args);
}

async function resetFailedStackIfNeeded(context) {
  if ((await stackStatus(context)) !== "ROLLBACK_COMPLETE") {
    return;
  }

  console.log(`Deleting stack ${context.stackName} in ROLLBACK_COMPLETE before redeploy`);
  await awsCli(context, ["cloudformation", "delete-stack", "--stack-name", context.stackName]);
  await awsCli(context, [
    "cloudformation",
    "wait",
    "stack-delete-complete",
    "--stack-name",
    context.stackName,
  ]);
}

async function main() {
  const context = getAwsContext();
  const imageTag = getImageTag();

  await resetFailedStackIfNeeded(context);
  await deployStack(context);

  const repositoryUri = await stackOutput(context, "BackendRepositoryUri");
  const registryHost = repositoryUri.split("/")[0];

  const loginPassword = await awsCliCapture(context, ["ecr", "get-login-password"], {
    stderr: "inherit",
  });

  await dockerCli(["login", "--username", "AWS", "--password-stdin", registryHost], {
    input: loginPassword.stdout,
  });

  await dockerCli([
    "build",
    "--platform",
    "linux/amd64",
    "--file",
    backendDockerfilePath,
    "--tag",
    `${repositoryUri}:${imageTag}`,
    backendDir,
  ]);

  await dockerCli(["push", `${repositoryUri}:${imageTag}`]);

  await deployStack(context, imageTag);

  await npmCli(["run", "-w", "aws", "build:pages"], { cwd: repoRoot });
  await npmCli(["exec", "-w", "aws", "--", "gh-pages", "-d", frontendDistDir], {
    cwd: repoRoot,
    env: mergeEnvs(process.env, githubActionsGitEnv()),
  });
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
