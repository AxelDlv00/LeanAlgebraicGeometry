---
author: sync
content_type: theorem
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivisorAdaptation.thetaSpan_mul_thetaInvSpan_le_one
docstring: 'Products of `Θᵃ`- and `Θ⁻ᵃ`-sections are untwisted: the pairing lands
  in the

  equalizer algebra.'
file: AlgebraicJacobian/Picard/DivisorFamilyThetaRank.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.thetaSpan_mul_thetaInvSpan_le_one
type: lean
updated: '2026-07-29T15:26:35'
---
theorem thetaSpan_mul_thetaInvSpan_le_one :
    A.thetaSpan a * A.thetaInvSpan a ≤ 1 := by
  rw [Submodule.mul_le]
  intro s hs t ht
  have hmul := A.mul_mem_unitGluedSubmodule
    (A.mem_thetaSpan_iff a |>.mp hs) (A.mem_thetaInvSpan_iff a |>.mp ht)
  rw [mul_inv_cancel, unitGluedSubmodule_one] at hmul
  rw [Submodule.one_eq_range]
  exact ⟨⟨s * t, hmul⟩, rfl⟩