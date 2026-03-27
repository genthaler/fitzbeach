import { run } from "./exec.mjs";

export async function npmCli(args, options = {}) {
  return run("npm", args, options);
}

export async function dockerCli(args, options = {}) {
  return run("docker", args, options);
}
