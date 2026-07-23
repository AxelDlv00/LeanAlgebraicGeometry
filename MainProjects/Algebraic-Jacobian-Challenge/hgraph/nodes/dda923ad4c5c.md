---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechEngineD_comp_augFam
docstring: 'The degree-`0` engine differential composed with the augmentation vanishes:
  the alternating

  face sum `δ₀ − δ₁` is killed because both faces become the identity after augmenting.  The

  cochain-map condition for the engine augmentation `cechEngineComplexAugFam`.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechEngineD_comp_augFam
type: lean
updated: '2026-07-16T21:14:26'
---
lemma cechEngineD_comp_augFam (V : TopologicalSpace.Opens ↥X) :
    cechEngineDFam U V 0 ≫ cechEngineAug0Fam U V = 0 := by
  apply Limits.Sigma.hom_ext
  intro σ
  rw [Limits.comp_zero, ← Category.assoc, cechEngineD_ιFam, Preadditive.sum_comp, Fin.sum_univ_two]
  simp only [Preadditive.zsmul_comp]
  erw [cechEngineAug0_ιFam, cechEngineAug0_ιFam]
  simp only [Fin.val_zero, Fin.val_one, pow_zero, pow_one, one_zsmul, neg_one_zsmul]
  abel