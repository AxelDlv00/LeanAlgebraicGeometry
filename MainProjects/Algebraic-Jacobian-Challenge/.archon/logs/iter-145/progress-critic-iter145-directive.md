# Progress-critic directive — iter-145

## Iteration

145

## Scope

Fresh-context convergence audit per active route. Verdict per route: CONVERGING / UNCLEAR / CHURNING / STUCK.

## STRICT CONTEXT DISCIPLINE

You may NOT read `STRATEGY.md`, blueprint chapters, full iter sidecars, or task results. Only consume the extracted signals below.

## Active routes the planner is considering for iter-146+

### Route 1 — piece (i.b) Step 2 d_app + IsIso + Main (bundled route)

- File: `AlgebraicJacobian/Cotangent/GrpObj.lean`
- **STATUS iter-145 ENTRY**: DESCOPED iter-144 under chart-algebra pivot. Sorry-bodied declarations preserved as auditable record but **NOT** iter-146+ prover target. No prover dispatch planned on this route iter-145+.

### Route 2 — chart-algebra piece (ii) PIN-path-(b)

- File: `AlgebraicJacobian/RigidityKbar.lean` (downstream consumer); chart-algebra (α)+(β) helpers expected to land in a NEW file under `AlgebraicJacobian/` (likely `Cotangent/ChartAlgebra.lean` or similar; decomposition decision is iter-145+ plan-agent territory).
- **STATUS iter-145 ENTRY**: NEW route, iter-144 pivot decision. No prover lane has fired yet (iter-144 was plan-only). Iter-146+ prover lane target per iter-144 STRATEGY.md commitment.

### Route 3 — off-critical-path scaffolds

- Files: `AlgebraicJacobian/Jacobian.lean` (`genusZeroWitness` L197 iter-127 scaffold; `positiveGenusWitness` L223 iter-134 scaffold).
- **STATUS iter-145 ENTRY**: CONVERGING-SCAFFOLD per iter-144 progress-critic; off-critical-path; bodies gated on M2.a body (iter-149+) + M3 Route A (~6500 LOC; off-critical-path).

## Last K=5 iter signals (extracted by the planner)

```
iter   | sorries-decls | sorries-inline | helpers-added | prover-status | recurring-blocker-phrase
-------|---------------|-----------------|---------------|-------------------|-------------------------------
140    | 5             | 7               | +1 (isIso_of_app_iso_module helper iter-140) | PARTIAL on d_app (0 sub-sorries closed; iter-140 narrowed letI scope) | "categorical chase / factoring witness h"
141    | 5             | 7               | 0             | plan-only (HARD GATE + CHURNING-trigger deferral; analogist verdict ALIGN_WITH_MATHLIB on Step 2 sub-sorries) | "categorical chase / factoring witness h"; "pushforward₀ whnf opacity" (resolved iter-141 via named-lemma swap)
142    | 6             | 7               | 0             | PARTIAL on d_app+d_map+IsIso bundled (1 of 3 closed substantively — d_map at L643 via 3-step ALIGN_WITH_MATHLIB chase) | "per-open IsIso identification"; "pushforward₀ whnf opacity on _ = 0 shape goals"
143    | 6             | 6               | +1 (refactor iter-143 Wave 2 extracted basechange_along_proj_two_inv_app_isIso into named theorem) | PARTIAL on d_app only (0 strict-count closures; 1-LOC have hw step 3.a landed but flagged dead-load by lean-auditor-review143) | "Pushforward.comp_eq + eqToHom type-coercion residual" (NEW iter-143 codification)
144    | 6             | 6               | 0             | plan-only (HARD GATE FIRES on 3 blueprint chapters; CHURNING corrective superseded by chart-algebra pivot) | n/a (no prover attempt this iter)
```

Sorry counts at iter-144 close (entering iter-145):
- `Cotangent/GrpObj.lean`: 3 decls / 3 inline (L663 d_app inside `basechange_along_proj_two_inv_derivation`; L751 `basechange_along_proj_two_inv_app_isIso`; L901 `mulRight_globalises_cotangent`). DESCOPED iter-145+ under chart-algebra pivot.
- `Jacobian.lean`: 2 decls / 2 inline (L197 `genusZeroWitness`, L223 `positiveGenusWitness`).
- `RigidityKbar.lean`: 1 decl / 1 inline (L87 `rigidity_over_kbar`; iter-149+ body closure target post-piece-(ii)).

## Iter-144 plan-only iter sorry count delta: unchanged (6/6 → 6/6). 

## Verdicts requested

For each of Routes 1, 2, 3: emit CONVERGING / UNCLEAR / CHURNING / STUCK with the named corrective TYPE (blueprint expansion, mathlib-idiom consult, structural refactor, route pivot). Route 1 is expected DESCOPED-CONVERGENT (the corrective has already landed in iter-144's chart-algebra pivot; route is no longer being assigned prover work). Route 2 is expected UNCLEAR (NEW route, no prover data). Route 3 is expected CONVERGING-SCAFFOLD (off-critical-path; no body closure expected this iter).

## What NOT to do

- Do NOT read STRATEGY.md, blueprint chapters, full iter sidecars.
- Do NOT recommend strategy pivots beyond Route 1 (already pivoted iter-144) or beyond what the data supports.
- Do NOT silently absorb the iter-143 CHURNING legacy as ongoing on Route 1 — Route 1 was structurally DESCOPED iter-144; the convergence axis for Route 1 going forward is "is the descope being honored?", not "is the d_app closing?".
