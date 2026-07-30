---
author: sync
content_type: theorem
created: '2026-07-30T10:26:46'
decl: AlgebraicJacobian.GaloisDescent.SemilinearAction.powers_map_eq_forces_pow
docstring: '**`powers_map_eq`''s hypothesis is not decoration, and this is the measurement.**


  A failing `exact?` on the invariance-free version of `powers_map_eq` would prove

  only that no *one-lemma* proof exists — a much weaker fact on a composite goal.

  So the non-vacuity is recorded as a theorem instead: the conclusion of

  `powers_map_eq` **forces** `γ • N` to be a power of `N`. Hence for any `N` whose

  `γ`-image is not a power of it, `powers_map_eq`''s conclusion is *false*, and every

  construction below genuinely needs `hN` rather than merely mentioning it.'
file: AlgebraicJacobian/Picard/GaloisDescent/InvariantsLocalization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.SemilinearAction.powers_map_eq_forces_pow
type: lean
updated: '2026-07-30T10:26:46'
---
theorem powers_map_eq_forces_pow (N : A) (γ : L ≃ₐ[K] L)
    (h : Submonoid.map (MulSemiringAction.toRingAut (L ≃ₐ[K] L) A γ).toMonoidHom
      (Submonoid.powers N) = Submonoid.powers N) :
    ∃ n : ℕ, N ^ n = γ • N := by
  rw [powers_map] at h
  have hmem : (γ • N) ∈ Submonoid.powers N := by
    rw [← h]; exact Submonoid.mem_powers _
  simpa [Submonoid.mem_powers_iff] using hmem

variable (N : A) (hN : ∀ γ : L ≃ₐ[K] L, γ • N = N)
variable (S : Type v) [CommRing S] [Algebra A S] [IsLocalization.Away N S]