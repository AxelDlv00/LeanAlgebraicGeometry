---
author: sync
content_type: definition
created: '2026-08-05T04:36:57'
decl: AlgebraicGeometry.PicRankOneLocalPresentation.h0BaseChange
docstring: 'The canonical `H^0` base-change equivalence attached to a rank-one presentation.


  This is derived from `P.h1_vanishing`; it is not an independently chosen witness.'
file: AlgebraicJacobian/Picard/Pic0RankOnePresentation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRankOneLocalPresentation.h0BaseChange
type: lean
updated: '2026-08-14T15:29:31'
---
noncomputable def h0BaseChange (P : PicRankOneLocalPresentation pi lam)
    (B : Type u) [CommRing B] [Algebra k B] [Algebra P.cover.Carrier B]
    [IsScalarTower k P.cover.Carrier B] :
    B ⊗[P.cover.Carrier] (Sheaf.HModule P.datum.sheaf 0) ≃ₗ[B]
      Sheaf.HModule (P.datum.baseChange B).sheaf 0 :=
  P.datum.datumH0BaseChange B
    ((subsingleton_datumPair_h1_iff P.datum).mpr P.h1_vanishing)