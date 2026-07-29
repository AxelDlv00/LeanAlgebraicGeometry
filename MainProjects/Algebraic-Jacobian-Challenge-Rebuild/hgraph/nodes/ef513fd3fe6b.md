---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: CategoryTheory.Sheaf.freeModuleSheaf
docstring: 'The free sheaf of `R`-modules on an object `U` of the site: the sheafification
  of the

  composite of the representable presheaf at `U` with the free module functor. Morphisms

  out of it compute sections over `U` (`Sheaf.freeModuleSheafHomEquiv`); it is the

  `ModuleCat R` analogue of the free abelian sheaves in mathlib''s

  `CategoryTheory.Sites.SheafCohomology.Basic`.'
file: AlgebraicJacobian/Cohomology/OverOpen.lean
generated: lean
lean_status: lean_ok
stale: true
title: CategoryTheory.Sheaf.freeModuleSheaf
type: lean
updated: '2026-07-29T15:26:38'
---
noncomputable def freeModuleSheaf (U : C) : Sheaf J (ModuleCat.{u} R) :=
  (presheafToSheaf J _).obj (yoneda.obj U ⋙ ModuleCat.free R)