---
author: sync
content_type: theorem
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.AffCoverData.flat_sections_pieces_inf
docstring: 'Piece overlaps are affine (the relative curve is separated over `Spec
  R`, being proper),

  so the overlap section rings are flat too — the widened

  `FinCoverData.flat_sections_pieces_inf`.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffCoverData.flat_sections_pieces_inf
type: lean
updated: '2026-07-29T15:31:43'
---
theorem flat_sections_pieces_inf (i j : D.index)
    (hinf : IsAffineOpen (D.pieces i ⊓ D.pieces j)) :
    Module.Flat R Γ(relCurve C R, D.pieces i ⊓ D.pieces j) :=
  flat_sections_isAffineOpen C R hinf

end AffCoverData

/-! ## The optional chart typing, for the Θ-layer only -/