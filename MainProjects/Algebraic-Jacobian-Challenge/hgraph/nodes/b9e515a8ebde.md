---
author: sync
content_type: lemma
created: '2026-07-24T17:02:57'
decl: AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso
docstring: '**Leg-B atomic claim: the lax-monoidal unit `ε` of `restrictScalars` along
  the open-immersion

  structure ring iso `(f.appIso W'').inv` is an isomorphism.**  Its underlying map
  is the (bijective)

  ring map `(f.appIso W'').inv.hom`, so `ε` is an iso by `restrictScalars_isIso_ε_of_bijective`

  (`PresheafInternalHom.lean`) fed the bijectivity from `ConcreteCategory.bijective_of_isIso`.  This

  is the single load-bearing fact powering `dualUnitRingSwap` (the codomain unit ring
  swap of leg-B),

  phrased at the `CommRingCat` carrier so `CommRing` is native.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.isIso_ε_restrictScalars_appIso
type: lean
updated: '2026-07-25T13:02:37'
---
lemma isIso_ε_restrictScalars_appIso {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (W' : TopologicalSpace.Opens ↥Y) :
    IsIso (Functor.LaxMonoidal.ε
      (ModuleCat.restrictScalars (Scheme.Hom.appIso f W').inv.hom)) :=
  restrictScalars_isIso_ε_of_bijective (Scheme.Hom.appIso f W').inv.hom
    (CategoryTheory.ConcreteCategory.bijective_of_isIso (Scheme.Hom.appIso f W').inv)