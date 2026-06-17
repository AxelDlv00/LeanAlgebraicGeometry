# Progress-critic directive — iter-043

Assess convergence per active route. K=5. The planner proposes 3 parallel prover lanes this iter
(3 distinct files). For each route: is it CONVERGING / CHURNING / STUCK / UNCLEAR?

## Route QUOT (file: AlgebraicJacobian/Picard/QuotScheme.lean)
Section-localization-descent + consumers. Signals (sorry count = protected stubs, stable at 4):
- iter-039: +feeders (PARTIAL; keystone not closed)
- iter-040: +4 decls, producer (a) + range-half (PARTIAL)
- iter-041: +7 decls, gap1 CLOSED + keystone + producer chain (COMPLETE for gap1)
- iter-042: +5 decls, G1-core CLOSED + gap2 core+crux landed; gap2 itself ABSENT (PARTIAL, ~80%)
- recurring blocker phrase: "gap2 left absent pending Piece A (QC-pullback, Mathlib-absent) + Piece B (mechanical)"
- Strategy estimate: QUOT-consumers "Iters left 2–4"; phase entered iter-042 (gap1 closed 041, ~14-iter arc).
- Proposed this iter: prover at Piece A (QC-pullback build) then Piece B → close gap2.

## Route FBC (file: AlgebraicJacobian/Cohomology/FlatBaseChange.lean)
i=0 affine base-change iso. Signals (sorry 4→4, untouched):
- iter-037–041: conjugate `gstar_transpose` route, 5 iters, NO close (STUCK); kill-criterion fired 039
- iter-041: FINAL conjugate round, Γ-collapse partial, recognition crux unclosed → route EXHAUSTED
- iter-042: no prover (pivot blueprint authored: affine tilde-transport, bypasses section mate)
- Strategy estimate: FBC-A1 "Iters left 3–6"; pivot iter-042.
- Proposed this iter: FIRST prover on the new tilde-transport route (`pushforward_base_change_mate_sections_direct`).

## Route GF (file: AlgebraicJacobian/Picard/FlatteningStratification.lean)
Generic flatness geometric wrapper. Signals (sorry 1→1, untouched since alg core done iter-022):
- gated on gap1 (now unblocked iter-041). GF-G1 = direct G1-core application; needs import of QuotScheme added.
- Strategy estimate: GF-geo "Iters left 2–4".
- Proposed this iter: build `gf_qcoh_fintype_finite_sections` (G1 ingredient) via import + G1-core. Does NOT
  close the 2264 sorry (needs G3 too) — incremental axiom-clean ingredient.

## Question
For each route: verdict + (if CHURNING/STUCK) the corrective TYPE. Sanity-check the 3-lane dispatch
(under/over-dispatch?). QUOT has run ~16 iters total on this arc — is it genuinely CONVERGING or churning?
