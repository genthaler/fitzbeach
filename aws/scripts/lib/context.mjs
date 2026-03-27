import path from "node:path";
import { fileURLToPath } from "node:url";

const currentDir = path.dirname(fileURLToPath(import.meta.url));

export const repoRoot = path.resolve(currentDir, "../../..");
export const awsDir = path.join(repoRoot, "aws");
export const backendDir = path.join(repoRoot, "backend");
export const frontendDir = path.join(repoRoot, "frontend");
export const awsTemplatePath = path.join(awsDir, "infra", "template.yaml");
export const backendDockerfilePath = path.join(backendDir, "Dockerfile");
export const frontendRedirectTemplatePath = path.join(frontendDir, "redirect.html");
export const frontendDistDir = path.join(frontendDir, "dist");
