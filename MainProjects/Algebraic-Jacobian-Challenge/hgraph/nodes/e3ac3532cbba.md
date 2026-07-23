---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.glueProj_app_mem_glueGammaCompatible
docstring: 'The family of chart projections of a global section of the glued sheaf
  is

  compatible.'
file: AlgebraicJacobian/Picard/SerreTwistSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.glueProj_app_mem_glueGammaCompatible
type: lean
updated: '2026-07-24T03:02:12'
---
lemma glueProj_app_mem_glueGammaCompatible (w : Γ(glue D M g hC1 hC2, ⊤)) :
    (fun i => (glueProj D M g hC1 hC2 i).app ⊤ w) ∈ glueGammaCompatible D M g := by
  intro p
  have h1 := app_top_congr (glueProj_leg_compat D M g hC1 hC2 p) w
  rw [comp_app_top_apply, comp_app_top_apply] at h1
  exact h1

/-! ## The glued-section equivalence -/