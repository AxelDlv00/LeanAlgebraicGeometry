---
author: sync
content_type: lemma
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.pointLattice_mono
docstring: 'The one-point lattices are monotone: a larger bound admits more functions.'
file: AlgebraicJacobian/RiemannRoch/Ledger/Devissage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pointLattice_mono
type: lean
updated: '2026-07-28T18:12:20'
---
lemma pointLattice_mono {m n : ℤ} (h : m ≤ n) : pointLattice K hx m ≤ pointLattice K hx n := by
  intro g hg
  rw [mem_pointLattice] at hg ⊢
  refine le_trans hg ?_
  exact_mod_cast Multiplicative.ofAdd_le.mpr h