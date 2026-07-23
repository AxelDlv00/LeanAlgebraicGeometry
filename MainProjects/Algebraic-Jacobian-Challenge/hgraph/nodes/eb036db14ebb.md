---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.HModule_zero_linearEquiv
docstring: 'Phase A step 6 algebraic bridge (iter-010 scaffold): the $k$-linear

  identification of `HModule k F 0` with the Hom group from the constant

  sheaf at `ModuleCat.of k k`. Mathlib provides

  `CategoryTheory.Abelian.Ext.linearEquiv₀ : Ext X Y 0 ≃ₗ[R] (X ⟶ Y)` in any

  `Linear R`-enriched abelian category; specialised to the `Linear k`

  enrichment of `Sheaf J (ModuleCat.{u} k)` (auto-inferable from

  `HasSheafify J (ModuleCat.{u} k)`), this collapses `HModule k F 0` to a

  `k`-linear Hom group. The closure body is `Abelian.Ext.linearEquiv₀`;

  probe-confirmed one-liner (iter-010 plan-agent). Used downstream to

  identify `H⁰(C, toModuleKSheaf C)` with `Γ(C, O_C)` viewed as a

  `k`-module on a connected proper `k`-curve.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.HModule_zero_linearEquiv
type: lean
updated: '2026-07-24T03:02:10'
---
noncomputable def HModule_zero_linearEquiv
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasSheafify J (ModuleCat.{u} k)] [HasExt (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) :
    HModule k F 0 ≃ₗ[k]
      ((constantSheaf J (ModuleCat.{u} k)).obj (ModuleCat.of k k) ⟶ F) :=
  Abelian.Ext.linearEquiv₀

/-- Phase A step 6 *Path 2* (iter-013 scaffold): the `ModuleCat k`-flavored
cohomology of an open `X : C` with values in a sheaf `F : Sheaf J (ModuleCat.{u} k)`.
Mirrors Mathlib's `Sheaf.H' F n X = (F.cohomologyPresheaf n).obj (op X)`
(`Mathlib/CategoryTheory/Sites/SheafCohomology/Basic.lean` L105) for
`AddCommGrpCat`-valued sheaves, with `AddCommGrpCat.free → ModuleCat.free k`.

The codomain is `Type u` (not `ModuleCat.{u} k`): `Abelian.Ext` returns a bare
`Type u` carrying `Module k` via `Abelian.Ext.instModule` through the `Linear k`
enrichment. The `noncomputable abbrev` form (rather than `def`) is required so