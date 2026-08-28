---
author: sync
content_type: theorem
created: '2026-07-31T03:02:18'
decl: AlgebraicGeometry.P1.isDomain_tensor_away
docstring: '**Ring-level input**: the chart ring stays a domain after base change
  to any field extension

  `K/k`, because `k[t] ⊗[k] K ≅ K[t]`.'
file: AlgebraicJacobian/Curve/P1Curve.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.isDomain_tensor_away
type: lean
updated: '2026-08-01T09:44:10'
---
theorem isDomain_tensor_away {i j : Fin 2} (hij : i ≠ j)
    (K : Type u) [Field K] [Algebra k K] :
    IsDomain (TensorProduct k (Away 𝒜 (X i)) K) := by
  have hPoly : IsDomain (TensorProduct k (Polynomial k) K) := by
    have e2 : TensorProduct k (Polynomial k) K ≃+* TensorProduct k K (Polynomial k) :=
      (Algebra.TensorProduct.comm k (Polynomial k) K).toRingEquiv
    have e1 : TensorProduct k K (Polynomial k) ≃+* Polynomial K :=
      (polyEquivTensor' k K).symm.toRingEquiv
    exact Function.Injective.isDomain (e1.toRingHom.comp e2.toRingHom)
      (e1.injective.comp e2.injective)
  have e : TensorProduct k (Away 𝒜 (X i)) K ≃+* TensorProduct k (Polynomial k) K :=
    (Algebra.TensorProduct.congr (awayAlgEquiv k hij) AlgEquiv.refl).toRingEquiv
  exact Function.Injective.isDomain e.toRingHom e.injective