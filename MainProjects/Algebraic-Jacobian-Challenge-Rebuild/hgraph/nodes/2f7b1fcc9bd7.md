---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.splitSurj_comp_splitSect
file: AlgebraicJacobian/Picard/EntriesIdeal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.splitSurj_comp_splitSect
type: lean
updated: '2026-07-31T20:15:25'
---
lemma splitSurj_comp_splitSect : splitSurj R N ∘ₗ splitSect R N = LinearMap.id :=
  (Module.Finite.exists_comp_eq_id_of_projective
    R N).choose_spec.choose_spec.choose_spec.2.2