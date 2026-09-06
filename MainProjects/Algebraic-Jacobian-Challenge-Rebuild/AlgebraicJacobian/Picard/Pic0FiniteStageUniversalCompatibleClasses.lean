/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageTensorCompatibility
import AlgebraicJacobian.Picard.Pic0FiniteStageUniversalTensorNaturality

/-!
# Compatible finite-stage values of the pinned universal class

Given tensor models of the exact chart and overlap rings and their restriction maps,
the pinned universal values descend to one common finite stage with both restriction
equations. The stage contains any prescribed finite stage. The result supplies affine
classes; identifying the models with a final glue package, enlarging to a Galois stage,
and constructing a universal class on the glued carrier are further steps.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

variable {F K : Type u} [Field F] [Field K] [Algebra F K]
  [Algebra.IsAlgebraic F K] [IsSepClosed K]
  (C : Over (Spec (.of F))) [SmoothOfRelativeDimension 1 C.hom]
  [IsProper C.hom] [GeometricallyIrreducible C.hom]
  (Ck : Over (Spec (.of K))) [SmoothOfRelativeDimension 1 Ck.hom]
  [IsProper Ck.hom] [GeometricallyIrreducible Ck.hom]

/-- The pinned universal chart and overlap classes admit compatible finite-stage values
through any tensor ring models whose algebra-map comparisons recover the restrictions. -/
theorem exists_pic0FiniteStageUniversalRingClass_compatible_tensorStage
    (i : (baseChange F K).obj C ≅ Ck)
    (A : Pic0FiniteStageRingIndex Ck → Type u)
    [∀ j, CommRing (A j)] [∀ j, Algebra F (A j)]
    (e : ∀ j, K ⊗[F] A j ≃ₐ[K] Pic0FiniteStageRing Ck j)
    (r : ∀ j : Pic0FiniteStageRestrictionIndex Ck,
      A (Pic0FiniteStageRestrictionSource Ck j) →ₐ[F]
        A (Pic0FiniteStageRestrictionTarget Ck j))
    (hr : ∀ j, Algebra.TensorProduct.map (AlgHom.id F K) (r j) =
      ((e (Pic0FiniteStageRestrictionTarget Ck j)).symm.toAlgHom.comp
        ((pic0FiniteStageRestriction Ck j).comp
          (e (Pic0FiniteStageRestrictionSource Ck j)).toAlgHom)).restrictScalars F)
    (S₀ : DatG0.FiniteStageData F K) :
    let x := fun j => pic0Map C (mapOverSpecIso F K (K ⊗[F] A j)).inv
      (pic0CrossBaseEquiv F K C (overSpec K (K ⊗[F] A j))
        (pic0Pullback i.hom (overSpec K (K ⊗[F] A j))
          (pic0Map Ck (Over.overSpecMap (e j).symm.toAlgHom)
            (pic0FiniteStageUniversalRingClass Ck j))))
    ∃ S : DatG0.FiniteStageData F K, S₀.stage ≤ S.stage ∧
      ∃ xS : ∀ j, pic0Subgroup C (overSpec F (S.stage ⊗[F] A j)),
        (∀ j, pic0Map C (Over.overSpecMap (S.tensorMap (A := A j))) (xS j) = x j) ∧
        ∀ j, pic0Map C (Over.overSpecMap
          (Algebra.TensorProduct.map (AlgHom.id F S.stage) (r j)))
            (xS (Pic0FiniteStageRestrictionSource Ck j)) =
              xS (Pic0FiniteStageRestrictionTarget Ck j) := by
  intro x
  apply exists_pic0Subgroup_tensorStage_compatible C A
    (Pic0FiniteStageRestrictionSource Ck) (Pic0FiniteStageRestrictionTarget Ck) r S₀ x
  intro j
  rw [hr j]
  exact pic0FiniteStageUniversalRingClass_tensor_restriction C Ck i A e j

end AlgebraicGeometry
