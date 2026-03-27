import { spawn } from "node:child_process";

export class CommandError extends Error {
  constructor(message, { command, exitCode, stdout, stderr }) {
    super(message);
    this.name = "CommandError";
    this.command = command;
    this.exitCode = exitCode;
    this.stdout = stdout;
    this.stderr = stderr;
  }
}

export function formatCommand(command, args) {
  return [command, ...args].join(" ");
}

export function run(command, args = [], options = {}) {
  const {
    cwd,
    env,
    input,
    allowFailure = false,
    stdout = "inherit",
    stderr = "inherit",
  } = options;

  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      cwd,
      env: env ?? process.env,
      stdio: ["pipe", stdout, stderr],
    });

    let capturedStdout = "";
    let capturedStderr = "";

    if (stdout === "pipe") {
      child.stdout.on("data", (chunk) => {
        capturedStdout += chunk.toString();
      });
    }

    if (stderr === "pipe") {
      child.stderr.on("data", (chunk) => {
        capturedStderr += chunk.toString();
      });
    }

    child.on("error", reject);

    child.on("close", (exitCode) => {
      const result = {
        exitCode: exitCode ?? 1,
        stdout: capturedStdout,
        stderr: capturedStderr,
      };

      if (result.exitCode !== 0 && !allowFailure) {
        reject(
          new CommandError(`Command failed: ${formatCommand(command, args)}`, {
            command: formatCommand(command, args),
            ...result,
          }),
        );
        return;
      }

      resolve(result);
    });

    if (input != null) {
      child.stdin.write(input);
    }

    child.stdin.end();
  });
}

export async function capture(command, args = [], options = {}) {
  return run(command, args, {
    ...options,
    stdout: "pipe",
    stderr: options.stderr ?? "pipe",
  });
}
