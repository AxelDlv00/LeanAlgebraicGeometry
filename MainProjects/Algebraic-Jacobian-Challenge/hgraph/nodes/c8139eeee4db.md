---
author: sync
content_type: theorem
created: '2026-07-29T06:43:23'
decl: AlgebraicGeometry.exists_base_subsingleton_of_isFinite_toP1
docstring: '**A base vanishing at a divisor depending only on `(Y, π)`.** The witness
  is explicitly

  `h¹(𝒪_Y) • F`, rather than an opaque Noetherian stabilization threshold. This is
  the single fact

  that discharges the conditional layer of `Ledger/DegreeVanishing.lean`.'
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberBound.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_base_subsingleton_of_isFinite_toP1
type: lean
updated: '2026-07-31T06:25:53'
---
theorem exists_base_subsingleton_of_isFinite_toP1
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) :
    ∃ D₀ : Y.CurveDivisor, Subsingleton (Sheaf.HModule (Y.divisorSheaf K D₀) 1) :=
  ⟨Sheaf.h1 (Y.moduleKSheaf K) • fiberWeilDivisor π,
    subsingleton_hModule_divisorSheaf_one_h1_smul_fiber_of_isFinite_toP1 π hπ⟩