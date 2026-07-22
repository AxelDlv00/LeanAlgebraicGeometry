---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.Scheme.LocalEquations.vanishingSubmodule
docstring: '**The vanishing submodule of a local-equation system** inside the global
  sections of a

  two-cover twisted sheaf: the pairs whose chart components have all their germs in
  the

  stalk ideals of `d`.  This is the DD-4 spelling of `H⁰(𝒪(Θᴬ − d)) ⊆ H⁰(𝒪(Θᴬ))`;
  it depends

  only on the divisor of `d` (`vanishingSubmodule_eq_of_divEq`), not on any adaptation
  —

  the kernel bridge to the Θ-twisted colength evaluation is

  `AlgebraicJacobian.Picard.DivisorFamilyTheta`.'
file: AlgebraicJacobian/Picard/DivisorStalkIdeal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.LocalEquations.vanishingSubmodule
type: lean
updated: '2026-07-17T16:57:13'
---
noncomputable def Scheme.LocalEquations.vanishingSubmodule (d : X.LocalEquations) :
    Submodule k ↥(twistSubmodule k V₀ V₁ g ⊤) where
  carrier := {x | (∀ (z : X) (hz : z ∈ ⊤ ⊓ V₀),
      (X.presheaf.germ (⊤ ⊓ V₀) z hz).hom x.val.1 ∈ d.stalkIdeal z) ∧
    ∀ (z : X) (hz : z ∈ ⊤ ⊓ V₁),
      (X.presheaf.germ (⊤ ⊓ V₁) z hz).hom x.val.2 ∈ d.stalkIdeal z}
  add_mem' := by
    rintro x y ⟨hx₀, hx₁⟩ ⟨hy₀, hy₁⟩
    refine ⟨fun z hz => ?_, fun z hz => ?_⟩
    · rw [Submodule.coe_add, Prod.fst_add, map_add]
      exact Ideal.add_mem _ (hx₀ z hz) (hy₀ z hz)
    · rw [Submodule.coe_add, Prod.snd_add, map_add]
      exact Ideal.add_mem _ (hx₁ z hz) (hy₁ z hz)
  zero_mem' := by
    refine ⟨fun z hz => ?_, fun z hz => ?_⟩ <;>
      simp only [Submodule.coe_zero, Prod.fst_zero, Prod.snd_zero, map_zero] <;>
      exact Ideal.zero_mem _
  smul_mem' := by
    rintro r x ⟨hx₀, hx₁⟩
    refine ⟨fun z hz => ?_, fun z hz => ?_⟩
    · rw [Submodule.coe_smul, Prod.smul_fst, Scheme.overModule_smul_def, map_mul]
      exact Ideal.mul_mem_left _ _ (hx₀ z hz)
    · rw [Submodule.coe_smul, Prod.smul_snd, Scheme.overModule_smul_def, map_mul]
      exact Ideal.mul_mem_left _ _ (hx₁ z hz)

variable {V₀ V₁ g}