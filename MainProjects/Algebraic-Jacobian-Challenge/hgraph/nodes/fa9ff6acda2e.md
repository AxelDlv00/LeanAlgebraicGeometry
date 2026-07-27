---
author: sync
content_type: instance
created: '2026-07-27T22:48:27'
decl: AlgebraicGeometry.Adelic.instSmoothOfRelativeDimensionOneP1Over
docstring: '`ℙ¹_k ⟶ Spec k` is smooth of relative dimension one, at the `p1Over` spelling
  the B3

  statements use.  (Instance search does not unfold `(p1Over k).hom` to the structural
  map of

  relative projective space, so the restatement is needed.)'
file: AlgebraicJacobian/Picard/RigidPushforwardP1Witness.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.instSmoothOfRelativeDimensionOneP1Over
type: lean
updated: '2026-07-27T22:48:27'
---
instance instSmoothOfRelativeDimensionOneP1Over :
    SmoothOfRelativeDimension 1 ((p1Over k).hom) :=
  instSmoothOfRelativeDimensionOneP1OverHom

/-! ## §3. The witness -/