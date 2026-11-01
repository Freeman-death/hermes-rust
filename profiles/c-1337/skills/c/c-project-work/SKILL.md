---
name: c-project-work
description: "Building, Makefiles, gdb debugging, sanitizers, project layout for C. Use when the user asks about building, compiling, running, or debugging C projects."
version: 1.0.0
author: c-1337
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [c, project, build, make, gcc, clang, gdb, valgrind, asan, project-layout]
    related_skills: [c-memory, c-basics]
---

# c-project-work — C Project Workflow

Ship working C: build clean, debug fast, verify thoroughly. Always-on rules:

- **Commit on every change.** After any modification (code, Makefile, layout, README), stage and commit with a clear message. A broken build never leaves the working tree.
- **Ask, never assume.** Before acting, confirm the platform, compiler, target standard, and exact goal. Ask ONE clarifying question before making any change or proposing an approach — do not assume.
- **Spell out assumptions.** The machine is dumb — name every assumption in your plan.
- **Gate = `-Wall -Wextra -Werror`.** A project that does not compile clean under `-Wall -Wextra -Werror` is not done. Period.
- **Undefined behavior is an error.** "It works on my machine" is not evidence. If UB is possible, fix it or isolate it.
- **Short and direct.** No filler. Code is the answer. Show the full snippet, then the exact command.
- **Depth earned.** Give long explanations only when the user asks. Otherwise: short, correct, done.

## When to Use
- "How do I build this C project?"
- Makefile questions / project structure
- Debugging a crash or wrong output
- Adding a new source file or dependency
- Setting up compiler flags

## The Process
1. **Clarify — NOT assume.** Ask: platform (macOS/Linux/PC), compiler (`gcc` vs `clang`), target standard (`c99`/`c11`/`c17`), and the exact goal. Missing a header or flag? Ask before adding.
2. **Inspect** — read the project: `Makefile`, `src/`, `include/`, `main.c`. Note the compiler and flags.
3. **Plan** — the smallest change that compiles and runs. Preserve existing build steps.
4. **Build** — run the Makefile (or `gcc` directly). Fix errors before touching logic.
5. **Debug** — use `gdb` for crashes: `bt` (backtrace), `print`, `list`. Use sanitizers for memory UB.
6. **Verify** — run the program; add a test harness if the logic is non-trivial.

## Memory-debug fix pattern: heap-buffer-overflow in a malloc/loop function

When a malloc-based loop function (split, strtrim, substring, etc.) crashes with a heap-buffer-overflow:
1. Identify the loop that fills the malloc'd buffer.
2. Verify the **count is computed BEFORE malloc** — count_words/word_len must be known first, else the allocation is too small.
3. Verify each iteration writes **one element per loop pass** (result[j] = ... then j++), and that j ranges 0..count-1, with the final NULL at result[count].
4. Check that word copies use `word_dup(s + i, len)` where len is the exact word length (ft_strlen of the word), not the whole string.
5. Run with sanitizer (`-fsanitize=address,undefined`) and a debug harness to confirm the exact line — then rewrite the function, never partially patch a crash.

## Sanitizer build for libft (compile + link + run, all in one)
```bash
# 1. Compile all libft sources with sanitizer flags
gcc -Wall -Wextra -Werror -g -fsanitize=address,undefined -I. -c ft_*.c

# 2. Compile the test file
gcc -Wall -Wextra -Werror -g -fsanitize=address,undefined -I. -c tests/test_libft.c -o tests/test_libft_asan.o

# 3. Link the sanitizer test binary
gcc -Wall -Wextra -Werror -g -fsanitize=address,undefined -I. -o tests/test_libft_asan ft_*.o tests/test_libft_asan.o

# 4. Run
./tests/test_libft_asan
```
- The `-I.` flag must match the Makefile's include path.
- Compile ALL sources in one command; separate compile+link causes `no file or directory` linker glob errors on some systems.
- Any error (heap-buffer-overflow, use-after-free, UB) must be fixed before submission — this is the gate for memory safety.

## Build Commands
```bash
# Debug build (everything the tools need)
gcc -std=c11 -Wall -Wextra -Werror -g -O0 -o prog src/*.c

# Release build (optimised, no debug info)
gcc -std=c11 -O2 -o prog src/*.c

# WITH SANITIZERS (memory / UB checks — always use for memory-critical code)
gcc -std=c11 -Wall -Wextra -Werror -g -fsanitize=address,undefined -o prog src/*.c

# Link with a library
gcc -std=c11 -Wall -Wextra -Werror -o prog main.c -lm
```

## Makefiles
- Use `CC`, `CFLAGS`, `LDFLAGS` variables.
- `-Wall -Wextra -Werror` in `CFLAGS` — it's the gate.
- Use automatic variables: `$@` (target), `$<` (first prerequisite), `$^` (all prerequisites).
- `clean` target: remove the binary and object files.
- `.PHONY` for `clean` and `all`.

Minimal Makefile:
```make
CC      := gcc
CFLAGS  := -std=c11 -Wall -Wextra -Werror -g
LDFLAGS :=
SRCDIR  := src
OBJDIR  := obj
BINDIR  := bin

SRCS := $(wildcard $(SRCDIR)/*.c)
OBJS := $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(SRCS))
TARGET := $(BINDIR)/prog

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJS) $(TARGET)

.PHONY: all clean
```

## Debugging with gdb
```bash
gcc -g -O0 -o prog src/*.c
gdb ./prog
(gdb) run
(gdb) bt                  # backtrace on crash
(gdb) print var           # inspect a variable
(gdb) list                # show source around current line
(gdb) break funcname      # set breakpoint
(gdb) next / step         # step over / into
(gdb) info registers      # register state (for low-level bugs)
```

## Sanitizers (always use for memory-critical code)
```bash
gcc -g -fsanitize=address,undefined -o prog src/*.c
./prog          # watch for error reports, not just program output
```
- `-fsanitize=address` catches: buffer overflow, use-after-free, double free.
- `-fsanitize=undefined` catches: integer overflow, null deref, bad shifts.

## Project Layout
```
proj/
├── Makefile
├── README.md
├── include/          # header files (public interface)
├── src/              # implementation files
├── tests/            # test harnesses
└── bin/              # compiled output (gitignored)
```

## Project verification against a subject

When the task asks you to check a C project against a subject file (libft subject, README, grading rubric):

1. **Read the subject** — extract the PDF text (see `references/pdf-text.txt`), identify every requirement: mandatory part, files, flags, structure, norm rules.
2. **Inspect the project** — read the Makefile, headers, all `.c` files, tests, and the README doc. Note the build flags, file layout, and progress state.
3. **Map each subject requirement to project state** — create a checklist: done ✅ / in-progress 🟡 / missing 🔴.
4. **Build and test** — `make fclean && make all`, then compile the tests with `-Wall -Wextra -Werror`. A clean build is the gate.
5. **Check norm** — run `norminette` on all sources and headers. Fix errors before reporting.
6. **Report** — a short table per requirement, plus a list of blocking issues only (no filler).

### Pitfalls
- **Merge conflict markers** (`<<<<<<<`, `=======`, `>>>>>>>`) left in files after git operations — always check with `grep -rn '<<<<<<<'` before committing or building. They block compilation and fail norm.
- **Outdated README tracker** — the doc may claim a status that diverges from actual code. Verify from the source, not the doc.
- **Files in `src/partN/` vs root** — the 42 subject PDF demands all files at repo root; some project docs or the user's own notes may allow `src/` subdirectories. Follow the subject exactly when grading.
- **Subject vs user notes** — the user may keep a personal `subject.md` (their own rephrasing); the attached PDF is the authority. Compare against the PDF, not an internal note.

## 42 submission preparation

For 42 school projects (libft, get_next_line, printf, etc.), the submission must follow specific rules:

1. **Flatten structure** — all `.c` and `.h` files must be at the repo root (no `src/` subdirectories). Move files up and update Makefile paths.
2. **42 header** — every `.c` and `.h` file must start with the standard 42 header comment block:
   ```
   /* ************************************************************************** */
   /*                                                        :::      ::::::::   */
   /*   filename.c                                         :+:      :+:    :+:   */
   /*                                                    +:+ +:+         +:+     */
   /*   By: login <login@student.42.fr>                +#+  +:+       +#+        */
   /*                                                +#+#+#+#+#+   +#+           */
   /*   Created: YYYY/MM/DD HH:MM:SS by login          #+#    #+#             */
   /*   Updated: YYYY/MM/DD HH:MM:SS by login         ###   ########.fr       */
   /*                                                                            */
   /* ************************************************************************** */
   ```
   The header must be exactly 80 columns wide and pass norminette.
3. **norminette** — install with `pip3 install norminette`. Run `norminette *.c *.h` on the root. Every file must report `OK!`.
   - Common errors: TOO_MANY_LINES (>25 per function), TOO_MANY_VARS_FUNC (>5 vars), MISALIGNED_VAR_DECL, WRONG_SCOPE_COMMENT (no comments inside functions), EMPTY_LINE_FUNCTION.
   - Strict norm rules (applied to every project): no multi-declaration lines (DECL_ASSIGN_LINE), no `break` in control flow, no assignment inside control statements (assign_in_control), no comma on a single line, no function over 25 lines. Verify with `norminette ft_*.c libft.h` before committing.
   - Fix by extracting static helpers, aligning declarations, removing inline comments, splitting merged statements.
4. **Makefile** — must have `all`, `clean`, `fclean`, `re` targets. Use `ar rcs` for libraries. No forbidden functions.
5. **Branch workflow** — create a dedicated branch (e.g. `push_pre`) for submission prep. Keep `main` clean.
6. **Verify** — `make fclean && make all` with `-Wall -Wextra -Werror` must succeed with zero warnings.

### Pitfalls
- **Merge conflict markers** (`<<<<<<<`, `=======`, `>>>>>>>`) left in files after git operations — always check with `grep -rn '<<<<<<<'` before committing.
- **Include paths** — when flattening, update `#include "../../libft.h"` to `#include "libft.h"`.
- **Return types** — 42 subject specifies exact signatures (e.g. `int ft_lstsize`, not `unsigned int`). Match the subject exactly.
- **norminette header spacing** — the 42 header is validated character-by-character; use a known-good template and test with norminette.
- **`ft_lstnew` must check malloc failure** — return NULL on allocation failure.
- **`ft_calloc` must handle overflow** — check `nmemb * size` doesn't overflow.

For a library split into logical parts (e.g. 42 libft: Part 1 C library, Part 2 additional, Part 3 linked list):

1. **Inspect the header** — parse the `#ifndef`/`#endif` groups to list exactly which functions belong to each part.
2. **Create one directory per part** — `src/part1/`, `src/part2/`, `src/part3/`.
3. **Move files** — one `.c` per declaration, part files never mixed.
4. **Sync the Makefile** — rewrite `SRCS` with the new `src/partN/...` paths. `OBJS = $(SRCS:.c=.o)` follows automatically; leave it.
5. **Verify** — `make fclean` first, then `make all`. A clean build under `-Wall -Wextra -Werror` is the only proof the layout is correct.

## Git workflow for C projects

- **Identity.** Commits authored by `Freeman <ayoub.meziane.hu@icloud.com>`. If the repo has a different identity (e.g. "Claude Agent"), fix with `git config --local user.name "Freeman"` and `git config --local user.email "ayoub.meziane.hu@icloud.com"`.
- **Fixing commit author on amend.** `git commit --amend --no-edit` keeps the ORIGINAL author. Use `git commit --amend --no-edit --reset-author` to adopt the current config identity.
- **Pushing to a remote with diverged history.** If the remote has commits not in local, use `git merge --allow-unrelated-histories origin/main` to reconcile, then push. Resolve conflicts by keeping the local (reorganized) version.
- **Structural mismatch.** When the local repo tracks the project as a subdirectory (e.g. `libft/Makefile`) but the remote has it at root (e.g. `Makefile`), restructure local to match the remote layout before pushing (move files up, update paths, commit).
- **Always commit on every change** (already in always-on rules above).
- **Always ask clarifying questions** before acting (already in always-on rules above).

## Pitfalls
- **Amending without `--reset-author` keeps the old author** — the commit still shows the previous identity even though config changed.
- **Building with `-O2` while debugging** — use `-O0 -g` for reproducibility.
- **`make` not rebuilding** — check timestamps; add `-Wall -Werror` and re-run.
- **Mixing `gcc` and `clang`** — pick one compiler per project.
- **Not linking with `-lm` for math functions.**
- **Debug output left in production code.**
- **Undefined behavior is an error.** "It works on my machine" is not evidence. Fix it or isolate it.
