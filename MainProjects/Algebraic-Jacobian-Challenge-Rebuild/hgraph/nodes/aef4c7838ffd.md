---
author: sync
content_type: theorem
created: '2026-07-20T12:01:17'
decl: AlgebraicGeometry.free_sections_relPinnedChart
docstring: '**Freeness of the pinned chart sections over the test ring**: `Γ(C_R,
  Vᵢᴿ)` is the free

  base change `R ⊗[k] Γ(C, Vᵢ)` (`free_relSections`).  (The `Free` companion of the
  landed

  `flat_sections_relPinnedChart`, needed as the free codomain of `chartReadMap`.)'
file: AlgebraicJacobian/Picard/DivSchemeRedesignFreeFlatChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.free_sections_relPinnedChart
type: lean
updated: '2026-07-31T20:15:22'
---
theorem free_sections_relPinnedChart (C : Over (Spec (.of k))) (R : Type u) [CommRing R]
    [Algebra k R] (π : C.left ⟶ P1 k) [IsFinite π] (b : Bool) :
    Module.Free R Γ(relCurve C R, relPinnedChart C R π b) := by
  cases b
  · exact free_relSections C R (fiberChart₀ π)
      (isAffineOpen_preimage_chartOpen π 0).isCompact
      (isAffineOpen_preimage_chartOpen π 0).isQuasiSeparated
  · exact free_relSections C R (fiberChart₁ π)
      (isAffineOpen_preimage_chartOpen π 1).isCompact
      (isAffineOpen_preimage_chartOpen π 1).isQuasiSeparated