---
author: sync
content_type: theorem
created: '2026-07-29T06:43:23'
decl: AlgebraicGeometry.exists_base_subsingleton_of_isFinite_toP1
docstring: '**A base vanishing at a divisor depending only on `(Y, π)`.**  The fibrewise
  large-twist

  vanishing at `D = 0`, read at its own threshold: there is an `n₀`, chosen before
  any divisor is

  considered, with `H¹(𝒪(n₀ • F)) = 0`.  This is the single fact that discharges the
  conditional

  layer of `Ledger/DegreeVanishing.lean`.'
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberBound.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_base_subsingleton_of_isFinite_toP1
type: lean
updated: '2026-07-29T06:43:23'
---
theorem exists_base_subsingleton_of_isFinite_toP1
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) :
    ∃ D₀ : Y.CurveDivisor, Subsingleton (Sheaf.HModule (Y.divisorSheaf K D₀) 1) := by
  obtain ⟨n₀, hn₀⟩ :=
    subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1 π hπ (0 : Y.CurveDivisor)
  refine ⟨n₀ • fiberWeilDivisor π, ?_⟩
  have h := hn₀ n₀ le_rfl
  rwa [zero_add] at h