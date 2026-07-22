---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: Module.actionMap_baseChange_mk
docstring: The action map of `B ⊗[A] X` retracts the base change of `x ↦ 1 ⊗ₜ x`.
file: AlgebraicJacobian/Descent/ModuleDescent.lean
generated: lean
lean_status: lean_ok
title: Module.actionMap_baseChange_mk
type: lean
updated: '2026-07-16T21:33:28'
---
theorem actionMap_baseChange_mk (x : B ⊗[A] X) :
    actionMap A B (B ⊗[A] X) ((TensorProduct.mk A B X 1).baseChange B x) = x := by
  induction x with
  | zero => simp
  | tmul b m => simp [TensorProduct.smul_tmul']
  | add x y hx hy => simp [hx, hy]

end actionMap

variable (A B M) in
/-- A descent datum on a `B`-module `M` relative to `A → B`, in comodule (Sweedler-coring)
form: a `B`-linear coaction `δ : M → B ⊗[A] M` (`B` acting through the left tensor factor
of the target) that is counital and coassociative.  This is equivalent to the classical
formulation via a `B ⊗[A] B`-linear cocycle isomorphism `M ⊗[A] B ≃ B ⊗[A] M`; see the
module docstring for the dictionary. -/
structure DescentDatum where
  /-- The coaction of the descent datum. -/
  coaction : M →ₗ[B] B ⊗[A] M
  /-- The action map retracts the coaction. -/
  counit (m : M) : actionMap A B M (coaction m) = m
  /-- Coassociativity: the two liftings of the coaction to `B ⊗[A] B ⊗[A] M` agree on
  coaction values.  In the classical dictionary this is the cocycle condition. -/
  coassoc (m : M) :
    (coaction.restrictScalars A).baseChange B (coaction m) =
      (TensorProduct.mk A B M 1).baseChange B (coaction m)

namespace DescentDatum

variable (A B) in
/-- The canonical descent datum on a base change `B ⊗[A] N`, with coaction
`b ⊗ₜ n ↦ b ⊗ₜ 1 ⊗ₜ n`. -/
@[simps coaction]