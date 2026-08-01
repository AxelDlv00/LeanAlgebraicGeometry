---
author: sync
content_type: theorem
created: '2026-07-27T12:04:46'
decl: AlgebraicGeometry.Scheme.LocalEquations.fibre_supportLocus_finite_of_pullback_support_eq
docstring: 'If a local-equation system pulls back to a regular system on the residue
  curve, then its

  support fibre is finite. This isolates the exact noncircular input needed by fibre
  avoidance:

  regularity after residue-field pullback.'
file: AlgebraicJacobian/Picard/DivSchemeCertZarFibreAvoid.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.LocalEquations.fibre_supportLocus_finite_of_pullback_support_eq
type: lean
updated: '2026-08-01T09:44:11'
---
theorem fibre_supportLocus_finite_of_pullback_support_eq
    (d : (relCurve C R).LocalEquations) (p : PrimeSpectrum R)
    (dK : (relCurve C p.asIdeal.ResidueField).LocalEquations)
    (hsupport : dK.supportLocus =
      (relCurveMap C R p.asIdeal.ResidueField).base ⁻¹' d.supportLocus) :
    (((relCurve C R) ↘ Spec (.of R)).base ⁻¹' {p} ∩
      d.supportLocus).Finite := by
  letI : SmoothOfRelativeDimension 1
      (relCurve C p.asIdeal.ResidueField ↘
        Spec (CommRingCat.of p.asIdeal.ResidueField)) :=
    instSmoothOfRelativeDimensionBaseChange C p.asIdeal.ResidueField
  letI : IsIntegral (relCurve C p.asIdeal.ResidueField) :=
    instIsIntegralBaseChange C p.asIdeal.ResidueField
  letI : QuasiCompact
      (relCurve C p.asIdeal.ResidueField ↘
        Spec (CommRingCat.of p.asIdeal.ResidueField)) :=
    instQuasiCompactBaseChange C p.asIdeal.ResidueField
  have hfinite := supportLocus_finite_on_curve p.asIdeal.ResidueField dK
  have heq :
      ((relCurve C R) ↘ Spec (.of R)).base ⁻¹' {p} ∩ d.supportLocus =
        (relCurveMap C R p.asIdeal.ResidueField).base '' dK.supportLocus := by
    ext x
    constructor
    · rintro ⟨hxp, hxd⟩
      change relCurveBasePoint C R x = p at hxp
      have hxrange :
          x ∈ Set.range (relCurveMap C R p.asIdeal.ResidueField).base := by
        rw [range_relCurveMap_residueField C R p]
        exact hxp
      obtain ⟨z, rfl⟩ := hxrange
      refine ⟨z, ?_, rfl⟩
      rw [hsupport]
      exact hxd
    · rintro ⟨z, hz, rfl⟩
      constructor
      · change relCurveBasePoint C R
          ((relCurveMap C R p.asIdeal.ResidueField).base z) = p
        exact relCurveBasePoint_relCurveMap_residueField C R p z
      · rw [hsupport] at hz
        exact hz
  rw [heq]
  exact hfinite.image (relCurveMap C R p.asIdeal.ResidueField).base