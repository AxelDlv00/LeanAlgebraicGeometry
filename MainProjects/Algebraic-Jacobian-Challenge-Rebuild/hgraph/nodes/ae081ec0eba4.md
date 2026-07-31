---
author: sync
content_type: definition
created: '2026-07-17T21:31:16'
decl: AlgebraicGeometry.thetaFiberPullback
docstring: '**The pulled fiber system**: the local-equation system of `a · F` on `C.left`,

  pulled back along the base-field collapse — regularity for free from integrality.'
file: AlgebraicJacobian/Cohomology/RelCurveCollapse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.thetaFiberPullback
type: lean
updated: '2026-07-31T20:15:17'
---
noncomputable def thetaFiberPullback : (relCurve C k).LocalEquations :=
  haveI : IsIntegral (C ⊗ overSpec k k).left := ‹IsIntegral (relCurve C k)›
  (fiberDivisor π a).pullback (fst C (overSpec k k)).left
    (fun y z hz => Scheme.LocalEquations.pullbackEqn_germ_mem_nonZeroDivisors
      (fst C (overSpec k k)).left (fst_left_self_genericPoint C) (fiberDivisor π a) y z hz)

omit [IsFinite π] in