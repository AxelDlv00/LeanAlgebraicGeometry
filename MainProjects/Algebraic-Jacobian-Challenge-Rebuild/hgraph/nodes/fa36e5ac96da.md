---
author: sync
content_type: definition
created: '2026-07-22T11:03:23'
decl: AlgebraicGeometry.DivUniversalHighWindowMulPreserves
docstring: 'The basis multiplications from `K` land in the chosen successor

  submodule `Knext`.  Keeping this as a hypothesis also covers the exceptional

  seed transition, whose target is not definitionally the recursive range.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowRelativeKoszul.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivUniversalHighWindowMulPreserves
type: lean
updated: '2026-07-22T11:33:49'
---
def DivUniversalHighWindowMulPreserves (n : Nat)
    (K : Submodule RZ
      (divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) n))
    (Knext : Submodule RZ
      (divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) (n + 1))) :
    Prop :=
  ∀ (t : HI) (z : K),
    divUniversalHighWindowBaseMultiplierTransition (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j n ((Module.finBasis k HS) t)
        (K.subtype z) ∈ Knext

set_option maxHeartbeats 1600000 in
-- The supported source vector unfolds the dependent multiplication map.