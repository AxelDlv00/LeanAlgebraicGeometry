---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.isAffineOpen_preimage_of_isFinite
docstring: '**Node `N10`, affine part.**  The preimage of an affine open under a finite

  morphism is affine.  Applied by the keystone to the two standard affine charts

  `U₀, U₁` of `ℙ¹`: with a finite `π : C ⟶ ℙ¹`, the preimages `π⁻¹U₀, π⁻¹U₁` are

  affine.'
file: AlgebraicJacobian/RiemannRoch/Adelic/P1BaseCase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.isAffineOpen_preimage_of_isFinite
type: lean
updated: '2026-07-24T03:02:13'
---
theorem isAffineOpen_preimage_of_isFinite {X Y : Scheme.{u}} (π : X ⟶ Y) [IsFinite π]
    {V : Y.Opens} (hV : IsAffineOpen V) : IsAffineOpen (π ⁻¹ᵁ V) :=
  hV.preimage π