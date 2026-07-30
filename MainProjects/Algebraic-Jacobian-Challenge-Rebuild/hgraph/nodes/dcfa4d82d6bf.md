---
author: sync
content_type: definition
created: '2026-07-29T02:23:55'
decl: AlgebraicGeometry.divFamZarAff.mapVal
docstring: The value of the restricted widened family at an affine open of the source.
file: AlgebraicJacobian/Picard/DivisorFamilyAffMap.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divFamZarAff.mapVal
type: lean
updated: '2026-07-30T15:28:04'
---
noncomputable def mapVal (f : T' ⟶ T) (s : divFamZarAff C n T)
    (W : T'.left.affineOpens) : DivFamZarAff C Γ(T'.left, W.1) n :=
  (existsUnique_isPullbackValue f s W).choose