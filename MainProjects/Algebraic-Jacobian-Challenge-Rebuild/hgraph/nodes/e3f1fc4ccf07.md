---
author: sync
content_type: definition
created: '2026-08-01T11:57:32'
decl: AlgebraicGeometry.AffAdaptation.tripleColength
docstring: The intrinsic divisor ring on a triple intersection.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaTriple.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.tripleColength
type: lean
updated: '2026-08-01T13:18:15'
---
noncomputable abbrev tripleColength (A : AffAdaptation D d)
    (i j l : D.index) : Type u :=
  Γ(relCurve C R, A.thetaTripleOpen i j l) ⧸ A.thetaTripleIdeal i j l

/-- The triple-colength action on the triple theta quotient. -/
@[reducible]