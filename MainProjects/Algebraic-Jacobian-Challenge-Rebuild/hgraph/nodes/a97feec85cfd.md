---
author: sync
content_type: theorem
created: '2026-08-13T12:33:46'
decl: AlgebraicGeometry.existsUnique_abel_divFamZarAff_of_presentation
docstring: 'The unique Abel-correct divisor of a rank-one local presentation, with
  the uniqueness

  interface discharged.'
file: AlgebraicJacobian/Picard/Pic0RankOneUniquenessDischarge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.existsUnique_abel_divFamZarAff_of_presentation
type: lean
updated: '2026-08-13T12:33:46'
---
theorem existsUnique_abel_divFamZarAff_of_presentation
    (hlam : lam ∈ (PicRankOneOpen pi).obj (op (overSpec k A)))
    (P : PicRankOneLocalPresentation pi lam) [IsNoetherianRing P.cover.Carrier] :
    ∃! F : DivFamZarAff C A (genus C),
      abelDivAffPlus C A F = picEtAffineEquiv C A lam.1 :=
  existsUnique_abel_divFamZarAff_of_localPresentation pi
    (rankOneDivisorUniqueness pi) hlam P