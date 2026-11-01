---
name: software-builder
description: Use Hermes for general tasks; delegate heavy code generation to Qwen/Qw6 models via Alibaba Cloud.
version: 1.0.0
platforms: [linux, macos, windows]
tags: [hermes, setup, configuration, multi-agent, spawning, cli, gateway, bots, bot-mode, features, themes, software-builder]
---

# Software-Builder Profile

## Overview for Heavy Coding Tasks via Alibaba Cloud Qwen/Qw6 Model

This profile routes complex architectural decisions and large code generation tasks to a specialized Qwen/Qw5 instance (110B) hosted on Alibaba Cloud's DashScope platform, allowing the main software-builder Hermes instance to handle lightweight and everyday queries while delegating heavy computational workloads for production-quality engineering.

### Task Routing Logic

- **Light/General tasks**: Direct handling by the main software-builder agent
- **Heavy architectural projects** (>60 LOC or complex full-stack builds): Automatically routed to Qw5-110b via Alibaba Cloud for superior code reasoning capabilities

### Setup Commands

```bash
# Activate Software-Builder profile with Alibaba Cloud integration
cd ~/.hermes/profiles/software-builder/
hermes model set provider=alibabaqwen model=qwen-qw5-110b

# Configure API credentials (must be present in ~/.env)
export QWEN_API_KEY=<your_alibaba_cloud_dashscope_api_key>
```

### Architecture

The software-builder profile leverages Alibaba Cloud's Qwen/Qw6 family of models. The routing threshold is set at 40 lines of code per file; any work exceeding this threshold triggers delegation to the specialized model instance while general queries remain local for speed and cost efficiency. This multi-tier approach scales engineering complexity without overburdening basic queries, maintaining operational balance while accessing high-performance code generation capabilities for your complex development workloads.

### Available Models

Select based on parameter size:
- **qw5-7b**: Fast-medium refactoring (3-4B parameters), suitable for simple code transformations and quick bug fixes
- **qw6-14b**: Complex architecture design and multi-file refactors (14B parameters), handles medium-to-large scale changes
- **qw5-110b**: Large-scale system generation (110B parameters), optimal for full-stack applications and major refactor projects

The configuration defaults to Qw5-110b model for maximum code quality on heavy tasks. Adjust as needed based on your available compute budget and latency requirements.