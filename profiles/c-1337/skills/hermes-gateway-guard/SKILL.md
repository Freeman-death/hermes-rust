---
name: hermes-gateway-guard
description: "Verify gateway is running before cron jobs."
version: 1.0.0
author: Hermes Agent, Nous Research
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [gateway, cron, verification, setup]
    related_skills: [hermes-agent, hermes-setup-macos, weekly-review-planning]
---

# Gateway Guard

Before any cron-dependent workflow, verify the Hermes gateway is running.

## Rule

**Cron jobs do not fire if the gateway is not running.** Always check before scheduling or relying on cron.

## Verification

```bash
hermes gateway status
```

If inactive:
```bash
hermes gateway install   # install as launchd service
hermes gateway start
```

## Pitfall

Cron jobs created via `tool_call` are saved but will NOT fire until the gateway is running. This is the most common reason scheduled tasks silently fail.

## macOS Setup

Install as launchd for auto-start at login:
```bash
hermes gateway install
```

Verify after OS updates — launchd plist can be reset by system updates.
