---
author: sync
content_type: theorem
created: '2026-07-29T06:43:23'
decl: AlgebraicGeometry.exists_bound_subsingleton_hModule_one_of_isFinite_toP1
docstring: '**Bounded `H¹` vanishing, no vanishing hypothesis** (cluster-P item 1,
  unconditional form):

  for a curve bundle carrying a finite dominant `π : Y ⟶ ℙ¹`, there is a degree threshold
  `b`

  depending only on `(Y, π)` past which `H¹(𝒪(D))` vanishes for **every** Weil divisor
  `D`.


  Read the module docstring on scope before consuming this: the threshold is over
  the single field

  `K` and says nothing about uniformity across field extensions.'
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberBound.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_bound_subsingleton_hModule_one_of_isFinite_toP1
type: lean
updated: '2026-07-29T06:43:23'
---
theorem exists_bound_subsingleton_hModule_one_of_isFinite_toP1
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) :
    ∃ b : ℤ, ∀ D : Y.CurveDivisor, b ≤ CurveDivisor.deg K D →
      Subsingleton (Sheaf.HModule (Y.divisorSheaf K D) 1) := by
  haveI : Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1) :=
    moduleFinite_hModule_one_of_isFinite_toP1 π hπ
  obtain ⟨D₀, hD₀⟩ := exists_base_subsingleton_of_isFinite_toP1 π hπ
  exact exists_bound_subsingleton_hModule_one K hD₀