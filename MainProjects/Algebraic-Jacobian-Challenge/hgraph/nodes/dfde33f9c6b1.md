---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.module_finite_HModule_zero_curve
docstring: '`module_finite_HModule_zero` for the structure sheaf `Scheme.toModuleKSheaf
  C` of a

  `Spec k`-scheme `C`. The Grothendieck topology `Opens.grothendieckTopology C.left.toTopCat`
  is

  inferred from the instances `instHasSheafify_Opens_ModuleCatK` and

  `instHasExt_Sheaf_Opens_ModuleCatK`, and the sheaf argument from the result type.
  On a proper

  geometrically integral `k`-curve the remaining hypothesis holds because `H⁰(C, O_C)
  ≃ k` by Stein

  factorization on a connected proper curve.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.module_finite_HModule_zero_curve
type: lean
updated: '2026-07-27T01:33:11'
---
theorem module_finite_HModule_zero_curve
    (k : Type u) [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [Module.Finite k
      ((constantSheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k)).obj
        (ModuleCat.of k k) ⟶ Scheme.toModuleKSheaf C)] :
    Module.Finite k (Scheme.HModule k (Scheme.toModuleKSheaf C) 0) :=
  Scheme.module_finite_HModule_zero k _