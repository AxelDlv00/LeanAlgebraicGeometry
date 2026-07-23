---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: CategoryTheory.Abelian.Ext.linearEquiv
docstring: 'Precomposition with `mk₀ f` corresponds to composition with `f` under
  the

  degree-zero identification `Ext X Y 0 ≃ₗ[R] (X ⟶ Y)` — the universe-polymorphic
  form

  of `Abelian.Ext.linearEquiv₀_mk₀_comp` (`Cohomology/OverOpen.lean`), applicable
  to the

  sheaf category (objects one universe above the homs).'
file: AlgebraicJacobian/Picard/DivisorFamilyWindowBaseChange.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Abelian.Ext.linearEquiv
type: lean
updated: '2026-07-23T15:01:46'
---
private lemma Abelian.Ext.linearEquiv₀_mk₀_comp' {X Y Z : D} (f : X ⟶ Y)
    (x : Abelian.Ext Y Z 0) :
    Abelian.Ext.linearEquiv₀ (R := R)
        ((Abelian.Ext.mk₀ f).comp x (zero_add 0)) =
      f ≫ Abelian.Ext.linearEquiv₀ (R := R) x := by
  apply (Abelian.Ext.mk₀_bijective X Z).injective
  rw [Abelian.Ext.mk₀_linearEquiv₀_apply, ← Abelian.Ext.mk₀_comp_mk₀,
    Abelian.Ext.mk₀_linearEquiv₀_apply]

end ExtCompat

namespace Sheaf

variable {C : Type u} [SmallCategory C] {J : GrothendieckTopology C}
variable {R : Type u} [CommRing R]
variable [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} R)]
variable {T : C} (hT : IsTerminal T) (F : Sheaf J (ModuleCat.{u} R))

set_option maxHeartbeats 800000 in
-- The `Ext`-level unfoldings through the sheafified free/constant sheaves are heavy.
omit [HasWeakSheafify J (Type u)] in