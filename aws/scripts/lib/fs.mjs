import fs from 'node:fs/promises'
import path from 'node:path'

export async function ensureDir(dirPath) {
  await fs.mkdir(dirPath, { recursive: true })
}

export async function removeTree(targetPath) {
  await fs.rm(targetPath, { recursive: true, force: true })
}

export async function emptyDir(dirPath) {
  await removeTree(dirPath)
  await ensureDir(dirPath)
}

export async function readText(filePath) {
  return await fs.readFile(filePath, 'utf8')
}

export async function writeText(filePath, contents) {
  await ensureDir(path.dirname(filePath))
  await fs.writeFile(filePath, contents, 'utf8')
}
