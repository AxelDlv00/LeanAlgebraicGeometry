---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pushforwardSliceTwoAdjunction
docstring: '**The two-pushforward slice adjunction** (blueprint `lem:pushforward_slice_two_adjunction`):

  `pushforward φ'''' ⊣ pushforward ψ_r`, assembled by feeding `pushforwardPushforwardAdj`
  the slice

  equivalence''s adjunction, the two ring maps `φ''''`/`ψ_r`, and the compatibility
  squares `H₁`/`H₂`.'
file: AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushforwardSliceTwoAdjunction
type: lean
updated: '2026-07-24T03:02:10'
---
noncomputable def pushforwardSliceTwoAdjunction :
    SheafOfModules.pushforward.{u} (sliceReverseRingMap φ Ui) ⊣
      SheafOfModules.pushforward.{u} (sliceStructureSheafHom φ Ui) := by
  haveI hF : (sliceOversEquiv φ Ui).symm.functor.IsContinuous
      ((Opens.grothendieckTopology Y).over (φ.inv ⁻¹ᵁ Ui))
      ((Opens.grothendieckTopology X).over Ui) :=
    sliceOversEquiv_inverse_isContinuous φ Ui
  haveI hG : (sliceOversEquiv φ Ui).symm.inverse.IsContinuous
      ((Opens.grothendieckTopology X).over Ui)
      ((Opens.grothendieckTopology Y).over (φ.inv ⁻¹ᵁ Ui)) :=
    sliceOversEquiv_functor_isContinuous φ Ui
  exact SheafOfModules.pushforwardPushforwardAdj
    (sliceOversEquiv φ Ui).symm.toAdjunction
    (sliceReverseRingMap φ Ui) (sliceStructureSheafHom φ Ui)
    (pushforwardSliceAdjunctionH1 φ Ui) (pushforwardSliceAdjunctionH2 φ Ui)