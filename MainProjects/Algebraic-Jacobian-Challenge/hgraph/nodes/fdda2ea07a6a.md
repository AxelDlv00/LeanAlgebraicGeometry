---
author: sync
content_type: theorem
created: '2026-08-03T08:55:17'
decl: AlgebraicJacobian.TwoTermFiniteReplacement.fiberVirtualRank_independent
docstring: 'The virtual fibre rank `(rank_t R.K0 : Int) - R.n` is independent of the

  chosen finite replacement of the same original map.  Both sides equal the

  signed kernel/cokernel index of that original map.'
file: AlgebraicJacobian/Picard/TwoTermEulerIndex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.TwoTermFiniteReplacement.fiberVirtualRank_independent
type: lean
updated: '2026-08-03T08:55:17'
---
theorem fiberVirtualRank_independent
    {A : Type u} [CommRing A]
    {M0 M1 : Type u} [AddCommGroup M0] [Module A M0]
    [AddCommGroup M1] [Module A M1] {d : M0 →ₗ[A] M1}
    (R R' : TwoTermFiniteReplacement d) (t : PrimeSpectrum A) :
    (t.asIdeal.fiberRank R.K0 : ℤ) - (R.n : ℤ) =
      (t.asIdeal.fiberRank R'.K0 : ℤ) - (R'.n : ℤ) := by
  rw [← R.fiberEulerIndex_eq_virtualRank t,
    ← R'.fiberEulerIndex_eq_virtualRank t]