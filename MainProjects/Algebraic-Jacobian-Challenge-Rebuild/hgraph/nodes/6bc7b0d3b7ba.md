---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.grPairStructMap
docstring: The structure morphism of the Grassmannian pair.
file: AlgebraicJacobian/Picard/GrassmannianPair.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Grassmannian.grPairStructMap
type: lean
updated: '2026-07-31T20:14:45'
---
noncomputable def grPairStructMap : grPair k d₁ r₁ d₂ r₂ ⟶ Spec (CommRingCat.of k) :=
  grPairFst k d₁ r₁ d₂ r₂ ≫ grStructMap k d₁ r₁