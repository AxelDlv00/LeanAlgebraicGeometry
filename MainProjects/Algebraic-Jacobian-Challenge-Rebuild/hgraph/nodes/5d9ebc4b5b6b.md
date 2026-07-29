---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.FinCoverData.pieces_inl
file: AlgebraicJacobian/Picard/DivisorFamily.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.FinCoverData.pieces_inl
type: lean
updated: '2026-07-29T15:26:22'
---
lemma pieces_inl (j : Fin D.m₀) :
    D.pieces (Sum.inl j) = (relCurve C R).basicOpen (D.h₀ j) := rfl

@[simp]