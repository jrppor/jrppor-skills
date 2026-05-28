# jrppor-skills

A collection of **Agent Skills** for AI coding agents — Claude Code, Cursor, Codex, Cline, Amp, and 9+ more via [`skills.sh`](https://skills.sh/). Structured, opinionated workflows for real engineering work. Auto-triggered by the agent based on the task at hand.

---

## Layout

Each skill is its own directory under `skills/`, containing a `SKILL.md` with YAML frontmatter (`name` and `description`). The agent reads the description and triggers the skill automatically when the task matches.

---

## Install

### With `npx skills` (Recommended)

```bash
npx skills add jrppor/jrppor-skills
```

### Alternative — local symlink for Claude Code (maintainer's dev loop)

Clone the repo, then symlink every skill into `~/.claude/skills/` (Claude Code only):

```bash
./scripts/install-local.sh
```

List every skill in the repo:

```bash
./scripts/list.sh
```

---

## Skills

- **[advise](./skills/advise/SKILL.md)** — Senior programming advisor for technical decisions: choosing libraries/frameworks/architecture patterns, comparing trade-offs, and giving recommendations tied to the user's context. Probes for XY problems before answering and warns about over-engineering.
- **[qa](./skills/qa/SKILL.md)** — Adversarial QA engineer that hunts for bugs, edge cases, and broken assumptions. Simulates failure scenarios (edge cases, invalid input, race conditions, environment failures), traces failure paths, and reports issues with concrete reproduction steps.
- **[frontend-review](./skills/frontend-review/SKILL.md)** — Reviews UX/UI quality and frontend code across four dimensions: usability, accessibility (WCAG/a11y), visual design, and code quality. Prioritizes findings as must-fix / should-fix / nice-to-have.
- **[backend-review](./skills/backend-review/SKILL.md)** — Reviews backend, API, and data layer quality across 7 dimensions: API design, security, performance, data layer, reliability, observability, and testability. Treats security issues that expose or modify data as critical, always.
- **[dev](./skills/dev/SKILL.md)** — Disciplined code work for build / fix / modify / refactor / cleanup. Auto-detects mode and size, then adapts the workflow: TDD for new features, reproduce-test-first for bugs, safety-net checks for refactor, orphan-proof for cleanup. Enforces a scope statement to prevent "while I'm here" creep.

---

## License

[MIT](./LICENSE) — free to use, modify, and distribute.
