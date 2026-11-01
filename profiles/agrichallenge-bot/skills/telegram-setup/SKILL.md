---
name: telegram-setup
description: "Set up Telegram bots with Hermes Agent."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [telegram, bot, setup, messaging, configuration]
    homepage: https://hermes-agent.nousresearch.com/docs/user-guide/messaging/telegram
---

# Telegram Setup for Hermes Agent

Hermes Agent integrates with Telegram as a full-featured conversational bot. This skill covers the complete setup process for connecting Hermes to Telegram.

## When to Use This Skill

Use this skill when you want to:
- Connect Hermes Agent to Telegram for cross-platform chatting
- Set up a Telegram bot that can run Hermes routines and delegate tasks
- Configure Telegram-specific features like voice messages, file attachments, and group chat behavior

## Quick Setup (Recommended)

### Via Dashboard or Desktop App

1. Open Hermes dashboard (`hermes desktop`) or desktop app (`hermes dashboard`)
2. Navigate to Messaging → Telegram page
3. Click the "Create with QR" button
4. Scan the QR code with your Telegram app or open the link it provides
5. Hermes will automatically:
   - Create a new bot via @BotFather
   - Detect your Telegram user ID
   - Write `TELEGRAM_BOT_TOKEN` and `TELEGRAM_ALLOWED_USERS` to the active profile's `.env`
   - Restart the gateway to load the new configuration

### Manual Setup Steps

When you prefer to create the bot yourself or need more control:

### Step 1: Create Bot via @BotFather

1. Open Telegram and search for `@BotFather`, or visit t.me/BotFather
2. Send `/newbot`
3. Choose a **display name** (this can be anything, e.g., "Hermes Agent")
4. Choose a **username** — must be unique and end in `bot` (e.g., `my_hermes_bot`)
5. BotFather will reply with your **API token** in format:
   ```
   123456789:ABCdefGHIjklMNOpqrSTUvwxYZ
   ```
   
   > **Warning**: Keep this token secret. Anyone with this token can control your bot. If leaked, revoke immediately via `/revoke` in BotFather.

### Step 2: Get Your Telegram User ID

1. Open Telegram and search for `@userinfobot`
2. Send `/start`
3. The bot will reply with your numeric user ID (e.g., `6853580822`)

### Step 3: Configure Hermes

Add the credentials to your environment:

#### Global Configuration (affects all profiles)

Edit `~/.hermes/.env`:

```bash
TELEGRAM_BOT_TOKEN=your_bot_token_from_step_1
TELEGRAM_ALLOWED_USERS=your_user_id_from_step_2
```

#### Profile-Specific Configuration

If using profiles (e.g., `philosophical-assistant`, `software-builder`), add to:

```bash
~/.hermes/profiles/<profile_name>/.env
```

### Step 4: Restart the Gateway

```bash
hermes gateway restart
```

Wait 10-15 seconds, then verify:

```bash
hermes gateway status
```

## Optional Bot Customization

After setup, enhance your bot's profile and commands via @BotFather:

| Command | Purpose |
|---------|--------|
| `/setdescription` | "What can this bot do?" text shown before chatting |
| `/setabouttext` | Short text on the bot's profile page |
| `/setuserpic` | Upload an avatar for your bot |
| `/setcommands` | Define the command menu (accessed via `/` button in chat) |
| `/setprivacy` | Control whether bot sees all group messages |

**Suggested starter commands**:
```
help - Show help information
new - Start a fresh conversation
sethome - Set this chat as the home channel
```

## Telegram-Specific Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TELEGRAM_BOT_TOKEN` | Telegram bot token from @BotFather | (required) |
| `TELEGRAM_ALLOWED_USERS` | Comma-separated list of allowed Telegram user IDs | (required) |
| `TELEGRAM_REQUIRE_MENTION` | Require explicit `@botname` trigger in groups | `false` |
| `TELEGRAM_BOTS_REQUIRE_MENTION` | Require `@botname` from other bots to respond | `false` |

Set these in `.env` or via `hermes config set` (for non-secret values):

```bash
# For boolean values in .env
TELEGRAM_REQUIRE_MENTION=true

# Or via hermes config (for config.yaml)
hermes config set telegram.require_mention true
```

## Troubleshooting

### "Duplicate Bot Token" Warning

If you see: "Profiles 'X' and 'Y' both hold the same telegram credential"

This happens when multiple profiles try to use the same bot token. Only one gateway can use a given token.

**Solutions**:
1. **Remove duplicates**: Keep token in only one profile's `.env` (usually `default` or `Main`)
2. **Separate bots**: Create different bots for different profiles via @BotFather
3. **Profile routing**: Use `gateway.profile_routes` in `config.yaml` to direct chats to specific profiles

### Gateway Not Responding

After changing .env:
1. Run `hermes gateway restart`
2. Wait 10-15 seconds for full restart
3. Check `hermes gateway status`
4. Check logs: `cat ~/.hermes/logs/gateway.error.log`

### Bot Not Responding in Groups

By default, Telegram bots in privacy mode only see:
- Messages that start with `/`
- Messages that reply to the bot
- Messages where the bot is `@mentioned`

To change this:
1. Go to @BotFather → your bot → `/setprivacy`
2. Choose `Disable` to let bot see all group messages
3. Or keep enabled and ensure users `@mention` your bot

### Voice Messages Not Transcribing

Ensure STT is enabled:

```bash
hermes config set stt.enabled true
hermes gateway restart
```

## Advanced Configuration

### Running Multiple Telegram Bots

Each bot token can only be used by one gateway instance. To run multiple:
1. Create separate bots via @BotFather (each gets unique token)
2. Assign each token to different profiles or separate Hermes instances
3. Configure each instance's `.env` with its respective token

### Using Webhooks Instead of Polling

By default, Hermes uses polling. For webhooks (requires public URL):

1. Set up a public HTTPS endpoint (ngrok, cloudflare tunnel, etc.)
2. Configure in .env:
   ```
   TELEGRAM_USE_WEBHOOKS=true
   TELEGRAM_WEBHOOK_URL=https://your-domain.com/telegram/webhook
   ```
3. Restart gateway

## Security Best Practices

1. **Never share your bot token** - treat it like a password
2. **Use @BotFather `/revoke`** if token is ever exposed
3. **Limit allowed users** - only add trusted user IDs to `TELEGRAM_ALLOWED_USERS`
4. **Consider group privacy** - evaluate if your bot needs to see all group messages
5. **Regular rotation** - periodically create new bots and update credentials

## Verification

After setup, verify by:
1. Sending `/start` to your bot in Telegram
2. The bot should respond with a welcome message or help text
3. Try `hermes chat -q "test"` and see if you get a response in Telegram
4. Check `hermes gateway status` shows "telegram" platform as connected

## Direct Bot API — Sending Files and Photos

When Hermes has no dedicated send-file tool, or you need a one-off push from the shell, use the Telegram Bot API directly. The bot token lives in `~/.hermes/.env`; the target chat ID comes from `TELEGRAM_ALLOWED_USERS` (or your `@userinfobot` lookup).

### Send a document (any file)

```bash
BOT_TOKEN=$(grep "^TELEGRAM_BOT_TOKEN=" ~/.hermes/.env | tail -1 | cut -d'=' -f2)
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" \
  -F "chat_id=<USER_ID>" \
  -F "document=@/absolute/path/to/file" \
  -F "caption=Optional caption text"
```

### Send a photo

```bash
BOT_TOKEN=$(grep "^TELEGRAM_BOT_TOKEN=" ~/.hermes/.env | tail -1 | cut -d'=' -f2)
curl -s -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendPhoto" \
  -F "chat_id=<USER_ID>" \
  -F "photo=@/absolute/path/to/image.png" \
  -F "caption=Optional caption text"
```

**Pitfalls:**
- **Use the last `TELEGRAM_BOT_TOKEN` line in `.env`** — the file may carry duplicates from profile merges; `grep ... | tail -1` avoids picking a stale token from an older profile block.
- **Paths must be absolute and start with `@`** — Telegram API expects a `multipart/form-data` file upload; a bare path without `@` is interpreted as a `file_id` string and fails silently.
- **Check `"ok":true`** in the JSON response before assuming delivery; a `400` with `Bad Request: chat not found` means the `chat_id` is wrong, not the file.
- **`file_id` reuse**: successful sends return a `file_id`; store it if you need to re-send the same asset without re-uploading (Telegram caches by `file_id`).

## Recommended: hermes send CLI (prefer for file/document sends)

For sending files, documents, or media over Telegram, prefer `hermes send` over the raw Bot API: it reuses the gateway's platform credentials, needs no token handling or curl, and runs without an LLM or agent loop.

### Send a document

```bash
hermes send --to telegram:6853580822:4411 "MEDIA:/Users/macbook/Downloads/CV-Ayoub-Meziane.pdf"
```

`MEDIA:<absolute path>` in the message text attaches the file as a document. Target format: `telegram:<chat_id>[:<thread_id>]`.

### Find targets

```bash
hermes send --list telegram
```

Lists reachable Telegram chats/channels; each line ends in `[<chat_id>[:<thread_id>]]`.

### Verification

```bash
hermes send --to telegram:<chat_id>:<thread_id> --json "MEDIA:<path>"
```

`--json` prints `{"success": true, ...}` on delivery; exit code 0 = delivered.

### Pitfalls

- Use `MEDIA:` with an absolute path; a relative path is sent as text.
- Confirm the target from `hermes send --list telegram` — the chat_id and thread_id matter.
- Telegram caches files by `file_id`; a re-send of the same asset needs no re-upload.

## Related Skills

- `hermes-agent` - Core Hermes configuration and usage
- `configuration` - General Hermes configuration management
- `providers-and-models` - Setting up AI models for your Telegram bot
- `background-systems` - Understanding cron, delegation, and kanban for automation

## Reference

Official documentation: https://hermes-agent.nousresearch.com/docs/user-guide/messaging/telegram
