---
author: sync
content_type: definition
created: '2026-07-21T21:31:59'
decl: AlgebraicGeometry.divUniversalHighWindowThetaSubmodule
docstring: The stage submodule transported into relative theta sections.
file: AlgebraicJacobian/Picard/DivSchemeHighWindowStage.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divUniversalHighWindowThetaSubmodule
type: lean
updated: '2026-07-31T20:14:49'
---
noncomputable def divUniversalHighWindowThetaSubmodule (n : Nat)
    (x : DivUniversalHighWindowStage (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j n) :
    Submodule RZ
      (relThetaSections C RZ pi
        (divUniversalHighWindowExponent (C := C) (pi := pi) hpi g n)) :=
  Submodule.map
    (divUniversalHighWindowThetaEquiv (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j n).toLinearMap
    x.toSubmodule

set_option maxHeartbeats 1600000 in
-- Both sides unfold the relative-theta transport over the dependent carve-chart ring.