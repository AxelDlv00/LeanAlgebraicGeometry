# Progress-critic directive — iter-026 (Quot-Foundations)

Assess convergence per active route from the signals below. K=4 window. Verdict per route
(CONVERGING / CHURNING / STUCK / UNCLEAR) + the named corrective TYPE for any CHURNING/STUCK.
Also run the dispatch-sanity check on the proposed objective list at the end.

## Route 1 — FBC (`AlgebraicJacobian/Cohomology/FlatBaseChange.lean`)

Target: close `base_change_mate_gstar_transpose` (the i=0 base-change mate coherence), gated on
`base_change_mate_inner_value_eq`. STRATEGY phase: FBC-A; Iters-left estimate = 2–4; entered the
current "gstar 5-lemma chain" phase ~iter-019 (≈5–6 iters elapsed).

Signals (per iter):
- iter-021: status PARTIAL; sorry-elim 0; helpers +0; blocker phrase "step 2–3 ~150-LOC telescoping".
- iter-022: status PARTIAL; sorry-elim 0 (gstar step-1 + `huce` conjugate scaffold landed, compiles);
  sorry=4; blocker "step 2–3 telescoping".
- iter-023: status PARTIAL; effort-breaker split gstar into a 5-lemma chain; **Seam C closed
  axiom-clean** (first sorry-elim in the gstar window); sorry 4→6 (decomposition stubs); helpers +5;
  blocker "inner_eCancel ~150-LOC".
- iter-024: status PARTIAL; effort-breaker split inner_eCancel into 3 atoms; **3 atoms + Seam B
  `gstar_generator_close` all closed axiom-clean**; sorry 6→5; helpers +3; blocker "literal-form-lock
  on `inner_value_eq`" (lemma LHS prints identically to goal subterm but `rw`/`simp only` fail to match
  — invisible implicit-arg divergence; project memory `fbc-subst-legs-literal-form-lock`).

Note for your read: the prior two iters DID eliminate sorries (Seam C; then 3 atoms + Seam B), so the
route is structurally advancing even though the terminal `inner_value_eq` assembly is unclosed. This
iter the planner has ADDED a new blueprint prescription to `inner_value_eq` (the "pre-subst route":
distribute the unit on the free composite BEFORE the legs lock to literal projections), i.e. a concrete
NEW route, not a reworded re-dispatch. Question for you: is FBC CONVERGING (closes each iter, terminal
assembly now has a fresh route) or STUCK (terminal sorry unmoved 4 iters)?

## Route 2 — QUOT keystone (`AlgebraicJacobian/Picard/QuotScheme.lean`)

Target: build the keystone `Scheme.Modules.isLocalizedModule_basicOpen` (qcoh sections on a basic open
are the localized module). STRATEGY phase: QUOT-defs; Iters-left = 4–8; keystone lane entered iter-024.

Signals:
- iter-024: status PARTIAL (mathlib-build); **2 affine-engine theorems added axiom-clean**
  (`isLocalizedModule_tilde_restrict`, `isLocalizedModule_restrict_of_isIso_fromTildeΓ`); keystone
  itself NOT added (would need a sorry) — handed off a precise decomposition: the bottleneck is "gap1"
  = `IsQuasicoherent M → IsIso M.fromTildeΓ` on Spec R (the QCoh≃Mod affine descent, confirmed
  Mathlib-absent). sorry unchanged (4 protected stubs). helpers +2.

Only 1 iter of data (fresh lane). This iter the planner re-targets the lane to gap1 itself
(`isIso_fromTildeΓ_of_isQuasicoherent`) as an explicit mathlib-build, with a fresh blueprint block.

## Route 3 — GR-glue (`AlgebraicJacobian/Picard/GrassmannianCells.lean`)

Target: build `Grassmannian.scheme` by gluing the affine charts. Fresh lane: charts + transitions +
cocycle were completed iter-012 (file GREEN, 0 sorry); the gluing itself has had 0 prover iters.
STRATEGY phase: GR-glue; Iters-left = 1–3; entering this iter. Expect UNCLEAR (no trajectory yet).

## Proposed objectives this iter (dispatch-sanity: 3 files, all import-independent)
1. `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` — FBC `inner_value_eq` via the new pre-subst route. [fine-grained]
2. `AlgebraicJacobian/Picard/QuotScheme.lean` — gap1 `isIso_fromTildeΓ_of_isQuasicoherent`. [mathlib-build]
3. `AlgebraicJacobian/Picard/GrassmannianCells.lean` — build `Grassmannian.scheme`. [mathlib-build]
