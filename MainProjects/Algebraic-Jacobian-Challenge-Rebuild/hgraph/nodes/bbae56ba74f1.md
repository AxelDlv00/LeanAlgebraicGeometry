---
author: sync
content_type: theorem
created: '2026-07-21T19:32:21'
decl: AlgebraicGeometry.PointwiseAchiever.exists_fibre_chart_cofactor_pointwiseSectionVector
docstring: 'Fibre-germ generation supplies an affine fibre-chart cofactor, already
  written as

  base-changed total-chart readings.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivPointwiseFibreLocal.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.exists_fibre_chart_cofactor_pointwiseSectionVector
type: lean
updated: '2026-07-31T20:15:23'
---
theorem exists_fibre_chart_cofactor_pointwiseSectionVector
    (z : relCurve C RZ)
    (hzg : relCurveResiduePoint C RZ z ≠
      genericPoint (relCurve C (relCurveBasePoint C RZ z).asIdeal.ResidueField))
    (b : Bool) (hz : z ∈ relPinnedChart C RZ π b)
    {xψ : RZ ⊗[k] ↥(Scheme.divisorSections k
      (windowM_choice π hπ g • fiberWeilDivisor π) ⊤)}
    (hxψ : xψ ∈ (divUniversalFstWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule) :
    let p := relCurveBasePoint C RZ z
    let K := p.asIdeal.ResidueField
    let zK := relCurveResiduePoint C RZ z
    let hzK := relCurveResiduePoint_mem_relPinnedChart C RZ (π := π) b hz
    let qK := (isAffineOpen_relPinnedChart C K π b).primeIdealOf ⟨zK, hzK⟩
    let v := pointwiseSectionVector C hπ g r₁ r₂ b₁ b₂ i j hO hχ z
    ∃ d : Γ(relCurve C K, relPinnedChart C K π b), d ∉ qK.asIdeal ∧
      d * (relPinnedTermBaseChangeAlg C RZ K π b).toLinearMap
          ((1 : K) ⊗ₜ[RZ] relThetaResSide (windowM_choice π hπ g) b le_rfl
            (relThetaWindowEquiv C RZ π (windowM_choice π hπ g)
              (relThetaPairH1_windowM C π hπ g) xψ)) ∈
        Ideal.span {(relPinnedTermBaseChangeAlg C RZ K π b).toLinearMap
          ((1 : K) ⊗ₜ[RZ] relThetaResSide (windowM_choice π hπ g) b le_rfl
            (relThetaWindowEquiv C RZ π (windowM_choice π hπ g)
              (relThetaPairH1_windowM C π hπ g) v))} := by
  dsimp only
  let hzK : relCurveResiduePoint C RZ z ∈
      relPinnedChart C (relCurveBasePoint C RZ z).asIdeal.ResidueField π b :=
    relCurveResiduePoint_mem_relPinnedChart C RZ (π := π) b hz
  let qK := (isAffineOpen_relPinnedChart C
    (relCurveBasePoint C RZ z).asIdeal.ResidueField π b).primeIdealOf
      ⟨relCurveResiduePoint C RZ z, hzK⟩
  have hgerm := fibre_germ_mem_span_pointwiseSectionVector_local
    C hπ g r₁ r₂ b₁ b₂ i j hO hχ z hzg b hz hxψ
  unfold pointwiseFibreReadGerm at hgerm
  obtain ⟨d, hdqK, hdmem⟩ :=
    IsAffineOpen.exists_notMem_primeIdealOf_mul_mem_span_singleton_of_germ_mem_span
      (isAffineOpen_relPinnedChart C
        (relCurveBasePoint C RZ z).asIdeal.ResidueField π b) hzK hgerm
  refine ⟨d, ?_, ?_⟩
  · simpa only [qK] using hdqK
  · have hxBC := relPinnedTermBaseChangeAlg_reading_windowEquiv_field
      C hπ g r₁ r₂ b₁ b₂ i j
        (relCurveBasePoint C RZ z).asIdeal.ResidueField b xψ
    have hsecBC := relPinnedTermBaseChangeAlg_reading_windowEquiv_field
      C hπ g r₁ r₂ b₁ b₂ i j
        (relCurveBasePoint C RZ z).asIdeal.ResidueField b
          (pointwiseSectionVector C hπ g r₁ r₂ b₁ b₂ i j hO hχ z)
    obtain ⟨c, hc⟩ := Ideal.mem_span_singleton.mp hdmem
    apply Ideal.mem_span_singleton.mpr
    refine ⟨c, ?_⟩
    calc
      _ = d * _ := congrArg (d * ·) hxBC
      _ = _ * c := hc
      _ = _ := congrArg (· * c) hsecBC.symm