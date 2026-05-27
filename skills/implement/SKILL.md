---
name: implement
description: Disciplined feature implementation that actually WRITES CODE. Trigger when the user asks to build, code, implement, add, write, or create new functionality — meaning they want working code produced, not just discussion or planning. Forces a 7-step process — clarify requirement, explore existing codebase, plan in phases, write tests first (TDD), implement to pass tests, verify with full test suite plus lint and type checks, then summarize. Asks for confirmation between phases for large tasks, compresses steps for trivial changes but always verifies. Distinct from advise — advise discusses options without coding. Distinct from qa — qa breaks code, implement builds it.
---

# Implement

Implement a feature or coding task with discipline.

If no task is specified → ask what feature to implement.

Work through steps in order. Do not jump straight to writing code.

---

## Step 1: Understand the Requirement
- Summarize your understanding back to the user for confirmation — prevent misalignment upfront
- Ask about ambiguities: expected input/output, edge cases to handle, constraints
- Ask what "done" looks like (acceptance criteria)
- Wait for confirmation before continuing

## Step 2: Explore the Existing Codebase
- Read relevant existing code — patterns, conventions, reusable utilities
- Determine whether to create new files or modify existing ones
- Check what test setup / frameworks are already in place

## Step 3: Plan
- Break the work into small steps that can be done one at a time
- For large or complex tasks → show the plan to the user before starting
- Identify files to create/modify and the order of operations
- For significant design decisions → explain the reasoning, or ask the user

## Step 4: Write Tests First (TDD)
- Write tests that describe the desired behavior — cover happy path + key edge cases
- Run the tests and confirm they fail (implementation doesn't exist yet)
- If the project has no test setup → ask the user whether to set it up or skip this step

## Step 5: Write Code to Pass the Tests
- Implement step by step following the plan
- Make tests pass one at a time
- Follow the project's conventions and coding style
- Don't write beyond what the requirement asks for (no gold-plating)

## Step 6: Verify
- Run all tests — including existing ones (don't break what was already working)
- Run lint / type check if the project has them
- Review against acceptance criteria from Step 1 — every item checked
- Look for edge cases that might have been missed

## Step 7: Summarize
- Brief summary of what was done and which files changed
- Design decisions made and why
- What's not done / known limitations / suggested next steps

---

Rules:
- Do not skip to Step 5 — always plan and write tests first
- For very small tasks (1–2 line changes), compress the steps — but still verify
- If the plan turns out to be wrong mid-way → stop, inform the user, revise the plan — don't push through
- For large tasks, break into phases and check in with the user regularly — don't write 500 lines then ask for review
