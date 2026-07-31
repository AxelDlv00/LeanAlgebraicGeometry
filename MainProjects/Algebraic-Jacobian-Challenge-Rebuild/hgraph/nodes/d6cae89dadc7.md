---
author: sync
content_type: theorem
created: '2026-07-20T18:02:05'
decl: AlgebraicGeometry.mem_prime_of_windowEquiv_fibre_dvd
docstring: 'Fibre-germ divisibility of two compared window vectors implies prime

  membership of their total chart readings at the corresponding point.'
file: AlgebraicJacobian/Picard/DivSchemeRedesignPointPrime.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.mem_prime_of_windowEquiv_fibre_dvd
type: lean
updated: '2026-07-31T20:14:50'
---
theorem mem_prime_of_windowEquiv_fibre_dvd
    (b : Bool) {z : relCurve C R}
    (hz : z ∈ relPinnedChart C R π b)
    {xsec xψ : R ⊗[k] ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)}
    (hsec : relThetaResSide a b le_rfl
        (relThetaWindowEquiv C R π a hH1 xsec) ∈
      ((isAffineOpen_relPinnedChart C R π b).primeIdealOf ⟨z, hz⟩).asIdeal)
    (hdiv :
      ((relCurve C (relCurveBasePoint C R z).asIdeal.ResidueField).presheaf.germ
        (relPinnedChart C (relCurveBasePoint C R z).asIdeal.ResidueField π b)
        (relCurveResiduePoint C R z)
        (relCurveResiduePoint_mem_relPinnedChart C R (π := π) b hz)).hom
        (relThetaResSide a b le_rfl
          (relThetaWindowEquiv C (relCurveBasePoint C R z).asIdeal.ResidueField π a hH1
            (windowCompare R (relCurveBasePoint C R z).asIdeal.ResidueField xψ))) ∈
      Ideal.span {
        ((relCurve C (relCurveBasePoint C R z).asIdeal.ResidueField).presheaf.germ
          (relPinnedChart C (relCurveBasePoint C R z).asIdeal.ResidueField π b)
          (relCurveResiduePoint C R z)
          (relCurveResiduePoint_mem_relPinnedChart C R (π := π) b hz)).hom
          (relThetaResSide a b le_rfl
            (relThetaWindowEquiv C (relCurveBasePoint C R z).asIdeal.ResidueField π a hH1
              (windowCompare R (relCurveBasePoint C R z).asIdeal.ResidueField xsec)))} ) :
    relThetaResSide a b le_rfl
        (relThetaWindowEquiv C R π a hH1 xψ) ∈
      ((isAffineOpen_relPinnedChart C R π b).primeIdealOf ⟨z, hz⟩).asIdeal := by
  let Kz := (relCurveBasePoint C R z).asIdeal.ResidueField
  let zK := relCurveResiduePoint C R z
  have hzK : zK ∈ relPinnedChart C Kz π b :=
    relCurveResiduePoint_mem_relPinnedChart C R (π := π) b hz
  have hbase : (relCurveMap C R Kz).base zK ∈ relPinnedChart C R π b := by
    rw [relCurveMap_relCurveResiduePoint]
    exact hz
  have hbase_eq : (relCurveMap C R Kz).base zK = z := by
    exact relCurveMap_relCurveResiduePoint C R z
  let zbase : relPinnedChart C R π b :=
    ⟨(relCurveMap C R Kz).base zK, hbase⟩
  have hscomp :=
    stalkMap_germ_relThetaResSide_windowEquiv_at_relCurveResiduePoint
      C R (π := π) a hH1 b hz xsec
  have htcomp :=
    stalkMap_germ_relThetaResSide_windowEquiv_at_relCurveResiduePoint
      C R (π := π) a hH1 b hz xψ
  have hsec' : relThetaResSide a b le_rfl
        (relThetaWindowEquiv C R π a hH1 xsec) ∈
      ((isAffineOpen_relPinnedChart C R π b).primeIdealOf zbase).asIdeal := by
    simpa [zbase, hbase_eq] using hsec
  have hdiv' :
      ((relCurve C Kz).presheaf.germ (relPinnedChart C Kz π b) zK hzK).hom
          (relThetaResSide a b le_rfl
            (relThetaWindowEquiv C Kz π a hH1 (windowCompare R Kz xψ))) ∈
        Ideal.span {
          ((relCurve C Kz).presheaf.germ (relPinnedChart C Kz π b) zK hzK).hom
            (relThetaResSide a b le_rfl
              (relThetaWindowEquiv C Kz π a hH1 (windowCompare R Kz xsec)))} := by
    simpa [Kz, zK] using hdiv
  have hmem := mem_prime_of_stalkMap_germ_mem_span
    (f := relCurveMap C R Kz) (hU := isAffineOpen_relPinnedChart C R π b)
    (hz := hzK) (hzbase := hbase) hscomp htcomp hdiv' hsec'
  simpa [zbase, hbase_eq] using hmem