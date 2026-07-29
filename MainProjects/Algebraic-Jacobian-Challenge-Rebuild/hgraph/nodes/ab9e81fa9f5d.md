---
author: sync
content_type: theorem
created: '2026-07-28T19:44:56'
decl: AlgebraicGeometry.ThetaGeneratorSeed.affAdaptation_fibre_regular
docstring: '**Obligation I-0492 4(i), DISCHARGED at arbitrary affine-open pieces.**  For
  a

  theta-generator seed, every widened adaptation over every widened cover satisfies
  the

  fibrewise-regularity hypothesis of the widened assembler — uniformly in the cover
  `Dc`, the

  piece `j` and the prime `p`.


  Nothing about the cover is used but that its pieces are affine opens (a field of

  `AffCoverData`), and nothing about the adaptation but `eqn_rel` (a field of `AffAdaptation`).

  The mathematical input is the seed''s own clause, through

  `ThetaGeneratorSeed.germ_self_pullbackEqn_mem_nonZeroDivisors`, whose statement
  mentions no

  cover at all — which is why widening the pieces costs nothing here.


  Compare `ThetaGeneratorSeed.divisorAdaptation_fibre_regular`, the chart-typed twin:
  that one is

  stated for the ONE extracted adaptation `D.divisorAdaptation hD`, because chart-typed
  pieces

  come from the extraction.  This one holds for every widened adaptation there is.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffFibre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.affAdaptation_fibre_regular
type: lean
updated: '2026-07-29T15:31:43'
---
theorem affAdaptation_fibre_regular (hD : D.IsGenerator) (Dc : AffCoverData C R)
    (A : AffAdaptation Dc (D.localEquations hD)) (j : Dc.index) (p : PrimeSpectrum R) :
    (A.eqn j ⊗ₜ[R] (1 : p.asIdeal.ResidueField) :
        Γ(relCurve C R, Dc.pieces j) ⊗[R] p.asIdeal.ResidueField) ∈
      nonZeroDivisors (Γ(relCurve C R, Dc.pieces j) ⊗[R] p.asIdeal.ResidueField) :=
  A.eqn_tmul_one_mem_nonZeroDivisors_of_self_pullbackEqn j p
    (fun z => D.germ_self_pullbackEqn_mem_nonZeroDivisors hD p z)