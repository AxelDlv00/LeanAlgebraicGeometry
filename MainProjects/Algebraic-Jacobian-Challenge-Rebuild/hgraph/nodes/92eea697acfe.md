---
author: sync
content_type: theorem
created: '2026-08-01T13:31:19'
decl: AlgebraicGeometry.AffAdaptation.thetaTripleOpen_le_pair31
docstring: 'The triple intersection lies in the reversed pair consisting of its third
  and first

  pieces.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaCoassoc.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.thetaTripleOpen_le_pair31
type: lean
updated: '2026-08-01T13:31:19'
---
theorem thetaTripleOpen_le_pair31 (i j l : D.index) :
    A.thetaTripleOpen i j l ≤ D.pieces l ⊓ D.pieces i := by
  intro x hx
  exact ⟨hx.2, hx.1.1⟩

omit [IsProper C.hom] in