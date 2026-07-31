---
author: sync
content_type: lemma
created: '2026-07-24T17:02:47'
decl: AlgebraicGeometry.DivisorAdaptation.gluedToIdeal₀_secRes
docstring: The assembly commutes with restriction of the glued section.
file: AlgebraicJacobian/Picard/DivisorThetaGlue.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.gluedToIdeal₀_secRes
type: lean
updated: '2026-07-31T20:15:25'
---
lemma gluedToIdeal₀_secRes {W' W : (relCurve C R).Opens} (h : W' ≤ W)
    (hW : W ≤ (relCover C R (fiberTwoCover π)).V₀) (s : A.ThetaIdealSections a W) :
    gluedToIdeal₀ A a (h.trans hW) (secRes ((A.thetaIdealDatum a).sheaf) h s)
      = (relCurve C R).resHom h (gluedToIdeal₀ A a hW s) := by
  refine (gluedToIdeal₀_unique (h.trans hW) _ (fun i => ?_)).symm
  have key := congrArg ((relCurve C R).resHom
    (inf_le_inf_right (A.pieces (Sum.inl i)) h :
      W' ⊓ A.pieces (Sum.inl i) ≤ W ⊓ A.pieces (Sum.inl i)))
    (res_gluedToIdeal₀ hW s i)
  rw [map_mul] at key
  simp only [Scheme.resHom_resHom] at key ⊢
  exact key