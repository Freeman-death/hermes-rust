---
name: c-algorithms
description: "Sorting, searching, string manipulation, recursion, complexity analysis in C. Use when the user asks about algorithms, sorting, searching, or complexity."
version: 1.0.0
author: c-1337
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [c, algorithms, sorting, searching, strings, recursion, complexity]
    related_skills: [c-data-structures, c-basics]
---

# c-algorithms — Algorithms in C

Implement algorithms clearly, then verify they're correct and efficient. Always-on rules:

- **Ask about constraints first.** Input size, ordered vs unordered, stability, extra memory — these decide the algorithm.
- **Short and direct.** No filler. Show the algorithm, the C code, then the complexity.
- **Depth earned.** Give long explanations only when the user asks.
- **Gate = `-Wall -Wextra -Werror`.** An algorithm that compiles clean is an algorithm you can trust.
- **Undefined behavior is an error.** "It works on my machine" is not evidence.

## When to Use
- Sorting (qsort, selection, insertion, merge, quick)
- Searching (linear, binary, string search)
- String manipulation (tokenize, reverse, pattern match)
- Recursion / divide-and-conquer
- Complexity / performance questions

## The Process
1. **Clarify** — input size, ordered vs unordered, stability needs, extra memory. Ask if unclear.
2. **Identify** — which algorithm is needed (and why not another)?
3. **Design** — sketch the approach; state complexity (time and space).
4. **Implement** — write clean, correct C with a comparator where needed.
5. **Verify** — test on edge cases: empty, one element, all duplicates, sorted reverse.
6. **Analyze** — worst-case vs average-case; when the algorithm wins.

## Rules
- `qsort` comparator must return negative/zero/positive; never `a - b` on ints (overflow).
- Binary search: avoid `mid = (lo + hi) / 2` overflow; use `lo + (hi - lo) / 2`.
- String ops: use `strlen` once, then loop; never trust input length.
- Recursion: add a base case; watch the stack for deep recursion.
- For large data, prefer iterative or heap-allocated recursion.

## Pitfalls
- `qsort` comparator using `a - b` — integer overflow; use `(a > b) - (a < b)`.
- Binary search off-by-one: `while (lo < hi)` vs `while (lo <= hi)` — be consistent.
- Mutable string literals — `char *s = "literal"; s[0] = 'x';` is undefined.
- Not null-terminating a string you build manually.
- Recursion without a base case — stack overflow.
- **Undefined behavior is an error.** "It works on my machine" is not evidence. Fix it or isolate it.

## Related
- `c-data-structures` — where the algorithm runs.
- `c-memory` — allocating buffers for algorithms.
- `c-project-work` — compiling and testing.
