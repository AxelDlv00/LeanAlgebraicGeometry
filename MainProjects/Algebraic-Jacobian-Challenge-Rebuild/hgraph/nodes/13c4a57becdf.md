---
author: sync
content_type: theorem
created: '2026-07-19T14:31:14'
decl: AlgebraicGeometry.divUniversalFibreKM_le
docstring: The first fibre window obeys the transported pole bound `N`.
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivAssembleKappa.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalFibreKM_le
type: lean
updated: '2026-07-29T15:31:42'
---
theorem divUniversalFibreKM_le :
    divUniversalFibreKM C hπ g r₁ r₂ b₁ i j K
      ≤ Scheme.divisorSections K (windowN C K hπ g) ⊤ := by
  rintro _ ⟨y, -, rfl⟩
  exact divFamPhi_apply_mem C K π (windowM_choice π hπ g)
    (relThetaPairH1_windowM C π hπ g) y