---
author: sync
content_type: theorem
created: '2026-07-29T04:25:58'
decl: CategoryTheory.MonObj.permAut_comp
file: AlgebraicJacobian/Albanese/GrpObjFoldSum.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.MonObj.permAut_comp
type: lean
updated: '2026-07-29T04:25:58'
---
theorem permAut_comp (C : K) {n : ℕ} (σ τ : Equiv.Perm (Fin n)) :
    permAut C σ ≫ permAut C τ = permAut C (σ * τ) := by
  apply Pi.hom_ext; intro i
  rw [Category.assoc, permAut_π, permAut_π, permAut_π]
  rfl

omit [CartesianMonoidalCategory K] in
@[simp]