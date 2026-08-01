---
author: sync
content_type: lemma
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.FinCoverData.toAffCoverData_pieces
file: AlgebraicJacobian/Picard/DivisorFamilyAffCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FinCoverData.toAffCoverData_pieces
type: lean
updated: '2026-08-01T09:44:13'
---
lemma toAffCoverData_pieces (j : Fin (D.m₀ + D.m₁)) :
    D.toAffCoverData.pieces j = D.pieces (finSumFinEquiv.symm j) := rfl