/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGlueDataAssembly

/-!
# A canonical finite-stage Picard glue package

The package stores only the finite-stage transition context.  Its affine presentation
and scheme glue datum are derived from that context, so every consumer sees the same
canonical charts, overlaps, and transition maps.
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

/-- A finite-stage context together with its selected affine gluing presentation.

The presentation is stored once at this boundary.  Consumers therefore share the
same proof-sensitive `Scheme.GlueData` and map data instead of rebuilding them. -/
structure Pic0FiniteStageGluePackage
    (F : Type u) [Field F] [Algebra F k] [Algebra.IsAlgebraic F k] where
  context : Pic0FiniteStageGlueContext C F

namespace Pic0FiniteStageGluePackage

variable {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]

def models (P : Pic0FiniteStageGluePackage C F) := P.context.models
def L (P : Pic0FiniteStageGluePackage C F) := P.context.L
def n (P : Pic0FiniteStageGluePackage C F) := P.context.n
def m (P : Pic0FiniteStageGluePackage C F) := P.context.m
def relation (P : Pic0FiniteStageGluePackage C F) := P.context.relation
def e (P : Pic0FiniteStageGluePackage C F) := P.context.e
def M (P : Pic0FiniteStageGluePackage C F) := P.context.M
def mapM (P : Pic0FiniteStageGluePackage C F) := P.context.mapM
def comparison (P : Pic0FiniteStageGluePackage C F) := P.context.comparison
def openImmersion (P : Pic0FiniteStageGluePackage C F) := P.context.openImmersion
def inverse (P : Pic0FiniteStageGluePackage C F) := P.context.inverse
def N (P : Pic0FiniteStageGluePackage C F) := P.context.N
def thetaN (P : Pic0FiniteStageGluePackage C F) := P.context.thetaN
def tripleComparison (P : Pic0FiniteStageGluePackage C F) := P.context.tripleComparison

/-- Construct the complete glue package from a finite-stage transition model. -/
noncomputable def ofModels
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (D : Pic0FiniteStageTransitionModelsData C F) :
    Pic0FiniteStageGluePackage C F := by
  let context : Pic0FiniteStageGlueContext C F := {
    models := D
    triple := Pic0FiniteStageTripleTransitionFamilyData.of_comparisons
      C D.L D.n D.m D.relation D.M D.mapM
        (pic0FiniteStageTripleModelComparisonFamily
          C D.L D.n D.m D.relation D.e D.M D.mapM D.comparison)
  }
  exact { context := context }

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

/-- The unique affine presentation derived from the canonical finite-stage context. -/
noncomputable def presentation
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    AlgebraicJacobian.AffineRingGluePresentation P.N.1 :=
  pic0FiniteStageAffineRingGluePresentation C P.context

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
