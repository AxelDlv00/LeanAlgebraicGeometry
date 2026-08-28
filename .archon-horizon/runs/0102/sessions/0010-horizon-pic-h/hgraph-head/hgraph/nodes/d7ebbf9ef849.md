---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: CategoryTheory.PresheafOfGroups.H1.resHom
docstring: 'Restriction of `H1` classes along an indexwise refinement, as a group
  homomorphism

  (for presheaves of commutative groups).'
file: AlgebraicJacobian/Picard/CechH1.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.PresheafOfGroups.H1.resHom
type: lean
updated: '2026-08-01T09:44:10'
---
def H1.resHom (f : ∀ i, V i ⟶ U i) :
    H1 (G ⋙ forget₂ CommGrpCat GrpCat) U →* H1 (G ⋙ forget₂ CommGrpCat GrpCat) V where
  toFun := H1.res f
  map_one' := rfl
  map_mul' x y := by
    obtain ⟨γ₁⟩ := x; obtain ⟨γ₂⟩ := y
    exact congrArg (Quot.mk _) (γ₁.mul_res γ₂ f)

@[simp]