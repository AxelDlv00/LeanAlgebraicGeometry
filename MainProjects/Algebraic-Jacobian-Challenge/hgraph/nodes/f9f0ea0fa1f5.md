---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.higherDirectImage
docstring: 'The `i`-th higher direct image `Rⁱ f_* F` of a sheaf of modules `F` on
  `X`

  along a morphism `f : X ⟶ S`, defined as the `i`-th right derived functor of the

  pushforward functor `f_*` applied to `F`.


  For `i = 0` this recovers the ordinary pushforward `R⁰ f_* F = f_* F`.


  Source: Stacks Project, Cohomology of Schemes, Definition of `Rⁱ f_*`.'
file: AlgebraicJacobian/Cohomology/HigherDirectImage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.higherDirectImage
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def higherDirectImage [HasInjectiveResolutions X.Modules]
    (f : X ⟶ S) (i : ℕ) (F : X.Modules) : S.Modules :=
  ((pushforward f).rightDerived i).obj F