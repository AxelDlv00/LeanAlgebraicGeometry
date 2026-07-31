---
author: sync
content_type: theorem
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.AffCoverData.hasAffineOverlaps_of_isProper
docstring: '**`HasAffineOverlaps` is FREE for a proper `C`** — which is the only case
  the DD-R lane

  ever uses.  The relative curve over a proper `C` is a separated scheme, so its affine
  opens are

  closed under intersection (`Over.isAffineOpen_inf`, via the affine diagonal).


  So the `hinf` threading below is bookkeeping, not a standing assumption: it is dischargeable

  wherever `C` is proper, and it is stated rather than assumed so that a reader can
  see the cost

  of `AffCoverData` demanding affineness of the pieces only.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffMapAlg.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffCoverData.hasAffineOverlaps_of_isProper
type: lean
updated: '2026-07-31T20:15:23'
---
theorem AffCoverData.hasAffineOverlaps_of_isProper [IsProper C.hom] (D : AffCoverData C R) :
    D.HasAffineOverlaps := fun i j =>
  Over.isAffineOpen_inf (A := R) C (D.isAffineOpen i) (D.isAffineOpen j)

/-! ## Witness transport along a tower -/