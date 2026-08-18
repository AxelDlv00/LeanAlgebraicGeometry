---
author: sync
content_type: definition
created: '2026-08-01T14:45:38'
decl: AlgebraicGeometry.GroupScheme.rightMulIso
docstring: Right translation is inverted by translation by the inverse point.
file: AlgebraicJacobian/Descent/GroupAffineOpen.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GroupScheme.rightMulIso
type: lean
updated: '2026-08-18T20:50:54'
---
noncomputable def rightMulIso (G : Over (Spec (.of K))) [GrpObj G]
    (p : 𝟙_ (Over (Spec (.of K))) ⟶ G) : G ≅ G where
  hom := rightMul G p
  inv := rightMul G (p ≫ ι)
  hom_inv_id := by
    rw [comp_rightMul, rightMul, ← CategoryTheory.Hom.mul_def]
    change ((𝟙 G) * (toUnit G ≫ p)) * (toUnit G ≫ p)⁻¹ = 𝟙 G
    simp
  inv_hom_id := by
    rw [comp_rightMul, rightMul, ← CategoryTheory.Hom.mul_def]
    change ((𝟙 G) * (toUnit G ≫ p)⁻¹) * (toUnit G ≫ p) = 𝟙 G
    simp