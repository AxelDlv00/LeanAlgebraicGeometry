---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.braiding_comp_unit_eq_unit_of_isInvertible
docstring: '**Descent equation for the self-braiding** (helper for `tensorBraiding_self_eq_id_of_isInvertible`):

  the presheaf self-braiding `β^{pre}` composed with the sheafification unit equals
  the unit.  Both

  land in a sheaf, and they agree on the trivializing basis carried by `IsInvertibleGr
  L` (where

  `β^{pre}` is the identity, `braiding_self_app_eq_id_of_invertible`), so they are
  equal by sheaf

  separatedness (`TopCat.Sheaf.hom_ext`).  Project-local.'
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.braiding_comp_unit_eq_unit_of_isInvertible
type: lean
updated: '2026-07-24T03:02:12'
---
private lemma braiding_comp_unit_eq_unit_of_isInvertible (L : X.Modules) [IsInvertibleGr L] :
    (BraidedCategory.braiding (C := MonoidalPresheaf X)
        ((toPresheafOfModules X).obj L) ((toPresheafOfModules X).obj L)).hom
      ≫ (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
          (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
            ((toPresheafOfModules X).obj L) ((toPresheafOfModules X).obj L))
      = (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
          (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
            ((toPresheafOfModules X).obj L) ((toPresheafOfModules X).obj L)) := by
  obtain ⟨ι, U, hbasis, hinv⟩ := IsInvertibleGr.exists_trivializing_basis (L := L)
  apply (PresheafOfModules.toPresheaf _).map_injective
  refine TopCat.Sheaf.hom_ext _
    ((SheafOfModules.toSheaf X.ringCatSheaf).obj (sheafTensorObj L L)) hbasis ?_
  intro i
  rw [Functor.map_comp, NatTrans.comp_app]
  have hb : ((PresheafOfModules.toPresheaf (X.sheaf.obj ⋙ forget₂ CommRingCat RingCat)).map
        (BraidedCategory.braiding (C := MonoidalPresheaf X)
          ((toPresheafOfModules X).obj L) ((toPresheafOfModules X).obj L)).hom).app
          (Opposite.op (U i)) = 𝟙 _ := by
    ext x
    erw [PresheafOfModules.toPresheaf_map_app_apply]
    rw [braiding_self_app_eq_id_of_invertible L (U i) (hinv i)]
    rfl
  rw [hb, Category.id_comp]