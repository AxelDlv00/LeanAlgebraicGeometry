---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: CategoryTheory.Sheaf.HModule.injective_map_f_zero
docstring: '**Left end of the slice**: `H⁰(X₁) → H⁰(X₂)` is injective when `X₁ ⟶ X₂`
  is a

  monomorphism (mathlib''s `Abelian.Ext.postcomp_mk₀_injective_of_mono`).'
file: AlgebraicJacobian/RiemannRoch/ChiSlice.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Sheaf.HModule.injective_map_f_zero
type: lean
updated: '2026-07-16T21:33:28'
---
theorem injective_map_f_zero (hS : S.ShortExact) :
    Function.Injective (map S.f 0) :=
  haveI := hS.mono_f
  Abelian.Ext.postcomp_mk₀_injective_of_mono (constModuleSheaf J R) S.f