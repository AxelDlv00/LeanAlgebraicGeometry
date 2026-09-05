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

/- The finite-stage models and canonical triple-transition data used to glue the
   descended Picard atlas.  The comparison family is pinned once at this
   boundary, so downstream declarations do not re-elaborate its dependent
   tensor carriers. -/
structure Pic0FiniteStageGlueContext
    (F : Type u) [Field F] [Algebra F k] [Algebra.IsAlgebraic F k] where
  models : Pic0FiniteStageTransitionModelsData C F
  /-- The triple-transition family is always indexed by the canonical comparison
  equivalences supplied by `models`; arbitrary comparison families are not valid
  package data because the assembly equations refer to this canonical family. -/
  triple : Pic0FiniteStageTripleTransitionFamilyData
    C models.L models.n models.m models.relation models.M models.mapM
      (pic0FiniteStageTripleModelComparisonFamily
        C models.L models.n models.m models.relation models.e models.M
          models.mapM models.comparison)

namespace Pic0FiniteStageGlueContext

variable {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]

def L (D : Pic0FiniteStageGlueContext C F) := D.models.L
def n (D : Pic0FiniteStageGlueContext C F) := D.models.n
def m (D : Pic0FiniteStageGlueContext C F) := D.models.m
def relation (D : Pic0FiniteStageGlueContext C F) := D.models.relation
def e (D : Pic0FiniteStageGlueContext C F) := D.models.e
def M (D : Pic0FiniteStageGlueContext C F) := D.models.M
def mapM (D : Pic0FiniteStageGlueContext C F) := D.models.mapM
def comparison (D : Pic0FiniteStageGlueContext C F) := D.models.comparison
@[reducible] def openImmersion (D : Pic0FiniteStageGlueContext C F) := D.models.openImmersion
def inverse (D : Pic0FiniteStageGlueContext C F) := D.models.inverse
def N (D : Pic0FiniteStageGlueContext C F) := D.triple.N
def thetaN (D : Pic0FiniteStageGlueContext C F) := D.triple.thetaN
def tripleComparison (D : Pic0FiniteStageGlueContext C F) := D.triple.comparison

@[simp] theorem tripleComparison_family (D : Pic0FiniteStageGlueContext C F) :
    D.triple.comparison =
      pic0FiniteStageTripleModelComparisonFamily
        C D.L D.n D.m D.relation D.e D.M D.mapM D.comparison := rfl

end Pic0FiniteStageGlueContext

end

end AlgebraicGeometry
