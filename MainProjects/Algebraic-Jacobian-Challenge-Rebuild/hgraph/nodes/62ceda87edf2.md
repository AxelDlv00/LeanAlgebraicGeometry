---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.projective_sections
docstring: '**Projectivity of the chart-1 glued sections over `B`**.'
file: AlgebraicJacobian/Cohomology/GluedSheafEngine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.projective_sections
type: lean
updated: '2026-07-22T17:56:01'
---
theorem projective_sections₁ :
    Module.Projective B
      (D.sheaf.obj.obj (op (relCover C B (fiberTwoCover π)).V₁)) := by
  haveI : Module.Free B Γ(relCurve C B, (relCover C B (fiberTwoCover π)).V₁) :=
    free_relSections C B (fiberChart₁ π)
      (isAffineOpen_preimage_chartOpen π 1).isCompact
      (isAffineOpen_preimage_chartOpen π 1).isQuasiSeparated
  exact projective_glued_of_free B D.pieces D.unit
    (relCover_isAffineOpen₁ C B (fiberTwoCover π)) D.isGluingCocycle
    (fun _ _ _ => rfl) (σ := Sum.inr) (h := D.h₁) (fun _ => le_rfl)
    D.span_range_h₁ ‹_›