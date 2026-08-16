// new-project-init: DeepSeek Harness plugin package.
//
// A Cordis plugin that registers one skill provider into the HOST layer of the
// `ctx.skills` registry, so every agent preset's scope chain merges this skill.
// The skill body lives at the package ROOT (`SKILL.md`), with templates/,
// testing/, and references/ resolved relative to it (resourceBase = package
// root). This keeps the repo layout identical to a plain filesystem skill, so
// the same directory also works installed as a local skill root.
//
// The provider protocol mirrors @deepseek-ai/dsh-skill-filesystem and
// superpowers-dsh:
//   - list() returns the single candidate parsed from the root SKILL.md
//   - get()  re-reads and parses the current SKILL.md and returns the full
//     definition with a directory resource base for relative references
//
// @module new-project-init
import { readFile } from 'node:fs/promises'
import { fileURLToPath } from 'node:url'
import { dirname, join } from 'node:path'

const name = 'new-project-init'
const inject = ['skills']

/** Registry precedence for packaged skill providers: below user/local roots. */
const PACKAGED_SKILL_RANK = 550

/** The source bucket this skill advertises under (prompt-visible metadata). */
const SOURCE = 'custom'

/** Absolute path of the package-root SKILL.md (an assembly fact, never user config). */
const SKILL_FILE = join(dirname(fileURLToPath(import.meta.url)), '..', 'SKILL.md')

/** Directory resource base: templates/, testing/, references/ resolve against it. */
const RESOURCE_BASE = dirname(SKILL_FILE)

/**
 * Parse the YAML frontmatter block of a SKILL.md into metadata plus body.
 * Handles only the scalar fields DSH skill discovery consumes (name,
 * description, whenToUse); richer metadata passes through verbatim.
 * @param text - the raw skill file contents.
 * @returns parsed metadata object and the markdown body after the block, or
 *   null when the file has no frontmatter block at all.
 */
function parseFrontmatter(text) {
  if (!text.startsWith('---')) return null
  const end = text.indexOf('\n---', 3)
  if (end === -1) return null
  const block = text.slice(3, end)
  const body = text.slice(end + 4).replace(/^\n+/, '')
  const metadata = {}
  for (const line of block.split('\n')) {
    const match = /^([A-Za-z][\w-]*):\s*(.*)$/.exec(line.trim())
    if (!match) continue
    let value = match[2].trim()
    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
      value = value.slice(1, -1)
    }
    metadata[match[1]] = value
  }
  return { metadata, body }
}

/**
 * Read and parse the package's root SKILL.md.
 * @param signal - optional cancellation; aborts the read.
 * @returns the parsed skill record, or undefined when the file vanished.
 */
async function parseSkill(signal) {
  let text
  try {
    text = await readFile(SKILL_FILE, 'utf8')
  } catch {
    return undefined
  }
  if (signal?.aborted) return undefined
  const parsed = parseFrontmatter(text)
  if (parsed === null) return undefined
  return {
    name: parsed.metadata.name ?? '',
    description: parsed.metadata.description ?? '',
    whenToUse: parsed.metadata.whenToUse,
    metadata: parsed.metadata,
    content: parsed.body
  }
}

/** Register the packaged skill provider on `ctx.skills`. */
function apply(ctx) {
  ctx.skills.registerProvider((control) => ({
    name,
    async list(options) {
      const parsed = await parseSkill(options?.signal)
      if (parsed === undefined) return []
      return [{
        name: parsed.name,
        description: parsed.description,
        ...(parsed.whenToUse !== undefined ? { whenToUse: parsed.whenToUse } : {}),
        invocation: { modelInvocable: true, userInvocable: true },
        source: SOURCE,
        provider: name,
        rank: PACKAGED_SKILL_RANK,
        locator: RESOURCE_BASE,
        path: SKILL_FILE,
        ...(Object.keys(parsed.metadata).length > 0 ? { metadata: parsed.metadata } : {})
      }]
    },
    async get(candidate, options) {
      const parsed = await parseSkill(options?.signal)
      if (parsed === undefined) return undefined
      return {
        name: parsed.name,
        description: parsed.description,
        ...(parsed.whenToUse !== undefined ? { whenToUse: parsed.whenToUse } : {}),
        invocation: { modelInvocable: true, userInvocable: true },
        source: SOURCE,
        provider: name,
        resourceBase: { kind: 'directory', path: RESOURCE_BASE },
        path: SKILL_FILE,
        ...(Object.keys(parsed.metadata).length > 0 ? { metadata: parsed.metadata } : {}),
        content: parsed.content
      }
    }
  }))
}

export { apply, name, inject }
export default { apply, name, inject }
