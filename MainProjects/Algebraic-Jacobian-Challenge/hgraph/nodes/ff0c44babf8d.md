---
author: sync
content_type: theorem
created: '2026-07-28T17:03:34'
decl: AlgebraicGeometry.flat_appTop_of_flat
docstring: '**`Γ(g)` is flat for a flat `g` between affine schemes.**  Specialisation
  of

  `Flat.flat_appLE` to `U = V = ⊤`, where `appLE` is `appTop` up to the identity restriction
  map.

  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.flat_appTop_of_flat
type: lean
updated: '2026-07-28T18:12:19'
---
theorem flat_appTop_of_flat (g : S' ⟶ S) [Flat g] [IsAffine S] [IsAffine S'] :
    (Scheme.Hom.appTop g).hom.Flat := by
  have h := Flat.flat_appLE g (U := ⊤) (isAffineOpen_top S) (V := ⊤) (isAffineOpen_top S')
    (by simp)
  rw [Scheme.Hom.appLE] at h
  simpa [Scheme.Hom.appTop] using h