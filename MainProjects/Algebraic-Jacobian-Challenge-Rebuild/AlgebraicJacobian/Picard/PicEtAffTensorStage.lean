/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicEtTensorStageCover

/-!
# Finite tensor-stage covers for etale Picard representatives

Every element of `PicEtAff C (K tensor[F] B)` can be represented on the base change of an
etale cover over `M tensor[F] B` for some finite subextension `M/F` of `K`.

This descends only the cover carrying the representative. The descent class itself remains
defined over the full tensor base; descending that class and its cocycle equation is a
separate step.
-/

set_option autoImplicit false

universe u

open scoped TensorProduct
open CategoryTheory

namespace AlgebraicGeometry

noncomputable section

/-- A class in the etale plus construction over a tensor base can be represented on the
base change of a cover from a finite tensor stage. The representative's descent class is
still defined over `K tensor[F] B`. -/
theorem exists_finSubext_baseChanged_tensorStage_cover_representation
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (C : Over (Spec (.of F))) (x : PicEtAff C (K ⊗[F] B)) :
    ∃ M : DatG0.FinSubext F K,
      let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
        Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
      letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
        iota.toRingHom.toAlgebra
      ∃ (E₀ : Algebra.EtaleCover (M.1 ⊗[F] B))
        (ξK : descentClasses C (E₀.baseChange (K ⊗[F] B))),
        PicEtAff.mk C (E₀.baseChange (K ⊗[F] B)) ξK = x := by
  induction x using PicEtAff.ind with
  | _ E ξ =>
      obtain ⟨M, hM⟩ := DatG0.exists_finSubext_etaleCover_tensorStage E
      refine ⟨M, ?_⟩
      let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
        Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
      letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) :=
        iota.toRingHom.toAlgebra
      dsimp only at hM ⊢
      obtain ⟨E₀, ⟨e⟩⟩ := hM
      let ψ : E.Carrier ≃ₐ[K ⊗[F] B] (E₀.baseChange (K ⊗[F] B)).Carrier := e.symm
      exact ⟨E₀, descentMap C ψ.toAlgHom ξ,
        PicEtAff.mk_descentMap C ψ.toAlgHom ξ⟩

end

end AlgebraicGeometry
