---
author: sync
content_type: theorem
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.descent_cechPicClass
docstring: '**The classes correspond under `CechPic.map`** (worksheet §3.2, the "consequently"

  half): for a descended datum, the class of the given datum on `C_B` is the pullback
  of

  the stage class along the relative-curve comparison — the stage-(1e) naturality

  rewritten along the descent certificate.'
file: AlgebraicJacobian/Cohomology/DatumDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.descent_cechPicClass
type: lean
updated: '2026-07-17T08:41:24'
---
theorem BasicOpenCocycleDatum.descent_cechPicClass [IsAffineHom π]
    {B₀ : Subalgebra k B} {D₀ : BasicOpenCocycleDatum C (↥B₀) π}
    {D : BasicOpenCocycleDatum C B π} (hbc : D₀.baseChange (B' := B) = D) :
    D.cechPicClass = Scheme.CechPic.map (relCurveMap C (↥B₀) B) D₀.cechPicClass := by
  rw [← hbc]
  exact D₀.cechPicClass_baseChange B

set_option synthInstance.maxHeartbeats 400000 in
-- The sheaf-of-modules instances over the subalgebra stage exceed the default
-- synthesis budget (the standing pattern of the engine files).