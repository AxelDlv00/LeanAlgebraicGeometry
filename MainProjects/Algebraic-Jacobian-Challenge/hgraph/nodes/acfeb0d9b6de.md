---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.Modules.pushforwardExtAddEquiv
docstring: '**`Ext` transport along a scheme isomorphism.** For `φ : X ≅ Y` and `A
  B : X.Modules`, the

  equivalence `pushforwardEquivOfIso φ` (whose functor is fully faithful, exact, and
  injective-object

  preserving) upgrades the additive map `Ext.mapExactFunctor` to an isomorphism of
  `Ext`-groups

  `Ext A B n ≃+ Ext (φ_* A) (φ_* B) n`, via `Functor.mapExt_bijective_of_preservesInjectiveObjects`.

  Project-local: the `Ext`-isomorphism half of Need #1 (the spectrum-equivalence transport).'
file: AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.pushforwardExtAddEquiv
type: lean
updated: '2026-07-24T03:02:10'
---
noncomputable def Scheme.Modules.pushforwardExtAddEquiv {X Y : Scheme.{u}} (φ : X ≅ Y)
    [EnoughInjectives X.Modules] (A B : X.Modules) (n : ℕ) :
    CategoryTheory.Abelian.Ext A B n ≃+
      CategoryTheory.Abelian.Ext ((Scheme.Modules.pushforwardEquivOfIso φ).functor.obj A)
        ((Scheme.Modules.pushforwardEquivOfIso φ).functor.obj B) n :=
  AddEquiv.ofBijective ((Scheme.Modules.pushforwardEquivOfIso φ).functor.mapExtAddHom A B n)
    (Functor.mapExt_bijective_of_preservesInjectiveObjects
      (Scheme.Modules.pushforwardEquivOfIso φ).functor A B n)