---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.Hom.Spec_map_structureStalk
docstring: On `Spec`, the structure map of a stalk is the canonical map `Spec 𝒪_x
  ⟶ X ⟶ Spec k`.
file: AlgebraicJacobian/Curve/RationalToP1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Hom.Spec_map_structureStalk
type: lean
updated: '2026-07-31T20:15:19'
---
theorem Scheme.Hom.Spec_map_structureStalk (x : X) :
    Spec.map (f.structureStalk x) = X.fromSpecStalk x ≫ f := by
  rw [Scheme.Hom.structureStalk, Spec.map_comp, Spec.map_comp,
    ← Scheme.fromSpecStalk_toSpecΓ X x]
  simp only [Category.assoc]
  rw [← Scheme.toSpecΓ_naturality_assoc, toSpecΓ_SpecMap_ΓSpecIso_inv, Category.comp_id]