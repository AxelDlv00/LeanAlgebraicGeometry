---
author: sync
content_type: definition
created: '2026-08-01T05:12:59'
decl: AlgebraicGeometry.AffAdaptation.divisorPieceMap
docstring: The colength spectrum of one adapted piece, mapped into the divisor subscheme.
file: AlgebraicJacobian/Picard/DivisorSubscheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.divisorPieceMap
type: lean
updated: '2026-08-01T09:44:14'
---
noncomputable def divisorPieceMap [IsProper C.hom]
    (A : AffAdaptation D d) (i : D.index) :
    Spec (.of (A.colength i)) ⟶ A.divisorSubscheme :=
  Spec.map (A.divisorPieceQuotientEquiv i).toRingEquiv.toCommRingCatIso.hom ≫
    A.cartierIdeal.subschemeCover.f ⟨D.pieces i, D.isAffineOpen i⟩