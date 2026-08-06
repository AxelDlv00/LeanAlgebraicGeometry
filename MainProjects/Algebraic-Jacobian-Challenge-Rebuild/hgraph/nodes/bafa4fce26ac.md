---
author: sync
content_type: definition
created: '2026-08-03T16:37:44'
decl: AlgebraicGeometry.divRepAffAdmissibleGrassmannianPair
docstring: The explicit Grassmannian-pair ambient space of the admissible divisor
  model.
file: AlgebraicJacobian/Picard/Pic0AdmissibleDivisorQuasiProjective.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divRepAffAdmissibleGrassmannianPair
type: lean
updated: '2026-08-07T05:01:55'
---
noncomputable def divRepAffAdmissibleGrassmannianPair : Over (Spec (.of k)) :=
  grPairOver k
    (divRepAffAdmissibleParameter C) (divRepAffAdmissibleWindowRankOne C)
    (divRepAffAdmissibleParameter C) (divRepAffAdmissibleWindowRankTwo C)