# Discord profile bot setup (step-by-step)

How to link a Hermes profile's bot to Discord, from the **agrichallenge-bot** build this session.

## Pre-flight checklist

- The profile's `config.yaml` already has `discord.enabled: true` (set via `hermes -p <profile> config set discord.enabled true`).
- The profile's platform toolsets include `discord` (the default clone already enables `discord: [hermes-discord]`).
- You must create a Discord application yourself — the CLI never generates tokens.

## Step-by-step

1. **Create the Discord app + bot**
   - Go to [discord.com/developers/applications](https://discord.com/developers/applications)
   - New Application → name it (e.g. `AgriChallenge Bot`)
   - Go to **Bot** → Create a bot
   - Set **Public Bot** = ON
   - Leave **Require OAuth2 Code Grant** = OFF
   - Under **Privileged Gateway Intents**: enable **Server Members Intent** and **Message Content Intent** (the #1 reason Discord bots fail to connect)
   - Under **Bot → Token**, click **Reset Token** → copy the token (shown once)
2. **Generate the invite URL**
   - Left sidebar → **Installation** → enable **Guild Install**
   - For Install Link, select **Discord Provided Link**
   - **Scopes**: select `bot` and `applications.commands`
   - Note the generated invite link
3. **Set the profile's Discord config**
   - In the profile working directory, set the token and allowlist:
     ```
     hermes config set discord.bot_token "<token>"
     hermes config set discord.allowed_users "["<your-discord-id>"]"
     ```
4. **Finish via the setup wizard**
   - **Run**: `hermes -p <profile> setup` → pick **Discord**
   - The wizard checks the token with Discord, warns if Message Content Intent is off (with a link to the toggle), prints the ready-made invite link, allowlists you as owner
   - Follow the on-screen steps; no Developer Mode needed for allowlisting
5. **Invite the bot**
   - Use the invite URL printed by the wizard
   - The bot now posts in DMs and replies when @mentioned in server channels (default: mention-only in channels)

## Verify

- Run `hermes profile show <profile>` — gateway should show "running" with the Discord adapter active.
- The bot is online when: gateway connects + token is valid.
- Test: DM the bot or @mention it in a channel.

## Pitfalls

- **Bot token is a secret.** Never store it in a skill, SOUL.md, or config.yaml in plain text in a committed repository. It is user-secret configuration, not reusable knowledge.
- **Message Content Intent is the #1 failure.** Without it, Discord rejects the bot's connection at startup. Toggle it ON, Save Changes, and wait for the gateway to pick up.
- **Server Members Intent is required** for the bot to resolve usernames for the allowed-users list.
- **Public Bot must be ON** for the Discord-provided invite link to work. For private bots, use the Manual URL method instead.
- **Each profile gets its own bot.** Telegram tokens are single-profile. The warning about "shares its telegram credential with default" applies to Telegram, not Discord — Discord has its own separate token per profile.
- **One bot per profile.** A second bot with the same name on the same profile will clash with the existing gateway.
- **Guild count ≥ 100** requires a verification application for privileged intents. For personal use (1 server), toggles suffice.