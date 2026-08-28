---
author: sync
content_type: theorem
created: '2026-07-20T00:31:14'
decl: AlgebraicGeometry.exists_sec_windowCompare_ne_zero_seedPrime
docstring: '**(b) The universal seed section at every seed-base prime** (I-0278 sub-lemma
  (b)):

  combining the fibre-window nonvanishing (`exists_mem_ne_zero_divUniversalFibreKM_seedPrime`)

  with the landed seed-prime bridge, at every prime `p` of `R_Z` there is a universal
  window

  vector `x ∈ divUniversalFstWindow` with nonzero fibre comparison `windowCompare
  … ≠ 0`

  whose window image `relThetaWindowEquiv … x` lies in `K_univ = divUniversalSeedK`.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivGen.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_sec_windowCompare_ne_zero_seedPrime
type: lean
updated: '2026-08-01T09:44:12'
---
theorem exists_sec_windowCompare_ne_zero_seedPrime
    (p : PrimeSpectrum (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
      (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)) :
    ∃ x ∈ (divUniversalFstWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule,
      windowCompare
          (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
            (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
          p.asIdeal.ResidueField x ≠ 0 ∧
      relThetaWindowEquiv C
          (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
            (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
          π (windowM_choice π hπ g) (relThetaPairH1_windowM C π hπ g) x
        ∈ divUniversalSeedK C π hπ g r₁ r₂ b₁ b₂ i j := by
  obtain ⟨f, hf_mem, hf_ne⟩ :=
    exists_mem_ne_zero_divUniversalFibreKM_seedPrime C hπ g r₁ r₂ b₁ b₂ i j hO hχ p
  exact exists_relThetaWindowEquiv_mem_divUniversalSeedK_windowCompare_ne_zero_seedPrime
    C hπ g r₁ r₂ b₁ b₂ i j p hf_mem hf_ne

set_option maxHeartbeats 2400000 in
-- the seed-base residue-field tower drives the `windowCompare`/`relThetaWindowEquiv` and
-- `basePrime` germ defeq past the defaults (the `divUniversal_carve_residueField` hatch)
set_option synthInstance.maxHeartbeats 800000 in
set_option maxSynthPendingDepth 8 in
set_option maxRecDepth 8000 in
include hO hχ in