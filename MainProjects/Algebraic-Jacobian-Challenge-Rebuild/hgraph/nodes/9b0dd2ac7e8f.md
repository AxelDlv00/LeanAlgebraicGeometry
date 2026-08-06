---
author: sync
content_type: theorem
created: '2026-08-01T13:31:19'
decl: AlgebraicGeometry.AffAdaptation.isAffineOpen_divisorPreimageAffine
docstring: The inverse image in the divisor subscheme of any affine ambient open is
  affine.
file: AlgebraicJacobian/Picard/DivisorSubschemeTriple.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.isAffineOpen_divisorPreimageAffine
type: lean
updated: '2026-08-07T05:01:53'
---
theorem isAffineOpen_divisorPreimageAffine [IsProper C.hom]
    (A : AffAdaptation D d) (U : (relCurve C R).affineOpens) :
    IsAffineOpen (A.divisorSubschemeι ⁻¹ᵁ (U : (relCurve C R).Opens)) := by
  rw [← A.cartierIdeal.opensRange_subschemeCover_map U]
  exact isAffineOpen_opensRange _