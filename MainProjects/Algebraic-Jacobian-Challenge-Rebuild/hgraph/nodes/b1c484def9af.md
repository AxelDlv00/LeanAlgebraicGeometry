---
author: sync
content_type: definition
created: '2026-08-14T10:32:16'
decl: AlgebraicGeometry.canonicalRankOneAbelIso
docstring: The canonical evaluation divisor is inverse to the rank-one Abel map on
  the big site.
file: AlgebraicJacobian/Picard/Pic0RankOneCanonicalEvaluation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.canonicalRankOneAbelIso
type: lean
updated: '2026-08-18T20:51:05'
---
noncomputable def canonicalRankOneAbelIso :
    rankOneDivisorLocus (C := C) (pi := divRepAffP1Map C) ≅
      rankOneLocus (C := C) (pi := divRepAffP1Map C) :=
  (canonicalRankOneEvaluationDivisorData (C := C)).rankOneAbelIso
    (divRepAffP1Map C)