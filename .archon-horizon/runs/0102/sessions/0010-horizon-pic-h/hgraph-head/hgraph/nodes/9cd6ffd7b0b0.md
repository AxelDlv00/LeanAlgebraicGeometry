---
author: sync
content_type: definition
created: '2026-08-01T05:12:59'
decl: AlgebraicGeometry.AffAdaptation.divisorSubschemeι
docstring: The closed immersion of the divisor subscheme into the relative curve.
file: AlgebraicJacobian/Picard/DivisorSubscheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.divisorSubschemeι
type: lean
updated: '2026-08-01T09:44:14'
---
noncomputable abbrev divisorSubschemeι (A : AffAdaptation D d) :
    A.divisorSubscheme ⟶ relCurve C R :=
  A.cartierIdeal.subschemeι