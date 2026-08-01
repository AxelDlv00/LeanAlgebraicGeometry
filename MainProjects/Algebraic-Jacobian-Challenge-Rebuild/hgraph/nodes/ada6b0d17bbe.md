---
author: sync
content_type: theorem
created: '2026-08-01T11:57:32'
decl: AlgebraicGeometry.AffAdaptation.isAffineOpen_thetaTripleOpen
docstring: A triple intersection of widened affine pieces is affine.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaTriple.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.isAffineOpen_thetaTripleOpen
type: lean
updated: '2026-08-01T13:18:13'
---
theorem isAffineOpen_thetaTripleOpen (A : AffAdaptation D d)
    (i j l : D.index) : IsAffineOpen (A.thetaTripleOpen i j l) :=
  Over.isAffineOpen_inf C
    (D.hasAffineOverlaps_of_isProper i j) (D.isAffineOpen l)