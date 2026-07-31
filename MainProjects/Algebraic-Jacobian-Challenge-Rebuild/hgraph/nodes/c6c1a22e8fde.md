---
author: sync
content_type: lemma
created: '2026-07-17T22:31:28'
decl: AlgebraicGeometry.DivFam.toZar_mapAlg
docstring: '**`toZar` intertwines the two total maps**: base change of a globally
  certified

  class agrees with base change of its locally certified image — both representatives

  are the pulled system (with proof-irrelevant regularity witnesses).'
file: AlgebraicJacobian/Picard/DivisorFamilyZarMapAlg.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivFam.toZar_mapAlg
type: lean
updated: '2026-07-31T20:15:25'
---
lemma DivFam.toZar_mapAlg (F : DivFam C R π n) :
    (DivFam.mapAlg R' n F).toZar = DivFamZar.mapAlg R' n F.toZar := by
  induction F using Quotient.inductionOn with
  | h F => exact DivFamZar.mk_eq_mk_iff.mpr (Scheme.LocalEquations.divEq_refl _)