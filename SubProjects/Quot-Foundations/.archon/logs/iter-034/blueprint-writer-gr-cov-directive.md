# Directive — blueprint-writer `gr-cov` (iter-034)

## Chapter to edit
`blueprint/src/chapters/Picard_GrassmannianCells.tex` ONLY.

## Task
Add **six coverage blocks** for prover-created helper declarations that currently have NO blueprint entry
(isolated `lean_aux` nodes). They form the ring-theoretic heart of `lem:gr_separated` (the surjective
restricted-diagonal comorphism) plus the source pullback iso. Insert all six **immediately after** the
`\label{sec:gr_separated}` line (line ~1712) and **before** `\begin{lemma}` of `lem:gr_separated`
(~1714), so they precede the keystone that consumes them. Then append `lem:gr_diagonalRingMap_surjective`
to the `\uses{}` of BOTH the `lem:gr_separated` statement block and its proof block (keep existing
`def:gr_glued_scheme, def:gr_transition`).

Most carry NO external source (project-bespoke ring algebra) → omit `% SOURCE` lines. Each needs
`\label{}`, `\lean{}`, accurate `\uses{}`, and a short informal proof.

### Block 1 — `lem:gr_transitionPreMap_minorDet_swap_mul`
- `\lean{AlgebraicGeometry.Grassmannian.transitionPreMap_minorDet_swap_mul}`
- `\uses{lem:gr_universalMatrix_map_transitionPreMap, lem:gr_transition_pre_unit, lem:gr_transitionPreMap_minorDet}`
- Statement: in `R^I_J = ℤ[X^I, 1/P^I_J]`, the explicit two-sided inverse identity
  `θ̃_{I,J}(P^J_I) · P^I_J = 1` (refining `isUnit_transitionPreMap_minorDet` to a named two-sided
  inverse), where `θ̃_{I,J} = transitionPreMap` is the pre-localisation transition hom.
- Proof: `θ̃_{I,J}(P^J_I)` is the determinant of the `I`-minor of `(X^I_J)^{-1}X^I` (via
  `universalMatrix_map_transitionPreMap`, `imageMatrix_submatrix_I`), and that determinant times `P^I_J`
  is `1` by `universalMinorInv_mul_cancel` (`RingHom.map_det` of the localisation-inverse cancellation).

### Block 2 — `def:gr_diagonalRingMap`
- `\lean{AlgebraicGeometry.Grassmannian.diagonalRingMap}`
- `\uses{def:gr_transition_pre}`
- Statement: the restricted-diagonal comorphism on the patch `U^I × U^J`,
  `δ_{I,J} : ℤ[X^I] ⊗_ℤ ℤ[X^J] → R^I_J`, `X^I⊗1 ↦ X^I`, `1⊗X^J ↦ (X^I_J)^{-1}X^I` — the ring map whose
  surjectivity is the content of separatedness (this is the `δ_{I,J}` of `lem:gr_separated`).
- Proof/construction: `Algebra.TensorProduct.lift` of the structure map `R^I → R^I_J` (left factor) and
  the pre-localisation transition hom `θ̃_{I,J} = transitionPreMap` (right factor), the two factors
  commuting; so the right component is `θ̃_{I,J}` by construction.

### Block 3 — `lem:gr_diagonalRingMap_left`
- `\lean{AlgebraicGeometry.Grassmannian.diagonalRingMap_left}`
- `\uses{def:gr_diagonalRingMap}`
- Statement: `δ_{I,J}(a ⊗ 1) = algebraMap_{R^I → R^I_J}(a)`. Proof: `Algebra.TensorProduct.lift_tmul`.

### Block 4 — `lem:gr_diagonalRingMap_right`
- `\lean{AlgebraicGeometry.Grassmannian.diagonalRingMap_right}`
- `\uses{def:gr_diagonalRingMap}`
- Statement: `δ_{I,J}(1 ⊗ b) = θ̃_{I,J}(b)` (the transition pre-map). Proof: `Algebra.TensorProduct.lift_tmul`.

### Block 5 — `lem:gr_diagonalRingMap_surjective`
- `\lean{AlgebraicGeometry.Grassmannian.diagonalRingMap_surjective}`
- `\uses{lem:gr_diagonalRingMap_left, lem:gr_diagonalRingMap_right, lem:gr_transitionPreMap_minorDet_swap_mul}`
- Statement: `δ_{I,J}` is surjective.
- Proof: given `z ∈ R^I_J`, `IsLocalization.surj` gives `z·(P^I_J)^n = algebraMap(a)` for some `a, n`.
  The witness `a ⊗ (P^J_I)^n` maps under `δ_{I,J}` to `algebraMap(a) · θ̃_{I,J}(P^J_I)^n
  = z·(P^I_J)^n · θ̃_{I,J}(P^J_I)^n = z·(P^I_J · θ̃_{I,J}(P^J_I))^n = z` by
  `lem:gr_transitionPreMap_minorDet_swap_mul` (the product is `1`). Hence `z` is in the image.

### Block 6 — `def:gr_pullbackιIso`
- `\lean{AlgebraicGeometry.Grassmannian.pullbackιIso}`
- `\uses{def:gr_glued_scheme}`
- Statement: the source pullback iso `e₂` for the diagonal computation —
  `pullback (ι i) (ι j) ≅ chartOverlap d r i j`, identifying the fibre product of two chart inclusions of
  the glued scheme with the overlap chart `U^I ∩ U^J`.
- Proof: the glue data's `vPullbackCone` is a limit cone (`vPullbackConeIsLimit`); compare it to the
  categorical pullback limit via `(limit.isLimit _).conePointUniqueUpToIso`.

## Out of scope
Do NOT touch the `lem:gr_separated` statement/proof prose (complete, gate-cleared); only append
`lem:gr_diagonalRingMap_surjective` to its two `\uses{}` sets. Do NOT add `\leanok`. Do NOT give the
three `private` helpers (`rotMid`, `transitionInvImageMatrix`, `transitionInvPair`) blocks — they are
implementation details whose public-namespace `\lean{}` pins would not resolve. Do NOT edit other chapters.

## References
Project-bespoke ring algebra; no new source needed. `references/**` authorized only as a safety valve.
