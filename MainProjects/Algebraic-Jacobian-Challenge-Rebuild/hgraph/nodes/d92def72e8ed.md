---
author: sync
content_type: definition
created: '2026-08-01T11:57:32'
decl: AlgebraicGeometry.AffAdaptation.thetaTripleIdeal
docstring: The intrinsic Cartier ideal on a triple intersection.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaTriple.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.thetaTripleIdeal
type: lean
updated: '2026-08-02T07:12:51'
---
noncomputable abbrev thetaTripleIdeal (A : AffAdaptation D d)
    (i j l : D.index) : Ideal Γ(relCurve C R, A.thetaTripleOpen i j l) :=
  A.cartierIdeal.ideal (A.thetaTripleAffineOpen i j l)

/-- Theta sections killed by the intrinsic divisor on a triple intersection. -/
@[reducible]