# Lean ↔ Blueprint Checker Directive

## Slug
cotangent-grpobj-review130

## Scope (one file pair)

- **Lean file**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean`
- **Blueprint chapter**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex`,
  specifically § "Piece (i): sub-lemma decomposition for iter-128+ build"
  and the surrounding lemma blocks `lem:GrpObj_cotangentSpace`,
  `lem:GrpObj_cotangent_bridge`, `lem:GrpObj_lieAlgebra_finrank`.

The Lean file has a single declaration `AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`
whose body was **swapped** this iter from the iter-128 evaluate-then-extend-scalars
form (which iter-129 mathlib-analogist proved computes the zero module)
to a Replacement (B) chart-base-change form (extract a chart `V` via
`smooth_locally_free_omega`, base-change the algebraic Kähler module
along `ψ_V : Γ(G, V) → k`).

## Audit task (bidirectional)

### (A) Lean → Blueprint

For `lem:GrpObj_cotangentSpace` (the (i.a) primary block):

- Is the `\lean{...}` hint pointing at the correct name (`AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity`)?
- Does the Lean signature (`{n : ℕ} [SmoothOfRelativeDimension n G.hom] [IsProper G.hom] [GeometricallyIrreducible G.hom]`) match the prose in the chapter?
- Does the Lean body actually execute the proof sketch the chapter
  describes? The iter-130 parallel writer was supposed to re-align Piece (i)
  prose to Replacement (B) chart-base-change; check that the lemma's
  `\begin{proof}` block describes that construction (not the iter-128
  evaluate-at-`⊤` body, and not the stalk-side Replacement (A)).
- The Lean body uses `Classical.choice (α := ModuleCat k)` on a
  `Nonempty (ModuleCat k)` wrapper to destructure the Prop-level
  existential of `smooth_locally_free_omega`. Does the blueprint prose
  acknowledge this opacity, or does it describe a non-opaque
  construction the Lean does not realise?

For `lem:GrpObj_cotangent_bridge` (deferred bridge):

- Is this lemma marked `\notready` in the blueprint?
- Does the prose hedge the LHS framing correctly (iter-130 chart-base-changed body, not iter-128 evaluate-then-extend)?

For `lem:GrpObj_lieAlgebra_finrank` (deferred rank lemma):

- Is the proof sketch's closure path consistent with the iter-130 body
  shape? The prover did NOT attempt the rank lemma this iter due to
  the `Classical.choice` opacity concern; flag whether the blueprint's
  proof sketch is realistic against the iter-130 body.

### (B) Blueprint → Lean

- Is the chapter's `\begin{proof}` for `lem:GrpObj_cotangentSpace`
  detailed enough that a prover could re-derive the iter-130 body from
  it (without recourse to `analogies/lieAlgebra-rank-bridge.md`)?
- Does the chapter explicitly name the four iter-130 verified Mathlib
  closure-chain names (`smooth_locally_free_omega`,
  `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`,
  `Module.finrank_baseChange`, `Algebra.TensorProduct.instFree`)?
- Are there any cross-references (`\uses{...}`) that point at
  declarations not yet built in Lean (e.g. `cotangentSpaceAtIdentity_iso_localRingCotangent`)?
  Is the gap acknowledged as `\notready`?

## Severity calibration

- `critical / must-fix-this-iter`: blueprint claims something the Lean body refutes (e.g. blueprint says body is rank-`n` free; Lean body actually returns `0`); or `\lean{...}` hint points to a non-existent declaration.
- `major`: blueprint proof sketch describes route (A) or iter-128 evaluate-at-`⊤` but Lean body implements route (B); blueprint missing must-have closure-chain reference; opacity caveat absent from prose.
- `minor`: stylistic prose drift; line refs stale.

## Output

Write to standard `task_results/lean-vs-blueprint-checker-cotangent-grpobj-review130.md`. Same checklist format as prior iters.
