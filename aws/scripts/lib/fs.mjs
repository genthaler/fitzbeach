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

export async function fileExists(filePath) {
  try {
    const stats = await fs.stat(filePath)
    return stats.isFile()
  } catch {
    return false
  }
}

export async function directoryExists(dirPath) {
  try {
    const stats = await fs.stat(dirPath)
    return stats.isDirectory()
  } catch {
    return false
  }
}

export async function readText(filePath) {
  return await fs.readFile(filePath, 'utf8')
}

export async function writeText(filePath, contents) {
  await ensureDir(path.dirname(filePath))
  await fs.writeFile(filePath, contents, 'utf8')
}

export async function copyText(sourcePath, targetPath) {
  const contents = await readText(sourcePath)
  await writeText(targetPath, contents)
}

