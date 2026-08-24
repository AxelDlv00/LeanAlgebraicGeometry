---
author: sync
content_type: theorem
created: '2026-08-11T17:13:18'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.nativeTargetPieceCoordinate_one
file: AlgebraicJacobian/Picard/Pic0RankOneNativeBaseChangePullback.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.BasicOpenCocycleDatum.nativeTargetPieceCoordinate_one
type: lean
updated: '2026-08-18T20:51:05'
---
private theorem nativeTargetPieceCoordinate_one (j : D.index)
    (s : Γ(D.nativeModule, D.pieces j))
    (hs : gluedTriv B D.isGluingCocycle j (le_refl (D.pieces j)) s = 1)
    (W : (relCurve C B').Opens)
    (hW : W = (D.baseChange B').pieces j) :
    let eOpen : W.ι ''ᵁ (⊤ : W.toScheme.Opens) ≤
        relCurveMap C B B' ⁻¹ᵁ D.pieces j := by
      rw [hW]
      exact (((D.baseChange B').pieces j).ι_image_le ⊤).trans
        (D.toBasicOpenCoverData.baseChange_pieces_le_preimage B' j)
    let eT :
      (Scheme.Modules.restrictFunctor W.ι).obj
          (D.baseChange B').nativeModule ≅
        SheafOfModules.unit W.toScheme.ringCatSheaf := by
      rw [hW]
      exact (D.baseChange B').nativeModulePieceSheafIso j
    let t := D.sectionsMap B' eOpen s
    let oneW : Γ(SheafOfModules.unit W.toScheme.ringCatSheaf,
        (⊤ : W.toScheme.Opens)) :=
      (show Γ(W.toScheme, ⊤) from 1)
    (Scheme.Modules.Hom.app eT.hom
      (⊤ : W.toScheme.Opens)).hom t = oneW := by
  subst W
  dsimp only
  let eTargetOpen :
      ((D.baseChange B').pieces j).ι ''ᵁ
          (⊤ : ((D.baseChange B').pieces j).toScheme.Opens) ≤
        relCurveMap C B B' ⁻¹ᵁ D.pieces j :=
    (((D.baseChange B').pieces j).ι_image_le ⊤).trans
      (D.toBasicOpenCoverData.baseChange_pieces_le_preimage B' j)
  have htriv := D.gluedTriv_sectionsMap B'
    eTargetOpen (le_refl (D.pieces j))
      (((D.baseChange B').pieces j).ι_image_le ⊤) s
  rw [hs, map_one] at htriv
  change
    (((D.baseChange B').pieces j).ι.appIso
      (⊤ : ((D.baseChange B').pieces j).toScheme.Opens)).commRingCatIsoToRingEquiv
      (gluedTriv B' (D.baseChange B').isGluingCocycle j
        (((D.baseChange B').pieces j).ι_image_le ⊤)
        (D.sectionsMap B' eTargetOpen s)) = 1
  rw [htriv, map_one]

set_option maxHeartbeats 1600000 in