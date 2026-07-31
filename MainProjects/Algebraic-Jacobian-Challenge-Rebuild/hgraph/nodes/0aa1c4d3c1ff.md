---
author: sync
content_type: definition
created: '2026-07-30T22:26:25'
decl: AlgebraicGeometry.AffAdaptation.eqnDiv
docstring: The cofactor of a section vanishing along `d` over a widened piece equation.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaKernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.eqnDiv
type: lean
updated: '2026-07-31T20:15:24'
---
noncomputable def eqnDiv (A : AffAdaptation D d) (j : D.index)
    {W : (relCurve C R).Opens} (hW : W ≤ D.pieces j) (s : Γ(relCurve C R, W))
    (hs : ∀ (z : relCurve C R) (hz : z ∈ W),
      ((relCurve C R).presheaf.germ W z hz).hom s ∈ d.stalkIdeal z) :
    Γ(relCurve C R, W) :=
  (A.existsUnique_eqn_mul_eq j hW hs).choose