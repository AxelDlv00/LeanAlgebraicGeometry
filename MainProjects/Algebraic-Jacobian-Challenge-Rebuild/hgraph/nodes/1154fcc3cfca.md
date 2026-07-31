---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.relThetaResFst_apply
file: AlgebraicJacobian/Picard/DivisorFamilyTheta.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.relThetaResFst_apply
type: lean
updated: '2026-07-31T20:14:40'
---
lemma relThetaResFst_apply {W : (relCurve C R).Opens}
    (hW : W ≤ ⊤ ⊓ (relCover C R (fiberTwoCover π)).V₀) (x : relThetaSections C R π a) :
    relThetaResFst a hW x = (relCurve C R).resHom hW x.val.1 := rfl