---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.isIso_sheafifyEta_of_unitSquare
docstring: '**D2'' η-bridge: reduction to the unit comparison square.**

  Given the commuting square identifying the sheafified presheaf unit comparison `a_Y.map
  (η F)`

  with the sheaf-level `pullbackObjUnitToUnit φ` through the canonical isos `pullbackValIso`
  and

  `sheafifyUnitIso`, the η-bridge `IsIso (a_Y.map (η (pullback φ'')))` follows (the
  comparison

  `pullbackObjUnitToUnit φ` is an iso since `Opens.map f.base` is always `Final`).
  This isolates the

  only mathematical content of the η-bridge as the square hypothesis `hsq`, the unit-side

  analogue of `pullbackObjUnitToUnit_comp`.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.isIso_sheafifyEta_of_unitSquare
type: lean
updated: '2026-07-25T05:59:05'
---
lemma isIso_sheafifyEta_of_unitSquare {X Y : Scheme.{u}} (f : Y ⟶ X)
    (hsq : letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
          (f.toRingCatSheafHom).hom
        (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).inv ≫
          (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
            (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')) ≫ sheafifyUnitIso.hom
          = SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    IsIso ((PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
      (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ'))) := by
  letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
      (f.toRingCatSheafHom).hom
  set a_Y := PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj) with ha
  set F := PresheafOfModules.pullback φ' with hF
  haveI hfin : (TopologicalSpace.Opens.map f.base).Final := final_of_representablyFlat _
  haveI hpbu : IsIso (SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom) :=
    isIso_pbu_of_final f
  have key : a_Y.map (Functor.OplaxMonoidal.η F) ≫ sheafifyUnitIso.hom
      = (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).hom ≫
        SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom :=
    (Iso.inv_comp_eq _).mp hsq
  rw [(Iso.eq_comp_inv sheafifyUnitIso).mpr key]
  exact IsIso.comp_isIso' (IsIso.comp_isIso' inferInstance hpbu) inferInstance