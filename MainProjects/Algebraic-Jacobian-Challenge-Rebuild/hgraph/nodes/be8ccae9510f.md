---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.PointwiseAchiever.rankAtStalk_colength_univSeed_of_swallowedBy
docstring: '**The exact widened rank producer for the high-window universal seed.**  On
  every widened

  cover and every adaptation of the universal seed equations, the colength of a piece
  swallowing

  the support has stalk rank `g`.


  Finiteness comes from the swallowed shape, projectivity from the seed''s fibre regularity,
  and

  the rank is computed after base change to `κ(p)`: the pulled swallowed cover collapses
  its glued

  module to the distinguished colength, while the certificate-free universal residue
  divisor has

  degree `g`.'
file: AlgebraicJacobian/Picard/DivRepChartClassUnivAffRank.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.rankAtStalk_colength_univSeed_of_swallowedBy
type: lean
updated: '2026-08-02T07:12:49'
---
theorem rankAtStalk_colength_univSeed_of_swallowedBy (hb : 0 < windowBound pi hpi)
    (Dc : AffCoverData C RZ)
    (A : AffAdaptation Dc
      ((univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).localEquations
        (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb)))
    (j0 : Dc.index)
    (hsub :
      ((univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).localEquations
        (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb)).supportLocus
          ⊆ (Dc.pieces j0 : Set (relCurve C RZ)))
    (hmiss : ∀ l : Dc.index, l ≠ j0 →
      Disjoint
        ((univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb).localEquations
          (isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb)).supportLocus
        (Dc.pieces l : Set (relCurve C RZ)))
    (p : PrimeSpectrum RZ) :
    Module.rankAtStalk (R := RZ) (A.colength j0) p = g := by
  classical
  let D := univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb
  let hD := isGenerator_univSeed C hpi g r1 r2 b1 b2 i j hO hchi hb
  let d := D.localEquations hD
  have hsw : Dc.SwallowedBy d := ⟨j0, hsub, hmiss⟩
  have hfin : ∀ l, Module.Finite RZ (A.colength l) :=
    A.forall_finite_colength_of_swallowedBy hsw
  have hproj : ∀ l, Module.Projective RZ (A.colength l) := fun l => by
    haveI := hfin l
    exact A.projective_colength_of_forall_tmul_residueField l
      (fun q => D.affAdaptation_fibre_regular hD Dc A l q)
  have hpull := D.aff_pulledEquations_eq_residueFibreLocalEquations hD A hproj p
  have hdeg : CurveDivisor.deg p.asIdeal.ResidueField
      (Scheme.presentationDivisor p.asIdeal.ResidueField
        ((A.pulledEquations p.asIdeal.ResidueField hproj).presentation)) = (g : ℤ) := by
    rw [hpull]
    exact deg_presentationDivisor_residueFibreLocalEquations_univSeed
      C hpi g r1 r2 b1 b2 i j hO hchi hb p
  exact A.rankAtStalk_colength_eq_of_swallowedBy_of_pulled_degree
    j0 hsub hmiss hfin hproj p hdeg