---
author: sync
content_type: theorem
created: '2026-07-31T19:20:46'
decl: AlgebraicGeometry.AffAdaptation.IsCertified.intrinsicThetaEvalRel_surjective
docstring: 'The widened certificate''s global theta-cokernel surjectivity is enough
  to make the

  intrinsic, chart-free theta evaluation surjective.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaCokernelGlobal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.IsCertified.intrinsicThetaEvalRel_surjective
type: lean
updated: '2026-07-31T19:20:46'
---
theorem IsCertified.intrinsicThetaEvalRel_surjective
    {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}
    {A : AffAdaptation D d} {g : ℕ} (hc : A.IsCertified g)
    (hπ : π ≫ P1.structureMap k = C.hom)
    (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    {a : ℕ} (ha1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1)
    (hMa : windowM_choice π hπ g ≤ a) :
    Function.Surjective (A.intrinsicThetaEvalRel (π := π) a) := by
  obtain ⟨B, hB⟩ := hc.exists_chartAdaptation_thetaIdealCokernel_app_top_surjective
    C R π hπ hO hχ ha1 hMa
  exact intrinsicThetaEvalRel_surjective_of_thetaIdealCokernel_app_top_surjective
    C R π B a hB