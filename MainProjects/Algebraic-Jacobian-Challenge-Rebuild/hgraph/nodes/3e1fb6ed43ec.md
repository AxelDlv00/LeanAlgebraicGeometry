---
author: sync
content_type: theorem
created: '2026-07-29T09:42:53'
decl: AlgebraicGeometry.AffAdaptation.germ_eqn_span_eq_stalkIdeal
docstring: '**The germ of a widened equation spans the stalk ideal of the family.**  The
  widened

  counterpart of `DivisorAdaptation.germ_eqn_span_eq_stalkIdeal`

  (`Picard/DivisorFamilyTheta.lean:322`); its proof is the same one, and it ports
  because

  `eqn_rel` is stated pointwise on both carriers.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffTheta.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.germ_eqn_span_eq_stalkIdeal
type: lean
updated: '2026-07-31T20:15:24'
---
theorem germ_eqn_span_eq_stalkIdeal (j : D.index) {z : relCurve C R}
    (hz : z ∈ D.pieces j) :
    Ideal.span {((relCurve C R).presheaf.germ (D.pieces j) z hz).hom (A.eqn j)}
      = d.stalkIdeal z := by
  obtain ⟨u, hu⟩ := A.eqn_rel j z
  have hzW : z ∈ D.pieces j ⊓ d.cover.opens z := ⟨hz, d.cover.mem_opens z⟩
  have hgerm : ((relCurve C R).presheaf.germ (D.pieces j) z hz).hom (A.eqn j)
      = ((relCurve C R).presheaf.germ (D.pieces j ⊓ d.cover.opens z) z hzW).hom
          (u : Γ(relCurve C R, D.pieces j ⊓ d.cover.opens z))
        * ((relCurve C R).presheaf.germ (d.cover.opens z) z
            (d.cover.mem_opens z)).hom (d.eqn z) := by
    have h := congrArg ((relCurve C R).presheaf.germ
      (D.pieces j ⊓ d.cover.opens z) z hzW).hom hu
    rw [map_mul, TopCat.Presheaf.germ_res_apply, TopCat.Presheaf.germ_res_apply] at h
    exact h
  rw [hgerm, Ideal.span_singleton_mul_left_unit (u.isUnit.map
    ((relCurve C R).presheaf.germ (D.pieces j ⊓ d.cover.opens z) z hzW).hom)]
  exact d.germ_eqn_span_eq z z (d.cover.mem_opens z)