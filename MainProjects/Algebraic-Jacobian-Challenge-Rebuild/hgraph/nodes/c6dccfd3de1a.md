---
author: sync
content_type: theorem
created: '2026-07-21T21:31:59'
decl: AlgebraicGeometry.finite_divUniversalHighWindowThetaQuotient
docstring: The relative-theta quotient of a stage is finite.
file: AlgebraicJacobian/Picard/DivSchemeHighWindowStage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.finite_divUniversalHighWindowThetaQuotient
type: lean
updated: '2026-07-21T22:01:54'
---
theorem finite_divUniversalHighWindowThetaQuotient (n : Nat)
    (x : DivUniversalHighWindowStage (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j n) :
    Module.Finite RZ
      (relThetaSections C RZ pi
          (divUniversalHighWindowExponent (C := C) (pi := pi) hpi g n) ⧸
        divUniversalHighWindowThetaSubmodule (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j n x) := by
  letI := finite_divUniversalHighWindowQuotient
    (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j n x
  exact Module.Finite.equiv
    (divUniversalHighWindowThetaQuotientEquiv (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j n x)

set_option maxHeartbeats 1600000 in
-- Transporting projectivity re-elaborates the dependent theta quotient equivalence.