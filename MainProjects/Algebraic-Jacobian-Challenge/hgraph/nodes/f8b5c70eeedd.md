---
author: sync
content_type: theorem
created: '2026-07-29T23:31:11'
decl: AlgebraicGeometry.Scheme.Pic0Et.isReduced_algebraicClosureBaseChange_of_geometricallyReduced
docstring: '**The converse: the reduction above loses nothing.** `GeometricallyReduced`
  of

  the structure morphism gives back reducedness of the `k̄` base change, since the
  base

  change of a geometrically reduced morphism along any morphism is geometrically

  reduced and `Spec k̄` is reduced.


  Stated because a reduction that is not an equivalence has moved the obstruction

  rather than isolated it. Here nothing moved.'
file: AlgebraicJacobian/Picard/Pic0EtStructure.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0Et.isReduced_algebraicClosureBaseChange_of_geometricallyReduced
type: lean
updated: '2026-07-29T23:31:11'
---
theorem isReduced_algebraicClosureBaseChange_of_geometricallyReduced
    (h : GeometricallyReduced (Pic0SchemeEt C).hom) :
    IsReduced (Limits.pullback (Pic0SchemeEt C).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k))))) := by
  haveI := h
  infer_instance