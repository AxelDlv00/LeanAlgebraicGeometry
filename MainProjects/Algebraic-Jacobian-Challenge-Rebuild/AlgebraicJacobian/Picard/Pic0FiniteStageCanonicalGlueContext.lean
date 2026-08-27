/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGlueContext
import AlgebraicJacobian.Picard.Pic0FiniteStageTransportedTripleTransitionFace

/-!
# Canonical finite-stage glue contexts

The general glue context keeps an explicit comparison family because it is useful while
assembling finite-stage data. A face consumer, however, needs the concrete comparison
family attached to the selected transition models. This module provides that boundary
without changing the legacy context: the family is fixed in the type of the triple data,
so a separately reconstructed comparison cannot silently enter a downstream statement.
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

namespace Pic0FiniteStageGlueContext

variable {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]

/-! ## The canonical comparison family -/

/-- The comparison family determined by one bundled transition-model datum. -/
noncomputable def canonicalComparisonFamily
    (D : Pic0FiniteStageTransitionModelsData C F) :
    ∀ q : Pic0FiniteStageTripleTransitionIndex C,
      k ⊗[D.M.1] Pic0FiniteStageTripleTransitionModelTarget
          C D.L D.n D.m D.relation D.M D.mapM q ≃ₐ[k]
        Pic0FiniteStageTripleRing C q.1 q.2.1 q.2.2 :=
  pic0FiniteStageTripleModelComparisonFamily C D.L D.n D.m D.relation
    D.e D.M D.mapM D.comparison

/-! ## Canonical constructor -/

/-- Build a legacy-compatible context with the comparison family pinned to `D`. -/
def ofCanonical
    (D : Pic0FiniteStageTransitionModelsData C F)
    (T : Pic0FiniteStageTripleTransitionFamilyData C
      D.L D.n D.m D.relation D.M D.mapM (canonicalComparisonFamily C D)) :
    Pic0FiniteStageGlueContext C F :=
  { models := D
    Q := canonicalComparisonFamily C D
    triple := T }

@[simp]
theorem ofCanonical_models
    (D : Pic0FiniteStageTransitionModelsData C F)
    (T : Pic0FiniteStageTripleTransitionFamilyData C
      D.L D.n D.m D.relation D.M D.mapM (canonicalComparisonFamily C D)) :
    (ofCanonical C D T).models = D :=
  rfl

@[simp]
theorem ofCanonical_Q
    (D : Pic0FiniteStageTransitionModelsData C F)
    (T : Pic0FiniteStageTripleTransitionFamilyData C
      D.L D.n D.m D.relation D.M D.mapM (canonicalComparisonFamily C D)) :
    (ofCanonical C D T).Q = canonicalComparisonFamily C D :=
  rfl

@[simp]
theorem ofCanonical_triple
    (D : Pic0FiniteStageTransitionModelsData C F)
    (T : Pic0FiniteStageTripleTransitionFamilyData C
      D.L D.n D.m D.relation D.M D.mapM (canonicalComparisonFamily C D)) :
    (ofCanonical C D T).triple = T :=
  rfl

end Pic0FiniteStageGlueContext

end

end AlgebraicGeometry
