# Directive — progress-critic (iter-147)

## Active routes

### Route 1: Chart-algebra piece (ii) — `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

**Strategy `Iters left` estimate / phase entry**:
- Per STRATEGY.md M2.body-pile row (iter-146 reconciliation): chart-algebra envelope
  ~600–1050 LOC over ~5–7 iter; expected iter-146 → iter-152.
- Route entered current phase iter-145 (chart-algebra skeleton scaffolded
  by `refactor-chart-algebra-skeleton-bundled-excise-iter145`).
- Elapsed iters in current phase: 2 (iter-145 scaffold + iter-146 first prover lane).

**Last 4 iters' signals**:

| Iter | File sorries (decl/inline) | Helpers added | Prover status | Recurring blocker phrases |
|---|---|---|---|---|
| 143 | n/a (file did not exist; bundled-route piece (i.b) lane on `Cotangent/GrpObj.lean`) | iter-143 `refactor-isiso-extract-iter143` extracted `basechange_along_proj_two_inv_app_isIso` from inline `letI` (per § Soundness "Sorry-must-be-named-declaration" rule) | PARTIAL on bundled route | "type-coercion residual", `Pushforward.comp_eq` / `eqToHom` |
| 144 | n/a (file did not exist; plan-only iter) | none (chart-algebra pivot decided this iter) | n/a (no prover lane) | chart-algebra-vs-bundled gate fired |
| 145 | 5 / 5 (file CREATED iter-145 with 5 `: True := sorry` placeholders) | none (refactor lane only; +5 placeholders is the decomposition cost) | n/a (refactor scaffold, no prover lane) | n/a |
| 146 | 3 / 3 (5 → 3; 2 closures + 1 PARTIAL refinement; 2 OFF-LIMITS placeholders preserved by planner directive) | 0 (prover refined 3 placeholder signatures + closed 2 + partial-closed 1) | DONE on assigned scope; 2 of 3 scoped sub-pieces sorry-free | "deferred to iter-147+ closure path"; "geom-irr base-change step" (constants substep 3) |

**Note**: iter-145's "5 placeholders" landed as a decomposition cost; the
qualitative picture is −3 dead-load (DESCOPED bundled-route artefacts excised) + 5 live (iter-146+ targets).
Iter-146 ate 2 of 5 (substantively closed); 1 of 5 partial-closed; 2 of 5
preserved OFF-LIMITS by planner directive. Iter-147+ targets the 2
deferred sub-pieces (β-core + KDM ring-side) + finishes the constants
substep 3.

**Recurring blockers (iter-145 → iter-146)**:
- iter-146 prover hit a real obstacle on constants substep 3
  (geom-irr base-change of `Γ` for proper schemes; substantive
  AG infrastructure gap; closure path documented inline at L167–176 of
  ChartAlgebra.lean).
- iter-146 prover signature-reduced `ext_of_diff_zero` by dropping the
  `df = dg` hypothesis. Iter-147+ refinement plan documented in prover
  report; not a blocker per se.

### Route 2 (off-critical-path scaffolds): `Jacobian.lean` + `RigidityKbar.lean`

**Strategy `Iters left` estimate / phase entry**:
- `Jacobian.lean:197` `genusZeroWitness` (iter-127 scaffold). Body
  closure iter-151+ per STRATEGY.md (gated on M2.a body iter-149+).
- `Jacobian.lean:223` `positiveGenusWitness` (iter-134 scaffold). Body
  closure M3 Route A work, ~6500 LOC; off-critical-path.
- `RigidityKbar.lean:87` `rigidity_over_kbar` (iter-126 scaffold). Body
  closure iter-149+ post chart-algebra piece (ii).
- All three are deliberately frozen scaffolds; no prover work expected
  this iter.

**Last 4 iters' signals**: unchanged — 2/2/1 sorries unchanged across
iter-143 → iter-146.

## Planner's PROGRESS.md `## Current Objectives` proposal

**Iter-147 plan (proposed)**:
1. `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` — Fill 3 sorries:
   - L97 (β-core) `df_zero_factors_through_constant_on_chart`: refine
     `: True` placeholder to real signature; close via the iter-146
     blueprint-writer's 5-step recipe (chart-Kähler kernel extraction
     + 2-chart Čech Mayer–Vietoris + char-p Frobenius patch).
     Estimate: ~150–300 LOC.
   - L107 (KDM ring-side) `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`:
     refine `: True` placeholder; close via the iter-146 blueprint-writer's
     KDM (p1) 4-substep recipe + the new helper lemma
     `lem:KaehlerDifferential_constants_in_chart_of_proper_curve`.
     Estimate: ~200–350 LOC.
   - L177 constants substep 3: complete the geom-irr base-change chain
     per iter-146 prover's documented closure path. Estimate: ~50–100 LOC.
   - Aggregate: ~400–750 LOC of proof script. ONE prover lane this iter
     per the user-hint to scope objectives larger.

**File count = 1** (single prover lane this iter; well below dispatch
cap of 10).

## What I'm asking

Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with
specific corrective recommendations where CHURNING / STUCK. Apply
your standard rubric to:
1. Route 1 chart-algebra: is the iter-146 first-prover-lane outcome
   (2 closures + 1 partial + 2 OFF-LIMITS held to plan) compatible
   with the iter-146→iter-152 envelope? Or does the substep-3
   geom-irr deferral signal a deeper blocker?
2. Route 2 scaffolds: do the three frozen scaffolds need any iter-147
   attention or are they correctly held?
3. Dispatch sanity on the iter-147 proposed objectives (single file,
   3 sorries, ~400–750 LOC aggregate). Per user-hint the loop wants
   prover output to be "several hundred LOC of proof script, not 20 LOC";
   the proposed lane sits in that range. Flag any over-scope concerns.

Iter-147 is the **second prover-attempt iter** on chart-algebra
(iter-146 was first). PARTIAL outcome on Route 1 would NOT yet
constitute CHURNING per your descriptor's K=3-5 minimum data window.
Iter-148+ would be the earliest CHURNING trigger if PARTIAL repeats.
