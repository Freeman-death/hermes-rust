---
name: hermes-setup-macos
description: "Set up Hermes on macOS: gateway, vault, cron."
version: 1.0.0
author: Hermes Agent, Nous Research
license: MIT
platforms: [macos]
metadata:
  hermes:
    tags: [setup, macOS, gateway, local-first, obsidian]
    related_skills: [hermes-agent, obsidian, weekly-review-planning]
---

# Hermes Setup — macOS (Local-First)

Setup procedure for Hermes Agent on macOS with a local-first workflow.

## When to Use

- Setting up Hermes on a new Mac
- Gateway is not running and cron jobs need to fire
- Configuring Obsidian vault path

## Procedure

### 1. Verify Hermes installation

```bash
hermes --version
hermes doctor
```

### 2. Start the gateway

```bash
hermes gateway install   # launchd service
hermes gateway start
hermes gateway status    # verify
```

**Pitfall:** Cron jobs silently fail if gateway is not running.

### 3. Configure the Obsidian vault path

Add `OBSIDIAN_VAULT_PATH=$HOME/Documents/Obsidian Vault` to `~/.hermes/.env`.

Create vault directory:
```bash
mkdir -p "$HOME/Documents/Obsidian Vault"
```

**Pitfall:** `~/.hermes/.env` is protected — use `write_file` via Hermes tools, not shell redirection. The OS blocks `cat ~/.hermes/.env` with an access-denied error; do NOT bypass this by forcing the read — secrets must never enter the conversation. Platform credentials like `TELEGRAM_BOT_TOKEN` go in `.env`, never in `config.yaml`.

### 4. Set up core vault notes

Create in vault: README.md, Project-Board.md, Weekly-Review.md, SAAS-Ideas.md, Social-Media-Plan.md, 1337-School.md. Use wikilinks (`[[Note Name]]`).

### 5. Schedule weekly review cron job

Use `cronjob_manage` (via `tool_call`):
- prompt: weekly review instructions
- schedule: `0 18 * * 0` (Sundays 6 PM)
- skills: ["weekly-review-planning"]
- deliver: "local"

### 6. Verify

```bash
hermes gateway status
ls ~/Documents/Obsidian\ Vault/
crontab -l
hermes cron list
```

## Pitfalls

- **Gateway not running = cron dead.** Install as launchd service.
- **`.env` is protected.** Use `write_file` through Hermes tools, never shell cat/redirection. OS blocks reads; bypassing the guard risks leaking secrets into conversation.
- **Messaging platform tokens go in `.env` only.** `TELEGRAM_BOT_TOKEN`, `TELEGRAM_ALLOWED_USERS`, `SLACK_TOKEN`, etc. — never in `config.yaml`.
- **Vault path must be absolute.** File tools don't expand shell variables.
- **Space in path.** Always quote paths with spaces.

## Verification

- [ ] `hermes gateway status` returns service active
- [ ] Core vault notes exist
- [ ] `crontab -l` shows weekly review at `0 18 * * 0`
- [ ] `hermes cron list` shows enabled job
