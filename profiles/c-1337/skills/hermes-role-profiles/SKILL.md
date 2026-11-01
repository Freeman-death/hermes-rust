---
name: hermes-role-profiles
description: Use when spinning up a purpose-built Hermes role profile.
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [hermes, profiles, configuration, multi-agent]
    related_skills: [hermes-agent]
---

# Role Profiles

A role profile is a purpose-built Hermes instance tuned for one kind of work (a hackathon, a design pass, a coding sprint, a philosophy chat). The default profile stays general; role profiles are narrow on purpose. Raw `hermes profile` command syntax lives in the bundled `hermes-agent` skill — this skill is the *pattern* for making a focused one.

## When to Use

- The user wants a separate Hermes instance tuned for one task or role ("make a profile for the hackathon", "a design-only profile").
- A clone exists but carries too much (generic SOUL.md, every skill enabled) and needs to be focused.

1. **Clone a base, don't build from scratch.** `hermes profile create <name> --clone-from default --description "<what it's for>"`. Cloning carries config, `.env` (provider keys), and skills, so the new profile inherits auth. `--description` powers kanban role-routing — write what the profile is *good at*, not its name.
2. **Write the system prompt into SOUL.md.** SOUL.md *is* the personality / system prompt. For a role profile keep it SHORT and focused on that role's goal, hard constraints, and how to work — not a generic persona. Overwrite the cloned generic SOUL.md; don't append to it.
3. **Trim skills aggressively.** A focused role wants few skills. List what's on: `hermes -p <name> skills list`. Disable the rest in one write (see Pitfalls for the flag):
   `hermes -p <name> config set skills.disabled "<yaml list>" --force`
4. **Pick the model for the role.** Clones inherit the base model, which is often too weak for the work (e.g. a small local model for a coding role). Switch with `hermes -p <name> model` (interactive picker).
5. **Rename if the create name was a placeholder** — `hermes profile rename <a> <b>` (updates path + alias wrapper).

## Pitfalls

- **`config set skills.disabled` prints "not a recognized config key" but still saves correctly.** It parses the YAML into a real list and round-trips fine; the warning is a schema-version false positive. Don't hand-edit config.yaml to work around it — the CLI write is the sanctioned path and keeps indentation safe.
- **Don't hand-edit config.yaml.** Use `hermes config set`; a stray indent corrupts the file and can break the live gateway. This bites most on list values like `skills.disabled`, which look intimidating to edit by hand.
- **A clone starts with every skill enabled.** Trimming (step 3) is required, not optional — a role profile with 60+ skills loads noise into every turn.
- **The cloned SOUL.md is generic.** Overwrite it; leaving the default persona defeats the point of a role profile.

## Keep vs disable (coding / agent roles)

Keep: delegation (`opencode`, `software-builder`), repo/publish (`github`, `repo-push-verification`), debug (`python-debugpy`, `node-inspect-debugger`), QA (`dogfood`, `requesting-code-review`, `sdlc-review`), ops (`hermes-agent`, `hermes-provider-setup`). Disable: email, docs (`docx`/`pdf`/`powerpoint`/`xlsx`), media, social, apple, note-taking, maps — anything off the role's critical path.
