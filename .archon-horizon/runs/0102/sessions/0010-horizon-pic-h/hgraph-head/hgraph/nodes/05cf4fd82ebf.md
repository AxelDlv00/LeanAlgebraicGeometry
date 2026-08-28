---
author: sync
content_type: theorem
created: '2026-07-28T19:44:57'
decl: AlgebraicGeometry.classDeg_cechPicMap_base_of_field
docstring: '**The degree of a base class is base-field invariant** — E-iv-alg

  (`classDeg_cechPicMap_baseFieldTransition`) read along `relCurveMap C k L` rather
  than along

  the raw whisker.  The two agree by `relCurveMap_eq_overSpecMap_ofId`, and this is
  the spelling

  every chart-layer statement uses.'
file: AlgebraicJacobian/Picard/Pic0ChartCoverageDegree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.classDeg_cechPicMap_base_of_field
type: lean
updated: '2026-08-01T09:44:15'
---
theorem classDeg_cechPicMap_base_of_field (L : Type u) [Field L] [Algebra k L]
    (Λ : (C ⊗ overSpec k k).left.CechPic) :
    classDeg L (Scheme.CechPic.map ((C ◁ Over.overSpecMap (Algebra.ofId k L)).left) Λ)
      = classDeg k Λ :=
  classDeg_cechPicMap_baseFieldTransition C (Algebra.ofId k L) Λ

variable (C) in