# Hermes Rust

Hermes Rust is a Rust rewrite of Hermes Agent — a local-first, privacy-conscious AI agent with profiles, memory, and skill-based automation.

## One-Line Install

```bash
curl -sSL https://raw.githubusercontent.com/AyoubMzian-Dev/hermes-rust/main/install-hermes-rust.sh | bash
```

This script will:
1. Check prerequisites (git, curl, Xcode CLT on macOS)
2. Install Rust via rustup (if not already installed)
3. Clone and build `hermes-rs-test` from source
4. Set up profiles from the exported setup
5. Configure your environment

## Requirements

- macOS (M1/M2/M3) or Linux
- Internet connection
- ~5GB free disk space (for Rust build)

## Post-Install

After installation:

```bash
# Check system
hermes doctor

# Start interactive session
hermes

# Test with a query
hermes chat -q 'Hello, test this working'
```

## Configuration

Edit `~/.hermes/.env` to add your API keys.

## Profiles

The installer sets up the following profiles:
- `main` — General planning, project organization, execution tracking
- `lite` — Local-first Qwen interactions (file exploration, computer control, Telegram)
- `designer` — Design and UI work
- `software-builder` — Rust/software development
- `philosophical-assistant` — Philosophical discussions
- `media-manager` — Media management
- `forge` — Forge/build tasks
- `agrichallenge-bot` — Agriculture challenge bot
- `c-1337` — C/1337 student tasks

## License

MIT
