---
author: sync
content_type: theorem
created: '2026-07-30T04:44:47'
decl: AlgebraicGeometry.h0_eq_one_of_subsingleton_of_deg
docstring: '**The rank anchor at a witness of the pinned degree.**'
file: AlgebraicJacobian/Picard/Pic0ChartLocusH0One.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.h0_eq_one_of_subsingleton_of_deg
type: lean
updated: '2026-07-30T04:44:47'
---
theorem h0_eq_one_of_subsingleton_of_deg
    {L : Type u} [Field L] [Algebra k L]
    [IsIntegral (relCurve C L)]
    [SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L))]
    [QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L))]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0)]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1)]
    (n : ℕ) (hχ : Sheaf.chi (((C ⊗ overSpec k L).left).moduleKSheaf L) = 1 - (n : ℤ))
    (W : ((C ⊗ overSpec k L).left).CurveDivisor)
    (hW : Scheme.CurveDivisor.deg L W = (n : ℤ))
    (h1 : Subsingleton (Sheaf.HModule ((C ⊗ overSpec k L).left.divisorSheaf L W) 1)) :
    Sheaf.h0 ((C ⊗ overSpec k L).left.divisorSheaf L W) = 1 := by
  have hanchor := h0_eq_deg_add_chi_of_subsingleton_hModule_one (K := L) W h1
  rw [hW, hχ] at hanchor
  omega