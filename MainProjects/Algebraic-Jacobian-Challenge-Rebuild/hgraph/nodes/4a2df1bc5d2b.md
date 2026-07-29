---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.component_mem_nonZeroDivisors
docstring: '**DAT-A2 on the datum, section-ring form**: a fibrewise-regular component
  of a

  global section of the DAT-1 glued sheaf is a nonzerodivisor of its piece ring

  (fibrewise-regular + flat ⟹ regular; the chart rings are free `B`-modules by

  `free_relSections`, so the pieces are flat, and the `lm:ctn`-lite core fires).'
file: AlgebraicJacobian/Picard/SectionsToDivisors.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.component_mem_nonZeroDivisors
type: lean
updated: '2026-07-29T15:31:48'
---
theorem component_mem_nonZeroDivisors [IsNoetherianRing B]
    (s : ↥(gluedSubmodule B D.pieces D.unit ⊤)) (j : D.index)
    (hfib : ∀ p : PrimeSpectrum B, Function.Injective
      ((Scheme.mulSectionEnd B (D.component s j)).rTensor p.asIdeal.ResidueField)) :
    D.component s j ∈ nonZeroDivisors Γ(relCurve C B, D.pieces j) := by
  cases j with
  | inl j₀ =>
      haveI : Module.Free B Γ(relCurve C B, (relCover C B (fiberTwoCover π)).V₀) :=
        free_relSections C B (fiberChart₀ π)
          (isAffineOpen_preimage_chartOpen π 0).isCompact
          (isAffineOpen_preimage_chartOpen π 0).isQuasiSeparated
      exact mem_nonZeroDivisors_of_fibrewise_regular B
        (relCover_isAffineOpen₀ C B (fiberTwoCover π)) (D.h₀ j₀)
        Module.Flat.of_free (D.component s (Sum.inl j₀)) hfib
  | inr j₁ =>
      haveI : Module.Free B Γ(relCurve C B, (relCover C B (fiberTwoCover π)).V₁) :=
        free_relSections C B (fiberChart₁ π)
          (isAffineOpen_preimage_chartOpen π 1).isCompact
          (isAffineOpen_preimage_chartOpen π 1).isQuasiSeparated
      exact mem_nonZeroDivisors_of_fibrewise_regular B
        (relCover_isAffineOpen₁ C B (fiberTwoCover π)) (D.h₁ j₁)
        Module.Flat.of_free (D.component s (Sum.inr j₁)) hfib