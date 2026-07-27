---
author: sync
content_type: theorem
created: '2026-07-27T15:50:35'
decl: AlgebraicGeometry.Adelic.exists_ne_zero_mem_of_one_le_chi
docstring: '**A class of positive `χ` has a nonzero global section.**  From `χ ≤ ℓ`

  (`chi_le_ell`, i.e. `h¹ ≥ 0`): if `1 ≤ χ(D)` then `1 ≤ ℓ(D)`, so

  `Γ(⊤, 𝒪(D)) ≠ 0`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/BoundedVanishing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.exists_ne_zero_mem_of_one_le_chi
type: lean
updated: '2026-07-27T15:50:35'
---
theorem exists_ne_zero_mem_of_one_le_chi {D : X.WeilDivisor}
    (hchi : 1 ≤ chi k U₀ U₁ D) :
    ∃ f : X.functionField, f ∈ sectionSub k ⊤ D ∧ f ≠ 0 := by
  have hell : 1 ≤ (ell k D : ℤ) := le_trans hchi (chi_le_ell k U₀ U₁ D)
  by_contra hno
  have hbot : sectionSub k ⊤ D = ⊥ := by
    apply le_antisymm _ bot_le
    intro x hx
    rcases eq_or_ne x 0 with rfl | hx0
    · exact Submodule.zero_mem _
    · exact absurd ⟨x, hx, hx0⟩ hno
  rw [ell, hbot] at hell
  simp at hell