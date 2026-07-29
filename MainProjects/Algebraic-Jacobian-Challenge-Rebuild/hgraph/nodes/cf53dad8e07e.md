---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.relThetaWindowEquiv
docstring: '**The window identification** (the DD-4 base-field seam, consumed): the
  free base

  change of the field window `H_a = divisorSections k (a • F) ⊤` is the module of
  global

  sections of the relative theta twist, `R`-linearly — `relThetaTwistH0BaseChangeDivisor`

  composed with the degree-zero collapse.  The `H¹` input is discharged by the DD-0

  window ledger at the pinned exponents (`relThetaPairH1_windowM` below).'
file: AlgebraicJacobian/Picard/DivisorFamilyWindow.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relThetaWindowEquiv
type: lean
updated: '2026-07-29T15:31:45'
---
noncomputable def relThetaWindowEquiv
    (hH1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1) :
    R ⊗[k] ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤) ≃ₗ[R]
      relThetaSections C R π a :=
  (relThetaTwistH0BaseChangeDivisor C π a R hH1).symm.trans
    (relThetaSectionsEquiv C R π a)

/-! ## The window submodule `K_a(d)` -/

variable {C R π a} in