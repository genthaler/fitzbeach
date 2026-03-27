import {
  frontendDistDir,
  frontendRedirectTemplatePath,
} from "./lib/context.mjs";
import { getAwsContext } from "./lib/env.mjs";
import { tryStackOutput } from "./lib/aws.mjs";
import { emptyDir, readText, writeText } from "./lib/fs.mjs";

function normalizeTrailingSlash(url) {
  return `${url.replace(/\/+$/, "")}/`;
}

async function main() {
  const context = getAwsContext();
  let redirectUrl = process.env.FITZBEACH_PAGES_REDIRECT_URL || "";

  if (!redirectUrl) {
    redirectUrl = await tryStackOutput(context, "FrontendUrl");
  }

  if (!redirectUrl || redirectUrl === "None") {
    console.error(`GitHub Pages redirect target is not available.

Provide one of:
- a working AWS session plus an existing stack so FrontendUrl can be read
- FITZBEACH_PAGES_REDIRECT_URL set to the deployed frontend URL

Current AWS context:
- stack: ${context.stackName}
- region: ${context.region}
- profile: ${context.profileLabel}`);
    process.exit(1);
  }

  const normalizedRedirectUrl = normalizeTrailingSlash(redirectUrl);

  let template;
  try {
    template = await readText(frontendRedirectTemplatePath);
  } catch {
    console.error(
      `Redirect template not found at ${frontendRedirectTemplatePath}.`,
    );
    process.exit(1);
  }

  const output = template.replaceAll("__REDIRECT_URL__", normalizedRedirectUrl);

  await emptyDir(frontendDistDir);
  await Promise.all([
    writeText(`${frontendDistDir}/index.html`, output),
    writeText(`${frontendDistDir}/404.html`, output),
  ]);
}

main().catch((error) => {
  console.error(error.message);
  process.exit(1);
});
