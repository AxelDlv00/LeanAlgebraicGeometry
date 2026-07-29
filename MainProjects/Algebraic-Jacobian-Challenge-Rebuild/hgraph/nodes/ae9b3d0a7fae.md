---
author: sync
content_type: theorem
created: '2026-07-22T03:01:55'
decl: AlgebraicGeometry.thetaSectionPair_thetaWindowMul
file: AlgebraicJacobian/Picard/DivSchemeThetaCoordinateRecurrence.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.thetaSectionPair_thetaWindowMul
type: lean
updated: '2026-07-29T15:31:43'
---
theorem thetaSectionPair_thetaWindowMul (p q : Nat)
    (a : ↥(divisorSections k (p • F) ⊤))
    (m : ↥(divisorSections k (q • F) ⊤)) :
    thetaSectionPair C pi (p + q)
        (thetaWindowMul (C := C) (pi := pi) p q a m) =
      thetaSectionPairMul (C := C) pi p q
        (thetaSectionPair C pi p a) (thetaSectionPair C pi q m) := by
  apply Subtype.ext
  apply Prod.ext
  · simpa [thetaSectionPairMul] using
      (thetaSectionPair_thetaWindowMul_fst C pi p q a m)
  · simpa [thetaSectionPairMul] using
      (thetaSectionPair_thetaWindowMul_snd C pi p q a m)

@[simp]