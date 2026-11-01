---
name: user-project-building
description: "Build with the user: short answers, verify target first."
category: software-development
version: 1.0.0
author: mr. freeman
license: MIT
tags: [planning, building, verification]
related_skills: []
---

# User project building

Class-level guide for working with mr. freeman on building software/projects and for answering questions: how I start, how I speak, and what to verify before I act.

## When to Use

Use this skill whenever the user asks me to build, scaffold, or verify a software project — or to start any new chat that involves structuring work. It governs response style throughout.

## Always-on rules

- **Short and direct.** No fluff, no "I'd be happy to," no restating the user's words, no narrating tool calls. One-line question → one-line answer. Deliverable → short report of net change / what was verified, never a process replay.
- **Ask before assuming.** Ambiguous target? Ask for confirmation with concrete options before scaffolding or building. Never infer the project from an ambiguous group chat or partial context.
- **Inspect before concluding.** Linked files/systems: read or inspect first; don't conclude "not found" from memory alone.
- **Local-first, cloud where needed.** Day-to-day uses local models. Upchain to cloud for heavy compute or cloud-specific behaviour. Don't assert a model is available from memory — confirm.
- **Hackathon = cloud + gemma4.** No local AI for the hackathon; mainly gemma4.
- **Verify, then claim.** Don't assert a build/push/commit succeeded unless you actually ran it.

## Workflow: start a new project for the user

1. Confirm the target (project name, location, purpose) if it isn't unambiguous.
2. Inspect current state (Crafts project matrix, git status, existing READMEs) before writing anything.
3. Create the repo and structure, then verify with a real build / run / compile step.
4. Report the net result, not the process.

## Pitfalls

- **Scaffold the wrong project.** Group-chat context is a suggestion, not a target; always confirm the actual project before creating anything. (This cost a session building libft when the target was a different hackathon app.)
- **Narrate instead of deliver.** The user wants the result; skip the process replay.
- **Assume model availability.** Ask or confirm first; never promise a model you haven't checked.

## references

- `references/model-choice.md` — when to use local vs cloud, and gemma4 for hackathons.
