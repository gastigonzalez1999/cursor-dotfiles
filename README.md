# cursor-dotfiles

Portable **Cursor rules** and **skills** you can copy into any repo. Works on **Windows** (PowerShell) and **macOS/Linux** (Bash).

**Repository:** [github.com/gastigonzalez1999/cursor-dotfiles](https://github.com/gastigonzalez1999/cursor-dotfiles)

## What you get

- **Skills** under `.cursor/skills/<slug>/SKILL.md`: core engineering (debug, pre-edit, how, verify-after-change, thermo-nuclear review, auto-improve, browser-use, frontend-design, …), architecture, workflow, and stacks. See `rules/toolkit-skills-index.mdc`.
- **Eight rules** under `.cursor/rules/toolkit-*.mdc`: execution, investigate-before-editing, change discipline, communication, conversation context, secrets and safety, **karpathy guidelines**, and skills index.

Rules use the `toolkit-` prefix so they do not silently overwrite unrelated files. Skills merge by folder name; existing skill folders are **skipped** unless you force.

## Global install (all Cursor projects on this machine)

```bash
cd cursor-dotfiles
chmod +x install-global.sh install-external-skills.sh
./install-global.sh --force
./install-external-skills.sh   # optional: vercel-react-native-skills, core-bluetooth
```

Installs to `~/.cursor/skills` and `~/.cursor/rules` (Windows: `%USERPROFILE%\.cursor\` when using PowerShell with `-Global`).

## Per-project install

Clone this repo once, then run the installer from inside the clone.

```bash
git clone https://github.com/gastigonzalez1999/cursor-dotfiles.git
```

### macOS / Linux / Git Bash

```bash
cd cursor-dotfiles
chmod +x install.sh
./install.sh /path/to/your-project
# or from the project root:
/path/to/cursor-dotfiles/install.sh .
```

### Windows (PowerShell)

```powershell
cd D:\path\to\your-project
& D:\path\to\cursor-dotfiles\install.ps1
# or with an explicit path:
& D:\path\to\cursor-dotfiles\install.ps1 -ProjectPath "D:\path\to\your-project"
```

### Flags

| Bash | PowerShell | Meaning |
|------|------------|--------|
| `--global` | `-Global` | Install to user home `~/.cursor/` (all projects) |
| `--skip-rules` | `-SkipRules` | Copy skills only |
| `--force` | `-Force` | Replace existing skill folders and rule files |

## After install

1. Open the **project folder** as the Cursor workspace root (not only a subfolder) so `.cursor/` applies.
2. Optional: add more skills with [skills.sh](https://skills.sh): `npx skills add <owner/repo>` from the project root.
3. Optional: copy heavy skill libraries from `~/.claude/skills/` or `%USERPROFILE%\.cursor\skills\` into `.cursor/skills/` if the workspace cannot read home paths.

## Updating

Re-run the installer with `--force` / `-Force` after pulling a newer toolkit version.

**macOS:** If `.cursor/skills` ever looked flattened (many `SKILL.md` fragments at the top level), you hit a BSD `cp` trailing-slash quirk fixed in installer **v1.3.1** — wipe that folder or run `--force` again after upgrading the clone.

## Version

See `VERSION`.
