---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: CategoryTheory.Sheaf.HModule
docstring: 'The degree-`n` cohomology of a sheaf of `R`-modules on a small site, as
  an `Ext`-group

  in the Grothendieck abelian category `Sheaf J (ModuleCat R)`. It is a `Type u` carrying
  a

  `Module R` instance (via the `R`-linear structure of the sheaf category).'
file: AlgebraicJacobian/Cohomology/ModuleKSheaf.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Sheaf.HModule
type: lean
updated: '2026-07-31T20:15:17'
---
noncomputable abbrev HModule (F : Sheaf J (ModuleCat.{u} R)) (n : ℕ) : Type u :=
  Abelian.Ext (constModuleSheaf J R) F n

namespace HModule

variable {F G G' : Sheaf J (ModuleCat.{u} R)}