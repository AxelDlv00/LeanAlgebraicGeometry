---
author: sync
content_type: class
created: '2026-07-24T17:02:56'
decl: AlgebraicGeometry.Scheme.IsAffineHModuleVanishing
docstring: 'Iter-040 affine cohomology vanishing carrier predicate. Packages the

  geometric statement that for every affine open `U` of `C.left.toTopCat` and

  every degree `i > 0`, the open-evaluation cohomology `Scheme.HModule'' k F i U`

  is the zero `k`-module (formulated as `Subsingleton`, since `HModule''` returns

  a `Type u` rather than a `ModuleCat` object — see iter-014 abbrev). The class

  is the affine-vanishing input the cover-evaluation chain consumes once the

  producer instance is supplied (queued for iter-041+; multi-iteration

  project-local construction expected since Mathlib does not yet provide

  scheme-level Serre vanishing on affines for the `ModuleCat k`-flavour).'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.IsAffineHModuleVanishing
type: lean
updated: '2026-07-24T17:02:56'
---
class IsAffineHModuleVanishing
    (k : Type u) [Field k] (C : Over (Spec (CommRingCat.of k)))
    (F : Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k)) :
    Prop where
  subsingleton_HModule' : ∀ {U : TopologicalSpace.Opens C.left.toTopCat},
    AlgebraicGeometry.IsAffineOpen U → ∀ i, 0 < i →
      Subsingleton (Scheme.HModule' k F i U)

/-- Iter-040 immediate consumer of `IsAffineHModuleVanishing`: given the