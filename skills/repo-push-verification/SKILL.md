---
name: repo-push-verification
description: "Verify local git state before pushing a repo."
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [git, github, push, verification, repo-management]
    related_skills: [github]
---

# Repo Push Verification

Gates to run before creating a GitHub repo or pushing a local repo. Prevents
pushing the wrong directory, a broken index, or an unintended repo name.

## When to Use

- User says "push", "push to GitHub", "create repo", or "upload"
- A local git repo exists and the remote is missing or needs creation
- Multiple similarly-named project directories exist and you must pick one

## Procedure

### 1. Identify the canonical project directory

```bash
cd <candidate-dir>
git status
ls -la
ls src tests 2>/dev/null
```

A canonical project has:
- A clean or sensibly staged `git status`
- Actual source files at the repo root (not sibling paths staged as `../other/`)
- Tests, README, or Makefile present

If multiple candidates exist, compare:
- Which has tests vs stubs
- Which has a README with progress/completion status
- Which has a clean git index (no mis-rooted staged paths)

### 2. Check for documented remote intent

Before inventing a repo name, check:
- README.md for intended GitHub path
- setup-guide.md, project-matrix.md, or similar index
- Existing `git remote -v` (may be empty or stale)

Use the documented owner/repo if present.

### 3. Verify git log and branch state

```bash
git status
git log --oneline -5
# If no commits exist, the repo needs an initial commit before pushing
```

If `git status` fails (not a git repo), run `git init` first.

### 4. Create remote and push

```bash
# Authenticated with gh first (see github skill auth reference)
# Default to --private for student/school repos unless user says public
gh repo create <repo-name> --source . --private --push
```

### 5. Post-push cleanup (if requested)

If the user says "delete the rest" or "remove the others", delete the
non-canonical sibling directories after the push succeeds. Verify the
deleted paths are the ones identified as non-canonical in Step 1.

## Pitfalls

- **`git rev-parse --is-inside-work-tree` always exits 0** — it prints `true` or `false` and returns 0 in both cases, so `&& echo "is git"` always runs. Use `git status` for a reliable presence check.
- **Broken git index with sibling paths staged** — `git status` shows `new file: ../other/file.c` staged. The repo root is wrong. Run `git reset`, re-stage the actual project root, then push.
- **Empty commits / no git history** — `gh repo create --source . --push` requires at least one commit. If `git log` is empty, run `git add . && git commit -m "Initial commit"` first.
- **Multiple similar directories** — Do not guess. Run the comparison checklist in Step 1 and, if still ambiguous, ask the user which directory is the canonical project.
