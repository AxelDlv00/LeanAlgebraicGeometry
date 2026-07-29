---
author: sync
content_type: theorem
created: '2026-07-29T20:27:12'
decl: AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_isIso_of_left_unit
docstring: '**The left-hand unit case is UNCONDITIONAL** — arbitrary second factor,
  no

  gate, no local triviality anywhere.


  `f^*(𝒪_X ⊗ M) ⟶ f^*𝒪_X ⊗ f^*M` is an isomorphism for every `f` and every `M`.

  This is `Modules.pullbackTensorMap_left_unitality`

  (`Picard/TensorObjInverse.lean:2377`) read as an invertibility statement: that

  square exhibits `pullbackTensorMap f 𝒪_X M`, post-composed with two

  isomorphisms, as `f^*` of the left unitor — itself an isomorphism — so the

  comparison is invertible by right cancellation.'
file: AlgebraicJacobian/Picard/PullbackTensorOneSided.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_isIso_of_left_unit
type: lean
updated: '2026-07-29T20:27:12'
---
theorem pullbackTensorMap_isIso_of_left_unit {X Y : Scheme.{u}} (f : Y ⟶ X)
    (M : X.Modules) :
    IsIso (pullbackTensorMap f (SheafOfModules.unit X.ringCatSheaf) M) := by
  have h := pullbackTensorMap_left_unitality f M
  haveI : IsIso ((tensorObjIsoOfIso (pullbackUnitIso f)
      (Iso.refl ((Scheme.Modules.pullback f).obj M))).hom) :=
    (tensorObjIsoOfIso (pullbackUnitIso f) (Iso.refl _)).isIso_hom
  haveI : IsIso ((tensorObj_left_unitor ((Scheme.Modules.pullback f).obj M)).hom) :=
    (tensorObj_left_unitor _).isIso_hom
  haveI h3 : IsIso ((Scheme.Modules.pullback f).map (tensorObj_left_unitor M).hom) :=
    Functor.map_isIso _ _
  rw [← h] at h3
  exact IsIso.of_isIso_comp_right
    (pullbackTensorMap f (SheafOfModules.unit X.ringCatSheaf) M)
    ((tensorObjIsoOfIso (pullbackUnitIso f)
        (Iso.refl ((Scheme.Modules.pullback f).obj M))).hom
      ≫ (tensorObj_left_unitor ((Scheme.Modules.pullback f).obj M)).hom)