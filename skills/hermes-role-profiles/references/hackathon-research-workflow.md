# Hackathon research + consolidate workflow

A repeatable pattern for generating a problem base (e.g., for a hackathon) using 4 parallel agents, then consolidating into a single deliverable.

## When to use

- The user asks for "problems we can solve for [hackathon]"
- A domain-exploration task where 4 parallel research angles give better coverage than one agent

## Steps

1. **Identify the hackathon context** — fetch the challenge page (web search first; the dashboard is usually a Next.js app with FAQ only) and extract: name, organisers, format (in-person/remote, day count), team size, fee, deadline, and theme families. Record verbatim — wrong facts get tested against.
2. **Spawn 4 parallel subagents**, each on a distinct research angle (never overlap). Each agent:
   - Searches for concrete local problems within its angle
   - For each problem: exact statement, who is affected, why it's a real pain (stats where findable), a plausible 2-day MVP, and 2–3 citable sources
   - Writes to a work file in the browser workspace
3. **Wait for all 4 to finish.** Verify each returned a JSON list of problems. No synthetic stats — if a source is unknown, say so.
4. **Consolidate into one deliverable** with this structure:
   - Title + hackathon context
   - Section 1: summary of ALL ideas, one-line-per-idea, grouped by theme
   - Section 2: detailed sections for each idea (problem / who / why / MVP / sources / hackathon fit)
   - How to choose one (scorecard of impact / Morocco relevance / feasibility / data availability / team fit)
   - Short "straight to the point" recap with the top candidates
5. **Save** the deliverable to `/Users/macbook/<hackathon>_problem_landscape.md`.

## Agent angle guide (example)

| Agent | Angle |
|---|---|
| 1 | Water & climate resilience |
| 2 | Soil health & precision ag |
| 3 | Crop protection & post-harvest loss / food waste |
| 4 | Livestock, agri-food, terroir & diversification |

## Pitfalls

- The dashboard is a Next.js app — FAQ is the only public content. Don't claim you read problem statements from the page; search for them or use prior-edition narrative.
- Each agent must write results to the workspace files, then you aggregate them with Python (dedupe/count/sort), not in your head.
- One agent's results are delivered as a notification message — track which delegation_id each corresponds to.
- The bot token must never be stored in a skill — it's user-secret configuration, not reusable knowledge.