---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: TensorProduct.baseChangeAlgebraModulePairing
docstring: '(Implementation) The collapse pairing `(S ⊗[R] A) →ₗ[R] M →ₗ[R] S ⊗[R]
  M`,

  `(s ⊗ a, m) ↦ s ⊗ (a • m)`, obtained by currying the composite of the associator
  with

  the `A`-action collapse on the right factor.'
file: AlgebraicJacobian/Picard/InvertibleModuleTransfer.lean
generated: lean
lean_status: lean_ok
stale: true
title: TensorProduct.baseChangeAlgebraModulePairing
type: lean
updated: '2026-07-29T15:26:31'
---
noncomputable def baseChangeAlgebraModulePairing :
    (S ⊗[R] A) →ₗ[R] M →ₗ[R] S ⊗[R] M :=
  TensorProduct.curry
    ((LinearMap.lTensor S
        ((LinearMap.liftBaseChange A (LinearMap.id : M →ₗ[R] M)).restrictScalars R)) ∘ₗ
      (TensorProduct.assoc R S A M).toLinearMap)

@[simp]