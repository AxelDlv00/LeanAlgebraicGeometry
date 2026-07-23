---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.unitBaseSectionsEquiv
docstring: '**Dialect bridge on sections of `𝒪`**: the sections of the unit module

  (`X.Modules` dialect) over an open `U` are `k`-linearly the sections of the

  structure sheaf of `k`-modules `toModuleKSheaf C` — by the *identity*

  function.  Both `k`-scalar paths are restriction of scalars along the same

  structure ring map `kToSection C (op U)`, acting by ring multiplication.'
file: AlgebraicJacobian/RiemannRoch/CohomologyKit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.unitBaseSectionsEquiv
type: lean
updated: '2026-07-24T03:02:13'
---
noncomputable def unitBaseSectionsEquiv (U : C.left.Opens) :
    BaseSections C (SheafOfModules.unit C.left.ringCatSheaf) U ≃ₗ[k]
      (toModuleKSheaf C).obj.obj (Opposite.op U) where
  toFun x := x
  invFun x := x
  map_add' _ _ := rfl
  map_smul' _ _ := rfl
  left_inv _ := rfl
  right_inv _ := rfl