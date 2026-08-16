/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.TensorFiniteSubextension
import Mathlib.RingTheory.Extension.Presentation.Core

/-!
# Finitely presented algebras at finite subextensions

A finitely presented algebra over an algebraic field extension is defined over a finite
intermediate extension.  The descended algebra is given explicitly by finitely many generators
and finitely many relations.
-/

set_option autoImplicit false

universe u

open TensorProduct

namespace AlgebraicGeometry.DatG0

/-- The algebra presented by `n` generators and the finite family `relation` of relations. -/
abbrev FiniteRelationAlgebra (R : Type u) [CommRing R] (n m : ℕ)
    (relation : Fin m → MvPolynomial (Fin n) R) : Type u :=
  MvPolynomial (Fin n) R ⧸ Ideal.span (Set.range relation)

instance finitePresentation_finiteRelationAlgebra
    (R : Type u) [CommRing R] (n m : ℕ)
    (relation : Fin m → MvPolynomial (Fin n) R) :
    Algebra.FinitePresentation R (FiniteRelationAlgebra R n m relation) := by
  classical
  exact .quotient ⟨Finset.image relation Finset.univ, by simp⟩

set_option synthInstance.maxHeartbeats 100000 in
-- Elaborating the dependent quotient inside the tensor product requires a larger typeclass budget.
/-- Every finitely presented `K`-algebra, for an algebraic field extension `K/F`, is the
base change of a finitely presented algebra over a finite subextension of `K/F`. -/
theorem exists_finSubext_finitePresentation_algebra_model
    {F K A : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing A] [Algebra K A]
    [Algebra.FinitePresentation K A] :
    ∃ L : FinSubext F K,
      ∃ n m : ℕ, ∃ relation : Fin m → MvPolynomial (Fin n) L.1,
        Nonempty (K ⊗[L.1] FiniteRelationAlgebra L.1 n m relation ≃ₐ[K] A) := by
  letI : Algebra F A := Algebra.compHom A (algebraMap F K)
  letI : IsScalarTower F K A := IsScalarTower.of_algebraMap_eq' rfl
  let P := Algebra.Presentation.ofFinitePresentation K A
  let A0 : Subalgebra F K := Algebra.adjoin F P.coeffs
  have hA0 : A0.FG := by
    rw [Subalgebra.fg_iff_finiteType]
    exact Algebra.FiniteType.adjoin_of_finite P.finite_coeffs
  letI : P.HasCoeffs A0 := by
    refine ⟨?_⟩
    intro x hx
    exact ⟨⟨x, Algebra.subset_adjoin hx⟩, rfl⟩
  letI : Algebra.IsAlgebraic F A0 :=
    Algebra.IsAlgebraic.of_injective A0.val Subtype.val_injective
  let L0 : IntermediateField F K := Algebra.IsAlgebraic.toIntermediateField A0
  letI : Algebra.FiniteType F L0 := by
    change Algebra.FiniteType F A0
    exact (Subalgebra.fg_iff_finiteType A0).mp hA0
  letI : Module.Finite F L0 := Algebra.finite_of_essFiniteType_of_isAlgebraic
  let L : FinSubext F K := ⟨L0, inferInstance⟩
  letI : P.HasCoeffs L.1 := by
    change P.HasCoeffs A0
    infer_instance
  refine ⟨L, Algebra.Presentation.ofFinitePresentationVars K A,
    Algebra.Presentation.ofFinitePresentationRels K A,
    P.relationOfHasCoeffs L.1, ?_⟩
  exact ⟨P.tensorModelOfHasCoeffsEquiv L.1⟩

end AlgebraicGeometry.DatG0
