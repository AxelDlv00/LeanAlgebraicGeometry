---
author: sync
content_type: theorem
created: '2026-07-18T23:31:13'
decl: AlgebraicGeometry.Grassmannian.baseChange_map_submodule
docstring: '`Submodule.baseChange` exchanges with `Submodule.map`: the base change
  of a mapped

  submodule is the image of the base-changed submodule under the base-changed map.'
file: AlgebraicJacobian/Picard/DivSchemeFrameKit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.baseChange_map_submodule
type: lean
updated: '2026-08-01T09:44:11'
---
theorem baseChange_map_submodule {R : Type u} [CommRing R] {M M' : Type u}
    [AddCommGroup M] [Module R M] [AddCommGroup M'] [Module R M']
    (A : Type u) [CommRing A] [Algebra R A] (f : M →ₗ[R] M') (N : Submodule R M) :
    (Submodule.map f N).baseChange A
      = Submodule.map (LinearMap.baseChange A f) (N.baseChange A) := by
  have hcomp : f ∘ₗ N.subtype = (Submodule.map f N).subtype ∘ₗ f.submoduleMap N :=
    LinearMap.ext fun x => rfl
  have h1 : (Submodule.map f N).baseChange A
      = LinearMap.range (LinearMap.baseChange A (Submodule.map f N).subtype) := rfl
  have h2 : N.baseChange A = LinearMap.range (LinearMap.baseChange A N.subtype) := rfl
  rw [h1, h2, ← LinearMap.range_comp, ← LinearMap.baseChange_comp, hcomp,
    LinearMap.baseChange_comp, LinearMap.range_comp,
    LinearMap.range_eq_top.mpr (LinearMap.baseChange_surjective A
      (LinearMap.submoduleMap_surjective f N)), Submodule.map_top]