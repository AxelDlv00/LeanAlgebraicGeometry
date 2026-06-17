# Progress Critic Directive

## Slug
iter144

## Iter
144

## Active routes / files under review

### Route 1 — Piece (i.b) Step 2 (`AlgebraicJacobian/Cotangent/GrpObj.lean`)

Active sub-sorries (entering iter-144):
- `basechange_along_proj_two_inv_derivation` body — d_app sub-sorry at
  L663 (PARTIAL across iter-138 → iter-143).
- `basechange_along_proj_two_inv_app_isIso` body sorry at L751
  (extracted iter-143; iter-144+ target).
- `mulRight_globalises_cotangent` body sorry at L901 (piece (i.b)
  Main; blocked on Step 2).

**Last K=6 iters' signals** (iter-138 → iter-143):

| Iter | Outcome | Sorries (decls/inline) | Helpers added | Strict-count substantive closures | Notes |
|---|---|---|---|---|---|
| 138 | PARTIAL | 3/4 → 3/7 | +1 (`basechange_along_proj_two_inv_derivation` decomposed; d_add+d_mul honestly closed) | 0 (Route (b) skeleton landed; d_app+d_map+IsIso opened as sub-sorries) | sub-sorry count from 3 → 7 (decomposition; sub-piece count went up, total to-close stayed conceptually 1) |
| 139 | plan-only (CHURNING-trigger deferral) | 3/7 | 0 | 0 | mathlib-analogist on IsIso route + STRATEGY.md/blueprint edits only |
| 140 | PARTIAL | 3/7 → 3/7 | +1 (private `isIso_of_app_iso_module`) | 0 | IsIso sub-sorry narrowed; d_app `change`-scaffold landed standalone-validated; new blocker `pushforward₀` whnf-opacity codified |
| 141 | plan-only (HARD GATE blueprint-gate fire + CHURNING-trigger) | 3/7 | 0 | 0 | mathlib-analogist on d_app/d_map shape; +125 LOC blueprint expansion |
| 142 | PARTIAL | 3/7 → 3/6 | 0 | **+1 (d_map closed substantively at L664–700)** | First strict-count closure on this route since iter-138. Iter-141 ALIGN_WITH_MATHLIB recipe via `pushforward_obj_map_apply'` + `NatTrans.naturality_apply` validated empirically. |
| 143 | PARTIAL | 3/6 → 3/6 | 0 | 0 (1-LOC `have hw` step 3.a landed but DEAD-LOAD per `lean-auditor-review143`) | d_app residual remains; structural advance was the iter-143 Wave-2 refactor extracting IsIso into a named theorem (audit transparency restored, +1 sorry-as-named-decl but net 0 inline) |

**Recurring blocker phrases**:
- "categorical chase / factoring witness `h`" — 3 iters (140, 141, 143) — `analogies/d-app-d-map-recipe-shape.md` Decision 2 NEEDS_MATHLIB_GAP_FILL
- "type-coercion via Pushforward.comp_eq + eqToHom" — iter-143 NEW (not yet a recurring phrase but is the iter-143 PARTIAL root cause per `task_results/Cotangent_GrpObj.lean.md`)
- "per-open IsIso identification" — 3 iters (139, 140, 143) — moved iter-143 into its own named theorem

**Iter-143 pre-committed acceptance matrix** (from iter-143 PROGRESS.md):
- PASS arm: d_app closes substantively → CONVERGING-confirmed; counter 2→1.
- **PARTIAL arm (FIRED iter-143)**: counter 2→3; iter-144 mid-iter strategy-critic DIAGNOSTIC question on whether d_app failure is recipe-/definition-/strategy-level. NOT a pre-committed route pivot.
- FAIL arm: d_app fails + new opacity blocker resurfaces → STUCK; mandatory route pivot. NOT fired iter-143 (the iter-143 prover reported recipe correctness; failure is at Lean type-coercion).

Cumulative (i.b)-side LOC measured iter-143: **~600 LOC** at
`Cotangent/GrpObj.lean:L350–L876` (well below 1000 LOC renormalised
trigger cap).

5-consult ledger on piece (i.b) Step 2 (iter-140 envelope-widening
threshold rule): iter-133 + iter-135 + iter-137 + iter-139 + iter-141 = 5
consults; only iter-137 widened envelope. **Envelope-widening arm has
NOT fired**; consult-count arm is the calibration watchpoint (per
iter-140 Edit-2 narrowing).

Counter accounting per iter-143 STRATEGY.md Edit 2 (consecutive-PARTIAL
breakeven): 2 entering iter-143 Wave-3; iter-143 PARTIAL with no
strict-count closure → 2+1 = **3 entering iter-144**. Breakeven fires
at 5; projects iter-146+ at earliest under no further closures.

### Route 2 — Piece (i.b) Step 2 IsIso `basechange_along_proj_two_inv_app_isIso` (extracted iter-143)

This is a NEW separately-tracked route as of iter-143. Last K iters' signals:

| Iter | Outcome | Sub-sorries here | Helpers added | Notes |
|---|---|---|---|---|
| 143 | extracted from prior letI-sorry pattern | +1 named-decl sorry | 0 (no closure attempts) | Wave 2 refactor; iter-144+ target via Route (b'2) items 2–4 (~195–365 LOC bundled) |

Single data point; UNCLEAR by definition. Watch.

### Route 3 — All other files (off-critical-path)

- `Jacobian.lean` L197 `genusZeroWitness` + L223 `positiveGenusWitness` — scaffold; bodies gated on M2.a + M3 closure respectively. No prover attempts last K iters. CONVERGING/SCAFFOLD trivially.
- `RigidityKbar.lean` L87 `rigidity_over_kbar` body — M2.a body; gated on the full pile. No prover attempts last K iters. SCAFFOLD trivially.

## Question to answer

For Route 1 (the only active prover-attempt route iter-144): is the
d_app sub-sorry's residual a CHURNING / STUCK / CONVERGING / UNCLEAR
verdict given the iter-143 PARTIAL outcome with iter-142 substantive
d_map closure offset?

Sub-question to weigh: the iter-143 prover's failure was reported
(per `task_results/Cotangent_GrpObj.lean.md`) as **Lean-level type-
coercion (`Eq.mpr` / `eqToHom` between pushforward composites)**
rather than recipe-level correctness or strategy-level alignment.
Does this matter for the CHURNING/STUCK threshold, or is it just
narration?

Iter-143 pre-committed CHURNING-CONFIRMED corrective shape, if you
issue one: was iter-143 Wave 2 (refactor IsIso to named theorem +
blueprint-writer +285 LOC) sufficient corrective, or does iter-144
need additional structural action (a 6th mathlib-analogist consult
on the type-coercion pattern? a further sub-decomposition of the
d_app sub-sorry into per-step named lemmas?).

## Acceptance signal pre-commitment (write this in your report)

If you issue CHURNING for Route 1, name a concrete iter-144 corrective
TYPE matched to the catalog (mathlib-analogist on type-coercion
pattern vs further structural refactor vs route pivot vs blueprint
sub-decomposition). The planner will match the type to the catalog;
your job is to commit the type, not name the agent.
