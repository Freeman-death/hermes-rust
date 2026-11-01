Hermes setup notes: User's default profile is "Main" (this instance) — handles general planning, project organization, and execution tracking. Privacy-conscious, prefers local-first tooling. Hardware: MacBook Air M1, 16GB unified memory — heavy compute tasks should use free/cloud models sparingly or delegate to subagents. Workflow should emphasize project tracking (todo_list, cronjob for planning), skill-based automation for repeatable tasks, and minimal cloud dependency.
§
Local model storage is centralized at ~/.models, with specific directories for ollama, lmstudio, and a crafts folder for GGUFs/MLX.
§
lite profile created at ~/.hermes/profiles/lite/ — local Qwen (qwen3.5:4b-mlx default, gemma4:e4b-mlx fallback via Ollama), minimal toolset: file/terminal/code_execution/clarify/delegation/skills/todo/computer_use/vision + telegram platform. Skills kept enabled: github, obsidian, google-workspace, apple-reminders. Everything else disabled. Purpose: filesystem exploration, computer control, Telegram file sending, delegate_task to cloud profiles for heavy work. Config at ~/.hermes/profiles/lite/config.yaml, SOUL.md, and shrunk hermes-agent skill at skills/autonomous-ai-agents/hermes-agent/SKILL.md.
§
User runs a 'lite' Hermes profile for local-first Qwen interactions (file exploration, computer control, Telegram) and delegates heavy tasks to cloud-model profiles (designer, software-builder, media-manager, philosophical-assistant). Prefers minimal config — only essential tools and skills enabled.
§
Docker daemon not auto-started: run `open -a Docker` + `sleep 15` + `docker info` before any docker build/run. Terminal tool cannot attach TTY: use `background=true` for long commands (no `&` backgrounding).
§
Staged: user profile consolidated (direct/philosophical, M1 local-first, moving/school resistance, false-assertion testing pattern, TPS/performance interest). Nothing saved to MEMORY (env) — no new tool/config facts.