---
name: hermes-profile-management
description: Switch, verify and manage existing Hermes profiles.
tags: ["hermes", "profiles", "configuration", "multi-agent"]
related_skills: ["hermes-role-profiles"]
category: autonomous-ai-agents
version: 1.0.0
author: Hermes Agent + user
license: MIT
---

# Hermes Profile Management

Use this for switching an existing named profile in the current session and verifying the switch. For creating a new focused profile from scratch, use hermes-role-profiles.

## When to Use

- Switching or verifying which Hermes profile the current session is running under (e.g. "switch to agrichallenge-bot", "which profile is active?").
- Running a command inside a specific profile's context (e.g. list its skills or edit its config).
- Troubleshooting profile-level issues: gateway state, credential conflicts, isolated skill/memories.

## Always-on rules

- `hermes profile list` — show every profile (name, model, gateway, alias, distribution) and any Telegram-credential warnings.
- `hermes profile use <name>` — persistent, session-level switch to that profile. Prints "Switched to: <name>".
- `hermes profile show <name>` — confirm the active profile: path, model, gateway, skills count, .env and SOUL.md present.
- Run further commands in that profile with `hermes -p <name> <subcommand>` (e.g. `hermes -p agrichallenge-bot skills list`), not as the default session.

## Switching a profile

1. `hermes profile list` — confirm the target exists and its gateway is running.
2. `hermes profile use <name>` — switch.
3. `hermes profile show <name>` — verify the switch landed.

## Pitfalls

- **Telegram credential sharing.** Messenger tokens are shared across profiles: only ONE profile may own a bot per platform. `hermes profile list` prints "shares its telegram credential" warnings for non-default profiles that have a bot. These are notices, not errors: the multiplexer parks the duplicate and `hermes gateway migrate --multiplex` refuses until the duplicate is dropped. If you only need chat, ignore the warnings; to run a bot, give the profile its own token via `hermes -p <name> setup`.
- Never hand-edit a profile's `config.yaml`; use `hermes -p <name> config set KEY VAL --force`.
- Do not read or modify another profile's skills/plugins/cron/memories unless the user explicitly directs it. Profiles are isolated under `~/.hermes/profiles/<name>/`.
