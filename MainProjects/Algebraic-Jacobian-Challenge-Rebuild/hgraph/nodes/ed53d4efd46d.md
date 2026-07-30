---
author: sync
content_type: lemma
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.FinCoverData.toAffCoverData_pieces
file: AlgebraicJacobian/Picard/DivisorFamilyAffCover.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.FinCoverData.toAffCoverData_pieces
type: lean
updated: '2026-07-30T15:28:05'
---
lemma toAffCoverData_pieces (j : Fin (D.m₀ + D.m₁)) :
    D.toAffCoverData.pieces j = D.pieces (finSumFinEquiv.symm j) := rfl