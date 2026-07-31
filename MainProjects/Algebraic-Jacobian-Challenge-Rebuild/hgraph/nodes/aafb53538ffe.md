---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.PicEtAff.mk
docstring: The plus class of a relative Picard class with a descent condition on a
  cover.
file: AlgebraicJacobian/Picard/PicEtAff.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.PicEtAff.mk
type: lean
updated: '2026-07-31T20:14:49'
---
def mk (E : Algebra.EtaleCover A) (x : descentClasses C E) : PicEtAff C A :=
  Quotient.mk _ ⟨E, x⟩

@[elab_as_elim]