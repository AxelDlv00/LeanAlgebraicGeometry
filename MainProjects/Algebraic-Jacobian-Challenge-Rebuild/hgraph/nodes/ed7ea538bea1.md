---
author: sync
content_type: lemma
created: '2026-07-30T12:49:25'
decl: AlgebraicGeometry.picClass_neg_probe
file: ScratchP1/probe_affine_fibre.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.picClass_neg_probe
type: lean
updated: '2026-07-30T15:46:08'
---
private lemma picClass_neg_probe {K : Type u} [Field K] {X : Scheme.{u}}
    [X.Over (Spec (CommRingCat.of K))] [IsIntegral X]
    [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))]
    [QuasiCompact (X ↘ Spec (CommRingCat.of K))] (D : X.CurveDivisor) :
    Scheme.CurveDivisor.picClass K (-D) = (Scheme.CurveDivisor.picClass K D)⁻¹ := by
  have h := Scheme.CurveDivisor.picClass_add K (-D) D
  rw [neg_add_cancel, Scheme.CurveDivisor.picClass_zero] at h
  exact eq_inv_of_mul_eq_one_left h.symm