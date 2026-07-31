---
author: sync
content_type: theorem
created: '2026-07-21T19:32:21'
decl: AlgebraicGeometry.PointwiseAchiever.fibre_germ_mem_span_pointwiseSectionVector_local
docstring: 'The pointwise achiever generates every universal-window reading in the
  residue-fibre

  stalk.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivPointwiseFibreLocal.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.PointwiseAchiever.fibre_germ_mem_span_pointwiseSectionVector_local
type: lean
updated: '2026-07-31T20:14:52'
---
theorem fibre_germ_mem_span_pointwiseSectionVector_local
    (z : relCurve C RZ)
    (hzg : relCurveResiduePoint C RZ z ≠
      genericPoint (relCurve C (relCurveBasePoint C RZ z).asIdeal.ResidueField))
    (b : Bool) (hz : z ∈ relPinnedChart C RZ π b)
    {xψ : RZ ⊗[k] ↥(Scheme.divisorSections k
      (windowM_choice π hπ g • fiberWeilDivisor π) ⊤)}
    (hxψ : xψ ∈ (divUniversalFstWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule) :
    pointwiseFibreReadGerm C hπ g r₁ r₂ b₁ b₂ i j z b hz xψ ∈
      Ideal.span {pointwiseFibreReadGerm C hπ g r₁ r₂ b₁ b₂ i j z b hz
        (pointwiseSectionVector C hπ g r₁ r₂ b₁ b₂ i j hO hχ z)} := by
  by_cases hxψzero : windowCompare RZ
      (relCurveBasePoint C RZ z).asIdeal.ResidueField xψ = 0
  · unfold pointwiseFibreReadGerm
    simp [hxψzero]
  exact Ideal.mem_span_singleton.mpr
    (pointwiseFibreReadGerm_dvd_of_ne
      C hπ g r₁ r₂ b₁ b₂ i j hO hχ z hzg b hz hxψ hxψzero)

set_option maxHeartbeats 8000000 in
-- This clears the fibre-stalk denominator and transports two dependent readings through
-- the chart base-change equivalence.
set_option synthInstance.maxHeartbeats 800000 in
set_option maxSynthPendingDepth 8 in
set_option maxRecDepth 8000 in