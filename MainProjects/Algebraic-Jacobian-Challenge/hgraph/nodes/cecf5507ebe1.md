---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.HModule'_eq_HModule_linearEquiv
docstring: 'Iter-034 universe-bump bridge. Composes iter-033''s

  `HModule''_top_linearEquiv` (universe-`u` cover-totality between `HModule'' k F
  n T`

  and `Ext.{u} ((constantSheaf J _).obj (ModuleCat.of k k)) F n`) with the

  universe shift `Abelian.Ext.chgUnivLinearEquiv` (Mathlib gap-fill at the top

  of this file) lifting the result to `Ext.{u+1} ((constantSheaf J _).obj

  (ModuleCat.of k k)) F n = HModule k F n` (definitional unfold of the iter-009

  abbrev). The composition gives the full bridge `HModule'' k F n T ≃ₗ[k]

  HModule k F n` for terminal `T`, closing Step 3 of the Serre-finiteness

  scaffold. Iter-035+ specialises this to `AffineCoverMVSquare` using

  iter-029''s `toMayerVietorisSquare_toSquare_X₄ : ... = ⊤` simp lemma.'
file: AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.HModule'_eq_HModule_linearEquiv
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def HModule'_eq_HModule_linearEquiv
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    [HasExt.{u} (Sheaf J (ModuleCat.{u} k))]
    [HasExt.{u + 1} (Sheaf J (ModuleCat.{u} k))]
    (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) {T : C} (hT : IsTerminal T) :
    HModule' k F n T ≃ₗ[k] HModule k F n :=
  (HModule'_top_linearEquiv k F n hT).trans Abelian.Ext.chgUnivLinearEquiv