---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.gluedQsmul_inv_of_mul_res_eq_one
docstring: '**The componentwise mutual-inverse law**: chart coordinates multiplying
  to `1` on

  the overlap act inversely on the glued sections of the overlap.'
file: AlgebraicJacobian/Cohomology/GluedSheafPair.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.gluedQsmul_inv_of_mul_res_eq_one
type: lean
updated: '2026-08-01T09:44:09'
---
lemma gluedQsmul_inv_of_mul_res_eq_one (r₀ : Γ(X, V₀)) (r₁ : Γ(X, V₁))
    (hmul : X.resHom (inf_le_left : V₀ ⊓ V₁ ≤ V₀) r₀ *
      X.resHom (inf_le_right : V₀ ⊓ V₁ ≤ V₁) r₁ = 1)
    (m : ↥(gluedSubmodule k U g (V₀ ⊓ V₁))) :
    gluedQsmul k U g (inf_le_left : V₀ ⊓ V₁ ≤ V₀) r₀
      (gluedQsmul k U g (inf_le_right : V₀ ⊓ V₁ ≤ V₁) r₁ m) = m := by
  refine Subtype.ext (funext fun j => ?_)
  rw [gluedQsmul_coe, gluedQsmul_coe, ← mul_assoc]
  have hres := congrArg
    (X.resHom (inf_le_left : (V₀ ⊓ V₁) ⊓ U j ≤ V₀ ⊓ V₁)) hmul
  rw [map_mul, map_one] at hres
  simp only [Scheme.resHom_resHom] at hres
  rw [hres, one_mul]