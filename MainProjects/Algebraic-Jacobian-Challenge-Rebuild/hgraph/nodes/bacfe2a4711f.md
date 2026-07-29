---
author: sync
content_type: theorem
created: '2026-07-21T21:31:59'
decl: AlgebraicGeometry.relThetaResSide_relThetaSectionsMul
file: AlgebraicJacobian/Picard/DivSchemeHighWindowChartExhaustion.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relThetaResSide_relThetaSectionsMul
type: lean
updated: '2026-07-29T15:31:40'
---
theorem relThetaResSide_relThetaSectionsMul (a b : Nat) (side : Bool)
    (x : relThetaSections C R pi a) (y : relThetaSections C R pi b) :
    relThetaResSide (a + b) side le_rfl (relThetaSectionsMul C R pi a b x y) =
      relThetaResSide a side le_rfl x * relThetaResSide b side le_rfl y := by
  cases side <;> simp [relThetaSectionsMul, map_mul]

end ThetaMultiplication

section EventualExhaustion

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable (R : Type u) [CommRing R] [Algebra k R]
variable (pi : C.left ⟶ P1 k) [IsFinite pi]