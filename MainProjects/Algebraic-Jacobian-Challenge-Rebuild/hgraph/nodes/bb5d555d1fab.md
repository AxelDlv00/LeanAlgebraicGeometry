---
author: sync
content_type: definition
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.shiftMap
docstring: '**The shift map `Lₐ → L₀`.** Multiplication by `uniformizer ^ a`, a `K`-linear
  map (the

  `K`-action is by multiplication in the field, which commutes).'
file: AlgebraicJacobian/RiemannRoch/JumpDimension.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.shiftMap
type: lean
updated: '2026-07-30T15:28:03'
---
noncomputable def shiftMap (a : ℤ) :
    ↥(pointLattice K hx a) →ₗ[K] ↥(pointLattice K hx 0) where
  toFun g := ⟨uniformizer K hx ^ a * (g : X.functionField), by
    rw [mem_pointLattice_uniformizer_zpow_mul, zero_add]; exact g.2⟩
  map_add' g g' := Subtype.ext (by simp only [Submodule.coe_add]; ring)
  map_smul' r g := Subtype.ext (by
    simp only [SetLike.val_smul, RingHom.id_apply, functionFieldOverModule_smul_def]; ring)