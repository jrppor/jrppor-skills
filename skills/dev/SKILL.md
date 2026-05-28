---
name: dev
description: Disciplined code work — builds NEW code and modifies EXISTING code with a workflow that adapts to task type and size. Trigger when the user asks to build, code, implement, add, write, create, fix, modify, change, refactor, edit, update, clean up, or migrate code. Auto-detects mode (build / fix / modify / refactor / cleanup) and task size (trivial / medium / large), and adjusts steps accordingly — full workflow for medium-large, compressed for trivial, but always verifies. Distinct from advise (discusses options without coding), qa (breaks code adversarially), and *-review skills (critique quality patterns without modifying).
---

# Dev — Disciplined Code Work

Cover any task that changes code: building new, fixing bugs, modifying features, refactoring, cleanup, or migration.

If no task is specified → ask what to work on.

Work through steps in order. Do not jump straight to writing code.

---

## Step 0: Detect Mode + Size

Classify the task before planning. This shapes every later step.

### Mode

| Mode | Trigger words | Key risk |
|---|---|---|
| **build** | build, implement, add, create new, write a... | Over-engineering, scope creep |
| **fix** | fix, repair, broken, bug, error, not working | Treating symptom not root cause |
| **modify** | change, update, adjust, edit (existing behavior) | Breaking callers, missing usage sites |
| **refactor** | refactor, restructure, clean up code (no behavior change) | Accidentally changing behavior |
| **cleanup** | remove, delete, deprecate, drop, migrate, upgrade | Deleting something still in use |

If ambiguous (e.g. "add a field to existing entity" = build + modify) → pick the dominant mode, mention the secondary.

### Size

| Size | Indicators | Workflow |
|---|---|---|
| **trivial** | 1-2 files, <30 lines, single-purpose | Compressed (steps 2 + 5 + 6 + 7) |
| **medium** | 3-10 files, single module/feature | Full workflow |
| **large** | Cross-cutting, multiple modules/layers | Full workflow + phase checkpoints |

If unsure of size → assume medium until exploration (Step 2) reveals otherwise.

State the detected mode + size in one line before continuing.

---

## Step 1: Clarify Requirement

- Summarize your understanding back for confirmation
- Ask about ambiguities: expected input/output, edge cases, constraints
- Ask what "done" looks like (acceptance criteria)
- **Mode-specific extras:**
  - `fix` — ask for reproduction steps + actual vs expected behavior + when it started
  - `modify` — confirm new behavior + whether old behavior must still work for some cases
  - `refactor` — explicit confirm: "behavior must not change, correct?" + scope boundary
  - `cleanup` — confirm what's safe to remove + whether deprecation period is needed

Wait for confirmation before continuing (skip wait only for trivial tasks).

## Step 2: Explore Existing Code

Always:
- Read relevant existing code — patterns, conventions, reusable utilities
- Check test setup / frameworks in place
- Determine whether to create new files or modify existing

**For `modify` / `refactor` / `cleanup` — extra discipline:**
- **Find caller / usage sites** — grep for the function/class/module being changed. Don't change a public API blind.
- **Read existing tests** — they describe current behavior. This is your baseline.
- **Run tests once before touching anything** — confirm green starting state. If red already, stop and report.
- **For cleanup:** prove it's actually orphaned — search references, check dynamic uses (reflection, config strings, DI containers)

## Step 3: Plan

- Break work into small steps doable one at a time
- Identify files to create/modify and order of operations
- For significant design decisions → explain reasoning, or ask user
- For medium/large tasks → show plan to user before starting

**Scope statement (mandatory for modify/refactor/cleanup):**
State explicitly:
- **Will touch:** [list files/functions]
- **Will NOT touch:** [adjacent code that looks tempting but is out of scope]

This prevents "while I'm here, let me also refactor X" — which violates surgical-change discipline. If you spot real issues outside scope → flag them in Step 7, don't fix them now.

## Step 4: Test Strategy (mode-dependent)

| Mode | Test approach |
|---|---|
| **build** | TDD — write failing tests first describing desired behavior, then implement |
| **fix** | Reproduce-test-first — write a failing test that reproduces the bug, confirm it fails for the right reason, then fix |
| **modify** | Update or add tests that pin the new behavior; keep tests covering unchanged behavior intact |
| **refactor** | Safety-net check — verify existing tests cover what you're touching. If coverage is thin, write characterization tests BEFORE refactoring |
| **cleanup** | Run tests before delete; ensure nothing fails after removal |

If the project has no test setup → ask user whether to set it up or skip (note the risk).

## Step 5: Write / Change the Code

- Implement step by step following the plan
- Make tests pass one at a time (build/fix) or keep tests green (modify/refactor)
- Follow project conventions and coding style
- Don't write beyond what the requirement asks (no gold-plating)
- **Stay inside the scope from Step 3** — if you find yourself touching files not on the "will touch" list, stop and reconsider

## Step 6: Verify

- Run **all** tests — including existing ones (don't break what was working)
- Run lint / type check if the project has them
- Review against acceptance criteria from Step 1 — every item checked
- **Mode-specific extras:**
  - `fix` — confirm the original reproduction case no longer reproduces
  - `refactor` — diff behavior against baseline from Step 2; behavior must be identical
  - `modify` — verify both new behavior works AND unchanged behavior still works
  - `cleanup` — verify no callers broke, no dynamic references missed
- Look for edge cases that might have been missed

## Step 7: Summarize

- What was done + which files changed
- Design decisions made and why
- **Scope confirmation** — what was in scope vs what was deliberately left untouched
- **Out-of-scope observations** — issues spotted but not fixed (so user can decide whether to tackle next)
- What's not done / known limitations / suggested next steps

---

## Rules

- **Detect mode + size first** — different modes need different test strategies; different sizes need different workflow depth
- **Compress only for trivial** — even then, always verify (Step 6 never skipped)
- **No skipping to Step 5** — always plan and decide test strategy first
- **For large tasks, break into phases and check in** — don't write 500 lines then ask for review
- **Surgical changes only** — never "while I'm here" refactor outside the scope statement; report issues instead
- **If plan turns out wrong mid-way** → stop, inform user, revise — don't push through
- **For refactor: behavior is sacred** — if you can't prove behavior is unchanged, you're not done
- **For cleanup: prove orphan** — search references, check dynamic uses; if uncertain, ask before deleting
