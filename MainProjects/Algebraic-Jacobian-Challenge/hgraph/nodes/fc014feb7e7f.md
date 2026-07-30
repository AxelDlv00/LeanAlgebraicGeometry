---
author: sync
content_type: definition
created: '2026-07-30T08:42:03'
decl: AlgebraicJacobian.GaloisDescent.galoisSelfTensorHom
docstring: '**The Galois splitting map** `L ⊗[K] L →ₐ[L] (Gal(L/K) → L)`,

  `a ⊗ b ↦ (γ ↦ a * γ b)`.


  The `L`-algebra structure on the source is the one on the **left** tensor factor,

  and on the target it is the diagonal (constant functions); the left factor is

  carried across untwisted, the right factor by evaluation at each `γ`.'
file: AlgebraicJacobian/Picard/GaloisDescent/GaloisSelfTensor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.galoisSelfTensorHom
type: lean
updated: '2026-07-30T08:42:03'
---
noncomputable def galoisSelfTensorHom : L ⊗[K] L →ₐ[L] ((L ≃ₐ[K] L) → L) :=
  Algebra.TensorProduct.lift (Algebra.ofId L _) (galoisEvalHom K L)
    fun _ _ => Commute.all _ _