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
updated: '2026-07-24T03:02:12'
---
lemma isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta {X Y : Scheme.{u}} (f : Y ⟶ X)
    (h : letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
          (f.toRingCatSheafHom).hom
        IsIso ((PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
          (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')))) :
    IsIso (pullbackTensorMap f (SheafOfModules.unit X.ringCatSheaf)
      (SheafOfModules.unit X.ringCatSheaf)) := by
  apply isIso_pullbackTensorMap_of_isIso_sheafifyDelta
  exact isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta f h

/-! **D2' onward — handoff (iter-246).** The δ-wrapping half of D2' is now LANDED axiom-clean:
`isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` reduces the sheafified `δ` on the unit pair to
the η-bridge `IsIso (a_Y.map (η (pullback φ')))` (via `left_unitality_hom` + the W-stable
right-whiskering `W_whiskerRight_of_W` fed by the new converse `W_of_isIso_sheafification`), and
`isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` chains it into the reduction brick. So the
SOLE remaining content of D2' is the **η-bridge**

  `IsIso (a_Y.map (η (PresheafOfModules.pullback φ')))`.

This is the commuting square (`sheafifyUnitIso` is its right vertical, built above)
`a_Y.map (η F) ≫ sheafifyUnitIso.hom = (pullbackValIso f 𝒪_X).hom ≫ pullbackObjUnitToUnit φ`.
Transposing across `SheafOfModules.pullbackPushforwardAdjunction φ` (apply `.homEquiv.injective`,
then `pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit`, `homEquiv_unit`,
`leftAdjointOplaxMonoidal_η`, `homEquiv_counit`) reduces the square to the concrete pushforward-side
identity (sheafification-mate bridge):

  `sheafAdj.unit.app 𝒪_X ≫ (pushforward φ).map ((pullbackValIso).inv ≫
      a_Y.map (pullback_pre.map ε_pre ≫ presheafAdj.counit) ≫ sheafifyUnitIso.hom)
    = unitToPushforwardObjUnit φ`,

where `ε_pre = LaxMonoidal.ε (PresheafOfModules.pushforward φ.hom)`. The glue is the leftAdjointUniq
compatibility of `SheafOfModules.sheafificationCompPullback`/`pullbackIso` (the bridges inside
`pullbackValIso`) — `Adjunction.{homEquiv_,unit_,}leftAdjointUniq_hom_app`,
`leftAdjointUniq_hom_app_counit` — relating the presheaf and sheaf adjunction units; this is the
unit-side analog of `pullbackObjUnitToUnit_comp`, NOT yet assembled (a self-contained next step).

* **D3'/D4'** (the chart-chase): use `isIso_of_isIso_restrict` (L546) over the common trivialising
  cover; on each chart D3' (δ commutes with the open-immersion base-change square — the sole
  genuinely-new mate calculus, analog of `pullbackObjUnitToUnit_comp`) localises the sheafified δ,
  the naturality D1' transports to the unit pair, and D2' closes. Each stays inside
  `IsIso (a_Y.map δ …)`, so `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` is the shared entry. -/