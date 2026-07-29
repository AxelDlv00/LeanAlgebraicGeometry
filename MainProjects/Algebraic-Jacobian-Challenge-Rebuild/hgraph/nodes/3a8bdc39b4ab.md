---
author: sync
content_type: lemma
created: '2026-07-30T03:30:39'
decl: AlgebraicGeometry.AffAdaptation.ovlStalkColEval_toOvlLeft
file: AlgebraicJacobian/Picard/DivisorFamilyAffStalkEval.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.ovlStalkColEval_toOvlLeft
type: lean
updated: '2026-07-30T03:30:39'
---
lemma ovlStalkColEval_toOvlLeft (i j : D.index) {z : relCurve C K}
    (hz : z ∈ D.pieces i ⊓ D.pieces j) (x : A.colength i) :
    A.ovlStalkColEval i j hz (A.toOvlLeft i j x) = A.stalkColEval i hz.1 x := by
  obtain ⟨t, rfl⟩ := Ideal.Quotient.mk_surjective x
  change Ideal.Quotient.mk (d.stalkIdeal z)
      (((relCurve C K).presheaf.germ (D.pieces i ⊓ D.pieces j) z hz).hom
        (((relCurve C K).presheaf.map (homOfLE inf_le_left).op).hom t))
    = Ideal.Quotient.mk (d.stalkIdeal z)
        (((relCurve C K).presheaf.germ (D.pieces i) z hz.1).hom t)
  rw [TopCat.Presheaf.germ_res_apply]

omit [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))] in