# Working on this repository

**This repo is generated output.** `skills/`, `rules/`, `commands/` and `loop/`
are built from [agent-dotfiles](https://github.com/gastigonzalez1999/agent-dotfiles)
by `scripts/sync-to-cursor.mjs`, which replaces those directories wholesale on
every sync.

So before editing anything here, check where it comes from:

| Path | Edit here? | Where it actually lives |
|---|---|---|
| `skills/**` | **no** | `agent-dotfiles/skills/<name>/SKILL.md` |
| `rules/toolkit-skills-index.mdc` | **no** | generated from the skills' frontmatter |
| `rules/*.mdc` (all others) | **no** | `agent-dotfiles/rules/` |
| `commands/**` | **no** | `agent-dotfiles/cursor/commands/` |
| `loop/**` | **no** | `agent-dotfiles/loop/` |
| `install*.sh`, `install.ps1` | yes | here |
| `README.md`, this file, `VERSION` | yes | here |

A change made in the wrong place is not rejected — it is silently reverted the
next time anyone runs the sync. That is the single most useful thing to know
about this repository.

## Changing a skill or rule

```bash
cd ../agent-dotfiles
# edit skills/<name>/SKILL.md — and make sure its frontmatter lists cursor:
#   targets: [claude, cursor, codex]
node scripts/sync-to-cursor.mjs ../cursor-dotfiles
```

Then commit in **both** repos. `--check` exits non-zero when this repo is behind,
so it works as a pre-push gate:

```bash
node scripts/sync-to-cursor.mjs ../cursor-dotfiles --check
```

## Changing an installer

The installers are the reason this repo exists separately — they are Cursor
specific and hand-written.

- `install.sh` / `install.ps1` — per-project install into `<project>/.cursor/`
- `install-global.sh` — install into `~/.cursor/` for every project
- `install-external-skills.sh` — optional third-party skills

Flags are `--global` / `--skip-rules` / `--force` (PowerShell: `-Global`,
`-SkipRules`, `-Force`). Keep the two implementations in step; a flag that exists
in only one of them is a bug.

Test against a scratch directory rather than a real project:

```bash
./install.sh "$(mktemp -d)"
```

## Conventions

- **Rules are prefixed `toolkit-`** so installing into a project cannot clobber
  an unrelated rule file of the same name.
- **Rules are `alwaysApply: true`**, which means every one of them costs context
  on every turn. Adding a rule is a real cost — prefer a skill, which loads only
  when triggered.
- **Line endings are pinned** by `.gitattributes`: LF for `.md`/`.mdc`/`.sh`/`.mjs`,
  CRLF for `.ps1`. The sync normalizes to LF on the way in, so a Windows checkout
  cannot introduce a spurious diff.

## Behavioral rules

- Think before coding; state assumptions; ask when uncertain.
- Minimum code that solves the problem; no speculative abstractions.
- Surgical edits only; match existing style; remove orphans your changes created.
- Define verifiable success criteria and check them before finishing.
- When corrected, re-read the user's message and confirm before proceeding.
- When stuck, summarize attempts and ask for guidance.

<!-- loop:begin -->
## Verification loop

This repository declares how to verify work in `.agent/loop.json`. `loop` is
`node ~/.claude/loop/loop.mjs`, or `npx -y github:gastigonzalez1999/agent-dotfiles loop`
on a machine without it.

- After an edit: `loop fast`. Before saying the work is done: `loop full`, and it must exit 0.
- A failing `guard` check means a line you added breaks a project rule. Fix the cause; never suppress, reword or move the line to get past it.
- When the user corrects a mistake, propose a `guard.rules` entry in `.agent/loop.json` that would have caught it, instead of adding prose here.
- If `features` are declared, run `loop prove` for the ones you touched and cite `.agent/.loop-proof/` as evidence.
<!-- loop:end -->
