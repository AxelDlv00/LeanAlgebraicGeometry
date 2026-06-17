# Mathlib-analogist directive — M3 Route A audit refresh, iter-145

## Iteration

145

## Slug

m3-route-a-refresh-iter145

## Question

The project's M3 (positive-genus Albanese witness) is COMMITTED to Route A — Picard scheme via FGA — per the iter-144 user-hint (`STRATEGY.md` § "Iter-144 user-hint M3 disposition (binding)"). The midpoint LOC estimate (~6500 LOC) comes from `analogies/m3-route-audit.md` produced at iter-123, against Mathlib snapshot `b80f227`. That audit is 21 iters stale; Mathlib has moved forward.

**Refresh the audit against the current Mathlib snapshot.** Specifically:

1. **A1 (Hilbert / QCoh / Coh / flattening)** — iter-123 estimate ~4150 LOC. Has any of the constituent infrastructure landed in Mathlib since `b80f227`?
   - Hilbert scheme representability for projective schemes (`Mathlib.AlgebraicGeometry.Hilbert.Representability` — did NOT exist iter-123).
   - QCoh / Coh typeclass on `Scheme.SheafOfModules` — flattening stratification (Grothendieck) — did NOT exist iter-123 in mainline.
   - Quasi-coherent sheaves of finite type / flat-locus formation.
2. **A2 (Quot post-A1)** — iter-123 estimate ~1400 LOC. Has any of the Quot-representability machinery landed?
3. **A3 (identity-component subgroup scheme)** — iter-123 estimate ~1025 LOC. Has any of the identity-component construction landed for `k`-group schemes locally of finite type? Specifically: connected components of topological group objects in `Scheme/k`, open/closed subgroup schemes.

For each of A1, A2, A3, return:

- **Per-piece LOC estimate refreshed** (in-tree implementation cost), against current Mathlib.
- **Per-piece "landed since iter-123" sub-pieces**, with Mathlib path and one-line role.
- **Per-piece "still missing" sub-pieces** (NEEDS_MATHLIB_GAP_FILL) with refreshed LOC.
- **Per-piece net delta** (was X LOC iter-123 → is Y LOC iter-145 ± Z LOC).

## Output expectations

Refreshed persistent file at `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/analogies/m3-route-a-refresh-iter145.md` (one file; UPDATE/REPLACE the iter-123 `analogies/m3-route-audit.md` only by appending a "Iter-145 refresh" section, NOT by overwriting the iter-123 prose — the iter-123 audit is part of the project's auditable history).

Report goes to `task_results/mathlib-analogist-m3-route-a-refresh-iter145.md`.

Verdict shape:
- **AUDIT_STABLE** — the iter-123 estimate is within ±20% on each of A1, A2, A3.
- **AUDIT_TIGHTENED** — material progress in Mathlib reduces the estimate by >20% on at least one of A1, A2, A3.
- **AUDIT_INFLATED** — Mathlib infrastructure we counted on iter-123 has been refactored / removed / re-shaped such that the in-tree cost is now higher than iter-123 estimated.
- **AUDIT_RESHAPED** — the route's gating pieces have changed structurally (e.g. a new Mathlib idiom replaces one of the iter-123 gating pieces).

## Strict context discipline

You may read:
- `analogies/m3-route-audit.md` (iter-123 reference)
- `references/challenge.lean` if relevant (the protected signatures M3 must serve)
- Mathlib (via `lean_local_search`, `lean_loogle`, `lean_leansearch`, `lean_state_search` as you need)
- `STRATEGY.md` § M3 (to confirm the route definition and the iter-123 numbers being refreshed)

You may NOT:
- Read prover task results, iter sidecars, or review reports.
- Re-decide the Route A vs Route B choice (decided iter-144 user-hint; out of scope).
- Recommend strategy pivots beyond the audit refresh.

## Why this dispatch is mandatory iter-145

The iter-144 strategy-critic surfaced this as Must-fix #3: "the iter-123 audit underpinning the iter-144 user-hint Route A commitment is 21 iters stale + rests on Mathlib snapshot b80f227". STRATEGY.md L627 commits to this dispatch this iter, with a "failure to refresh by iter-150 is a sunk-cost trap" guardrail. Iter-145 honors the commitment.
