/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageUniversalClass
import AlgebraicJacobian.Picard.Pic0FiniteStageTensorProducer
import AlgebraicJacobian.Picard.Pic0Pullback
import AlgebraicJacobian.Picard.Pic0ThetaAssembly

/-!
# Common finite-stage values of the pinned universal atlas class

Given tensor models of the exact chart and overlap rings and an isomorphism identifying
their curve with a base change, all restrictions of its separably closed universal class
descend to one finite stage above any prescribed stage. The chosen atlas stays on the
given curve. This concerns the values only: compatibility along the descended restriction
maps and gluing to a class on the final carrier are separate obligations.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

section UniversalValues

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

/-- The pinned chart or overlap class selected by the finite ring index. -/
def pic0FiniteStageUniversalRingClass (j : Pic0FiniteStageRingIndex C) :
    pic0Subgroup C (overSpec k (Pic0FiniteStageRing C j)) := by
  cases j with
  | inl U => exact pic0FiniteStageUniversalChartClass C U
  | inr UV => exact pic0FiniteStageUniversalOverlapClass C UV.1 UV.2

end UniversalValues

variable {F K : Type u} [Field F] [Field K] [Algebra F K]
  [Algebra.IsAlgebraic F K] [IsSepClosed K]
  (C : Over (Spec (.of F))) [SmoothOfRelativeDimension 1 C.hom]
  [IsProper C.hom] [GeometricallyIrreducible C.hom]
  (Ck : Over (Spec (.of K))) [SmoothOfRelativeDimension 1 Ck.hom]
  [IsProper Ck.hom] [GeometricallyIrreducible Ck.hom]

/-- The exact universal chart and overlap values descend simultaneously through their
chosen tensor ring models. The image equation retains the pinned source classes, and
the stage contains the prescribed stage holding any previously descended coefficients.
The explicit curve isomorphism preserves the literal atlas of `Ck`, including when the
comparison comes from an iterated base change. -/
theorem exists_pic0FiniteStageUniversalRingClass_tensorStage
    (i : (baseChange F K).obj C ≅ Ck)
    (A : Pic0FiniteStageRingIndex Ck → Type u)
    [∀ j, CommRing (A j)] [∀ j, Algebra F (A j)]
    (e : ∀ j, K ⊗[F] A j ≃ₐ[K] Pic0FiniteStageRing Ck j)
    (S₀ : DatG0.FiniteStageData F K) :
    ∃ (S : DatG0.FiniteStageData F K), S₀.stage ≤ S.stage ∧
      ∃ xS : ∀ j, pic0Subgroup C (overSpec F (S.stage ⊗[F] A j)),
        ∀ j, pic0Map C (Over.overSpecMap (S.tensorMap (A := A j))) (xS j) =
          pic0Map C (mapOverSpecIso F K (K ⊗[F] A j)).inv
            (pic0CrossBaseEquiv F K C (overSpec K (K ⊗[F] A j))
              (pic0Pullback i.hom (overSpec K (K ⊗[F] A j))
                (pic0Map Ck (Over.overSpecMap (e j).symm.toAlgHom)
                  (pic0FiniteStageUniversalRingClass Ck j)))) := by
  exact exists_pic0Subgroup_tensorStage_finite C A S₀
    (fun j => pic0Map C (mapOverSpecIso F K (K ⊗[F] A j)).inv
      (pic0CrossBaseEquiv F K C (overSpec K (K ⊗[F] A j))
        (pic0Pullback i.hom (overSpec K (K ⊗[F] A j))
          (pic0Map Ck (Over.overSpecMap (e j).symm.toAlgHom)
            (pic0FiniteStageUniversalRingClass Ck j)))))

end

end AlgebraicGeometry
