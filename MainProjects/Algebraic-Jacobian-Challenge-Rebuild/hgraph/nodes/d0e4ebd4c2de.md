---
author: sync
content_type: theorem
created: '2026-07-22T01:32:17'
decl: AlgebraicGeometry.map_divUniversalHighWindowShiftedRelationTransitionOfLE_relation_le
docstring: The shifted arbitrary-index transition preserves the recursive relation
  modules.
file: AlgebraicJacobian/Picard/DivSchemeHighWindowTransitionRelation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.map_divUniversalHighWindowShiftedRelationTransitionOfLE_relation_le
type: lean
updated: '2026-07-31T20:15:22'
---
theorem map_divUniversalHighWindowShiftedRelationTransitionOfLE_relation_le
    (side : Bool) (n m : Nat) (h : n ≤ m) :
    Submodule.map
        (divUniversalHighWindowShiftedRelationTransitionOfLE
          (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j side n m h)
        (divUniversalHighWindowRelation (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j (n + 1)) ≤
      divUniversalHighWindowRelation (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j (m + 1) := by
  exact HighWindowTransitionKit.map_transitionOfLE_le
    (fun q => G (q + 1))
    (fun q => divUniversalHighWindowRelationTransition (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j side (q + 1))
    (fun q => divUniversalHighWindowRelation (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j (q + 1))
    (fun q y hy => map_divUniversalHighWindowRelationTransition_relation_succ_le
      (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j q side ⟨y, hy, rfl⟩)
    n m h