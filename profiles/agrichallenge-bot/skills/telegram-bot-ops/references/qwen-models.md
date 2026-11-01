# Qwen Cloud (DashScope) model catalog for bot deployment

API-compatible endpoint:
`https://dashscope-intl.aliyuncs.com/compatible-mode/v1`

Model IDs are the Alibaba DashScope OpenAI-compatible API IDs. The key is `DASHSCOPE_API_KEY`.

| Model ID | Category | Typical use |
|---|---|---|
| qwen3.6-35b-a3b | Large MoE (35B activated) | Conversational bots — default here |
| qwen3-coder-480b-a35b-instruct | Large coder MoE (480B activated) | Code-heavy bots |
| qwen3-8b | Small | Fast, low-latency, local/edge |
| qwen3-32b | Medium | General-purpose |

Free tier: Alibaba periodically offers free tiers on some models via the DashScope console. Check https://dashscope.console.aliyun.com for current pricing and free-tier availability.

Note: model names differ between Ollama (local, e.g. `qwen3.5:4b-mlx`) and DashScope (cloud, e.g. `qwen3.6-35b-a3b`). The bot config must use the DashScope IDs.