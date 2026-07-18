# global agent instructions

- Never use the em dash "—". Use plain dash "-" instead
- When writing commit messages, NEVER auto-add your agent name as co-author
- Never manually modify CHANGELOG.md files or any files that are marked as auto-generated
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user would experience it as possible.
  This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
  If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
  If you see one, even if it is not caused by what you are working on right now, still get it fixed.

## LLM Wiki

This machine has a persistent LLM wiki at ~/dev/wiki. To access it from any repo:

    ln -sfn ~/dev/wiki .omc/wiki

### Operations (OMC wiki tools)
- `wiki_query({ query: "keywords" })` — search pages by keyword + tag
- `wiki_read({ page: "page-slug" })` — read a specific page
- `wiki_add({ title: "...", content: "...", tags: [...], category: "..." })` — add a page
- `wiki_ingest({ title: "...", content: "...", tags: [...], category: "..." })` — multi-page ingest
- `wiki_list()` — list all pages
- `wiki_lint()` — health check (run monthly)

### When to query
Before answering questions about this machine's environment, Nix patterns, tool constraints, or architectural decisions. The wiki is the first place to check for "why is it done this way?" questions.

### When to write
After discovering something that took >15 minutes to figure out, or any environment/tool fact that a future session would waste time re-deriving. Keep entries under 300 words, one fact per page.

### When NOT to write
If the fact is readable from source code, git history, or official docs — skip it.

### Schema
See ~/dev/wiki/CLAUDE.md for the full page format spec (frontmatter fields, categories, cross-reference syntax).

### Categories
architecture | decision | pattern | debugging | environment | session-log | reference | convention

`media` and `person` are NOT categories — use `category: reference` + a `media` or `person` tag. See `~/dev/wiki/CLAUDE.md` §Categories.

### Filing Media (videos, audio, images, PDFs, documents)

For media content (URL or local file), use the `/file` skill — it auto-detects media type, transcribes/describes/summarizes, extracts key screenshots from videos, and writes a clean markdown note into the Octarine workspace (`~/dev/notes/octarine/personal/personal/YY.MM.DD <Title> [<Type>].md`) plus a binary copy to `~/dev/media/<type>/<yyyy-mm>/`.

```
/file <url-or-path>
/file <path> --force   # bypass PDF 20-page cost cap (flag may appear anywhere)
```

Skill spec: `~/.claude/skills/file/SKILL.md`. Triggers: `/file`, `file this`. The wiki (`wiki_add`) is NOT written by `/file` anymore — Octarine is the default note destination.

### Session workflow
- Start: `cd ~/dev/wiki && git pull --ff-only`, then `wiki_query` with task-relevant keywords
- End: capture findings with `wiki_add`, then `cd ~/dev/wiki && git add -A && git commit -m "session $(date +%Y-%m-%d)" && git push`

## Review Loop (RLP) — Default Review Gate

After non-trivial implementation work (code changes, refactors, bug fixes), run the **Review Loop** before claiming the work is done. RLP cycles your changes through **Codex adversarial review** + **CodeRabbit review** in parallel until both pass with zero issues remaining.

### When to Use RLP

- Code changes, refactors, bug fixes, or significant feature work
- After implementation is complete, before commit/PR
- When acceptance criteria can be clearly stated (plan-driven preferred)

### When to Skip RLP

- Trivial changes: docs-only, comment fixes, config tweaks, `.md` files only
- Single-line fixes or minimal edits
- When the user explicitly says "skip review" or "no review needed"

### How to Invoke

Read `~/.omc/skills/review-loop/SKILL.md` for the full skill specification. Trigger patterns: `rlp`, `review loop`, `dual review`.

**Usage:**
```
rlp --plan .omc/plans/my-feature.md           # Plan-driven (preferred)
rlp "task; acceptance: criterion1, criterion2"  # Inline criteria
rlp 3 "refactor X; acceptance: Y, Z"          # Max 3 cycles
```

### Fallback Behavior

- **Codex missing:** Falls back to `oh-my-claudecode:code-reviewer` (Claude-native adversarial review)
- **CodeRabbit missing:** Skill exits with error; install CodeRabbit CLI and authenticate via `coderabbit auth login`

### Integration with Workflow

Workflow order: **Brainstorm** → **Plan** → **Implement** → **RLP** (verification gate) → **Commit/PR**

Success: Both reviewers pass with zero issues. If max cycles are exhausted before both pass, consider relaxing criteria or addressing remaining issues manually before committing.

@~/.claude/OCTARINE_SKILLS.md
