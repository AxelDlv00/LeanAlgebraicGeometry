---
author: sync
content_type: theorem
created: '2026-07-22T01:02:01'
decl: AlgebraicGeometry.map_divUniversalHighWindowBaseMultiplierTransition_le_mulSpan
docstring: Uniform submodule form of base-field multiplier compatibility.
file: AlgebraicJacobian/Picard/DivSchemeHighWindowTransitionRelation.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.map_divUniversalHighWindowBaseMultiplierTransition_le_mulSpan
type: lean
updated: '2026-07-31T20:14:41'
---
theorem map_divUniversalHighWindowBaseMultiplierTransition_le_mulSpan
    (n : Nat) (K : Submodule RZ (G n)) (a : HS) :
    Submodule.map
        (divUniversalHighWindowBaseMultiplierTransition (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j n a) K ≤
      divUniversalHighWindowMulSpan (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j n K := by
  rintro _ ⟨x, hx, rfl⟩
  exact divUniversalHighWindowBaseMultiplierTransition_mem_mulSpan
    (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j n K a x hx