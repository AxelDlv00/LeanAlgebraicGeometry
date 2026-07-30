---
author: sync
content_type: theorem
created: '2026-07-30T16:21:25'
decl: AlgebraicGeometry.ProjectiveSpace.standardOpenImmersion_over
file: AlgebraicJacobian/Picard/ProjectiveSpaceAffineChartIso.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.standardOpenImmersion_over
type: lean
updated: '2026-07-30T16:21:25'
---
theorem standardOpenImmersion_over :
    standardOpenImmersion n S ≫ (ℙ(Option n; S) ↘ S) = 𝔸(n; S) ↘ S := by
  rw [standardOpenImmersion, Category.assoc, ← affineChart.over_eq,
    ← affineChart.isoAffineSpace_hom_over]
  simp only [Iso.inv_hom_id_assoc]