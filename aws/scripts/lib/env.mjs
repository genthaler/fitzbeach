export function getAwsContext() {
  const stackName = process.env.FITZBEACH_AWS_STACK_NAME || "fitzbeach-aws";
  const projectName = process.env.FITZBEACH_AWS_PROJECT_NAME || "fitzbeach";
  const region =
    process.env.AWS_REGION ||
    process.env.FITZBEACH_AWS_REGION ||
    "ap-southeast-2";
  const profile =
    process.env.AWS_PROFILE ||
    process.env.FITZBEACH_AWS_PROFILE ||
    "";

  return {
    stackName,
    projectName,
    region,
    profile,
    profileLabel: profile || "<default>",
  };
}

export function getImageTag() {
  const explicitTag = process.env.FITZBEACH_AWS_IMAGE_TAG;

  if (explicitTag) {
    return explicitTag;
  }

  const timestamp = new Date().toISOString().replace(/[-:]/g, "");
  return timestamp.slice(0, 8) + timestamp.slice(9, 15);
}

export function withGitHubActionsGitIdentity(baseEnv = process.env) {
  if (!process.env.GITHUB_ACTIONS) {
    return baseEnv;
  }

  return {
    ...baseEnv,
    GIT_AUTHOR_NAME: "GitHub Actions",
    GIT_AUTHOR_EMAIL: "41898282+github-actions[bot]@users.noreply.github.com",
    GIT_COMMITTER_NAME: "GitHub Actions",
    GIT_COMMITTER_EMAIL:
      "41898282+github-actions[bot]@users.noreply.github.com",
  };
}
