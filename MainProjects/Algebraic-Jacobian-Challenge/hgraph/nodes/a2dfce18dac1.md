---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta
docstring: '**D2'' assembly — `pullbackTensorMap` on the unit pair is an iso, given
  the η-bridge.**

  Chains the δ-wrapping `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` into the
  reduction brick

  `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` (on `M = N = 𝒪`). This is the full
  statement of

  D2'' (`lem:pullback_tensor_iso_unit`) modulo the single remaining η-bridge hypothesis

  `IsIso (a_Y.map (η (pullback φ'')))` (the sheafification-mate identification of
  the sheafified

  presheaf unit comparison with `pullbackUnitIso`, the unit-side analog of

  `pullbackObjUnitToUnit_comp`). Project-local.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta
type: lean
updated: '2026-07-25T05:32:31'
---
lemma isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta {X Y : Scheme.{u}} (f : Y ⟶ X)
    (h : letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
          (f.toRingCatSheafHom).hom
        IsIso ((PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
          (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')))) :
    IsIso (pullbackTensorMap f (SheafOfModules.unit X.ringCatSheaf)
      (SheafOfModules.unit X.ringCatSheaf)) := by
  apply isIso_pullbackTensorMap_of_isIso_sheafifyDelta
  exact isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta f h

/-! ### The unit comparison

The following lemmas identify the sheafified oplax unit with the sheaf-level structure
sheaf comparison. This proves that `pullbackTensorMap` is an isomorphism on the unit pair,
which is the local input for the line-bundle argument. -/