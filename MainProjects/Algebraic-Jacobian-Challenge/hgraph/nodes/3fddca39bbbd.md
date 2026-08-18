---
author: sync
content_type: theorem
created: '2026-08-03T08:55:16'
decl: AlgebraicGeometry.Scheme.chi_toModuleKSheafOfModules_congr
docstring: 'The totalized degree-at-most-one Euler index after restriction to `k`
  is

  invariant under an isomorphism of sheaves of `O_C`-modules.  This is exactly

  `Sheaf.chi_congr` applied through `toModuleKSheafOfModulesFunctor`.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/ModulesFunctor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.chi_toModuleKSheafOfModules_congr
type: lean
updated: '2026-08-18T20:52:03'
---
theorem chi_toModuleKSheafOfModules_congr
    (C : Over (Spec (CommRingCat.of k))) {M N : C.left.Modules} (e : M ≅ N) :
    CategoryTheory.Sheaf.chi (toModuleKSheafOfModules C M) =
      CategoryTheory.Sheaf.chi (toModuleKSheafOfModules C N) :=
  CategoryTheory.Sheaf.chi_congr ((toModuleKSheafOfModulesFunctor C).mapIso e)