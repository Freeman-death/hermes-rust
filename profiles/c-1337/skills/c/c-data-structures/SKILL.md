---
name: c-data-structures
description: "Choosing and implementing arrays, linked lists, stacks, queues, trees, hash tables in C. Use when the user asks about data structures, DS questions, or choosing a structure."
version: 1.0.0
author: c-1337
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [c, data-structures, ds, linked-list, tree, hash-table, stack, queue]
    related_skills: [c-memory, c-algorithms]
---

# c-data-structures — Data Structures in C

Pick the right structure, implement it correctly, and explain why. Always-on rules:

- **Ask about ownership before implementing.** Who allocates the nodes? Who frees them? Map it out first.
- **Match the project's style.** Read existing code first — if the project uses a specific `free` convention, follow it.
- **Short and direct.** No filler. Show the struct, the operations, then the complexity.
- **Depth earned.** Give long explanations only when the user asks.
- **Gate = `-Wall -Wextra -Werror`.** A structure that compiles clean is a structure you can trust.

## When to Use
- "Which data structure for X?"
- Implementing a list, stack, queue, tree, hash table, graph
- DS questions (traversal, search, insertion, deletion)
- Memory layout of a structure

## The Process
1. **Clarify** — what operations matter most? Ask if the use case is unclear.
2. **Recommend** — match the use case to the structure (frequency of operations, memory layout, ordering needs).
3. **Design** — define the struct; decide static vs dynamic; note ownership.
4. **Implement** — the core operations: init, insert, delete, search, free. Keep it minimal.
5. **Explain** — complexity of each operation; cache behavior; edge cases.
6. **Test** — a small harness: build, run, verify with `-fsanitize=address`.

## Structure Selection Guide
| Need | Best choice |
|------|-------------|
| Fixed size, random access | Array / static buffer |
| Unknown size, frequent insert/delete at ends | Dynamic array / amortised |
| Frequent insert/delete at middle | Linked list |
| LIFO | Stack |
| FIFO | Queue |
| Ordered, fast lookup | Binary search tree / sorted array |
| Key → value | Hash table |

## Rules
- A struct's size should be declared; use `sizeof(struct name)` for allocations.
- For tree nodes, use `malloc` + `free` consistently; document ownership.
- Hash tables: handle collisions (chaining vs open addressing); rehash when load factor > 0.7.
- Always check `malloc` return; never assume success.
- Implement `free` that recursively frees children (trees) or iterates (lists).

## Pitfalls
- Forgetting to free a node's children in a tree — leak.
- Using `int` for indices on large arrays — use `size_t`.
- Not checking `malloc(0)` — implementation-defined; handle it.
- Queue with head/tail pointers — handle empty/full states correctly.
- `sizeof` on pointer instead of the pointed-to type.
- **Undefined behavior is an error.** "It works on my machine" is not evidence. Fix it or isolate it.

## Related
- `c-memory` — ownership, leaks, sanitizers.
- `c-algorithms` — algorithms over DS.
- `c-basics` — struct syntax, pointers.
