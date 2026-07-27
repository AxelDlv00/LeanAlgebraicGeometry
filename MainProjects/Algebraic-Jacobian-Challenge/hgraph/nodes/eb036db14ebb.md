---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.HModule_zero_linearEquiv
docstring: 'The `k`-linear identification of `HModule k F 0` with the group of morphisms
  from the constant

  sheaf at `ModuleCat.of k k` to `F`. It is `CategoryTheory.Abelian.Ext.linearEquiv₀`

  (`Ext X Y 0 ≃ₗ[R] (X ⟶ Y)` in any `Linear R`-enriched abelian category) specialised
  to the

  `Linear k` enrichment of `Sheaf J (ModuleCat.{u} k)`, which is inferred from

  `HasSheafify J (ModuleCat.{u} k)`. On a connected proper `k`-curve this identifies

  `H⁰(C, toModuleKSheaf C)` with `Γ(C, O_C)` viewed as a `k`-module.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.HModule_zero_linearEquiv
type: lean
updated: '2026-07-27T01:33:11'
---
noncomputable def HModule_zero_linearEquiv
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasSheafify J (ModuleCat.{u} k)] [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) :
    HModule k F 0 ≃ₗ[k]
      ((constantSheaf J (ModuleCat.{u} k)).obj (ModuleCat.of k k) ⟶ F) :=
  Abelian.Ext.linearEquiv₀