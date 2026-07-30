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

omit [FiniteDimensional K L] [IsGalois K L] in
@[simp] lemma splitHom_tmul (a b : L) (γ : L ≃ₐ[K] L) :
    splitHom K L (a ⊗ₜ b) γ = a * γ b := by
  simp [splitHom, Algebra.ofId_apply]

/-- The `L`-linear map underlying `splitHom`. -/
noncomputable def splitLin : (L ⊗[K] L) →ₗ[L] ((L ≃ₐ[K] L) → L) :=
  (splitHom K L).toLinearMap

lemma splitLin_apply (x : L ⊗[K] L) : splitLin K L x = splitHom K L x := rfl

theorem splitHom_surjective : Function.Surjective (splitHom K L) := by
  classical
  have hb : Module.Basis (Module.Free.ChooseBasisIndex K L) K L := Module.Free.chooseBasis K L
  -- range is an L-submodule containing every column
  have hcol : ∀ i, (fun γ : L ≃ₐ[K] L => γ (hb i)) ∈ LinearMap.range (splitLin K L) := by
    intro i
    exact ⟨(1 : L) ⊗ₜ hb i, by ext γ; simp [splitLin_apply]⟩
  have htop : LinearMap.range (splitLin K L) = ⊤ := by
    rw [eq_top_iff, ← galoisCol_span (K := K) (L := L) hb, Submodule.span_le]
    rintro _ ⟨i, rfl⟩
    exact hcol i
  intro y
  obtain ⟨x, hx⟩ := (LinearMap.range_eq_top.mp htop) y
  exact ⟨x, hx⟩

end Probe
