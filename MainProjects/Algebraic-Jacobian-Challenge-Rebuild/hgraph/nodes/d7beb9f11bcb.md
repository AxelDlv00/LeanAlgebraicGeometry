---
author: sync
content_type: theorem
created: '2026-07-21T22:01:54'
decl: AlgebraicGeometry.finite_divUniversalHighWindowMulSource
docstring: A successor multiplication source is finite when its input relation module
  is finite.
file: AlgebraicJacobian/Picard/DivSchemeHighWindowRelations.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.finite_divUniversalHighWindowMulSource
type: lean
updated: '2026-07-31T20:15:21'
---
theorem finite_divUniversalHighWindowMulSource (n : Nat)
    (K : Submodule RZ
      (divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) n))
    [Module.Finite RZ ↥K] :
    Module.Finite RZ
      (DivUniversalHighWindowMulSource (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j n K) := by
  infer_instance

set_option maxHeartbeats 1600000 in
-- Reducing the dependent range and its base-changed map exceeds the default budget.
set_option synthInstance.maxHeartbeats 400000 in
-- The range instance combines source finiteness with the dependent multiplication map.