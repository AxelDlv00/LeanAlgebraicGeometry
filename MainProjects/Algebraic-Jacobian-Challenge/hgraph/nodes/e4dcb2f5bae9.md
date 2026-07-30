---
author: sync
content_type: definition
created: '2026-07-30T19:28:43'
decl: AlgebraicGeometry.Adelic.LaurentChartData.pullbackX
docstring: The pullback of the first Laurent coordinate to the first source chart.
file: AlgebraicJacobian/Picard/FiniteMapLaurentGenerators.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.LaurentChartData.pullbackX
type: lean
updated: '2026-07-30T20:02:41'
---
def LaurentChartData.pullbackX (D : LaurentChartData Y) (pi : C ⟶ Y) :
    Γ(C.left, pi.left ⁻¹ᵁ D.V₀) :=
  (pi.left.app D.V₀).hom D.x