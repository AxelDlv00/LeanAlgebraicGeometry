---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechSectionCoeff
docstring: 'Dependent coefficient family for the Stub-6 engine: the sections of `F`
  over

  `stubOpen m σ`.  Kept as a reducible abbreviation so the `AddCommGroup` instance
  is the

  generic one on `Ab`-objects (no bespoke match-instance).'
file: AlgebraicJacobian/Cohomology/CechSectionIdentification.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechSectionCoeff
type: lean
updated: '2026-07-24T03:02:09'
---
private noncomputable abbrev cechSectionCoeff (m : ℕ) (σ : Fin m → 𝒰.I₀) : Type u :=
  ToType (((SheafOfModules.forget X.ringCatSheaf).obj F).presheaf.obj
    (Opposite.op (stubOpen 𝒰 V m σ)))