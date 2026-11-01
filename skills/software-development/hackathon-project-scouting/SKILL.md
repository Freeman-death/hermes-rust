---
name: hackathon-project-scouting
description: Scout a hackathon project idea, then describe and name it.
tags: ["hackathon", "ideation", "obsidian", "project-scouting"]
related_skills: ["hermes-agent", "obsidian"]
category: software-development
version: 1.0.0
author: Hermes Agent + user
license: MIT
---

# Hackathon Project Scouting

Scout a project idea from a problem-landscape markdown doc, write a short description, generate a project name, and save a note to the Obsidian vault.

## When to Use

- The user asks for a short description + project name for a hackathon idea, or asks to record it in Obsidian.
- Scouting a problem from a problem-landscape doc (Section 1 summary → Section 2 detail).
- Creating a new Obsidian note that captures an idea, its description, and project name.

## Always-on rules

- The landscape doc is the single source of truth. Read Section 1 (theme summaries) and Section 2 (full detail) rather than inventing facts.
- A "short description" = problem, who it affects, why it matters, 2-day MVP, and hackathon fit — 3–5 lines.
- A project name is a short, catchy 2–4 word agri/agri-tech phrase. Do NOT duplicate an existing idea's label or numbered name (e.g. not "Idea 26", "A1", or the theme name).
- When the user says "the N-th idea", resolve it against Section 1's numbered list. Cross-reference Section 2's internal labels (A1–A32) so you grab the right idea.
- Save the note to the Obsidian vault at the resolved `OBSIDIAN_VAULT_PATH` (default `~/Documents/Obsidian Vault` if unset). Create the note with `write_file`. The doc-structure reference lives in `references/landscape-doc-structure.md`.

## Workflow

1. Resolve the vault path and confirm it exists. (If missing, stop and tell the user — do NOT write into app-support.)
2. Read the landscape doc's Section 1 and map the requested idea number to a Section 1 item.
3. Read Section 2's detail for that idea (Problem / Who / Why / MVP / Sources / fit).
4. Draft the 3–5 line description from those fields.
5. Invent a 2–4 word project name (no duplicates of existing titles/labels).
6. Write the note with the description, name, and source cross-references.

## Pitfalls

- **Vault location.** Obsidian app metadata lives in `~/Library/Application Support/obsidian/`, but that is not the vault. The vault is user-managed and resolved via `OBSIDIAN_VAULT_PATH` (fallback `~/.hermes/vault` on this machine). If the vault folder is missing, tell the user before writing.
- **Idea-number ambiguity.** Section 1 numbers 1–32 grouped into 4 themes (8 each); Section 2 labels them A1–A32. "The 4th idea" = Section 1 item 4, which in this doc's Theme 1 is **Idea A4 — Heat Stress at Flowering**. Always cross-check S1 vs S2 before reading details.
- **Name collisions.** Never reuse A#/Idea labels or theme names in the project name; a good project name is a fresh phrase, not a descriptor.
