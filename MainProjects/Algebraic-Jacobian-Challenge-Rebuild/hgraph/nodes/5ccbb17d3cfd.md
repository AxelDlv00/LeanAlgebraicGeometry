---
author: sync
content_type: theorem
created: '2026-08-03T08:02:46'
decl: AlgebraicGeometry.divUniversalFibreHighWindow_one_at
docstring: Stage one of the decoupled high-window fibre is the second universal window.
file: AlgebraicJacobian/Picard/DivSchemeHighWindowPersistence.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalFibreHighWindow_one_at
type: lean
updated: '2026-08-18T20:50:58'
---
theorem divUniversalFibreHighWindow_one_at {gamma : ℕ}
    (hgamma : gamma ≤ g)
    (hχgamma : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ))
    (hkerGamma : divCarveIdeal k (windowS_choice pi hpi g • fiberWeilDivisor pi)
        (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1 b2 i j
      ≤ RingHom.ker (algebraMap (PairChartRing k g r1 g r2 i j) K)) :
    divUniversalFibreHighWindow_at
        C hpi g r1 r2 b1 b2 i j K hgamma hχgamma hkerGamma 1 =
      divUniversalFibreK' C hpi g r1 r2 b2 i j K := by
  rw [divUniversalFibreHighWindow_at, one_nsmul]
  exact (divUniversalFibreDivisor_spec_at
    C hpi g r1 r2 b1 b2 i j K hgamma hχgamma hkerGamma).2.2.2.symm

set_option maxHeartbeats 1600000 in