---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechEngineComplexAug
docstring: '**The augmentation chain map** `cechEngineComplex 𝒰 V ⟶ O_X(V)[0]`, whose
  degree-`0` component

  is the codiagonal `cechEngineAug0`.  The chain-map condition is `cechEngineD_comp_aug`.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechEngineComplexAug
type: lean
updated: '2026-07-24T03:02:09'
---
noncomputable def cechEngineComplexAug (𝒰 : X.OpenCover) (V : TopologicalSpace.Opens ↥X) :
    cechEngineComplex 𝒰 V ⟶ (ChainComplex.single₀ _).obj (coverSectionModule V) :=
  ((cechEngineComplex 𝒰 V).toSingle₀Equiv (coverSectionModule V)).symm
    ⟨cechEngineAug0 𝒰 V, by
      rw [show (cechEngineComplex 𝒰 V).d 1 0 = cechEngineD 𝒰 V 0 from
        ChainComplex.of_d (cechEngineX 𝒰 V) (cechEngineD 𝒰 V) 0]
      exact cechEngineD_comp_aug 𝒰 V⟩

/-! ## Project-local Mathlib supplement — degree-`0` splitting and engine quasi-isomorphism -/