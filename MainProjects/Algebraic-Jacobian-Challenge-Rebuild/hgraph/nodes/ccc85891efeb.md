---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: CategoryTheory.Sheaf.freeModuleSheafMap
docstring: Functoriality of the free sheaf of modules in the object of the site.
file: AlgebraicJacobian/Cohomology/OverOpen.lean
generated: lean
lean_status: lean_ok
stale: true
title: CategoryTheory.Sheaf.freeModuleSheafMap
type: lean
updated: '2026-07-30T15:28:04'
---
noncomputable def freeModuleSheafMap {U V : C} (i : U ⟶ V) :
    freeModuleSheaf J R U ⟶ freeModuleSheaf J R V :=
  (presheafToSheaf J _).map (Functor.whiskerRight (yoneda.map i) (ModuleCat.free R))