---
author: sync
content_type: definition
created: '2026-07-30T19:28:43'
decl: AlgebraicGeometry.Adelic.LaurentChartData.pullbackY
docstring: The pullback of the second Laurent coordinate to the second source chart.
file: AlgebraicJacobian/Picard/FiniteMapLaurentGenerators.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.LaurentChartData.pullbackY
type: lean
updated: '2026-07-30T20:02:41'
---
def LaurentChartData.pullbackY (D : LaurentChartData Y) (pi : C ⟶ Y) :
    Γ(C.left, pi.left ⁻¹ᵁ D.V₁) :=
  (pi.left.app D.V₁).hom D.y