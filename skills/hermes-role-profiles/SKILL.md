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

## Hackathon & Specialist Bot Profiles

A hackathon-facing bot profile is a narrower, knowledge-dense beast: it must carry the hackathon's facts, problem base, and guardrails inside SOUL.md, then be reachable on Discord for its users. The workflow below came from building `agrichallenge-bot`.

1. **Create the profile.** Clone from `default` (inherits model + skill set), set a description:
   ```
   hermes profile create agrichallenge-bot --clone-from default --description "AgriChallenge 6ème Edition hackathon assistant: problem finder, project advisor, Q&A bot."
   ```
2. **Write the SOUL.md.** Overwrite the generic clone SOUL.md with role-specific knowledge:
   - Identity, tone, and language (match the user's language — here French + English)
   - Hard facts (dates, format, team size, organisers)
   - The domain knowledge the bot must know (here: 32 project ideas with problem/who/why/MVP/sources)
   - How the bot should behave in conversation (what to do per question type)
   - Guardrails (no invented stats, don't share secrets, stay on scope)
   Keep it SHORTER than a novel — it's the steering layer, not the full script. A future session should be able to replace the content and keep the structure.
3. **Set the description.** After creation, persist what the profile is good at:
   ```
   hermes profile describe agrichallenge-bot --text "AgriChallenge 6ème Edition hackathon assistant for UM6P x IAV students: finds agricultural problems, scopes 2-day projects, answers Q&A on the hackathon."
   ```
4. **Give the profile its own Discord.** Each profile gets its own bot — the Telegram token cannot be shared across profiles (warning: messaging channels were NOT cloned). Steps:
   a. Create a Discord app + bot at [discord.com/developers/applications](https://discord.com/developers/applications).
   b. Enable **Public Bot** = ON and **Require OAuth2 Code Grant** = OFF.
   c. Enable **Server Members Intent** and **Message Content Intent** under Privileged Gateway Intents (the #1 reason Discord bots fail to connect).
   d. Under Bot → Token, **Reset Token** and copy the generated token.
   e. Place the token in the profile's `.env` — NOT in config.yaml:
      ```bash
      echo "DISCORD_BOT_TOKEN=<the token>" >> ~/.hermes/profiles/<name>/.env
      ```
      The gateway reads bot tokens from the profile's `.env`, NOT from `hermes config set` (which writes to the main config). `hermes config set` is fine for non-secret flags (`enabled`, `require_mention`) in the profile's `config.yaml`.
   f. Install the Discord Python dependencies into the Hermes agent's venv:
      ```bash
      /Users/macbook/.hermes/hermes-agent/venv/bin/python -m pip install discord.py PyNaCl
      ```
   g. Run `hermes -p agrichallenge-bot setup` and pick **Discord** (the wizard checks the token, warns if Message Content Intent is off, prints the invite link, allowlists you).
   h. Invite the bot to the server with the generated link. Optional: add user IDs to `allowed_users` in `config.yaml` to restrict the bot to the hackathon team.
5. **Verify the Discord adapter is online.**
   - Run `hermes profile show <profile>` — gateway should show "running", and the Discord adapter should show as connected.
   - The bot is online when: Discord gateway connects + token is valid.
   - Test: DM the bot or @mention it in a channel.
   - A `discord connect timed out after 30s` error means the token is likely invalid **or the bot is not in the server** (once discord.py/PyNaCl are installed). Verify: is the bot invited? Is Public Bot ON? Are intents enabled? Is the token still valid?

## Communication Style (standing user preferences)

- **Spartan.** Short, direct answers. No filler — no "Great question," "I'd be happy to," no restating the request, no narrating tool calls.
- Match reply length to ask weight: a one-line question gets a one-line answer; finished work gets a short report of what changed/verified.
- Answer in the language the user writes in (here: French for a Moroccan student, English where technical).
- Long answers are structured: clear first section (summary), then detailed sections with sources. Headings and blank lines do the layout — markdown renders as literal characters here, so use plain text formatting.
- Depth only when asked or when the stakes demand it. Broad overview first, details on demand.

## References

- `references/hackathon-research-workflow.md` — the 4-parallel-agent research + consolidate pattern used to build the hackathon problem base.
- `references/discord-profile-setup.md` — step-by-step Discord linkup details for a profile's bot.