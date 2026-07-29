---
author: sync
content_type: lemma
created: '2026-07-17T21:17:12'
decl: AlgebraicGeometry.fiberEqn_of_mem'
docstring: '`fiberEqn` in `resHom` normal form on the chart-0 members.'
file: AlgebraicJacobian/Cohomology/RelCurveCollapse.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.fiberEqn_of_mem'
type: lean
updated: '2026-07-29T15:26:35'
---
private lemma fiberEqn_of_mem' {z : Y} (h : z ∈ fiberChart₀ π) :
    fiberEqn π a z
      = Y.resHom (le_of_eq (fiberCover_opens_of_mem π h)) ((fiberCoord π) ^ a) :=
  fiberEqn_of_mem π a h

omit [IsIntegral Y] [IsDominant π] in