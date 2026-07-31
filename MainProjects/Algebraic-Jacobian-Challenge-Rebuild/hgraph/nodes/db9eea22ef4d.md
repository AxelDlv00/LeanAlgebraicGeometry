---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.overlapLaurentHom
docstring: 'The `k[T;T⁻¹]`-algebra structure map on the sections of the chart-preimage
  overlap:

  `π`''s map on sections over `D₊(X₀X₁)` composed with the Laurent identification.
  Only used

  as a local `Algebra` instance inside the finiteness argument.'
file: AlgebraicJacobian/Cohomology/Finiteness.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.overlapLaurentHom
type: lean
updated: '2026-07-31T20:15:17'
---
private noncomputable def overlapLaurentHom :
    LaurentPolynomial k →+* Γ(Y, π ⁻¹ᵁ P1.chartOpen k 0 ⊓ π ⁻¹ᵁ P1.chartOpen k 1) :=
  ((π.appLE (Proj.basicOpen 𝒜 (X 0 * X 1)) _ (preimage_overlap_le π)).hom).comp
    (P1.overlapSectionsEquiv k).symm.toRingHom