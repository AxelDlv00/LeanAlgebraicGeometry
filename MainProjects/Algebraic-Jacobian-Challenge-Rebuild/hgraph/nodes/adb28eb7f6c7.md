---
author: sync
content_type: theorem
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.AffAdaptation.projective_colength_of_forall_tmul_residueField
docstring: '**Clause (c1) for the piece `j`**: fibrewise-regular equation + finite
  colength ⟹

  finite projective.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffPerPiece.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.projective_colength_of_forall_tmul_residueField
type: lean
updated: '2026-07-30T15:28:02'
---
theorem projective_colength_of_forall_tmul_residueField (j : D.index)
    (hfib : ∀ p : PrimeSpectrum R,
      (A.eqn j ⊗ₜ[R] (1 : p.asIdeal.ResidueField) :
          Γ(relCurve C R, D.pieces j) ⊗[R] p.asIdeal.ResidueField) ∈
        nonZeroDivisors
          (Γ(relCurve C R, D.pieces j) ⊗[R] p.asIdeal.ResidueField))
    [Module.Finite R (A.colength j)] :
    Module.Projective R (A.colength j) := by
  haveI : Module.Flat R Γ(relCurve C R, D.pieces j) := D.flat_sections_pieces j
  exact Module.Projective.quotient_span_singleton_of_forall_tmul_residueField hfib