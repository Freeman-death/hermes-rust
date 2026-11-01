---
name: telegram-bot-ops
description: "Deploy an LLM-backed Telegram bot on Hermes."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [telegram, bot, setup, messaging, configuration]
    homepage: https://hermes-agent.nousresearch.com/docs/user-guide/messaging/telegram
---

# telegram-bot-ops

Deploy an LLM-backed Telegram bot on your own Hermes instance — from bot creation to live gateway.

## Always-on rules

1. **Bot token is user-created.** Created by the user in Telegram (@BotFather → /newbot). Paste the token verbatim; the agent never auto-fills it.
2. **Never hand-edit config.yaml.** Add or change LLM providers only through `hermes config set section.key value`. A stray indent can corrupt the live gateway.
3. **Secrets in .env, settings in config.yaml.** Token and API keys live in .env; provider configuration lives in config.yaml.
4. `hermes gateway restart` after any config change; verify with `hermes gateway status` before telling the user the bot is live.

## Procedure

### 1. Create the bot in Telegram
- Open Telegram → @BotFather → /newbot.
- Choose a display name (e.g. "fog") and a username ending in `bot`.
- Paste the token you receive into the chat with the agent (out-of-band).
- (Optional) /setdescription, /setcommands to define the bot's menu.

### 2. Register the LLM provider
- Qwen Cloud (DashScope) is OpenAI-compatible: POST to /completions on `https://dashscope-intl.aliyuncs.com/compatible-mode/v1`, `Authorization: Bearer <DASHSCOPE_API_KEY>`.
- `hermes config set providers.<name>.api https://dashscope-intl.aliyuncs.com/compatible-mode/v1`
- `hermes config set providers.<name>.default_model <model-id>`
- `hermes config set providers.<name>.env_var DASHSCOPE_API_KEY`
- `hermes config set providers.<name>.name "<display name>"`
- `hermes config set providers.<name>.models "<model1,model2,...>"`
- The DashScope API key must be in `.env` as `DASHSCOPE_API_KEY=<key>`.

### 3. Configure the Telegram platform
- `TELEGRAM_BOT_TOKEN=<token-from-botfather>`
- `TELEGRAM_ALLOWED_USERS=<your-user-id>` (get from @userinfobot)

### 4. Launch and verify
- `hermes gateway restart`
- `hermes gateway status` → telegram should show connected.
- Send /start to the bot in Telegram; it should reply or present its menu.

## Pitfalls

- A new `/newbot` always creates a new token — old tokens stay valid but you need the new one. Paste the token verbatim, not a username.
- Qwen cloud is a separate provider from local Ollama Qwen — the model ID is the DashScope API ID (e.g. `qwen3.6-35b-a3b`), not the Ollama name (`qwen3.5:4b-mlx`).
- `hermes config set` stores the `models` value as a comma-separated string, not a YAML list. If the gateway ignores the model list, set each model individually or edit the models block as YAML.
- The bot token has full control of the bot — if it leaks, revoke via /revoke in @BotFather.
