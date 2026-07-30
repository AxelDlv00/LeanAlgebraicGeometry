---
author: sync
content_type: theorem
created: '2026-07-19T15:31:13'
decl: AlgebraicGeometry.divFamPhi_windowCompare_mem_divUniversalFibreKM
docstring: '**The elementwise forward seam**: the `Φ`-read fibre comparison of any
  element of

  the universal window lies in the fibre window.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivRes.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divFamPhi_windowCompare_mem_divUniversalFibreKM
type: lean
updated: '2026-07-30T15:46:03'
---
theorem divFamPhi_windowCompare_mem_divUniversalFibreKM
    {x : TensorProduct k
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
      ↥(Scheme.divisorSections k (windowM_choice π hπ g • fiberWeilDivisor π) ⊤)}
    (hx : x ∈ (divUniversalFstWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule) :
    divFamPhi C K π (windowM_choice π hπ g) (relThetaPairH1_windowM C π hπ g)
        (windowCompare
          (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
            (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j) K x)
      ∈ divUniversalFibreKM C hπ g r₁ r₂ b₁ i j K := by
  rw [divUniversalFibreKM_eq_span C hπ g r₁ r₂ b₁ b₂ i j K]
  exact Submodule.subset_span (Set.mem_image_of_mem _ hx)