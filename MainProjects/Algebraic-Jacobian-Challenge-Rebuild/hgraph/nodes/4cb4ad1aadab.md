---
author: sync
content_type: definition
created: '2026-07-17T10:22:28'
decl: AlgebraicGeometry.thetaFieldH1PairEquiv
docstring: '**`H¹(𝒪(Θⁿ)) ≃ₗ[k] H¹` of the field pair.**'
file: AlgebraicJacobian/Cohomology/RelThetaTransport.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.thetaFieldH1PairEquiv
type: lean
updated: '2026-07-29T15:26:19'
---
noncomputable def thetaFieldH1PairEquiv :
    Sheaf.HModule (thetaTwistSheaf π n) 1 ≃ₗ[k] (thetaFieldPair C π n).H1 :=
  (thetaFieldPairData C π n).h1Equiv
    (isAffineOpen_preimage_chartOpen π 0) (isAffineOpen_preimage_chartOpen π 1)
    (preimage_chartOpen_sup π)

end FieldPair

/-! ## The relative two-lattice pair at test ring `k` -/

section RelPair

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable (π : C.left ⟶ P1 k) [IsFinite π] (n : ℕ)