---
name: frontend-review
description: Reviews UX/UI and frontend code QUALITY — not bug-hunting. Trigger when the user wants to review a React, Angular, or Vue component for design quality, audit accessibility (a11y, WCAG), check responsive behavior across viewports, assess visual hierarchy, evaluate user experience flow, or review frontend code structure and patterns. Evaluates four dimensions — usability, accessibility, visual design, and code quality — and reports findings prioritized as 🔴 must-fix, 🟡 should-fix, or 🟢 nice-to-have. Distinct from qa — that one hunts bugs through adversarial testing, this one critiques quality and design choices. Provides opinions only, does not modify code.
---

# Frontend Review

Review UX/UI quality and frontend code.

Find what to review:
1. If given a component file path → review that code
2. If given a URL → open the live app (use preview/browser tool), screenshot, then review what's seen
3. If nothing specified → check `git diff` for frontend files; if none, ask what to review

---

## Important: Opinions Only — Do Not Modify Code
Report issues and suggestions. The user decides what to fix.

---

## Review 4 Dimensions

### 1. Usability — Is it easy to use?
- Is the flow clear? Does the user know what to do next?
- Are all feedback states present: loading, success, error, empty state?
- Do buttons/links communicate their purpose — can users predict the outcome?
- Do error messages help users fix the problem, not just say something went wrong?
- Is the number of steps appropriate — not forcing unnecessary input?

### 2. Accessibility (a11y) — Can everyone use it?
- Uses semantic HTML (`button`, `nav`, `main`, headings in order) — not `div` for everything
- ARIA labels where needed, `alt` text on images
- Full keyboard navigation — tab order, visible focus
- Color contrast meets WCAG (typically AA: 4.5:1 for text)
- Form `<label>` elements are associated with inputs
- Not communicating with color alone (e.g. errors need text, not just a red border)

### 3. Visual Design — Does it look good?
- Visual hierarchy — important things are more prominent
- Consistent spacing (same scale throughout — no ad-hoc values)
- Typography — font size/weight is systematic and readable
- Consistency — same button/color/spacing style across the app
- Responsive — works on mobile / tablet / desktop
- Clean alignment — nothing looks off or crooked

### 4. Frontend Code Quality
- Component structure — appropriate size, separated concerns, reusable
- State management — state lives at the right level, no excessive prop drilling
- Performance — unnecessary re-renders, missing memo/key, large lists without virtualization
- `key` prop is correct (don't use index if the list can be reordered)
- Side effects / data fetching handled properly (cleanup, race conditions, loading/error states)
- Follows the React/Angular/Vue conventions of the project

---

## Output Format

Ordered by priority:

**🔴 Must fix** (broken / inaccessible / bug)
- [Issue + why it's a problem + suggested fix] — `file:line` or location on screen

**🟡 Should fix** (works but degrades experience)
- [...]

**🟢 Nice-to-have** (improvement, not critical)
- [...]

Close with a **Summary**: overall UX/UI health, things already done well.

---

Rules:
- Back every finding with "why" — tie it to real user impact
- When reviewing from a URL, check multiple viewport sizes (mobile + desktop)
- If the UI/code is already good, say so — don't manufacture criticism
- Accessibility issues that make the UI unusable → always 🔴
