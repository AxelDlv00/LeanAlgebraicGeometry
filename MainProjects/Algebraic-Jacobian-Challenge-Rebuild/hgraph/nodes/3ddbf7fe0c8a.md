---
author: sync
content_type: theorem
created: '2026-07-30T21:44:02'
decl: AlgebraicGeometry.Scheme.CurveDivisor.not_forall_eq_of_two_le_h0
docstring: '**THE REFUTATION OF UNIQUENESS.**  At `2 ≤ h⁰` no effective divisor of
  the class is *the*

  unique effective representative — the exact negation of the shape a chart-locus
  uniqueness

  statement produces.


  Stated with the uniqueness clause quantified over the same class rather than over
  a fixed

  divisor, because that is the form the consumers use.'
file: AlgebraicJacobian/RiemannRoch/EffectiveNonUniqueness.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.CurveDivisor.not_forall_eq_of_two_le_h0
type: lean
updated: '2026-08-01T09:44:17'
---
theorem CurveDivisor.not_forall_eq_of_two_le_h0
    (hO : Sheaf.h0 (X.moduleKSheaf K) = 1) {A : X.CurveDivisor} (hA : 0 ≤ A)
    (hh0 : 2 ≤ Sheaf.h0 (X.divisorSheaf K A)) :
    ¬ ∃ E : X.CurveDivisor, 0 ≤ E ∧
        CurveDivisor.picClass K E = CurveDivisor.picClass K A ∧
        ∀ E' : X.CurveDivisor, 0 ≤ E' →
          CurveDivisor.picClass K E' = CurveDivisor.picClass K A → E' = E := by
  rintro ⟨E, -, -, hEu⟩
  obtain ⟨D, D', hD, hD', hne, hcl, hcl'⟩ :=
    CurveDivisor.exists_two_effective_picClass_eq_of_two_le_h0 K hO hA hh0
  exact hne ((hEu D hD hcl).trans (hEu D' hD' hcl').symm)