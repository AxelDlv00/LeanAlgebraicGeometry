---
author: sync
content_type: lemma
created: '2026-07-18T20:01:11'
decl: AlgebraicGeometry.germ_thetaFieldGluedEquiv_snd
docstring: '**The germ reading of the glued components off the first chart**: at a
  point `x`

  outside `V₀` (hence in `V₁`), the component of the glued image is (a restriction
  of)

  the chart-1 component of the pair.'
file: AlgebraicJacobian/Picard/DivisorFamilyFieldDictionaryCore.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.germ_thetaFieldGluedEquiv_snd
type: lean
updated: '2026-07-29T15:26:35'
---
lemma germ_thetaFieldGluedEquiv_snd (s : relThetaSections C K π a) {x : relCurve C K}
    (hx : x ∉ (relCover C K (fiberTwoCover π)).V₀) {w : relCurve C K}
    (hw : w ∈ ⊤ ⊓ (thetaFieldPointedCover C K π).opens x)
    (hw₁ : w ∈ ⊤ ⊓ (relCover C K (fiberTwoCover π)).V₁) :
    ((relCurve C K).presheaf.germ (⊤ ⊓ (thetaFieldPointedCover C K π).opens x) w hw).hom
        ((thetaFieldGluedEquiv C K π a s).val x)
      = ((relCurve C K).presheaf.germ
          (⊤ ⊓ (relCover C K (fiberTwoCover π)).V₁) w hw₁).hom s.val.2 := by
  have hw' : w ∈ ⊤ ⊓ (thetaChartCover C K π).pieces (thetaFieldChartIndex C K π x) := hw
  have hA : ((relCurve C K).presheaf.germ
        (⊤ ⊓ (thetaFieldPointedCover C K π).opens x) w hw).hom
        ((thetaFieldGluedEquiv C K π a s).val x)
      = ((relCurve C K).presheaf.germ
          (⊤ ⊓ (thetaChartCover C K π).pieces (thetaFieldChartIndex C K π x)) w hw').hom
        ((twistToGluedApp C K π a ⊤ s).val (thetaFieldChartIndex C K π x)) :=
    (relCurve C K).presheaf.germ_res_apply (homOfLE (inf_le_inf_left ⊤ le_rfl)) w hw
      ((twistToGluedApp C K π a ⊤ s).val (thetaFieldChartIndex C K π x))
  have key : ∀ (j : (thetaChartCover C K π).index)
      (hj : thetaFieldChartIndex C K π x = j)
      (hwj : w ∈ ⊤ ⊓ (thetaChartCover C K π).pieces j),
      ((relCurve C K).presheaf.germ
          (⊤ ⊓ (thetaChartCover C K π).pieces (thetaFieldChartIndex C K π x)) w hw').hom
        ((twistToGluedApp C K π a ⊤ s).val (thetaFieldChartIndex C K π x))
        = ((relCurve C K).presheaf.germ (⊤ ⊓ (thetaChartCover C K π).pieces j) w hwj).hom
            ((twistToGluedApp C K π a ⊤ s).val j) := by
    intro j hj hwj
    cases hj
    rfl
  have hwj : w ∈ ⊤ ⊓ (thetaChartCover C K π).pieces (Sum.inr PUnit.unit) :=
    ⟨trivial, by rw [thetaChartCover_pieces_inr]; exact hw₁.2⟩
  have hB : ((relCurve C K).presheaf.germ
        (⊤ ⊓ (thetaChartCover C K π).pieces (Sum.inr PUnit.unit)) w hwj).hom
        ((twistToGluedApp C K π a ⊤ s).val (Sum.inr PUnit.unit))
      = ((relCurve C K).presheaf.germ
          (⊤ ⊓ (relCover C K (fiberTwoCover π)).V₁) w hw₁).hom s.val.2 :=
    (relCurve C K).presheaf.germ_res_apply
      (homOfLE (inf_le_inf_left ⊤ (thetaChartCover_pieces_le_inr C K π PUnit.unit)))
      w hwj s.val.2
  exact hA.trans
    ((key (Sum.inr PUnit.unit) (thetaFieldChartIndex_of_notMem C K π hx) hwj).trans hB)

variable [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))]