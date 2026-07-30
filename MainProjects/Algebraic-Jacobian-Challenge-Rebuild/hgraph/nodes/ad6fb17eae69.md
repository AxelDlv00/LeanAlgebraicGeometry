---
author: sync
content_type: theorem
created: '2026-07-30T12:49:24'
decl: AlgebraicGeometry.divEq_of_isCertified_zero
docstring: '**Any two degree-zero certified families are divisor-equal**, since both
  cut the zero

  divisor and over a field equal presentation divisors force `DivEq`.'
file: AlgebraicJacobian/Picard/DivisorFamilyDegreeZeroUnique.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divEq_of_isCertified_zero
type: lean
updated: '2026-07-30T12:49:24'
---
theorem divEq_of_isCertified_zero
    {d d' : (relCurve C K).LocalEquations}
    (A : DivisorAdaptation C K pi d) (hc : A.IsCertified 0)
    (A' : DivisorAdaptation C K pi d') (hc' : A'.IsCertified 0) :
    Scheme.LocalEquations.DivEq d d' :=
  Scheme.divEq_of_presentationDivisor_eq K
    ((presentationDivisor_eq_zero_of_isCertified_zero A hc).trans
      (presentationDivisor_eq_zero_of_isCertified_zero A' hc').symm)

/-! ## The quotients are subsingletons -/