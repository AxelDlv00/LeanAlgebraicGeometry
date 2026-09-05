/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageTransitionModels
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleTransitionModels
import AlgebraicJacobian.Picard.Pic0FiniteStageTransportedTripleTransitionFace

/-!
# Core finite-stage Picard glue package

This module records the finite-stage transition model together with its canonical
triple-transition data. It is kept below the assembly module so the assembly producer
can consume one substantive package rather than a long dependent telescope.
-/

set_option autoImplicit false

universe u

open CategoryTheory TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

/-- The finite-stage models and canonical triple-transition data used to glue the
descended Picard atlas. -/
structure Pic0FiniteStageGluePackage
    (F : Type u) [Field F] [Algebra F k] [Algebra.IsAlgebraic F k] where
  L : DatG0.FinSubext F k
  n : Pic0FiniteStageRingIndex C → ℕ
  m : Pic0FiniteStageRingIndex C → ℕ
  relation : ∀ j, Fin (m j) → MvPolynomial (Fin (n j)) L.1
  e : ∀ j,
    k ⊗[L.1] DatG0.FiniteRelationAlgebra L.1 (n j) (m j) (relation j) ≃ₐ[k]
      Pic0FiniteStageRing C j
  M : DatG0.FinSubext L.1 k
  mapM : ∀ q : Pic0FiniteStageMapIndex C,
    Pic0FiniteStageTransitionModelMap C L n m relation M q
  modelComparison : ∀ q : Pic0FiniteStageMapIndex C,
    Pic0FiniteStageTransitionModelComparison C L n m relation e M mapM q
  openImmersion : ∀ i : Pic0FiniteStageRestrictionIndex C,
    Pic0FiniteStageTransitionOpenImmersion C L n m relation M mapM i
  inverse : ∀ U V : Pic0FiniteStageChartIndex C,
    Pic0FiniteStageTransitionInverse C L n m relation M mapM U V
  N : DatG0.FinSubext M.1 k
  thetaN : forall p : Pic0FiniteStageTripleTransitionIndex C,
    Pic0FiniteStageTripleTransitionFamilyMap
      C L n m relation M mapM N p
  comparison : forall p : Pic0FiniteStageTripleTransitionIndex C,
    Pic0FiniteStageTripleTransitionFamilyComparison
      C L n m relation M mapM
        (pic0FiniteStageTripleModelComparisonFamily
          C L n m relation e M mapM modelComparison)
        N p (thetaN p)

/-- Compatibility view for consumers that still need the transition-model record.

This is a value-level adapter, not a second stored package field; the canonical data lives
in the flat fields above. -/
noncomputable def Pic0FiniteStageGluePackage.models
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) : Pic0FiniteStageTransitionModelsData C F :=
  { L := P.L
    n := P.n
    m := P.m
    relation := P.relation
    e := P.e
    M := P.M
    mapM := P.mapM
    comparison := P.modelComparison
    openImmersion := P.openImmersion
    inverse := P.inverse }

end

end AlgebraicGeometry
