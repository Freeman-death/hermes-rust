---
name: browser-automation
description: "Local browser automation for testing web apps."
tags: [browser, automation, testing, web, browser-exec]
version: 1.0.0
platforms: [macos, linux, windows]
---

# Browser Automation (browser_exec)

Class-level skill for automating a real browser and testing web apps using the local `browser_exec` tool (headless Chromium). Covers: coordinating browser state across calls, reading clickable element coordinates, clicking via coordinates (the reliable path), capturing evidence, and verifying the result.

## When to Use

- Opening a local web app and clicking through its UI
- Testing a web app for bugs (calculating, form fields, navigation)
- Any task that requires clicking buttons and reading the page state
- Finding layout/rendering issues or input failures

## Core Tools (browser_exec)

All actions run inside a `browser_exec` call. State persists across calls (browser tab), but Python variables do not. Each call must be self-contained.

| Action | Idiom |
|--------|-------|
| Navigate | `goto_url("http://localhost:PORT/path")` then `wait_for_load()` |
| Page state | `page_info()` |
| Elements | `js("Array.from(document.querySelectorAll('[data-action]')).map(b => ({action: b.dataset.action, value: b.dataset.value, x: Math.round(b.getBoundingClientRect().x), y: Math.round(b.getBoundingClientRect().y)}))"` |
| Click (preferred) | `js("document.querySelector('[data-action=\"action\"][data-value=\"value\"]").click()")` |
| Click (fallback) | `click_at_xy(x, y)` with centre from element list |
| Read value | `js("document.getElementById('display').value")` |
| Screenshot | `capture_screenshot()` |
| Console errors | `js("window.__qa_errors || []")" (after registering hook) |

## The Reliable Workflow

### Step 1 — Find exact element coordinates

```python
result = js("Array.from(document.querySelectorAll('[data-action]')).map(b => ({action: b.dataset.action, value: b.dataset.value, x: Math.round(b.getBoundingClientRect().x), y: Math.round(b.getBoundingClientRect().y)}))
print(result)
```

Every `[data-action]` element has a `(x, y)` viewport centre. Use these for `click_at_xy`.

### Step 2 — Click by coordinates

```python
goto_url("http://localhost:PORT/path")
wait_for_load()
click_at_xy(x, y)  # verified coordinate for the button
wait_for_load()
```

**Do not** use `document.querySelector('.button-class').click()` via `js()` — the shared JS scope conflicts with `const` declarations across calls. Use `document.querySelector('[data-action="action"][data-value="value"]').click()` for pixel-perfect clicks, or use `click_at_xy` with the exact `(x, y)` from a fresh coordinate read.

### Step 3 — Read the result

```python
result = js("document.getElementById('display').value")
print(result)
```

### Step 4 — Verify

- Read `document.getElementById('display').value` after each action
- Compare with the expected outcome
- If the display is wrong, re-read coordinates and re-click

## Known Pitfalls

### `click_at_xy` coordinate mismatch
`click_at_xy` operates on viewport pixel coordinates. `getBoundingClientRect()` returns viewport-relative coordinates, but the box centre is `(x + width/2, y + height/2)`. Always compute the centre, not the top-left corner.

### `js()` shared scope
Every `js()` call runs in a shared V8 context. A `const btn = ...` declared in one call persists across calls and causes `Identifier 'btn' has already been declared` on the next call. **Never declare `const` or `let` in `js()` expressions** — use arrow functions with immediate invocation or inline expressions only.

### `data-action` attribute required
Calculator buttons with `class="decimal"` but NO `data-action` attribute don't fire click events. Verify the button has `data-action` before trusting it.

### Division by zero display
The calculator returns the string `"Error"` internally for division by zero, but `updateDisplay()` runs `parseFloat("Error")` which becomes `NaN` before display. The calculation is correct; the display formatting is the bug.

## Calculator Test Findings (example evidence)

Testing the calculator at `http://localhost:8765/calculator/calculator.html` produced these findings:

1. **Decimal button is non-functional** (bug): `<button class="decimal">` has class but no `data-action`, so click events never fire. Cannot enter decimals.

2. **Division by zero shows NaN** (bug): `performCalculation` returns `"Error"` internally, but `updateDisplay()` formats via `parseFloat()`, which converts to `NaN`.

3. **Everything else works**: addition, subtraction, multiplication, division, left-to-right chaining, backspace, AC clear, all passed.

## Batch by sub-procedure

One `browser_exec` call should contain a self-contained batch: navigate, wait, read coordinates, act, read result. Fewer round-trips, and the JS hook stays in place.
