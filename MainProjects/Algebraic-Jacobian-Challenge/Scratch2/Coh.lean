import Mathlib
import AlgebraicJacobian.Picard.GaloisDescent.GaloisSelfTensor
open scoped TensorProduct
universe u
namespace Probe
variable (K L : Type u) [Field K] [Field L] [Algebra K L]
  [FiniteDimensional K L] [IsGalois K L]
open AlgebraicJacobian.GaloisDescent

/-- THE RING-LEVEL COHERENCE, both legs, via the ring homs Spec actually uses. -/
example (γ : L ≃ₐ[K] L) (a : L) :
    galoisSelfTensorEquiv K L (Algebra.TensorProduct.includeLeftRingHom a) γ = a := by
  show galoisSelfTensorEquiv K L (a ⊗ₜ[K] (1:L)) γ = a
  simp [galoisSelfTensorEquiv_apply_tmul]

example (γ : L ≃ₐ[K] L) (a : L) :
    galoisSelfTensorEquiv K L ((1:L) ⊗ₜ[K] a) γ = γ a := by
  simp [galoisSelfTensorEquiv_apply_tmul]
end Probe
