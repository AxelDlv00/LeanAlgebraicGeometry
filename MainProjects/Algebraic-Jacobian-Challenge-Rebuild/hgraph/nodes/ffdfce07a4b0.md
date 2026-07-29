---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.res_mem_span_eqn_inl_of_forall_germ
docstring: 'A chart section all of whose germs lie in the stalk ideals of `d` restricts
  into the

  regular principal ideal `(f_j)` of every chart-0 piece (the

  `Scheme.mem_span_singleton_of_forall_germ` pattern of the kernel bridge).'
file: AlgebraicJacobian/Picard/DivisorFamilyThetaSurj.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.res_mem_span_eqn_inl_of_forall_germ
type: lean
updated: '2026-07-29T15:26:40'
---
lemma res_mem_span_eqn_inl_of_forall_germ
    {α : Γ(relCurve C R, (relCover C R (fiberTwoCover π)).V₀)}
    (hα : ∀ (z : relCurve C R) (hz : z ∈ (relCover C R (fiberTwoCover π)).V₀),
      ((relCurve C R).presheaf.germ _ z hz).hom α ∈ d.stalkIdeal z) (j : Fin A.m₀) :
    (relCurve C R).resHom (A.pieces_inl_le j) α
      ∈ Ideal.span {A.eqn (Sum.inl j)} := by
  refine Scheme.mem_span_singleton_of_forall_germ
    (fun z hz => A.eqn_regular (Sum.inl j) z hz) (fun z hz => ?_)
  have hswap : ((relCurve C R).presheaf.germ (A.pieces (Sum.inl j)) z hz).hom
      ((relCurve C R).resHom (A.pieces_inl_le j) α)
      = ((relCurve C R).presheaf.germ ((relCover C R (fiberTwoCover π)).V₀) z
          (A.pieces_inl_le j hz)).hom α :=
    TopCat.Presheaf.germ_res_apply _ _ _ _ _
  rw [hswap, A.germ_eqn_span_eq_stalkIdeal (Sum.inl j) hz]
  exact hα z _