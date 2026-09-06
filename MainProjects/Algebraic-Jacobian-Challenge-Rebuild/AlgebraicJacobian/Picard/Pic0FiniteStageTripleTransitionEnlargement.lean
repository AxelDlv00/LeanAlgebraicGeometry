/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.TensorStageMapEnlargement
import AlgebraicJacobian.Picard.Pic0FiniteStageGluePackageCore

/-!
# Enlarging the field of triple-transition coefficients

A finite-stage triple-transition family extends to any larger finite intermediate
field. Its comparison with the ambient transition maps is preserved. In particular,
a glue context can retain its chosen atlas models while extending its triple maps
to a stage that also carries the universal chart classes.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {F K : Type u} [Field F] [Field K] [Algebra F K]
  (C : Over (Spec (.of K))) [SmoothOfRelativeDimension 1 C.hom]
  [IsProper C.hom] [GeometricallyIrreducible C.hom] [IsSepClosed K]
  {L : DatG0.FinSubext F K}
  {n m : Pic0FiniteStageRingIndex C → ℕ}
  {relation : ∀ j, Fin (m j) → MvPolynomial (Fin (n j)) L.1}
  {M : DatG0.FinSubext L.1 K} [Algebra.IsAlgebraic M.1 K]
  {mapM : ∀ q : Pic0FiniteStageMapIndex C,
    Pic0FiniteStageModelRing C L n m relation M (Pic0FiniteStageMapSource C q) →ₐ[M.1]
      Pic0FiniteStageModelRing C L n m relation M (Pic0FiniteStageMapTarget C q)}
  {Q : ∀ p : Pic0FiniteStageTripleTransitionIndex C,
    K ⊗[M.1] Pic0FiniteStageTripleTransitionModelTarget C L n m relation M mapM p ≃ₐ[K]
      Pic0FiniteStageTripleRing C p.1 p.2.1 p.2.2}

namespace Pic0FiniteStageTripleTransitionFamilyData

variable (T : Pic0FiniteStageTripleTransitionFamilyData C L n m relation M mapM Q)

/-- Enlarge the coefficient field of every triple map while keeping its ambient
comparison and the original atlas models fixed. -/
def enlarge (S : DatG0.FinSubext M.1 K) (h : T.N.1 ≤ S.1) :
    Pic0FiniteStageTripleTransitionFamilyData C L n m relation M mapM Q where
  N := S
  thetaN p := DatG0.tensorAlgHomOfLE h (T.thetaN p)
  comparison p := DatG0.tensorAlgHomOfLE_comparison h (T.thetaN p)
    (pic0FiniteStageTransportedTripleTransition C L n m relation M mapM Q p)
    (T.comparison p)

@[simp]
theorem enlarge_N (S : DatG0.FinSubext M.1 K) (h : T.N.1 ≤ S.1) :
    (T.enlarge C S h).N = S := rfl

end Pic0FiniteStageTripleTransitionFamilyData

namespace Pic0FiniteStageGlueContext

variable [Algebra.IsAlgebraic F K] (E : Pic0FiniteStageGlueContext C F)

/-- Retain the chosen transition models and extend the triple-transition maps to
the prescribed larger stage. -/
def enlarge (S : DatG0.FinSubext E.models.M.1 K) (h : E.triple.N.1 ≤ S.1) :
    Pic0FiniteStageGlueContext C F where
  models := E.models
  triple := E.triple.enlarge C S h

@[simp]
theorem enlarge_models (S : DatG0.FinSubext E.models.M.1 K) (h : E.triple.N.1 ≤ S.1) :
    (E.enlarge C S h).models = E.models := rfl

@[simp]
theorem enlarge_N (S : DatG0.FinSubext E.models.M.1 K) (h : E.triple.N.1 ≤ S.1) :
    (E.enlarge C S h).triple.N = S := rfl

end Pic0FiniteStageGlueContext

end

end AlgebraicGeometry
