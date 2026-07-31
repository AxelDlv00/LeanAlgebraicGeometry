---
author: sync
content_type: theorem
created: '2026-07-17T18:01:32'
decl: AlgebraicGeometry.PicEtAff.baseFieldShuffle_unit
docstring: 'The base-field shuffle is compatible with the unit of the plus construction:
  on

  classes pulled back to the trivial cover it is B-4a''s relPic-level shuffle.'
file: AlgebraicJacobian/Picard/PicEtAffBaseFieldShuffle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicEtAff.baseFieldShuffle_unit
type: lean
updated: '2026-07-31T20:15:27'
---
theorem baseFieldShuffle_unit (x : relPic C (overSpec k A)) :
    baseFieldShuffle k L C A (unit C A x)
      = unit ((baseChange k L).obj C) A (relPicCrossBase k L C A x) :=
  (crossBaseTransportFamily k L C).picEtAffHom_unit x