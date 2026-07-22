---
author: sync
content_type: theorem
created: '2026-07-19T14:01:14'
decl: AlgebraicGeometry.divOf_msCoherenceUnit
docstring: '**The divisor of the coherence unit is the transported-window discrepancy**:

  `div (u_s·u_M·u_{M+s}⁻¹) = T(M+s) − (N + S)` — the theta-divisor terms cancel by
  the

  exponent additivity `thetaFieldDivisor_add`.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivAssemble.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divOf_msCoherenceUnit
type: lean
updated: '2026-07-19T14:31:14'
---
theorem divOf_msCoherenceUnit :
    windowTransportDivisor C K π (windowM_choice π hπ g + windowS_choice π hπ g)
        - (windowN C K hπ g + windowS C K hπ g)
      = Scheme.divOf (relCurve C K ↘ Spec (CommRingCat.of K))
          (msCoherenceUnit C K hπ g) := by
  have hinv : Scheme.divOf (relCurve C K ↘ Spec (CommRingCat.of K))
        (thetaFieldShiftUnit C K π (windowM_choice π hπ g + windowS_choice π hπ g))⁻¹
      = -Scheme.divOf (relCurve C K ↘ Spec (CommRingCat.of K))
          (thetaFieldShiftUnit C K π
            (windowM_choice π hπ g + windowS_choice π hπ g)) := by
    have h0 := Scheme.divOf_mul (relCurve C K ↘ Spec (CommRingCat.of K))
      (thetaFieldShiftUnit C K π (windowM_choice π hπ g + windowS_choice π hπ g))
      (thetaFieldShiftUnit C K π (windowM_choice π hπ g + windowS_choice π hπ g))⁻¹
    rw [mul_inv_cancel, Scheme.divOf_one] at h0
    exact (neg_eq_of_add_eq_zero_right h0.symm).symm
  rw [msCoherenceUnit, Scheme.divOf_mul, Scheme.divOf_mul, hinv,
    ← divOf_thetaFieldShiftUnit C K π (windowS_choice π hπ g),
    ← divOf_thetaFieldShiftUnit C K π (windowM_choice π hπ g),
    ← divOf_thetaFieldShiftUnit C K π (windowM_choice π hπ g + windowS_choice π hπ g),
    thetaFieldDivisor_add C K π (windowM_choice π hπ g) (windowS_choice π hπ g),
    show windowN C K hπ g
      = windowTransportDivisor C K π (windowM_choice π hπ g) from rfl,
    show windowS C K hπ g
      = windowTransportDivisor C K π (windowS_choice π hπ g) from rfl]
  abel