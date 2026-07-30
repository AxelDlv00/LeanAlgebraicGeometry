---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.PicEtAff.mk_mul_mk
file: AlgebraicJacobian/Picard/PicEtAff.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.PicEtAff.mk_mul_mk
type: lean
updated: '2026-07-30T15:27:58'
---
lemma mk_mul_mk (E F : Algebra.EtaleCover A) (x : descentClasses C E)
    (y : descentClasses C F) :
    mk C E x * mk C F y
      = mk C (E.prod F)
          (descentMap C (E.prodInl F) x * descentMap C (E.prodInr F) y) :=
  rfl