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
 * Handles the scalar and block-scalar forms DSH skill discovery consumes
 * (name, description, whenToUse, `disable-model-invocation`, `user-invocable`);
 * richer metadata passes through verbatim.
 * @param text - the raw skill file contents.
 * @returns parsed metadata object and the markdown body after the block, or
 *   null when the file has no frontmatter block at all.
 */
function parseFrontmatter(text) {
  if (!text.startsWith('---')) return null
  const end = text.indexOf('\n---', 3)
  if (end === -1) return null
  const lines = text.slice(3, end).split('\n').map(line => line.replace(/\r$/, ''))
  const body = text.slice(end + 4).replace(/^(?:\r?\n)+/, '')
  const metadata = {}
  for (let index = 0; index < lines.length; index++) {
    const match = /^([A-Za-z][\w-]*):[ \t]*(.*)$/.exec(lines[index])
    if (!match) continue
    const key = match[1]
    const inline = match[2].trim()
    const block = /^([|>])([-+]?)$/.exec(inline)
    if (block === null) {
      metadata[key] = unquote(inline)
      continue
    }
    // `|` keeps newlines, `>` folds them, and a trailing `-` strips the final newline.
    const gathered = []
    while (index + 1 < lines.length && (lines[index + 1].trim() === '' || /^[ \t]/.test(lines[index + 1]))) {
      gathered.push(lines[index + 1].replace(/^[ \t]+/, ''))
      index += 1
    }
    while (gathered.length > 0 && gathered[gathered.length - 1] === '') gathered.pop()
    let value = block[1] === '>' ? gathered.join(' ').replace(/[ \t]+/g, ' ').trim() : gathered.join('\n')
    if (block[2] !== '-' && value.length > 0) value += '\n'
    metadata[key] = value
  }
  return { metadata, body }
}

/** Strip one layer of matching single or double quotes from a scalar value. */
function unquote(value) {
  if (value.length >= 2
    && ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'")))) {
    return value.slice(1, -1)
  }
  return value
}

/**
 * Read a frontmatter boolean the way DSH does: a real boolean, `1`/`0`, or the
 * case-insensitive words true/false, yes/no, on/off. Anything else is undefined.
 * @param value - the raw metadata value.
 * @returns the parsed boolean, or undefined when the value is not a boolean literal.
 */
function readBoolean(value) {
  if (typeof value === 'boolean') return value
  if (value === 1) return true
  if (value === 0) return false
  if (typeof value !== 'string') return undefined
  switch (value.toLowerCase()) {
    case 'true':
    case 'yes':
    case 'on':
    case '1':
      return true
    case 'false':
    case 'no':
    case 'off':
    case '0':
      return false
    default:
      return undefined
  }
}

/**
 * Derive the invocation policy from the canonical DSH frontmatter switches.
 * Mirrors @deepseek-ai/dsh-skill-filesystem: `disable-model-invocation: true`
 * hides the skill from the model, `user-invocable: false` hides it from the user.
 * @param metadata - parsed frontmatter metadata.
 * @returns the resolved invocation policy.
 */
function invocationPolicy(metadata) {
  return {
    modelInvocable: readBoolean(metadata['disable-model-invocation']) !== true,
    userInvocable: readBoolean(metadata['user-invocable']) !== false
  }
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
        invocation: invocationPolicy(parsed.metadata),
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
        invocation: invocationPolicy(parsed.metadata),
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
