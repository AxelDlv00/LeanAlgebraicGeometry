---
author: sync
content_type: definition
created: '2026-07-22T01:02:01'
decl: AlgebraicGeometry.divUniversalHighWindowShiftMulLinear
docstring: Multiplication into the next high window, linear in the multiplier.
file: AlgebraicJacobian/Picard/DivSchemeHighWindowTransitionRelation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalHighWindowShiftMulLinear
type: lean
updated: '2026-07-31T20:15:22'
---
noncomputable def divUniversalHighWindowShiftMulLinear (n : Nat) :
    HS →ₗ[k] ((H n) →ₗ[k] (H (n + 1))) :=
  (LinearMap.llcomp k _ _ _
    (divUniversalHighWindowSuccEquiv (C := C) (pi := pi) hpi g n).toLinearMap).comp
      (sectionMulBilin k
        (windowS_choice pi hpi g • fiberWeilDivisor pi)
        (divUniversalHighWindowExponent (C := C) (pi := pi) hpi g n •
          fiberWeilDivisor pi))

@[simp]