import { repoRoot } from "./lib/context.mjs";
import { getAwsContext } from "./lib/env.mjs";
import { stackOutput } from "./lib/aws.mjs";
import { npmCli } from "./lib/tools.mjs";

async function main() {
  const context = getAwsContext();
  let apiBaseUrl = process.env.FITZBEACH_API_BASE_URL || "";

  if (!apiBaseUrl) {
    apiBaseUrl = await stackOutput(context, "BackendFunctionUrl");
  }

  if (!apiBaseUrl || apiBaseUrl === "None") {
    console.error(
      "Backend Function URL is not available. Deploy the stack first or set FITZBEACH_API_BASE_URL.",
    );
    process.exit(1);
  }

  await npmCli(["run", "-w", "frontend", "clean"], { cwd: repoRoot });
  await npmCli(["run", "-w", "frontend", "build"], {
    cwd: repoRoot,
    env: {
      ...process.env,
      API_BASE_URL: apiBaseUrl,
    },
  });
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
