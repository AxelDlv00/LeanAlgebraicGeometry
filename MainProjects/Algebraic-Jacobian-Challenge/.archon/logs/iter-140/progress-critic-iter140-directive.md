# progress-critic directive — iter-140

You are the iter-140 progress-critic. Render a fresh-context CONVERGING
/ CHURNING / STUCK / UNCLEAR verdict per ACTIVE route based ONLY on
the extracted signals below. Do NOT read STRATEGY.md, blueprint
chapters, or iter sidecars.

## Active routes (one block per route)

### Route 4 — Piece (i.b) Step 2: base-change-along-`pr_2` iso

File: `AlgebraicJacobian/Cotangent/GrpObj.lean` (`relativeDifferentialsPresheaf_basechange_along_proj_two` at L612 main body; helpers `basechange_along_proj_two_inv_derivation` L547 + `basechange_along_proj_two_inv` L596).

**K = 5 iters signal table** (iter-135 → iter-139):

| Iter | Prover status | Sorries on (i.b) Step 2 family | Helpers added on (i.b) Step 2 | Recurring blocker phrase |
|---|---|---|---|---|
| iter-135 | refactor (no prover dispatch on (i.b)) | scaffold landed: 3 hollow sorries (Step2 + Step3 + Main were all `sorry`) | 0 (refactor replaces hollow placeholders with honest scaffolds typed against intended sheaf-level RHS) | — |
| iter-136 | prover COMPLETE (Step 3 closed); Step 2 deferred | scaffold 3 → 2 (Step 3 closed; Step 2 + Main remain) | 0 (Step 3 closure took ~27 LOC kernel-only) | — |
| iter-137 | prover PARTIAL (Step 2 lane); 4 docstring edits, 0 code edits, 0 new declarations | 2 → 2 (no body cut on Step 2) | 0 code | `PresheafOfModules.pullback opacity` (analogist Decision 4 anticipated; blueprint did not) |
| iter-138 | prover PARTIAL with substantive Route (b) skeleton body cut; +2 helpers, body refactored | 2 → 3 (decomposition trade-off: 1 hollow Step 2 sorry → 3 narrow sub-sorries: d_app L581 + d_map L585 + IsIso L624) | +2 helpers (`_inv_derivation` + `_inv`); d_add + d_mul of pointwise derivation closed honestly | — (NEW progress; envelope-widening absorbed iter-137) |
| iter-139 | NO PROVER DISPATCH (plan-only; blueprint-writer Wave 2 ran instead — iter-139 blueprint-reviewer HARD GATE FIRED because `RigidityKbar.tex` AND `AlgebraicJacobian_Cotangent_GrpObj.tex` were `complete: partial` after iter-138's substantive body cut) | 3 → 3 (unchanged; intentional iter-139 deferral, not stall) | 0 (no Lean edits this iter) | — (intentional plan-only iter; blueprint hardened via iter-139 blueprint-writer) |

**Iter-139 → iter-140 transition state**: 3 sub-sorries remain (d_app L581 + d_map L585 + IsIso L624). The iter-139 mathlib-analogist (`isiso-routes`) returned PROCEED-with-Route-(b'2) for the IsIso sub-sorry (5-line bridge + ~195–365 LOC; saves ~50–195 LOC vs Route (a)); iter-139 blueprint-writer added d_app + d_map closure recipes to `RigidityKbar.tex`. Iter-140 prover lane will target the 3 sub-sorries (likely bundled).

### Cumulative analogist-overhead axis on piece (i.b) Step 2

Per iter-139 STRATEGY.md Edit 2: piece (i.b) Step 2 has had 4 cumulative analogist consults across iter-133→iter-139:
- iter-133 `mulright-globalises-cotangent` — PROCEED.
- iter-135 `phi-compatibility-morphisms` — PROCEED.
- iter-137 `kaehler-tensorequiv-presheafpullback` — PROCEED; **envelope-widening (150–300 → 360–710 LOC)**.
- iter-139 `isiso-routes` — PROCEED with Route (b'2); validated and refined, did NOT widen.

Threshold rule committed iter-139: ≥5 consults on a single sub-piece OR ≥3 envelope-widening consults re-raises the route-pivot question with explicit strategy-critic re-dispatch (mid-iter). Currently 4 consults, 1 envelope-widening; iter-140 PARTIAL triggering a 5th consult on Step 2 alone would cross the threshold.

### Off-active routes (NOT under your jurisdiction this iter)

- M2.a body closure `rigidity_over_kbar` (iter-151+; not active iter-140).
- M2.b body closure `genusZeroWitness` (iter-153+; not active).
- M3 `positiveGenusWitness` (off-critical-path).
- Piece (i.c.1/i.c.2/i.c.3) (iter-141+; not active iter-140).
- Piece (ii) (iter-143+; not active).
- Piece (iii) (iter-144+; not active).

Do NOT render verdicts on these; they are off-critical-path or
scheduled for future iters with no active prover work.

## Iter-139 hard gates committed for iter-140

(These are the planner's pre-commitment; you reapply them after iter-140 ships.)

- **PASS (CONVERGING-confirmed)**: ≥2 of 3 sub-sorries closed substantively (d_app + d_map at minimum; IsIso preferred via Route (b'2)). Sorry count 6 decls → ≤4 decls.
- **PARTIAL (CHURNING-trigger)**: 0 or 1 sub-sorries closed (third consecutive PARTIAL on (i.b) Step 2 family). Iter-141 must fire CHURNING-trigger AND re-open over-k vs over-`k̄` decision via mid-iter strategy-critic re-dispatch.
- **FAIL (STUCK)**: 0 sub-sorries closed AND `PresheafOfModules.pullback` chart-opacity blocker phrase resurfaces. Route pivot required.

These pre-commits are for iter-141's evaluation of the iter-140 outcome; iter-140 hasn't shipped yet. **Render your iter-140 verdict on the iter-139 state** (the data above; what should iter-140 plan agent commit?), NOT on iter-140 outcomes.

## Output

Write a self-contained report to `task_results/<your-name>-<slug>.md`
naming per-route verdicts (CONVERGING / CHURNING / STUCK / UNCLEAR)
with specific correctives if CHURNING or STUCK. The plan agent uses
this to commit (or revise) the iter-140 prover lane dispatch.
