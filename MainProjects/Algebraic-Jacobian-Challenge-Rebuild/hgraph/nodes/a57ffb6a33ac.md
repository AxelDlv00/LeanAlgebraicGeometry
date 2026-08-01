---
author: sync
content_type: theorem
created: '2026-08-01T11:57:32'
decl: AlgebraicGeometry.AffAdaptation.thetaTripleOpen_le_pair23
docstring: The triple intersection lies in the second/third pairwise intersection.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaTriple.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.thetaTripleOpen_le_pair23
type: lean
updated: '2026-08-01T13:18:13'
---
theorem thetaTripleOpen_le_pair23 (A : AffAdaptation D d) (i j l : D.index) :
    A.thetaTripleOpen i j l ≤ D.pieces j ⊓ D.pieces l := by
  intro x hx
  exact ⟨hx.1.2, hx.2⟩