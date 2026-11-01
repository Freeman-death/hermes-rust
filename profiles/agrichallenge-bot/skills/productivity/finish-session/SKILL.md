---
name: finish-session
description: Reset SESSION.md to starting fresh after completing a project or session.
version: 1.0.0
author: mr. freeman, Hermes Agent
license: MIT
platforms: [linux, macos, windows]
---

# Finish Session

Reset `~/.hermes/SESSION.md` to the starting state. Use when mr. freeman says `/finish`, "finish", "end session", "wrap up", or wants to close out completed work.

## How to Run

```bash
cat > ~/.hermes/SESSION.md << 'EOF'
# Session State

## Summary
starting fresh

## Completed
-

## Active
-
EOF
```

## Behavior

- Overwrites `~/.hermes/SESSION.md` completely.
- Sets Summary to `starting fresh`.
- Clears Completed and Active sections.
- Does not touch any other files.

## When to Use

- After completing a project or major task
- When starting a new phase and want a clean slate
- When mr. freeman explicitly asks to finish/reset
