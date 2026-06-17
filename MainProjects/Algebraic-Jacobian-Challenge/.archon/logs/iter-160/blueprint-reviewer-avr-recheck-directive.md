# Blueprint-reviewer directive — scoped fast-path re-review of AbelianVarietyRigidity.tex

## Context
This is a same-iter fast-path re-review after a blueprint-writer round. A prover lane on
`AlgebraicJacobian/AbelianVarietyRigidity.lean` (target: `rigidity_eqOn_saturated_open_to_affine`)
is gated on this chapter clearing the HARD GATE THIS iter.

The iter-159 review (lean-vs-blueprint-checker) flagged ONE must-fix on this chapter: the new Lean
declaration `AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine` (bridge 2 of the
Rigidity-Lemma chain, the chain's lone residual `sorry`) had NO `\lean{}` block, creating a
marker-graph laundering vector (the `\leanok`-tagged proofs of `thm:rigidity_lemma` and
`lem:rigidity_eqOn_dense_open` rendered as fully proven despite transitively depending on a `sorry`).

A blueprint-writer (slug `avr-helper`) just made three edits to
`blueprint/src/chapters/AbelianVarietyRigidity.tex`:
1. Added a new lemma block `\label{lem:rigidity_eqOn_saturated_open_to_affine}` +
   `\lean{AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine}` + `\uses{lem:rigidity_eqOn_dense_open}`,
   with route-B proof prose (per-closed-slice constancy → dense-closed-points globalisation).
2. Added `lem:rigidity_eqOn_saturated_open_to_affine` to the `\uses` of `lem:rigidity_eqOn_dense_open`'s proof.
3. Refreshed `rmk:rigidity_lemma_decomposition`'s stale "two residual sorries" wording.

## What I need (scoped to AbelianVarietyRigidity.tex)
You read the whole blueprint as usual, but the VERDICT I need this iter is narrowly:

1. Does `AbelianVarietyRigidity.tex` now read **complete: true** AND **correct: true**, with the
   above three edits correctly applied?
2. Specifically confirm the must-fix is CLOSED: the new helper block exists with `\lean{}` +
   `\label` + `\uses` edge present; the parent `lem:rigidity_eqOn_dense_open` proof's `\uses` now
   includes the new label (de-laundering the graph); the decomposition remark no longer claims
   "two residual sorries".
3. Confirm the new block's stated hypotheses match the Lean signature of
   `rigidity_eqOn_saturated_open_to_affine` (saturated open `U = p₂⁻¹(Vset)`, `[IsAlgClosed kbar]`,
   `IsProper X.hom`, `GeometricallyIrreducible (X⊗Y).hom`, `IsReduced (X⊗Y).left`, `IsSeparated Z.hom`,
   affine `U₀`, `f(U)⊆U₀` ⟹ `f` and `retract≫f` agree on `U`), and that the route-B proof prose is
   the cohomology-free per-slice + dense-closed-points argument (NOT relative Stein, which must be
   recorded as a deliberately-avoided gap).
4. Any NEW must-fix introduced by the edits.

Report the standard per-chapter checklist (complete/correct/must-fix) for AbelianVarietyRigidity.tex,
and a one-line all-clear or flag for the rest of the blueprint.
