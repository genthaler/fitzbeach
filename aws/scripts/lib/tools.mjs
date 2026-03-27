import { capture, run } from "./exec.mjs";

export async function npmCli(args, options = {}) {
  return run("npm", args, options);
}

export async function npmCliCapture(args, options = {}) {
  return capture("npm", args, options);
}

export async function dockerCli(args, options = {}) {
  return run("docker", args, options);
}

export async function dockerCliCapture(args, options = {}) {
  return capture("docker", args, options);
}
