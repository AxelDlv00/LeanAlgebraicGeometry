---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.PicEtAff.descentMap_prodLift_inr
docstring: Transport through a `prodLift` collapses on the right factor.
file: AlgebraicJacobian/Picard/PicEtAff.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicEtAff.descentMap_prodLift_inr
type: lean
updated: '2026-07-16T21:33:28'
---
lemma descentMap_prodLift_inr {E F H : Algebra.EtaleCover A}
    (f : E.Carrier →ₐ[A] H.Carrier) (g : F.Carrier →ₐ[A] H.Carrier)
    (y : descentClasses C F) :
    descentMap C (Algebra.EtaleCover.prodLift f g) (descentMap C (E.prodInr F) y)
      = descentMap C g y := by
  rw [← descentMap_comp, Algebra.EtaleCover.prodLift_comp_prodInr]

set_option maxHeartbeats 4000000 in
-- The `rw` chain unifies `descentMap` nests whose `AlgHom` instance arguments run through
-- quotient and tensor-product carriers; the unifications are heartbeat-hungry.