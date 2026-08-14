---
author: sync
content_type: theorem
created: '2026-08-14T07:25:47'
decl: AlgebraicGeometry.canonicalRankOneSection_layer
file: AlgebraicJacobian/Picard/Pic0RankOneCanonicalEvaluation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.canonicalRankOneSection_layer
type: lean
updated: '2026-08-14T07:25:47'
---
theorem canonicalRankOneSection_layer {T : Over (Spec (.of k))}
    (lam : (PicRankOneOpen (divRepAffP1Map C)).obj (op T)) :
    (abelDivAffTrans C (genus C)).app (op T)
        (canonicalRankOneSection lam.1 lam.2) = lam.1 := by
  apply Subtype.ext
  exact canonicalRankOneSection_abel lam.1 lam.2