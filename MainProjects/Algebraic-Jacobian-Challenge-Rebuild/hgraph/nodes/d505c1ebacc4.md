---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: CategoryTheory.GrothendieckTopology.MayerVietorisSquare.exists_moduleDelta_eq
docstring: 'Exactness at `H¹''(X₄)`: a degree-one class of `X₄` restricting to zero
  on both

  pieces is a connecting class.'
file: AlgebraicJacobian/Cohomology/MayerVietoris.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.GrothendieckTopology.MayerVietorisSquare.exists_moduleDelta_eq
type: lean
updated: '2026-07-29T15:31:35'
---
theorem exists_moduleDelta_eq (y : Sheaf.HModule' F S.X₄ 1)
    (h₂ : Sheaf.HModule'.res S.f₂₄ F 1 y = 0)
    (h₃ : Sheaf.HModule'.res S.f₃₄ F 1 y = 0) :
    ∃ s : F.obj.obj (op S.X₁), S.moduleDelta F s = y := by
  have hg : (Abelian.Ext.mk₀ (S.moduleShortComplex R).g).comp y (zero_add 1) = 0 := by
    apply Abelian.Ext.biprodAddEquiv.injective
    rw [map_zero]
    refine Prod.ext ?_ ?_ <;> simp only [Prod.fst_zero, Prod.snd_zero]
    · rw [Abelian.Ext.biprodAddEquiv_apply_fst, Abelian.Ext.mk₀_comp_mk₀_assoc,
        show biprod.inl ≫ (S.moduleShortComplex R).g =
          Sheaf.freeModuleSheafMap J R S.f₂₄ from biprod.inl_desc _ _]
      exact h₂
    · rw [Abelian.Ext.biprodAddEquiv_apply_snd, Abelian.Ext.mk₀_comp_mk₀_assoc,
        show biprod.inr ≫ (S.moduleShortComplex R).g =
          Sheaf.freeModuleSheafMap J R S.f₃₄ from biprod.inr_desc _ _]
      exact h₃
  obtain ⟨x₁, hx₁⟩ := Abelian.Ext.contravariant_sequence_exact₃
    (S.moduleShortComplex_shortExact R) F y hg (n₀ := 0) rfl
  refine ⟨Sheaf.HModule'.linearEquiv₀ F S.X₁ x₁, ?_⟩
  rw [moduleDelta_apply, LinearEquiv.symm_apply_apply]
  exact hx₁