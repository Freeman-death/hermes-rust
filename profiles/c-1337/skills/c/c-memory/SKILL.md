---
name: c-memory
description: "Pointers, malloc/free, memory leaks, valgrind, AddressSanitizer, undefined behavior. Use when the user asks about memory, pointers, allocation, leaks, or crashes."
version: 1.0.0
author: c-1337
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [c, memory, pointers, malloc, free, leaks, valgrind, asan, ubsan]
    related_skills: [c-basics, c-data-structures]
---

# c-memory — Memory Management in C

Memory correctness is non-negotiable. Every allocation traceable, every write in bounds. Always-on rules:

- **Ask about ownership before touching `malloc`/`free`.** Who allocates? Who frees? If the user doesn't know, map it out first.
- **Gate = `-Wall -Wextra -Werror`.** Memory bugs are the gate. A leak in the test suite is a failed test.
- **Undefined behavior is an error.** "It works on my machine" is not evidence.
- **Short and direct.** No filler. Show the fix, then the compile command, then the sanitizer run.
- **Depth earned.** Give long explanations only when the user asks.

## When to Use
- "Why does this crash / segfault?"
- Pointer questions (dereference, null, dangling, void *)
- `malloc`/`calloc`/`realloc`/`free` usage
- "Memory leak" or valgrind/sanitizer reports
- Undefined behavior in memory (buffer overflow, use-after-free, double free)

## The Process
1. **Clarify** — who owns the allocation? Is it a stack or heap object? Ask if unclear.
2. **Reproduce** — is it a crash, leak, or UB? Get the exact command and OS.
3. **Trace** — show the allocation → use → free path. Where does ownership live?
4. **Verify** — run with `-fsanitize=address,undefined` and `valgrind --leak-check=full`.
5. **Fix** — the minimal correct fix, not a rewrite. Explain why it's correct.
6. **Confirm** — re-run sanitizers/valgrind; no output = clean.

## Rules
- Every `malloc`/`calloc` has exactly one matching `free` (or is intentionally leaked and documented).
- Don't free a pointer twice (double free) or after it's been `free`d and reused.
- Never dereference a `NULL` or dangling pointer. Allocate with enough room.
- `realloc` — check the return; old pointer is only valid until the call returns.
- For strings, prefer `strdup`-style helpers or fixed-size buffers with bounds.

## Common Bugs and Fixes
| Bug | Fix |
|-----|-----|
| `malloc` + no `free` | Track lifetime; `free` at end or in cleanup path |
| `free(p); *p = 0;` | Set `p = NULL` after free; don't touch freed memory |
| `strcpy(dst, src)` | `strncpy` or `snprintf` with explicit size |
| Buffer too small | Use `malloc(strlen(s) + 1)` for exact size |
| `realloc` without check | `tmp = realloc(p, new_size); if (!tmp) { free(p); return -1; }` |

## Pitfalls
- `malloc(sizeof(ptr))` instead of `sizeof(*ptr)` — wrong when ptr changes type.
- `calloc(n, sizeof(*p))` for `n` elements — check `n` for overflow.
- Returning a local array's address — the stack frame is gone.
- `fork()` without a `NULL` check or `perror()` on failure.
- **Undefined behavior is an error.** "It works on my machine" is not evidence. Fix it or isolate it.

## Tools
- Compile: `gcc -Wall -Wextra -Werror -fsanitize=address,undefined -g`
- Run: `./prog; echo $?`
- Leak check: `valgrind --leak-check=full --show-leak-kinds=all ./prog`
- OOM/ASLR: run repeatedly until flaky bug appears (`for i in $(seq 1 100); do ./prog; done`)

## Related
- `c-basics` — pointer syntax and types.
- `c-data-structures` — ownership in DS.
- `c-project-work` — build commands and sanitizers.
