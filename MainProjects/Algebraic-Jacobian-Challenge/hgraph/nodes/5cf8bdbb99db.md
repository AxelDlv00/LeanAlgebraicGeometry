---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.sheafifyMap_pullbackComp_hom_inv_id
docstring: '**Brick 1 (Sq-cancellation).**

  For composable scheme morphisms `h : Z ⟶ Y`, `f : Y ⟶ X` and any presheaf `T` over
  `X`, the

  sheafification functor sends the `hom ≫ inv` round trip of

  `PresheafOfModules.pullbackComp` to the identity. This supplies the middle cancellation
  in

  `pullbackTensorMap_restrict`.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.Modules.sheafifyMap_pullbackComp_hom_inv_id
type: lean
updated: '2026-07-28T13:22:17'
---
private lemma sheafifyMap_pullbackComp_hom_inv_id {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    (T : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) :
    (PresheafOfModules.sheafification (R := Z.ringCatSheaf) (𝟙 Z.ringCatSheaf.obj)).map
        ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).hom.app T) ≫
      (PresheafOfModules.sheafification (R := Z.ringCatSheaf) (𝟙 Z.ringCatSheaf.obj)).map
        ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).inv.app T) = 𝟙 _ := by
  rw [← Functor.map_comp]
  erw [Iso.hom_inv_id_app]
  exact
    (PresheafOfModules.sheafification
      (R := Z.ringCatSheaf) (𝟙 Z.ringCatSheaf.obj)).map_id _