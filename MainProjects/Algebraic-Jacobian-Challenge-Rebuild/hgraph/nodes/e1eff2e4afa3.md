---
author: sync
content_type: lemma
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.mem_pointLattice_zero_iff
docstring: 'Membership in `L₀` is exactly integrality: `ord_x g ≤ 1`.'
file: AlgebraicJacobian/RiemannRoch/JumpDimension.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.mem_pointLattice_zero_iff
type: lean
updated: '2026-07-30T15:28:05'
---
private lemma mem_pointLattice_zero_iff {g : X.functionField} :
    g ∈ pointLattice K hx 0 ↔ Scheme.ord (X ↘ Spec (CommRingCat.of K)) hx g ≤ 1 := by
  rw [mem_pointLattice, ofAdd_zero, WithZero.coe_one]