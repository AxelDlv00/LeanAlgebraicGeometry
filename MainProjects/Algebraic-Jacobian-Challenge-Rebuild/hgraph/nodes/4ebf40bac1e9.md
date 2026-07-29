---
author: sync
content_type: lemma
created: '2026-07-18T21:01:13'
decl: AlgebraicGeometry.DivisorAdaptation.stalkIdeal_eq_span_germ_eqn
docstring: '**A piece equation generates the stalk ideal at each of its points, over
  any test

  ring** (the `R`-generic port of the field-level

  `DivisorAdaptation.span_germ_eqn_eq_stalkIdeal`): the pointwise clause `eqn_rel
  j z`

  presents the germ of `f_j` as a unit germ times the germ of `d`''s equation at the

  member of `z` itself, whose span is the stalk ideal.'
file: AlgebraicJacobian/Picard/DivSchemeMonoBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.stalkIdeal_eq_span_germ_eqn
type: lean
updated: '2026-07-29T15:31:41'
---
lemma stalkIdeal_eq_span_germ_eqn (j : A.index) {z : relCurve C R}
    (hz : z ∈ A.pieces j) :
    d.stalkIdeal z
      = Ideal.span {((relCurve C R).presheaf.germ (A.pieces j) z hz).hom (A.eqn j)} := by
  obtain ⟨u, hu⟩ := A.eqn_rel j z
  have hzW : z ∈ A.pieces j ⊓ d.cover.opens z := ⟨hz, d.cover.mem_opens z⟩
  have hgerm := congrArg ((relCurve C R).presheaf.germ
    (A.pieces j ⊓ d.cover.opens z) z hzW).hom hu
  rw [map_mul, TopCat.Presheaf.germ_res_apply, TopCat.Presheaf.germ_res_apply] at hgerm
  exact (span_eq_of_unit_mul (u.isUnit.map ((relCurve C R).presheaf.germ
    (A.pieces j ⊓ d.cover.opens z) z hzW).hom) hgerm).symm