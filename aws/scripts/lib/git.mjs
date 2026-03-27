export function githubActionsGitEnv(env = process.env) {
  if (!env.GITHUB_ACTIONS) {
    return {}
  }

  const authorName = 'GitHub Actions'
  const authorEmail = '41898282+github-actions[bot]@users.noreply.github.com'

  return {
    GIT_AUTHOR_NAME: authorName,
    GIT_AUTHOR_EMAIL: authorEmail,
    GIT_COMMITTER_NAME: authorName,
    GIT_COMMITTER_EMAIL: authorEmail,
  }
}

export function mergeEnvs(...envs) {
  return Object.assign({}, ...envs)
}

