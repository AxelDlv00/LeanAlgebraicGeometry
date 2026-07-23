---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechEngineComplexAugFam
docstring: '**The augmentation chain map** `cechEngineComplexFam U V ⟶ O_X(V)[0]`,
  whose degree-`0` component

  is the codiagonal `cechEngineAug0Fam`.  The chain-map condition is `cechEngineD_comp_augFam`.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechEngineComplexAugFam
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def cechEngineComplexAugFam (V : TopologicalSpace.Opens ↥X) :
    cechEngineComplexFam U V ⟶ (ChainComplex.single₀ _).obj (coverSectionModule V) :=
  ((cechEngineComplexFam U V).toSingle₀Equiv (coverSectionModule V)).symm
    ⟨cechEngineAug0Fam U V, by
      rw [show (cechEngineComplexFam U V).d 1 0 = cechEngineDFam U V 0 from ChainComplex.of_d (cechEngineXFam U V) (cechEngineDFam U V) 0]
      exact cechEngineD_comp_augFam U V⟩