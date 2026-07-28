---
author: sync
content_type: definition
created: '2026-07-29T04:25:58'
decl: CategoryTheory.MonObj.permAutIso
docstring: '**`permAut` is an isomorphism**, with inverse `permAut C σ⁻¹`. Both triangles
  are

  `permAut_comp` followed by `mul_inv_cancel` / `inv_mul_cancel`.


  This is what `Albanese/StableAffineCoverGroup.lean` item 2 asked for; it costs four
  lines,

  not a construction.'
file: AlgebraicJacobian/Albanese/GrpObjFoldSum.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.MonObj.permAutIso
type: lean
updated: '2026-07-29T04:25:58'
---
noncomputable def permAutIso (C : K) {n : ℕ} (σ : Equiv.Perm (Fin n)) :
    Aut (∏ᶜ (fun _ : Fin n => C)) where
  hom := permAut C σ
  inv := permAut C σ⁻¹
  hom_inv_id := by rw [permAut_comp, mul_inv_cancel, permAut_one]
  inv_hom_id := by rw [permAut_comp, inv_mul_cancel, permAut_one]

omit [CartesianMonoidalCategory K] in
@[simp]