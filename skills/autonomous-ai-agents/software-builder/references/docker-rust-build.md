# Docker-based Rust workspace builds

Multi-stage cargo-chef build recipe for workspace Rust projects (e.g. hermes-rs-test).

## Dockerfile pattern

```dockerfile
# Chef: dependency caching
FROM rust:1-bookworm AS chef
RUN cargo install cargo-chef --locked
WORKDIR /app

# Planner: plan
FROM chef AS planner
COPY Cargo.toml Cargo.lock ./
COPY crates crates
RUN cargo chef prepare --recipe-path recipe.json

# Builder: compile
FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
COPY Cargo.toml Cargo.lock ./
COPY crates crates
RUN cargo build --release -p hermes-cli

# Runtime: minimal image
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates git \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash hermes
COPY --from=builder /app/target/release/hermes /usr/local/bin/hermes
USER hermes
ENV HERMES_HOME=/data
VOLUME ["/data"]
HEALTHCHECK --interval=60s --timeout=5s --retries=3 CMD hermes doctor || exit 1
ENTRYPOINT ["hermes"]
```

## Run the container

```bash
docker build -t hermes-rs:latest .
docker run -it --rm \
  -v /Users/macbook/.hermes:/data \
  -v /Users/macbook/Crafts/hermes-rs-test:/workspace \
  -w /workspace hermes-rs:latest bash
```

## Verify

```bash
docker exec <container> /usr/local/bin/hermes --version
docker exec <container> /usr/local/bin/hermes doctor
```

## Pitfalls

- Container entrypoint must be `bash -c "while true; do sleep 1; done"` to stay alive without a TTY. Plain `bash` exits immediately.
- Override the image `ENTRYPOINT` (which is `hermes`) when you need a shell instead of running hermes.
- The hermes-rs-test directory is actually named `hermes-rs-test`, not `hermes-rus`.
- `docker exec` needs a TTY for interactive sessions; use `docker exec -it`.
