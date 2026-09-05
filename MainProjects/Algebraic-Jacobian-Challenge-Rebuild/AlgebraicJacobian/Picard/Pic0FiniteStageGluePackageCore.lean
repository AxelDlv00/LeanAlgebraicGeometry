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
    (F : Type u) [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    extends Pic0FiniteStageTransitionModelsData C F where
  N : DatG0.FinSubext M.1 k
  thetaN : forall p : Pic0FiniteStageTripleTransitionIndex C,
    Pic0FiniteStageTripleTransitionFamilyMap
      C L n m relation M mapM N p
  tripleComparison : forall p : Pic0FiniteStageTripleTransitionIndex C,
    Pic0FiniteStageTripleTransitionFamilyComparison
      C L n m relation M mapM
        (pic0FiniteStageTripleModelComparisonFamily
          C L n m relation e M mapM comparison)
        N p (thetaN p)

end

end AlgebraicGeometry
