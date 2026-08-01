---
author: sync
content_type: lemma
created: '2026-07-20T03:01:15'
decl: AlgebraicGeometry.algebraMap_germ_thetaFieldGluedEquiv_eq
docstring: '**The glued-component germ is the trivialized reading**: in the function
  field, the

  image of the germ (at any point `z`) of the deterministic glued component of a global
  theta

  section is the trivializing element `elem z` times its function-field reading

  `thetaFieldRead s`.  Unwinds `thetaFieldRead = gluedVal = elem⁻¹ · germ_η(glued)`
  through the

  generic-germ/stalk seam.'
file: AlgebraicJacobian/Picard/DivSchemeUnivFibreHdiv.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.algebraMap_germ_thetaFieldGluedEquiv_eq
type: lean
updated: '2026-08-01T09:44:12'
---
lemma algebraMap_germ_thetaFieldGluedEquiv_eq (s : relThetaSections C K π a)
    (z : relCurve C K) :
    algebraMap ((relCurve C K).presheaf.stalk z) (relCurve C K).functionField
        (((relCurve C K).presheaf.germ (⊤ ⊓ (thetaFieldPointedCover C K π).opens z) z
            ⟨trivial, (thetaFieldPointedCover C K π).mem_opens z⟩).hom
          ((thetaFieldGluedEquiv C K π a s).val z))
      = (((thetaFieldPresentation C K π a).elem z : (relCurve C K).functionFieldˣ) :
          (relCurve C K).functionField)
        * thetaFieldRead C K π a s := by
  have hh : (((thetaFieldPresentation C K π a).elem z : (relCurve C K).functionFieldˣ) :
        (relCurve C K).functionField) * thetaFieldRead C K π a s
      = algebraMap ((relCurve C K).presheaf.stalk z) (relCurve C K).functionField
          (((relCurve C K).presheaf.germ
              (⊤ ⊓ (thetaFieldPointedCover C K π).opens z) z
              ⟨trivial, (thetaFieldPointedCover C K π).mem_opens z⟩).hom
            ((thetaFieldGluedEquiv C K π a s).val z)) := by
    rw [thetaFieldRead_apply, Scheme.MeromorphicPresentation.gluedVal_eq_elem_inv_mul K
      (thetaFieldPresentation C K π a) z (W := ⊤) trivial (thetaFieldGluedEquiv C K π a s)]
    simp only [thetaFieldPresentation_cover]
    rw [Scheme.germ_generic_eq_algebraMap_germ
        (⟨trivial, (thetaFieldPointedCover C K π).genericPoint_mem_opens z⟩ :
          genericPoint (relCurve C K) ∈ ⊤ ⊓ (thetaFieldPointedCover C K π).opens z)
        (⟨trivial, (thetaFieldPointedCover C K π).mem_opens z⟩ :
          z ∈ ⊤ ⊓ (thetaFieldPointedCover C K π).opens z)
        ((thetaFieldGluedEquiv C K π a s).val z),
      ← mul_assoc, Units.mul_inv, one_mul]
  exact hh.symm

omit [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))] in