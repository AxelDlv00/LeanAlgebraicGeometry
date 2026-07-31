---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.productChartSectionsIso
docstring: '**The sections identification** (in `CommRingCat`): for affine opens `U
  ⊆ X.left`,

  `V ⊆ T.left`, `Γ(U) ⊗[k] Γ(V) ≅ Γ((X ⊗ T).left, 𝔚 U V)`. The `k`-algebra structures
  on the

  factors are `Over.sectionsAlgebra`.'
file: AlgebraicJacobian/Curve/ProductCharts.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.productChartSectionsIso
type: lean
updated: '2026-07-31T20:15:19'
---
noncomputable def productChartSectionsIso {U : X.left.Opens} {V : T.left.Opens}
    (hU : IsAffineOpen U) (hV : IsAffineOpen V) :
    CommRingCat.of (Γ(X.left, U) ⊗[k] Γ(T.left, V)) ≅
      Γ((X ⊗ T).left, productChart X T U V) :=
  (CommRingCat.isPushout_tensorProduct k Γ(X.left, U) Γ(T.left, V)).isoIsPushout _ _
    (isPushout_algebraMap_productChart X T hU hV)