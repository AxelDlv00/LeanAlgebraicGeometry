---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.module_finite_HModule_zero_curve
docstring: 'Iter-039 curve specialisation of iter-038''s `module_finite_HModule_zero`
  to

  the structure sheaf `Scheme.toModuleKSheaf C` of a `Spec k`-scheme `C`. The

  Grothendieck topology `Opens.grothendieckTopology C.left.toTopCat` is auto-inferred

  via the iter-005 instances `instHasSheafify_Opens_ModuleCatK` and

  `instHasExt_Sheaf_Opens_ModuleCatK`. The sheaf argument is inferred from the

  result type. Mirrors iter-030 / iter-035 / iter-036 / iter-037''s `_curve`

  patterns. Used downstream as a building block for `Module.Finite k (HModule k

  (toModuleKSheaf C) 0)` once the Hom-from-constant-sheaf finiteness input is

  supplied for proper geometrically integral $k$-curves (typically the morally

  trivial `H^0(C, O_C) ≃ k` from Stein factorization on a connected proper

  curve).'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.module_finite_HModule_zero_curve
type: lean
updated: '2026-07-16T21:14:26'
---
theorem module_finite_HModule_zero_curve
    (k : Type u) [Field k]
    (C : Over (Spec (CommRingCat.of k)))
    [Module.Finite k
      ((constantSheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k)).obj
        (ModuleCat.of k k) ⟶ Scheme.toModuleKSheaf C)] :
    Module.Finite k (Scheme.HModule k (Scheme.toModuleKSheaf C) 0) :=
  Scheme.module_finite_HModule_zero k _