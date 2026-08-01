---
author: sync
content_type: theorem
created: '2026-07-30T08:49:43'
decl: AlgebraicGeometry.bot_ne_top_specObj
docstring: '**`Spec k` has a proper open** — the binder the `⊥` witness could not
  supply.


  `k` is a field, so `Spec k` has a point, so `⊥ ≠ ⊤` there.'
file: AlgebraicJacobian/Picard/Pic0ChartCoverForcesNonInj.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.bot_ne_top_specObj
type: lean
updated: '2026-08-01T09:44:15'
---
theorem bot_ne_top_specObj : (⊥ : (Spec (CommRingCat.of k)).Opens) ≠ ⊤ := by
  intro h
  have hne : Nonempty (Spec (CommRingCat.of k)) :=
    inferInstanceAs (Nonempty (PrimeSpectrum k))
  have hm : hne.some ∈ (⊥ : (Spec (CommRingCat.of k)).Opens) := by rw [h]; trivial
  exact hm

variable (C) in