---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.CombinatorialCech.cons_comp_zero_succAbove
docstring: 'Deleting the prepended index `r` (the `0`-th coface of `Fin.cons r σ`)

  recovers `σ`.'
file: AlgebraicJacobian/Cohomology/CechAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.CombinatorialCech.cons_comp_zero_succAbove
type: lean
updated: '2026-07-16T21:14:25'
---
lemma cons_comp_zero_succAbove {m : ℕ} (σ : Fin m → ι) :
    (Fin.cons r σ : Fin (m + 1) → ι) ∘ (0 : Fin (m + 1)).succAbove = σ := by
  funext i; simp