---
author: sync
content_type: theorem
created: '2026-07-22T01:02:01'
decl: AlgebraicGeometry.map_divUniversalHighWindowBaseMultiplierTransition_relation_succ_le
docstring: 'From stage one onward, every base-field multiplier transition preserves
  the

  recursive relation tower.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowTransitionRelation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.map_divUniversalHighWindowBaseMultiplierTransition_relation_succ_le
type: lean
updated: '2026-07-29T15:31:40'
---
theorem map_divUniversalHighWindowBaseMultiplierTransition_relation_succ_le
    (n : Nat) (a : HS) :
    Submodule.map
        (divUniversalHighWindowBaseMultiplierTransition (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j (n + 1) a)
        (divUniversalHighWindowRelation (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j (n + 1)) ≤
      divUniversalHighWindowRelation (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j (n + 2) := by
  rw [divUniversalHighWindowRelation_succ_succ]
  exact map_divUniversalHighWindowBaseMultiplierTransition_le_mulSpan
    (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j (n + 1)
      (divUniversalHighWindowRelation (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j (n + 1)) a

set_option maxHeartbeats 1600000 in
-- Rewriting the recursive dependent relation at `n+2` needs extended reduction.