---
name: software-builder
description: Local Rust workspace builds, Docker-isolated.
version: 1.0.0
platforms: [linux, macos, windows]
tags: [hermes, setup, configuration, multi-agent, spawning, cli, gateway, bots, bot-mode, features, themes, software-builder]
---

# Software-Builder Profile

## Overview for Local Rust Builds

This profile builds Rust workspaces as single binaries (no Python, no heavy frameworks) using the local toolchain and Docker for isolation. Alibaba Cloud's Qwen/Qw6 models are a fallback for heavy architectural decisions that exceed local capacity — never the default for project work.

### Workflow

1. **Inspect**: Read the project's Cargo.toml and Dockerfile first.
2. **Local build**: `cargo build --release` (or `cargo build -p <crate>` for targeted builds).
3. **Docker build**: `docker build -t hermes-rs:latest .` for the full workspace with cargo-chef caching.
4. **Verify**: `hermes --version` and `hermes doctor` inside the container.
5. **Iterate**: Rebuild only changed crates; rely on Docker layer caching.

### Docker-based multi-stage Rust build

See `references/docker-rust-build.md` for the cargo-chef multi-stage recipe used by hermes-rs-test.

### The user's preferences

- Answer short and direct; no filler, no "Great question" / "I'd be happy to", no restating the request. If the ask is minimal, respond minimally.
- Local Rust toolchain first; Docker for isolation and clean builds.
- Single-binary output (~16MB hermes-cli).
- Verify with `hermes --version` and `hermes doctor`.
- No cloud delegation unless explicitly asked.

### Before you run Docker commands

The Docker daemon is not guaranteed to be running. Before any `docker build` / `docker run` / `docker exec`, run `docker info` first. If it errors with "cannot connect to the Docker API" / "no such file or directory" for the socket, start Docker Desktop (it may not be running yet):

```bash
# On macOS, start Docker Desktop first, then wait for the socket:
open -a Docker
sleep 15
docker info   # re-check; expect exit 0
```

If the socket still does not appear, run the privileged socket helper:

```bash
sudo /Library/PrivilegedHelperTools/com.docker.socket macbook
sleep 5
docker info
```

### Resource comparison: native vs Docker

When comparing two implementations' resource usage, do not Docker-build both. Docker builds of Python projects can take 30-90 minutes. Instead:

1. Run the Rust version in a container (fast).
2. Run the original (Python) version natively on the host.
3. Compare with `ps` / `docker stats` on each.

The original hermes-agent (NousResearch) ships a multi-stage Dockerfile; running it natively on the host gives the apples-to-apples runtime comparison without the build cost. Session result: hermes-rs RSS = 10 MiB vs original hermes RSS = 72 MB.

### Directory naming

The Rust project directory is `crafts/hermes-rs-test` (NOT `crafts/hermes-rus`). The Python original is cloned separately as `crafts/hermes-original`.