---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.sheafifyMap_pullbackComp_hom_inv_id
docstring: '**Brick 1 (Sq-cancellation) — sheafification kills the presheaf `pullbackComp`
  hom∘inv round-trip.**

  For composable scheme morphisms `h : Z ⟶ Y`, `f : Y ⟶ X` and any presheaf `T` over
  `X`, the

  sheafification functor `aZ = sheafification (𝟙 Z.ringCatSheaf.val)` sends the `hom
  ≫ inv` round-trip

  of the Mathlib presheaf coherence `PresheafOfModules.pullbackComp φf φh` to the
  identity.  This is the

  `D ≫ E = 𝟙` cancellation consumed by step (i) of the four-square interleave in

  `pullbackTensorMap_restrict` (where `D = aZ.map (pbComp.hom.app T)` comes from the
  Sq1 brick

  `sheafificationCompPullback_comp` and `E = aZ.map (pb.inv.app T)` from the Sq2b
  splice `hδ`).'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.sheafifyMap_pullbackComp_hom_inv_id
type: lean
updated: '2026-07-24T03:02:12'
---
private lemma sheafifyMap_pullbackComp_hom_inv_id {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    (T : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) :
    (PresheafOfModules.sheafification (R := Z.ringCatSheaf) (𝟙 Z.ringCatSheaf.val)).map
        ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).hom.app T) ≫
      (PresheafOfModules.sheafification (R := Z.ringCatSheaf) (𝟙 Z.ringCatSheaf.val)).map
        ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
          (Hom.toRingCatSheafHom h).hom).inv.app T) = 𝟙 _ := by
  rw [← Functor.map_comp]
  erw [Iso.hom_inv_id_app]
  exact (PresheafOfModules.sheafification (R := Z.ringCatSheaf) (𝟙 Z.ringCatSheaf.val)).map_id _