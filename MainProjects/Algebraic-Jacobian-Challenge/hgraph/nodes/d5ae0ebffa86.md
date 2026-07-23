---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.appIso_hom_naturality_apply
docstring: '**Pointwise naturality of the `.hom` direction of the structure ring iso**:
  `(f.appIso _).hom`

  intertwines the `X`- and `Y`-restriction maps.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.appIso_hom_naturality_apply
type: lean
updated: '2026-07-24T03:02:12'
---
lemma appIso_hom_naturality_apply {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    {U V : TopologicalSpace.Opens ↥Y} (i : op U ⟶ op V)
    (w : (X.presheaf.obj (op ((Hom.opensFunctor f).obj U)) : Type u)) :
    (Scheme.Hom.appIso f V).hom.hom ((X.presheaf.map ((Hom.opensFunctor f).op.map i)).hom w)
      = (Y.presheaf.map i).hom ((Scheme.Hom.appIso f U).hom.hom w) := by
  have hinj : Function.Injective (Scheme.Hom.appIso f V).inv.hom :=
    (CategoryTheory.ConcreteCategory.bijective_of_isIso (Scheme.Hom.appIso f V).inv).1
  apply hinj
  have hVcancel : (Scheme.Hom.appIso f V).inv.hom ((Scheme.Hom.appIso f V).hom.hom
      ((X.presheaf.map ((Hom.opensFunctor f).op.map i)).hom w))
      = (X.presheaf.map ((Hom.opensFunctor f).op.map i)).hom w :=
    ConcreteCategory.congr_hom (Scheme.Hom.appIso f V).hom_inv_id _
  rw [hVcancel]
  have hUw : (Scheme.Hom.appIso f U).inv.hom ((Scheme.Hom.appIso f U).hom.hom w) = w :=
    ConcreteCategory.congr_hom (Scheme.Hom.appIso f U).hom_inv_id w
  have h1 := ConcreteCategory.congr_hom (Scheme.Hom.appIso_inv_naturality f i)
    ((Scheme.Hom.appIso f U).hom.hom w)
  change (Scheme.Hom.appIso f V).inv.hom
      ((Y.presheaf.map i).hom ((Scheme.Hom.appIso f U).hom.hom w))
      = (X.presheaf.map ((Hom.opensFunctor f).op.map i)).hom
        ((Scheme.Hom.appIso f U).inv.hom ((Scheme.Hom.appIso f U).hom.hom w)) at h1
  rw [hUw] at h1
  exact h1.symm

set_option backward.isDefEq.respectTransparency false in
open Opposite in