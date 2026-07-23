---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.glueSnd_
docstring: 'The second projection of the cover overlap, composed with the inclusion
  of

  its chart, agrees with the first: the glue condition of the cover glue datum

  over `T.left`.'
file: AlgebraicJacobian/Picard/GrassmannianZariskiSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.glueSnd_
type: lean
updated: '2026-07-16T21:14:27'
---
lemma glueSnd_ι (k l : κ) :
    ((covGD W hW).t k l ≫
        (covGD W hW).f l k) ≫ (W l).ι
      = (covGD W hW).f k l ≫ (W k).ι :=
  gluedCover_glue_base (opensCover T.left W hW) k l