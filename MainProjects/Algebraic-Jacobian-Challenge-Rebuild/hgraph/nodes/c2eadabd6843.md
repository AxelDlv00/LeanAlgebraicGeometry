---
author: sync
content_type: theorem
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.flat_sections_relPinnedChart
docstring: '**Flatness of the pinned chart sections over the test ring**: `Γ(C_R,
  Vᵢᴿ)` is the

  free base change `R ⊗[k] Γ(C, Vᵢ)` (`free_relSections`), hence flat.'
file: AlgebraicJacobian/Picard/DivSchemeFamilySide.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.flat_sections_relPinnedChart
type: lean
updated: '2026-07-29T15:31:39'
---
theorem flat_sections_relPinnedChart (b : Bool) :
    Module.Flat R Γ(relCurve C R, relPinnedChart C R π b) := by
  cases b
  · haveI : Module.Free R Γ(relCurve C R, relPinnedChart C R π false) :=
      free_relSections C R (fiberChart₀ π)
        (isAffineOpen_preimage_chartOpen π 0).isCompact
        (isAffineOpen_preimage_chartOpen π 0).isQuasiSeparated
    exact Module.Flat.of_free
  · haveI : Module.Free R Γ(relCurve C R, relPinnedChart C R π true) :=
      free_relSections C R (fiberChart₁ π)
        (isAffineOpen_preimage_chartOpen π 1).isCompact
        (isAffineOpen_preimage_chartOpen π 1).isQuasiSeparated
    exact Module.Flat.of_free

variable {C R π}
variable (a : ℕ)