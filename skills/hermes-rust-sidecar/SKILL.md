---
name: hermes-rust-sidecar
description: Build a lightweight Rust sidecar for Hermes lifecycle.
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [macos, linux]
metadata:
  hermes:
    tags: [rust, discord, bot, gateway, sidecar, subprocess, lifecycle]
---

## When to Use

Create or update a Rust-based subprocess that runs alongside the Hermes gateway — Discord slash-command bots, WebSocket relays, or any lightweight integration that must start on gateway boot, restart on gateway restart, and terminate cleanly on shutdown. Use this skill when you need a single-binary sidecar with no heavy framework and no cloud dependency beyond its upstream platform.

# hermes-rust-sidecar

Build and integrate a minimal Rust binary as a managed subprocess of the Hermes gateway. Primary example: a Discord Gateway WebSocket bot handling /chat slash commands.

## Always-on rules

1. **Rust only** — no Python, no heavy frameworks (no serenity, no actix, no web server).
2. **Single binary** at `~/.hermes/bin/discord-bot`; target ~5–10MB, ~15–30MB RAM idle, ~0% CPU idle.
3. **Log to `~/.hermes/logs/discord-bot.log`**.
4. **Stateless** — no database.
5. **Short, direct output. No filler.**
6. **Never hand-edit config.yaml** — set values via `hermes config set discord.<key> <value>`. Hermes refuses writes to security-sensitive config.

## Build (do first)

1. Init the Rust project under `~/.hermes/bot_relay/` with `cargo init --name discord-bot`.
2. Dependencies (Cargo.toml): `tokio` (full), `tokio-tungstenite` with `native-tls` feature, `tungstenite`, `tracing`, `tracing-subscriber`, `reqwest` (json), `serde` (derive), `serde_json`, `futures-util`.
3. Build release: `cargo build --release` from the project dir, then `cp target/release/discord-bot ~/.hermes/bin/discord-bot`.

## TLS on macOS (critical pitfall)

Use `native-tls`, NOT `rustls-tls`, for `tokio-tungstenite`. rustls does not trust macOS system certificate roots and fails the Discord Gateway TLS handshake with `invalid peer certificate: UnknownIssuer`. `native-tls` uses the system keychain and connects cleanly.

## Discord Gateway (WebSocket)

1. Connect to `wss://gateway.discord.gg/?v=10&encoding=json`.
2. On Hello (op 10), read `heartbeat_interval`, then Identify (op 2) with bot token, properties, and intents `1 << 0` (GUILDS). Add `1 << 9` (GUILD_MESSAGES) if the bot listens for new messages. GUILD_MESSAGES is not privileged; only `message_content` intent is gated.
3. Heartbeat (op 1) on schedule and on Discord's heartbeat request. Track last sequence (`s` field) for resume.
4. On RESUMED (op 0 / t="RESUMED") or RECONNECT (op 7), handle appropriately — resume with stored session_id + seq, or re-identify on InvalidSession (op 9).
5. Auto-reconnect with exponential backoff 1s → 60s cap on disconnect/close.
6. On READY, store the bot's own user ID from `d.user.id` — used to skip self-messages and prevent response loops.

## Slash command flow (/chat)

1. Register the command via REST: `PUT https://discord.com/api/v10/applications/{app_id}/guilds/{guild_id}/commands` with name "chat", a required STRING option "message", type 3.
2. Use the GUILD ID (not a channel ID) for registration — channel IDs return 403 Missing Access.
3. On INTERACTION_CREATE (type 2, name "chat"): immediately defer (type 5, DeferredChannelMessageWithSource) to buy the 15-minute window.
4. Extract the `message` option value, forward to Ollama `POST {base}/api/generate` with `{model, prompt, stream: false}`.
5. Send follow-up via `POST https://discord.com/api/v10/webhooks/{token}/messages/@original` with `{content: reply}`.

## Auto-reply flow (MESSAGE_CREATE)

1. Handle dispatch op 0 with t="MESSAGE_CREATE" — parse `d` into channel_id, author.id, author.username, content, webhook_id.
2. Skip messages where `webhook_id` is set (avoid webhook loops).
3. Skip messages where `author.id` matches the bot's own user ID (avoid self-response loops).
4. Forward `content` to Ollama `POST {base}/api/generate` with `{model, prompt, stream: false}`.
5. Send reply via `POST https://discord.com/api/v10/channels/{channel_id}/messages` with `{content: reply}`.
6. No defer step needed — MESSAGE_CREATE is not an interaction, so Discord's 3-second window does not apply.

## Hermes gateway lifecycle integration

1. Add spawn to `gateway/run_startup.py` `_start_post_connect_services()`: call `await self._spawn_discord_bot()`.
2. `_spawn_discord_bot()`: verify `~/.hermes/bin/discord-bot` exists, create logs dir, open `~/.hermes/logs/discord-bot.log` append-binary, set `HERMES_CONFIG_PATH` env to `~/.hermes/config.yaml`, `asyncio.create_subprocess_exec` with `start_new_session=True`, store handle in `self._discord_bot_process`.
3. Add termination to `gateway/run_shutdown.py` `_stop_finalize_agents_and_adapters()`: call `await self._terminate_discord_bot()`.
4. `_terminate_discord_bot()`: SIGTERM via `proc.terminate()`, wait up to 5s, then `proc.kill()` if still alive, wait again. Never SIGKILL first.

## Config

Keys: `bot_token`, `guild_id`, `home_channel_id`, `owner_id`, `ollama.base_url`, `ollama.model`.
The bot reads them via a simple line-based scan of config.yaml (serde_yaml is not a dependency; don't add it).

## Pitfalls

- Do not use `home_channel_id` as the guild ID for command registration; Discord returns 403 Missing Access. Use `guild_id` from config.
- Do not use `rustls-tls` on macOS; certificate trust fails against Discord's cert chain.
- Do not add `serde_yaml` just to parse config — a line-based scan for known keys avoids an unnecessary dependency.
- Do not skip the deferred response (type 5); Discord requires an ack within 3 seconds for interactions.
- On MESSAGE_CREATE, skip webhook messages and self-messages by author ID; otherwise the bot replies to itself in an infinite loop.
- For slash-command registration, store `app_id` from READY's `d.application.id` — the config's `guild_id` alone is not enough.
