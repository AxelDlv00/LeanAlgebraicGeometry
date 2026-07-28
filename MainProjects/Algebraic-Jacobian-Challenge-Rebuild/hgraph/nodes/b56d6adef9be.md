---
author: sync
content_type: theorem
created: '2026-07-29T07:53:26'
decl: AlgebraicGeometry.Scheme.map_eq_one_of_pullbackOverlapQuot_eq_one
docstring: '**Forward: the upstream kernel lands in the `CechPic` kernel.** The landed

  `map_twoChartClass_eq_one_iff` in the direction the bijection''s `toFun` consumes.'
file: AlgebraicJacobian/Tangent/TwoChartKernelComparison.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.map_eq_one_of_pullbackOverlapQuot_eq_one
type: lean
updated: '2026-07-29T07:53:26'
---
theorem map_eq_one_of_pullbackOverlapQuot_eq_one (f : X ⟶ Y)
    (hsel' : Function.Surjective (fun x ↦ sel (f.base x))) (q : overlapQuot Y V)
    (hq : pullbackOverlapQuot f q = 1) :
    CechPic.map f (twoChartClass V sel hmem hsel q) = 1 :=
  (map_twoChartClass_eq_one_iff f sel hmem hsel hsel' q).mpr hq