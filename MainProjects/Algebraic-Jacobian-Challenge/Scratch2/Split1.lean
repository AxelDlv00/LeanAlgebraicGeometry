import Mathlib

open scoped TensorProduct

universe u

namespace Probe

variable (K L : Type u) [Field K] [Field L] [Algebra K L]
  [FiniteDimensional K L] [IsGalois K L]

/-- The comparison `L ⊗[K] L → (Gal(L/K) → L)`, `a ⊗ b ↦ (γ ↦ a * γ b)`.
`L`-algebra map for the LEFT factor. -/
noncomputable def splitHom : (L ⊗[K] L) →ₐ[L] ((L ≃ₐ[K] L) → L) :=
  Algebra.TensorProduct.lift (Algebra.ofId L _)
    (Pi.algHom _ _ fun γ : L ≃ₐ[K] L => (γ : L →ₐ[K] L))
    (fun _ _ => Commute.all _ _)

example (a b : L) (γ : L ≃ₐ[K] L) : splitHom K L (a ⊗ₜ b) γ = a * γ b := by
  simp [splitHom, Algebra.ofId_apply]

end Probe
