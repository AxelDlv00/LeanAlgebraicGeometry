---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.P1.overlapSectionsEquiv
docstring: 'The identification of the section ring of the chart overlap `D₊(X₀X₁)`
  with the Laurent

  polynomial ring, `T = X₁/X₀`.'
file: AlgebraicJacobian/Curve/P1Charts.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.overlapSectionsEquiv
type: lean
updated: '2026-07-30T15:46:00'
---
noncomputable def overlapSectionsEquiv :
    Γ(P1 k, Proj.basicOpen 𝒜 (X 0 * X 1)) ≃+* LaurentPolynomial k :=
  ((Proj.basicOpenIsoAway 𝒜 (X 0 * X 1)
    (X_mul_X_mem k) two_pos).commRingCatIsoToRingEquiv).symm.trans
    (overlapAlgEquiv k).toRingEquiv