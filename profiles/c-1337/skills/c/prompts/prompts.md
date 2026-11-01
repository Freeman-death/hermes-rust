# prompts — C prompt templates

Reusable prompt templates for common C work. Copy the template into a message to use it.

---

## c-analyze
Analyze a C code snippet. Rules:
1. Compile with: `gcc -std=c11 -Wall -Wextra -Werror -g -fsanitize=address,undefined`
2. Explain what the code does step by step.
3. List any undefined behavior, memory issues, or style problems.
4. Suggest the minimal fix for each.

## c-explain
Explain a C concept. Rules:
1. Give the concept name and a one-line definition.
2. Show a minimal, compilable example.
3. Explain the mechanism (what the machine does).
4. List the top 3 pitfalls with how to avoid them.

## c-debug
Debug a C crash or wrong output. Rules:
1. Ask for: the exact command, the error/expected vs actual output, OS/compiler version.
2. Trace the allocation/use path (pointer → value → scope).
3. Suggest the minimal fix.
4. Re-verify with sanitizers: `-fsanitize=address,undefined`.

## c-review
Review C code for quality. Rules:
1. Compile with: `gcc -std=c11 -Wall -Wextra -Werror`
2. Check: memory ownership, error handling, style, complexity.
3. For each issue, give: file:line, problem, cost, suggested fix, confidence.
4. Separate SAFE fixes (auto-apply) from RISKY (flag for review).

## c-plan
Plan a C feature or fix. Rules:
1. Ask for: the goal, the project structure, the subject, the constraints (`-std`, platform, headers).
2. State assumptions explicitly.
3. Break into small steps. Each step: input, expected output, test method.
4. Verify each step compiles before moving to the next.
