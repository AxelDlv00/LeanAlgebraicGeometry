---
author: sync
content_type: theorem
created: '2026-07-22T11:03:23'
decl: AlgebraicGeometry.map_divUniversalHighWindowBaseMultiplierTransition_relation_zero_le
docstring: 'Multiplication by any base-field multiplier preserves the relation tower
  at

  its initial transition.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowTransitionRelationZero.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.map_divUniversalHighWindowBaseMultiplierTransition_relation_zero_le
type: lean
updated: '2026-07-29T15:31:40'
---
theorem map_divUniversalHighWindowBaseMultiplierTransition_relation_zero_le
    (a : HS) :
    Submodule.map
        (divUniversalHighWindowBaseMultiplierTransition (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j 0 a)
        (divUniversalHighWindowRelation (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j 0) ≤
      divUniversalHighWindowRelation (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j 1 :=
  (map_divUniversalHighWindowBaseMultiplierTransition_le_mulSpan
    (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j 0
      (divUniversalHighWindowRelation (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j 0) a).trans
    (divUniversalHighWindowMulSpan_zero_relation_le_one
      (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j)

set_option maxHeartbeats 1600000 in
-- The zero branch unfolds the transported seed multiplication span.