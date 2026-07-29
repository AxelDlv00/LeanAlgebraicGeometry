---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: CategoryTheory.Sheaf.HModule'.mapCoeff
docstring: 'Functoriality of `HModule'' _ U n` in the coefficient sheaf, as an `R`-linear
  map:

  postcomposition with `f : F ⟶ G` (the coefficient-variable analogue of `HModule''.res`,

  which is functoriality in the object of the site).'
file: AlgebraicJacobian/Cohomology/RelativeTwoCover.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Sheaf.HModule'.mapCoeff
type: lean
updated: '2026-07-29T15:31:36'
---
noncomputable def HModule'.mapCoeff (f : F ⟶ G) (n : ℕ) :
    HModule' F U n →ₗ[R] HModule' G U n :=
  (Abelian.Ext.mk₀ f).postcompOfLinear R (freeModuleSheaf J R U) (add_zero n)