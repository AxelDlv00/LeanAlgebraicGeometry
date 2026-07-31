---
author: sync
content_type: lemma
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.Over.algebraMap_testPointFieldAffine
file: AlgebraicJacobian/Picard/Pic0ChartTestPoint.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.algebraMap_testPointFieldAffine
type: lean
updated: '2026-07-31T20:14:52'
---
lemma algebraMap_testPointFieldAffine (t : (overSpec k A).left) :
    algebraMap A (testPointField (T := overSpec k A) t)
      = (Spec.preimage ((overSpec k A).left.fromSpecResidueField t)).hom :=
  rfl