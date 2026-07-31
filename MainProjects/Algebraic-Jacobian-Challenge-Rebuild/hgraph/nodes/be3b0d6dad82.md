---
author: sync
content_type: theorem
created: '2026-07-17T18:01:32'
decl: AlgebraicGeometry.PicEtAff.baseFieldShuffle_symm_mk
file: AlgebraicJacobian/Picard/PicEtAffBaseFieldShuffle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicEtAff.baseFieldShuffle_symm_mk
type: lean
updated: '2026-07-31T20:15:27'
---
theorem baseFieldShuffle_symm_mk (U : Algebra.EtaleCover A)
    (x : descentClasses ((baseChange k L).obj C) U) :
    (baseFieldShuffle k L C A).symm (mk ((baseChange k L).obj C) U x)
      = mk C U ((crossBaseTransportFamilyInv k L C).descentHom U x) :=
  rfl

/-- The descent-class transport of the forward family is B-4a's `relPicCrossBase` on the
underlying relative Picard classes — the mk-level identification consumed by B-4b's
degree matching (route through `relPicDeg_relPicCrossBase`). -/
@[simp]