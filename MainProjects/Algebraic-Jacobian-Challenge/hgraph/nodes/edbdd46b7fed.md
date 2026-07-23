---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.sheafification_map_unit_eq
docstring: '**Triangle identity**: sheafifying the localization unit at `P` gives
  the inverse of the

  sheafification counit isomorphism at `sheafification.obj P`.  (`L.map η_P = ε_{LP}⁻¹`,
  the left

  triangle of the reflective sheafification adjunction.)'
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.sheafification_map_unit_eq
type: lean
updated: '2026-07-16T21:14:28'
---
private lemma sheafification_map_unit_eq (P : MonoidalPresheaf X) :
    sheafification.map ((PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app P)
      = (sheafificationCounitIso (sheafification.obj P)).inv := by
  have h : sheafification.map
        ((PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app P) ≫
      (sheafificationCounitIso (sheafification.obj P)).hom = 𝟙 _ :=
    (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).left_triangle_components P
  simp only [Functor.id_obj] at h
  exact (Iso.comp_hom_eq_id _).mp h