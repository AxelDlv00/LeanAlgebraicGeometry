---
author: sync
content_type: definition
created: '2026-07-30T17:24:12'
decl: AlgebraicGeometry.AffAdaptation.ThetaPieceQuotient
docstring: Intrinsic theta sections restricted to the divisor on one widened piece.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.ThetaPieceQuotient
type: lean
updated: '2026-07-30T17:24:12'
---
noncomputable abbrev ThetaPieceQuotient (A : AffAdaptation D d) (a : ℕ)
    (j : D.index) : Type u :=
  letI : Module Γ(relCurve C R, D.pieces j)
      (A.ThetaPieceSections (π := π) a j) :=
    A.thetaPieceSectionsModule (π := π) a j
  A.ThetaPieceSections (π := π) a j ⧸ A.thetaPieceVanishing (π := π) a j