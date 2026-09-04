/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGlueDataAssembly
import AlgebraicJacobian.Picard.Pic0FiniteStageTransitionModels
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleTransitionModels

/-!
# A canonical finite-stage Picard glue package

The simultaneous pair- and triple-transition descent theorems produce one coherent
finite-stage model.  The package below stores that model once and indexes its triple
transition data directly by the comparison family determined by the model.

In particular, there is no freely chosen comparison family, equality witness identifying
it with the canonical family, or second wrapper around the resulting package.
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
  models : Pic0FiniteStageTransitionModelsData C F
  N : DatG0.FinSubext models.M.1 k
  thetaN : forall p : Pic0FiniteStageTripleTransitionIndex C,
    Pic0FiniteStageTripleTransitionFamilyMap
      C models.L models.n models.m models.relation models.M models.mapM N p
  comparison : forall p : Pic0FiniteStageTripleTransitionIndex C,
    Pic0FiniteStageTripleTransitionFamilyComparison
      C models.L models.n models.m models.relation models.M models.mapM
        (pic0FiniteStageTripleModelComparisonFamily
          C models.L models.n models.m models.relation models.e
            models.M models.mapM models.comparison)
        N p (thetaN p)

namespace Pic0FiniteStageGluePackage

/-- Construct the complete glue package from a finite-stage transition model. -/
noncomputable def ofModels
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (D : Pic0FiniteStageTransitionModelsData C F) :
    Pic0FiniteStageGluePackage C F := by
  let T := Pic0FiniteStageTripleTransitionFamilyData.of_comparisons
    C D.L D.n D.m D.relation D.M D.mapM
      (pic0FiniteStageTripleModelComparisonFamily
        C D.L D.n D.m D.relation D.e D.M D.mapM D.comparison)
  exact {
    models := D
    N := T.N
    thetaN := T.thetaN
    comparison := T.comparison
  }

/-- A finite-presentation witness for a scalar-extended finite-stage chart ring. -/
theorem finitePresentation_pic0FiniteStageChartBaseChangeRing
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (U : Pic0FiniteStageChartIndex C) :
    Algebra.FinitePresentation N.1
      (Pic0FiniteStageChartBaseChangeRing C L n m relation M N U) := by
  letI : Algebra M.1
      (Pic0FiniteStageChartModelRing C L n m relation M U) :=
    Algebra.TensorProduct.leftAlgebra
      (R := L.1) (S := M.1) (A := M.1)
      (B := DatG0.FiniteRelationAlgebra L.1
        (n (Sum.inl U)) (m (Sum.inl U)) (relation (Sum.inl U)))
  letI : CommRing
      (Pic0FiniteStageChartModelRing C L n m relation M U) := inferInstance
  letI : Algebra.FinitePresentation M.1
      (Pic0FiniteStageChartModelRing C L n m relation M U) := by
    exact Algebra.FinitePresentation.baseChange M.1
  exact Algebra.FinitePresentation.baseChange N.1

/-- A finite-type witness for a scalar-extended finite-stage chart ring. -/
theorem finiteType_pic0FiniteStageChartBaseChangeRing
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (U : Pic0FiniteStageChartIndex C) :
    Algebra.FiniteType N.1
      (Pic0FiniteStageChartBaseChangeRing C L n m relation M N U) := by
  exact @Algebra.FiniteType.of_finitePresentation
    N.1 (Pic0FiniteStageChartBaseChangeRing C L n m relation M N U)
    (inferInstance : CommRing N.1)
    (pic0FiniteStageChartBaseChangeCommRing C L n m relation M N U)
    (pic0FiniteStageChartBaseChangeAlgebra C L n m relation M N U)
    (finitePresentation_pic0FiniteStageChartBaseChangeRing
      C L n m relation M N U)

/-- The affine gluing presentation computed from the package's canonical data. -/
noncomputable def presentation
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    AlgebraicJacobian.AffineRingGluePresentation P.N.1 := by
  letI : Algebra.IsAlgebraic P.models.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.models.M.1 k := by infer_instance
  refine pic0FiniteStageAffineRingGluePresentation
    C P.models.L P.models.n P.models.m P.models.relation P.models.M
      P.models.mapM P.N P.models.e P.models.comparison
      P.models.openImmersion P.thetaN ?_
  rintro ⟨U, V, W⟩
  simpa only [Pic0FiniteStageTripleTransitionFamilyComparison,
    pic0FiniteStageTransportedTripleTransitionOfModels] using
      P.comparison (U, (V, W))

/-- The scheme glue datum underlying the canonical presentation. -/
noncomputable def glueData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) : Scheme.GlueData :=
  P.presentation.glueData

@[simp]
theorem presentation_glueData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    P.presentation.glueData = P.glueData :=
  rfl

end Pic0FiniteStageGluePackage

/-- The simultaneous finite-stage descent producers inhabit the canonical package. -/
theorem exists_pic0FiniteStageGluePackage
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k] :
    Nonempty (Pic0FiniteStageGluePackage C F) :=
  ⟨Pic0FiniteStageGluePackage.ofModels C
    (Pic0FiniteStageTransitionModelsData.of_models (C := C) (F := F))⟩

end

end AlgebraicGeometry
