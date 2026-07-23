---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.tensorHom_comp3
docstring: '**Generic 3-fold tensor/composition interchange.** In any monoidal category,
  the tensor of two

  3-step composites distributes as the 3-step composite of tensors.  Stated explicitly
  (with the

  three-fold `≫` shape) so a single `rw` matches the per-leg `(η ≫ pbv ≫ ρ⁻¹) ⊗ₘ (…)`
  form that the

  bare `tensorHom_comp_tensorHom` rewrite fails to key on under a sheafification `Functor.map`.'
file: AlgebraicJacobian/Picard/TensorObjInverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.tensorHom_comp3
type: lean
updated: '2026-07-24T03:02:12'
---
lemma tensorHom_comp3 {C : Type*} [Category C] [MonoidalCategory C]
    {a₀ a₁ a₂ a₃ b₀ b₁ b₂ b₃ : C} (a : a₀ ⟶ a₁) (b : a₁ ⟶ a₂) (c : a₂ ⟶ a₃)
    (d : b₀ ⟶ b₁) (e : b₁ ⟶ b₂) (g : b₂ ⟶ b₃) :
    MonoidalCategory.tensorHom (a ≫ b ≫ c) (d ≫ e ≫ g)
      = MonoidalCategory.tensorHom a d ≫ MonoidalCategory.tensorHom b e
        ≫ MonoidalCategory.tensorHom c g := by
  rw [MonoidalCategory.tensorHom_comp_tensorHom, MonoidalCategory.tensorHom_comp_tensorHom]