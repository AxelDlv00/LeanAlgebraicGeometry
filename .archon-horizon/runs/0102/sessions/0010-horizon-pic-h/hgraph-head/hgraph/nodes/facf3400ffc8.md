---
author: sync
content_type: definition
created: '2026-07-17T10:19:49'
decl: AlgebraicGeometry.relThetaTwistH0BaseChange
docstring: '**DD-4 (2), the on-the-nose base change** (`informal/dat-d-worksheet.md`
  §2.1, mirror

  of `RigidEngine4BaseChange.relTwistH0BaseChange`): on the `H¹`-vanishing locus,
  the

  degree-zero cohomology of the relative theta twist commutes with base change from
  the base

  field `k` to the affine test ring `R`,


  `R ⊗[k] H⁰(C_k, Θⁿ) ≃ₗ[R] H⁰(C_R, Θⁿ)`.


  The right-hand side is `H⁰(relThetaTwistSheaf C R π n)`, obtained from the engine''s

  `relCocycleBaseChange` output by the cocycle functoriality `relThetaCocycle_baseChange`.'
file: AlgebraicJacobian/Cohomology/RelThetaTwist.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relThetaTwistH0BaseChange
type: lean
updated: '2026-08-01T09:44:09'
---
noncomputable def relThetaTwistH0BaseChange
    (hH1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π n)).H1) :
    R ⊗[k] Sheaf.HModule (relThetaTwistSheaf C k π n) 0 ≃ₗ[R]
      Sheaf.HModule (relThetaTwistSheaf C R π n) 0 :=
  (relTwistH0BaseChange C k R π (relThetaCocycle C k π n) hH1).trans
    (Sheaf.HModule.mapEquiv
      (eqToIso (congrArg (relTwistSheaf C R (fiberTwoCover π))
        (relThetaCocycle_baseChange C R π n))) 0)