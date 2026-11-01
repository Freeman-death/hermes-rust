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

### 6. Publish to platform (GitHub + Vercel)  ← add after push

Pushing to git is step one. Getting the project public does the rest.

#### Vercel static export deployment (Expo web)

1. `npx expo export --platform web` → files land in `dist/`
2. Add `vercel.json` to repo root:
   ```json
   {
     "outputDirectory": "dist"
   }
   ```
3. `vercel link` (first time), then `vercel deploy --prod --yes`
4. Verify: `curl -s -o /dev/null -w "HTTP:%{http_code}" <prod-url>`

#### Environment variables (Vercel)

`EXPO_PUBLIC_*` vars must be set in the **Vercel project**, not just `.env`:

```bash
vercel env add EXPO_PUBLIC_TEXT_API_KEY --environment=production --value="<your-key>" --yes
vercel env add EXPO_PUBLIC_TEXT_BASE_URL --environment=production --value="https://ap-southeast-1.maas.qwencloudapi.com/compatible-mode/v1" --yes
# repeat for all EXPO_PUBLIC_* vars
```

If the build serves the page but AI calls fail with 401/invalid key, the env vars were not in the build.

#### GitHub contributor attribution (AI agent commits)

If commits were made by an AI agent (e.g. `Claude <claude@anthropic.com>`),
GitHub will show them as a contributor when you expect a human name.

1. Create a `.mailmap` at repo root:
   ```
   Claude <claude@anthropic.com> Freeman <ayoub.meziane.hu@icloud.com>
   ```
2. Rewrite history with filter-branch:
   ```bash
   git filter-branch -f --env-filter 'export GIT_AUTHOR_NAME="Freeman"; export GIT_AUTHOR_EMAIL="ayoub.meziane.hu@icloud.com"; export GIT_COMMITTER_NAME="Freeman"; export GIT_COMMITTER_EMAIL="ayoub.meziane.hu@icloud.com"' HEAD
   ```
3. Remove old refs + prune:
   ```bash
   git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
   git reflog expire --expire=now --all
   git gc --prune=now --aggressive
   ```
4. Force push:
   ```bash
   git push --force origin main
   ```

The contributor graph on GitHub updates after the force push settles.

#### README preview-link updates

When the Vercel URL changes:
1. Update the preview link in README (`## 🌐 Live demo`)
2. Commit and push
3. Don't leave stale preview links from `--temporary` deployments.

## Pitfalls

- **`vercel deploy --temporary`** creates a transient deployment that expires and gets cleaned up. Use `vercel deploy --prod` for permanent URLs.
- **Expo static export `output: "server"`** does not work on Vercel. Set `output: "static"` in `app.json` `web` config, then `outputDirectory: "dist"` in `vercel.json`.
- **Missing API keys in Vercel** → the app serves but AI features 401. Add all `EXPO_PUBLIC_*` vars to the Project Settings → Environment Variables tab, both Development and Production.
- **Contributor graph shows AI** → AI agent commits create fake contributors. Use `.mailmap` + `git filter-branch` + force push to restore the human attribution.
