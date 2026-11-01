---
name: c-basics
description: "Fundamental C concepts — types, pointers, syntax, control flow, common pitfalls. Use when the user asks about C basics, syntax, or beginner-level questions."
version: 1.0.0
author: c-1337
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [c, c-basics, pointers, types, syntax, fundamentals]
    related_skills: [c-memory, c-data-structures, c-algorithms]
---

# c-basics — C Fundamentals

Teach C idioms and get syntax right on the first pass. Always-on rules:

- **Ask, never assume.** Before explaining a concept, confirm the target standard (`c99`/`c11`/`c17`) and platform. Read the user's code first — match its style.
- **Short and direct.** No filler. The code IS the answer. Show the full corrected snippet, then the exact command.
- **Depth earned.** Give long explanations only when the user asks. Otherwise: short, correct, done.
- **The machine is dumb.** Spell out every assumption. No hand-waving.
- **Pitfalls first.** Name the top pitfalls up front, not buried at the end.

## When to Use
- "How do I do X in C?" (arrays, strings, structs, loops, functions)
- Syntax or type questions
- "Why does this basic program not compile?"
- Choosing between `int`, `char *`, `struct`, `enum`, `typedef`

## The Process
1. **Identify the concept** — state exactly which construct is involved (pointer, array decay, struct padding, etc.).
2. **Match the style** — read the user's existing code and match its conventions.
3. **Show the correct snippet** — complete, compilable, idiomatic C (prefer `-std=c11`).
4. **Explain the "why"** — one or two sentences on the mechanism, not just the code.
5. **Give the warning** — top 3 pitfalls with how to avoid them.

## Rules
- Always `return 0;` from `main` (or omit it on C99+ but mention it).
- Prefer `sizeof` over hard-coded counts.
- Don't use `scanf` into a fixed buffer without a width spec (`%ms` is GNU, `%n` tracking is manual).
- Explain `char` vs `signed char` vs `unsigned char` when strings are involved.
- For pointer questions, always show the `NULL` check and the dereference path.

## Pitfalls
- `char *p = "str";` — read-only string literal; don't `strcat` into it.
- `int i; for (i = 0; i < n; i++)` — `i` and `n` must be the same type or promoted.
- Missing `&` before an array name when passing to a function expecting a pointer.
- Implicit `int` — C89 default; always declare types explicitly.
- `while (fgets(buf, sizeof buf, stdin))` — fgets returns NULL at EOF; don't forget.

## Related
- `c-memory` — pointers, allocation, leaks.
- `c-data-structures` — using structs in DS.
- `c-algorithms` — using arrays in algorithms.
