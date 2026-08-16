/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.FinitePresentationAlgebraMapFiniteStage

/-!
# Algebra maps between chosen finite-presentation models

An algebra map between algebras identified with scalar extensions of finitely generated
algebras descends, after transporting it through the chosen identifications, to one common
finite subextension.
-/

set_option autoImplicit false

universe u

open TensorProduct

namespace AlgebraicGeometry.DatG0

/-- A finite family of algebra maps between chosen models of scalar extensions descends to
one common finite subextension.  The displayed equation records the transport direction:
the ambient map on tensor-product models is `eB.symm ∘ phi ∘ eA`. -/
theorem exists_finSubext_tensorProduct_algHom_finite_of_models
    {F K : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] {ι : Type*} [Finite ι]
    (A B A' B' : ι → Type u)
    [∀ i, CommRing (A i)] [∀ i, Algebra F (A i)]
    [∀ i, Algebra.FiniteType F (A i)]
    [∀ i, CommRing (B i)] [∀ i, Algebra F (B i)]
    [∀ i, CommRing (A' i)] [∀ i, Algebra K (A' i)]
    [∀ i, CommRing (B' i)] [∀ i, Algebra K (B' i)]
    (eA : ∀ i, K ⊗[F] A i ≃ₐ[K] A' i)
    (eB : ∀ i, K ⊗[F] B i ≃ₐ[K] B' i)
    (phi : ∀ i, A' i →ₐ[K] B' i) :
    ∃ L : FinSubext F K, ∀ i,
      ∃ phiL : L.1 ⊗[F] A i →ₐ[L.1] L.1 ⊗[F] B i,
        (Algebra.TensorProduct.map L.1.val (AlgHom.id F (B i))).comp
            (phiL.restrictScalars F) =
          (((eB i).symm.toAlgHom.comp
              ((phi i).comp (eA i).toAlgHom)).restrictScalars F).comp
            (Algebra.TensorProduct.map L.1.val (AlgHom.id F (A i))) := by
  exact exists_finSubext_tensorProduct_algHom_finite A B fun i =>
    (eB i).symm.toAlgHom.comp ((phi i).comp (eA i).toAlgHom)

end AlgebraicGeometry.DatG0
