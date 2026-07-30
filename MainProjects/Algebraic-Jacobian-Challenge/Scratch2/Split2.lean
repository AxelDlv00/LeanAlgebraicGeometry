import Mathlib
import AlgebraicJacobian.Picard.GaloisDescent.SemilinearModules

open scoped TensorProduct
open AlgebraicJacobian.GaloisDescent

universe u

namespace Probe

variable (K L : Type u) [Field K] [Field L] [Algebra K L]
  [FiniteDimensional K L] [IsGalois K L]

noncomputable def splitHom : (L ⊗[K] L) →ₐ[L] ((L ≃ₐ[K] L) → L) :=
  Algebra.TensorProduct.lift (Algebra.ofId L _)
    (Pi.algHom _ _ fun γ : L ≃ₐ[K] L => (γ : L →ₐ[K] L))
    (fun _ _ => Commute.all _ _)

@[simp] lemma splitHom_tmul (a b : L) (γ : L ≃ₐ[K] L) :
    splitHom K L (a ⊗ₜ b) γ = a * γ b := by
  simp [splitHom, Algebra.ofId_apply]

-- Is it bijective?  Try dimension count + injectivity, or surjectivity from galoisCol_span.
example : Function.Surjective (splitHom K L) := by
  classical
  -- the image is an L-submodule containing the columns σ ↦ σ (b i)
  sorry

-- dimension check: both sides have L-dimension = card Gal = finrank K L
example : Module.finrank L (L ⊗[K] L) = Module.finrank L ((L ≃ₐ[K] L) → L) := by
  haveI : Fintype (L ≃ₐ[K] L) := AlgEquiv.fintype K L
  rw [Module.finrank_fintype_fun_eq_card, ← Nat.card_eq_fintype_card,
    IsGalois.card_aut_eq_finrank K L]
  simp [Module.finrank_tensorProduct]

end Probe
