import { backendDir, backendDockerfilePath, frontendDistDir, repoRoot, awsTemplatePath } from "./lib/context.mjs";
import { awsCli, stackOutput, stackStatus } from "./lib/aws.mjs";
import { getAwsContext, getImageTag } from "./lib/env.mjs";
import { capture, run } from "./lib/exec.mjs";
import { githubActionsGitEnv, mergeEnvs } from "./lib/git.mjs";

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

  const loginPassword = await capture(
    "aws",
    [
      "--region",
      context.region,
      ...(context.profile ? ["--profile", context.profile] : []),
      "ecr",
      "get-login-password",
    ],
    { stderr: "inherit" },
  );

  await run(
    "docker",
    ["login", "--username", "AWS", "--password-stdin", registryHost],
    { input: loginPassword.stdout },
  );

  await run("docker", [
    "build",
    "--platform",
    "linux/amd64",
    "--file",
    backendDockerfilePath,
    "--tag",
    `${repositoryUri}:${imageTag}`,
    backendDir,
  ]);

  await run("docker", ["push", `${repositoryUri}:${imageTag}`]);

  await deployStack(context, imageTag);

  await run("npm", ["run", "-w", "aws", "build:pages"], { cwd: repoRoot });
  await run("npm", ["exec", "-w", "aws", "--", "gh-pages", "-d", frontendDistDir], {
    cwd: repoRoot,
    env: mergeEnvs(process.env, githubActionsGitEnv()),
  });
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
