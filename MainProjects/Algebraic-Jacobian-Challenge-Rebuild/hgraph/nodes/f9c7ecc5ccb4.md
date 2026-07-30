---
author: sync
content_type: definition
created: '2026-07-30T15:46:03'
decl: AlgebraicGeometry.AffAdaptation.thetaPieceSectionsModel
docstring: 'A canonical choice of the finite projective invertible sections model
  of the

  intrinsic theta line bundle on the widened affine piece `j`.  The choice internally

  refines the arbitrary piece by basic opens subordinate to the theta cover; it does
  not

  type the piece itself into either pinned chart.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaRestriction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.thetaPieceSectionsModel
type: lean
updated: '2026-07-30T15:46:03'
---
noncomputable def thetaPieceSectionsModel (_A : AffAdaptation D d) (a : ℕ) (j : D.index) :
    (thetaChartDatum C R π a).AffineSectionsModel (D.pieces j) :=
  Classical.choice ((thetaChartDatum C R π a).nonempty_affineSectionsModel
    (D.pieces j) (D.isAffineOpen j))

/-- The piece-ring action on intrinsic theta sections selected by
`thetaPieceSectionsModel`. -/
@[reducible]