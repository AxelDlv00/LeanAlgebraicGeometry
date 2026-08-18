---
author: sync
content_type: theorem
created: '2026-08-17T13:21:30'
decl: AlgebraicGeometry.pic0FiniteStageTripleTensorEquiv_tmul_one
file: AlgebraicJacobian/Picard/Pic0FiniteStageTripleOverlapRings.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageTripleTensorEquiv_tmul_one
type: lean
updated: '2026-08-18T20:51:05'
---
theorem pic0FiniteStageTripleTensorEquiv_tmul_one
    (U V W : Pic0FiniteStageChartIndex C)
    (x : Pic0FiniteStageOverlapRing C U V) :
    pic0FiniteStageTripleTensorEquiv C U V W (x ⊗ₜ 1) =
      pic0FiniteStageOverlapToTripleLeft C U V W x := by
  exact congr($((CommRingCat.isPushout_tensorProduct (Pic0FiniteStageChartRing C U)
    (Pic0FiniteStageOverlapRing C U V)
    (Pic0FiniteStageOverlapRing C U W)).inl_isoIsPushout_hom _ _
      (isPushout_pic0FiniteStageTripleRing C U V W)).hom x)

@[simp]