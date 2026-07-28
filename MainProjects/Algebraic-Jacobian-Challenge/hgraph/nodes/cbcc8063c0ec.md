---
author: sync
content_type: lemma
created: '2026-07-29T02:01:52'
decl: AlgebraicGeometry.StableGroupAction.act_mul_hom
docstring: Multiplicativity, in the composition order `Aut` gives.
file: AlgebraicJacobian/Albanese/StableAffineCoverGroup.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.StableGroupAction.act_mul_hom
type: lean
updated: '2026-07-29T02:01:52'
---
lemma act_mul_hom (g t : G) : (act (g * t)).hom = (act t).hom ≫ (act g).hom := by
  rw [map_mul]; rfl