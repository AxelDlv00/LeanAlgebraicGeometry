---
author: sync
content_type: theorem
created: '2026-07-27T01:04:30'
decl: AlgebraicGeometry.DivRepAffinePullback.overSpecMap_comp_divRepClassifyZar
docstring: '**The affine backward classifier is natural in the test algebra.**  This
  is not

  proved from the characterizing clause: it is forced by the affine package, whose
  forward

  map `D.pull` is injective and natural, so its inverse is natural too — concretely,
  the

  base change of a classifier classifies the base-changed class, by

  `D.isDivRepClassify_pull` at the base-changed morphism.'
file: AlgebraicJacobian/Picard/DivRepGlobalClassify.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.DivRepAffinePullback.overSpecMap_comp_divRepClassifyZar
type: lean
updated: '2026-07-28T17:25:23'
---
private theorem overSpecMap_comp_divRepClassifyZar
    (D : DivRepAffinePullback hpi g hO hchi r1 r2 b1 b2)
    {A B : Type u} [CommRing A] [Algebra k A] [CommRing B] [Algebra k B]
    (phi : A →ₐ[k] B) (F : DivFamZar C A pi g) :
    Over.overSpecMap phi ≫ divRepClassifyZar hpi g hO hchi r1 r2 b1 b2 A F
      = divRepClassifyZar hpi g hO hchi r1 r2 b1 b2 B (DivFamZar.mapAlgHom phi F) := by
  have hpull : D.pull B
      (Over.overSpecMap phi ≫ divRepClassifyZar hpi g hO hchi r1 r2 b1 b2 A F)
      = DivFamZar.mapAlgHom phi F := by
    rw [D.pull_naturality phi (divRepClassifyZar hpi g hO hchi r1 r2 b1 b2 A F),
      D.pull_classify A F]
  refine divRepClassifyZar_eq_of_isDivRepClassify hpi g hO hchi r1 r2 b1 b2 _ _ ?_
  rw [← hpull]
  exact D.isDivRepClassify_pull B _

/-! ## The general-test classifier -/