---
author: sync
content_type: theorem
created: '2026-07-29T20:27:12'
decl: AlgebraicGeometry.Scheme.Modules.pullbackTensorRightUnit_of_iso_unit
docstring: '**Consistency of the residual class**: it is satisfied when the first
  factor

  is *also* trivialisable, by the landed two-sided base case

  `pullbackTensorMap_isIso_of_base_unit`.


  This is not a global instance and does not discharge anything for D2'' (whose `P`

  is a divisor-family quotient, not trivialisable). It is recorded for one reason:

  it exhibits a *witness* for `PullbackTensorRightUnit`, so the class is not

  vacuous — there really are `(f, P)` satisfying it, and a consumer binding it is

  not binding an empty hypothesis. Per protection `I-0838`, a gate should be shown

  inhabitable before anything is built on it.'
file: AlgebraicJacobian/Picard/PullbackTensorOneSided.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.pullbackTensorRightUnit_of_iso_unit
type: lean
updated: '2026-07-29T20:27:12'
---
theorem pullbackTensorRightUnit_of_iso_unit {X Y : Scheme.{u}} (f : Y ⟶ X)
    (P : X.Modules) (eP : P ≅ SheafOfModules.unit X.ringCatSheaf) :
    PullbackTensorRightUnit f P :=
  ⟨pullbackTensorMap_isIso_of_base_unit f eP (Iso.refl _)⟩

/-! ## The residual, sharpened to a single coherence identity

The three statements below narrow `PullbackTensorRightUnit` from "prove an
`IsIso`" to "prove one equation", and prove everything in it except that
equation. This is the measurement a lane taking the residual should start from.

The unitor route: both sides of `pullbackTensorMap f P 𝒪_X` are canonically
`f^*P`, so the map ought to be the composite

```
f^*(P ⊗ 𝒪_X) --f^*ρ_P--> f^*P --ρ⁻¹--> f^*P ⊗ 𝒪_Y --1 ⊗ (pullbackUnitIso)⁻¹--> f^*P ⊗ f^*𝒪_X
```

of `tensorObj_right_unitor`, its inverse downstairs, and `pullbackUnitIso`
(`f^*𝒪_X ≅ 𝒪_Y`, unconditional). `unitorRoute_isIso` proves that composite is an
isomorphism — with no hypothesis on `P`. So the residual is *exactly* the
assertion that `pullbackTensorMap` agrees with it.

Measured, so nobody re-derives it: that identity is **not** closed by `rfl`,
`dsimp only; rfl`, `simp`, or `aesop_cat` (all four tried at these binders; the
goal survives unchanged). It is a genuine coherence square at the sheafification
level, of the same kind as `pullbackTensorMap_unit_isIso`'s proof
(`Picard/TensorObjSubstrate.lean:1654`, via `pullbackEtaUnitSquare` and
`isIso_sheafifyEta_of_unitSquare`) — which is the argument to imitate, with one
side left general instead of both taken to be the unit. -/