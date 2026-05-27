---
name: backend-review
description: Reviews backend, API, and data layer quality. Trigger when the user wants to review backend code, audit an API endpoint or REST service, check for security vulnerabilities (auth, IDOR, SQL injection, secrets), assess performance (N+1, caching, async), evaluate a data layer (transactions, ORM, race conditions), check reliability patterns (retry, circuit breaker, idempotency), audit observability (logging, tracing, metrics), or assess testability/maintainability. Covers 7 dimensions and reports findings prioritized as 🔴 must-fix (security hole, data loss, outage), 🟡 should-fix, or 🟢 nice-to-have. Provides opinions only; does not modify code.
---

# Backend Review

Review backend / API / data layer quality.

Find what to review:
1. If given a file/folder path → review that code (controller, service, repository, middleware, etc.)
2. If given an API URL or OpenAPI spec → review the API design from the spec
3. If given a feature or endpoint name → search in the current directory
4. If nothing specified → check `git diff` for backend files; if none, ask what to review

---

## Important: Opinions Only — Do Not Modify Code
Report issues and suggestions. The user decides what to fix.

---

## Review 7 Dimensions

### 1. 🌐 API Design — Is the contract with clients well-defined?

- **REST/HTTP conventions** — correct method usage (GET doesn't change state; POST/PUT/PATCH/DELETE match intent)
- **Status codes** — semantically correct (2xx success, 4xx client error, 5xx server error — never 200 with `success: false`)
- **Resource naming** — plural nouns, consistent kebab-case or snake-case throughout
- **Versioning** — `/v1/...` or version headers in place to support breaking changes
- **Idempotency** — PUT/DELETE must be idempotent; POST that creates resources should support an idempotency key
- **Pagination** — list endpoints support pagination — not returning entire datasets (cursor-based is safer than offset)
- **Error response** — structured so clients can parse it (error code + message + details) — no raw stack traces
- **Request/Response schema** — clear and documentable (OpenAPI/Swagger-ready)

### 2. 🔒 Security — Is it safe?

- **Authentication** — protected endpoints are actually checked, not just commented
- **Authorization** — resource-level permission checks (user A cannot access user B's resources) — watch for IDOR
- **Input validation** — all inputs validated (type, range, length, format) before use
- **SQL injection** — parameterized queries / ORM used — no string concatenation
- **XSS / Output encoding** — output is properly encoded if rendered in HTML
- **Secrets management** — no hardcoded keys/passwords/tokens; use env vars / secret manager
- **CORS** — as restrictive as possible — no `*` in production
- **Rate limiting** — critical endpoints (login, signup, password reset) have rate limits
- **CSRF** — cookie-based auth requires CSRF tokens
- **Mass assignment** — not accepting entire objects from client (e.g. `user.isAdmin` cannot be set via request body)
- **Sensitive data in logs** — passwords, tokens, and PII are never logged

### 3. ⚡ Performance — Is it fast and scalable?

- **N+1 queries** — loops that query the DB one at a time should use joins / batch / DataLoader
- **Missing indexes** — queries that filter/sort on unindexed columns
- **Over-fetching** — `SELECT *` or loading unused data
- **Caching** — endpoints with rarely-changing results should use cache (HTTP cache headers / Redis)
- **Async I/O** — I/O-bound work uses async/await correctly — not blocking the event loop (Node) or thread pool (Java)
- **Connection pooling** — pool sized appropriately — not opening/closing connections per request
- **Heavy work in request cycle** — heavy tasks (reports, emails, image processing) should be offloaded to a background queue
- **Payload size** — responses not unnecessarily large; gzip/compression supported
- **Timeouts** — all external calls have timeouts — nothing waits forever

### 4. 💾 Data Layer — Is data handled correctly?

- **Transaction boundaries** — related operations are in a single transaction (atomicity)
- **Isolation level** — appropriate for the use case (read committed / repeatable read / serializable)
- **Race conditions** — read-then-write operations have proper locking / optimistic concurrency
- **Repository pattern** — data access clearly separated from business logic
- **ORM gotchas** — lazy loading causing N+1, over-eager cascades, dirty tracking surprises
- **Migrations** — schema changes have migration scripts — no manual DB edits
- **Soft delete vs hard delete** — chosen correctly for the business requirement
- **Data integrity constraints** — FK, unique, NOT NULL enforced at the DB level, not just application level
- **Timezone handling** — stored as UTC in the DB, converted on display

### 5. 🛡️ Reliability — Can it recover from failure?

- **Error handling** — errors are caught and acted on — not silently swallowed
- **Retry strategy** — transient external failures have retry with exponential backoff
- **Circuit breaker** — downstream service outage doesn't cascade into this service
- **Idempotency** — duplicate requests don't cause duplicate side effects (critical for payments, orders)
- **Timeout chaining** — each call's timeout is shorter than its caller's timeout
- **Graceful shutdown** — handles SIGTERM and drains in-flight requests before stopping
- **Health checks** — `/health` (liveness) is separate from `/ready` (readiness)
- **Distributed transactions** — if unavoidable, uses saga pattern / outbox pattern

### 6. 📊 Observability — Can you debug it when it breaks?

- **Structured logging** — logs are JSON with fields like `request_id`, `user_id`, `level`
- **Appropriate log levels** — DEBUG/INFO/WARN/ERROR used correctly
- **Correlation / Trace IDs** — requests are traceable across services
- **Metrics** — request count, latency, error rate (RED method) / saturation, utilization (USE method)
- **Distributed tracing** — OpenTelemetry or equivalent for call chains
- **Actionable alerts** — alerts tell you what to do immediately, not just that something happened
- **Audit log** — significant actions (login, delete, permission change) are recorded

### 7. 🧪 Testability & Maintainability — Is it easy to maintain?

- **Clear layering** — controller / service / repository have distinct responsibilities — not mixed
- **Dependency injection** — dependencies are passed in, not instantiated inside classes (enables mocking)
- **Pure functions** — core business logic is pure and separated from side effects
- **Test coverage on critical paths** — happy path + edge cases + error cases
- **No magic numbers/strings** — named constants with clear intent
- **DRY without overdoing it** — abstract after three repetitions (rule of three), not at the first sign of similarity
- **Configuration** — separated from code via env vars
- **Documentation** — README covers setup/run/test; ADRs for significant decisions

---

## Output Format

Ordered by priority:

**🔴 Must fix** (security hole / data loss / production outage)
- [Issue + why it's a problem + suggested fix] — `file:line` or endpoint
- Example: SQL injection at `users.controller.ts:45` — string concat used → use parameterized query

**🟡 Should fix** (works but risky / poor performance / hard to maintain)
- [...]

**🟢 Nice-to-have** (improvement, not critical)
- [...]

Close with a **Summary**:
- Overall backend quality (score 1–5 per dimension if feasible)
- Things already done well
- Top 3 issues to fix first

---

Rules:
- Back every finding with "why" — tie it to real impact (security risk / downtime / data loss / cost)
- Severity is based on actual impact, not how annoying the issue is
- **Security issues that expose or allow modification of data → always 🔴, no exceptions**
- If the code/architecture is already good, say so — don't manufacture criticism
- Scale depth to scope — reviewing one endpoint doesn't require going through all 7 dimensions
- For performance concerns that need measurement first → explicitly say "benchmark before optimizing"
- Don't make definitive calls on context-dependent decisions (e.g. microservices vs monolith) — present the trade-offs and let the user decide
