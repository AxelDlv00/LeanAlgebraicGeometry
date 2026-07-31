---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.productChartSections_tmul_one
docstring: On `s ⊗ₜ 1` the identification is the first-projection pullback `fst^♯
  s`.
file: AlgebraicJacobian/Curve/ProductCharts.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.productChartSections_tmul_one
type: lean
updated: '2026-07-31T20:15:19'
---
theorem productChartSections_tmul_one {U : X.left.Opens} {V : T.left.Opens}
    (hU : IsAffineOpen U) (hV : IsAffineOpen V) (s : Γ(X.left, U)) :
    productChartSections X T hU hV (s ⊗ₜ 1)
      = (fst X T).left.appLE U (productChart X T U V)
          (productChart_le_fst_preimage X T U V) s :=
  congr($((CommRingCat.isPushout_tensorProduct k Γ(X.left, U)
    Γ(T.left, V)).inl_isoIsPushout_hom _ _
    (isPushout_algebraMap_productChart X T hU hV)).hom s)