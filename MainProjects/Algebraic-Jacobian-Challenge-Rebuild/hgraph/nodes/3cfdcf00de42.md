---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.relCurveMap_fst
docstring: The comparison morphism commutes with the first projections.
file: AlgebraicJacobian/Cohomology/RelativeSectionsLinear.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relCurveMap_fst
type: lean
updated: '2026-07-29T15:31:36'
---
lemma relCurveMap_fst :
    relCurveMap C R R' ≫ (fst C (overSpec k R)).left = (fst C (overSpec k R')).left :=
  congrArg (fun φ : C ⊗ overSpec k R' ⟶ C ↦ φ.left)
    (whiskerLeft_fst C (overSpecMap (k := k) R R'))