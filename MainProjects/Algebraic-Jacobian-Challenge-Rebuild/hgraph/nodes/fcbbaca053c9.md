---
author: sync
content_type: lemma
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.fiberEqn_of_mem
file: AlgebraicJacobian/RiemannRoch/FiberTwist.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.fiberEqn_of_mem
type: lean
updated: '2026-07-29T15:31:49'
---
lemma fiberEqn_of_mem (n : ℕ) {z : Y} (h : z ∈ fiberChart₀ π) :
    fiberEqn π n z
      = (Y.presheaf.map (homOfLE (le_of_eq (fiberCover_opens_of_mem π h))).op).hom
          ((fiberCoord π) ^ n) :=
  dif_pos h