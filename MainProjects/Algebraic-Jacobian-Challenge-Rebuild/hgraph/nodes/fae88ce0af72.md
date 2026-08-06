---
author: sync
content_type: theorem
created: '2026-08-03T08:02:46'
decl: AlgebraicGeometry.divRepAffP1Map_comp
docstring: The chosen map is a morphism over the base field.
file: AlgebraicJacobian/Picard/DivRepAffChallenge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divRepAffP1Map_comp
type: lean
updated: '2026-08-07T05:01:47'
---
theorem divRepAffP1Map_comp :
    divRepAffP1Map C ≫ P1.structureMap k = C.hom :=
  (exists_isFinite_isDominant_toP1 (C := C)).choose_spec.2.2