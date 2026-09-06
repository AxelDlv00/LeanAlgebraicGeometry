/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Descent.FiniteGaloisStage
import AlgebraicJacobian.Picard.Pic0FiniteStageTensorCompatibility
import AlgebraicJacobian.Picard.Pic0FiniteStageUniversalTensorNaturality

/-!
# Compatible Picard classes at a finite Galois stage

For an algebraic Galois extension of the original field, finitely many degree-zero
Picard classes on tensor test rings over a finite intermediate field descend to a
common stage Galois over the original field. It contains any prescribed finite stage,
and the restriction equations survive the enlargement.

The construction concerns affine classes and their equations. It does not choose a
glued scheme or identify the stage with the field of an existing glue package.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

variable {F K : Type u} [Field F] [Field K] [Algebra F K]
  [Algebra.IsAlgebraic F K]
  {F₀ : Type u} [Field F₀] [Algebra F₀ F] [Algebra F₀ K]
  [IsScalarTower F₀ F K] [FiniteDimensional F₀ F] [IsGalois F₀ K]
  (C : Over (Spec (.of F))) [SmoothOfRelativeDimension 1 C.hom]
  [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- Finitely many degree-zero classes descend above prescribed coefficients to a
finite stage Galois over the original field `F₀`, even when their rings are over `F`. -/
theorem exists_pic0Subgroup_tensorStage_finite_isGalois
    {ι : Type*} [Finite ι]
    (A : ι → Type u) [∀ i, CommRing (A i)] [∀ i, Algebra F (A i)]
    (S₀ : DatG0.FiniteStageData F K)
    (x : ∀ i, pic0Subgroup C (overSpec F (K ⊗[F] A i))) :
    ∃ S : DatG0.FiniteStageData F K, S₀.stage ≤ S.stage ∧ IsGalois F₀ S.stage ∧
      ∃ xS : ∀ i, pic0Subgroup C (overSpec F (S.stage ⊗[F] A i)),
        ∀ i, pic0Map C (Over.overSpecMap (S.tensorMap (A := A i))) (xS i) = x i := by
  obtain ⟨S, hS, xS, hxS⟩ := exists_pic0Subgroup_tensorStage_finite C A S₀ x
  obtain ⟨T, hST, hT⟩ := S.exists_le_isGalois_of_tower F₀
  let j (i : ι) : S.stage ⊗[F] A i →ₐ[F] T.stage ⊗[F] A i :=
    Algebra.TensorProduct.map (IntermediateField.inclusion hST) (AlgHom.id F (A i))
  refine ⟨T, hS.trans hST, hT,
    fun i => pic0Map C (Over.overSpecMap (j i)) (xS i), ?_⟩
  intro i
  apply Subtype.ext
  change picEtMap C (Over.overSpecMap (T.tensorMap (A := A i)))
    (picEtMap C (Over.overSpecMap (j i)) (xS i).val) = (x i).val
  rw [← picEtMap_comp, ← Over.overSpecMap_comp]
  have hcomp : (T.tensorMap (A := A i)).comp (j i) = S.tensorMap := by
    ext z <;> rfl
  rw [hcomp]
  exact congrArg Subtype.val (hxS i)

/-- A compatible finite family descends to a stage Galois over the original field
`F₀`, with all arrow equations and any previously prescribed finite stage retained. -/
theorem exists_pic0Subgroup_tensorStage_compatible_isGalois
    {ι δ : Type*} [Finite ι]
    (A : ι → Type u) [∀ i, CommRing (A i)] [∀ i, Algebra F (A i)]
    (s t : δ → ι) (r : ∀ d, A (s d) →ₐ[F] A (t d))
    (S₀ : DatG0.FiniteStageData F K)
    (x : ∀ i, pic0Subgroup C (overSpec F (K ⊗[F] A i)))
    (hx : ∀ d, pic0Map C (Over.overSpecMap
      (Algebra.TensorProduct.map (AlgHom.id F K) (r d))) (x (s d)) = x (t d)) :
    ∃ S : DatG0.FiniteStageData F K, S₀.stage ≤ S.stage ∧ IsGalois F₀ S.stage ∧
      ∃ xS : ∀ i, pic0Subgroup C (overSpec F (S.stage ⊗[F] A i)),
        (∀ i, pic0Map C (Over.overSpecMap (S.tensorMap (A := A i))) (xS i) = x i) ∧
        ∀ d, pic0Map C (Over.overSpecMap
          (Algebra.TensorProduct.map (AlgHom.id F S.stage) (r d))) (xS (s d)) =
            xS (t d) := by
  obtain ⟨S, hS, hG, xS, hmap⟩ :=
    exists_pic0Subgroup_tensorStage_finite_isGalois (F₀ := F₀) C A S₀ x
  refine ⟨S, hS, hG, xS, hmap, ?_⟩
  intro d
  apply pic0Map_tensorStage_injective C S (A (t d))
  rw [hmap]
  have hcomp : (S.tensorMap (A := A (t d))).comp
      (Algebra.TensorProduct.map (AlgHom.id F S.stage) (r d)) =
    (Algebra.TensorProduct.map (AlgHom.id F K) (r d)).comp
      (S.tensorMap (A := A (s d))) := by
    ext z <;> rfl
  apply Subtype.ext
  change picEtMap C (Over.overSpecMap (S.tensorMap (A := A (t d))))
    (picEtMap C (Over.overSpecMap
      (Algebra.TensorProduct.map (AlgHom.id F S.stage) (r d))) (xS (s d)).val) =
        (x (t d)).val
  rw [← picEtMap_comp, ← Over.overSpecMap_comp, hcomp,
    Over.overSpecMap_comp, picEtMap_comp]
  change (pic0Map C (Over.overSpecMap
    (Algebra.TensorProduct.map (AlgHom.id F K) (r d)))
    (pic0Map C (Over.overSpecMap (S.tensorMap (A := A (s d)))) (xS (s d)))).val = _
  rw [hmap, hx]

variable [IsSepClosed K]
  (Ck : Over (Spec (.of K))) [SmoothOfRelativeDimension 1 Ck.hom]
  [IsProper Ck.hom] [GeometricallyIrreducible Ck.hom]

/-- The pinned universal chart and overlap values have compatible models at one
stage Galois over `F₀`. The tensor ring models may already be over the finite
extension `F`, and the stage retains any coefficients specified over `F`. -/
theorem exists_pic0FiniteStageUniversalRingClass_compatible_isGalois
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
    ∃ S : DatG0.FiniteStageData F K, S₀.stage ≤ S.stage ∧ IsGalois F₀ S.stage ∧
      ∃ xS : ∀ j, pic0Subgroup C (overSpec F (S.stage ⊗[F] A j)),
        (∀ j, pic0Map C (Over.overSpecMap (S.tensorMap (A := A j))) (xS j) = x j) ∧
        ∀ j, pic0Map C (Over.overSpecMap
          (Algebra.TensorProduct.map (AlgHom.id F S.stage) (r j)))
            (xS (Pic0FiniteStageRestrictionSource Ck j)) =
              xS (Pic0FiniteStageRestrictionTarget Ck j) := by
  intro x
  apply exists_pic0Subgroup_tensorStage_compatible_isGalois (F₀ := F₀) C A
    (Pic0FiniteStageRestrictionSource Ck) (Pic0FiniteStageRestrictionTarget Ck) r S₀ x
  intro j
  rw [hr j]
  exact pic0FiniteStageUniversalRingClass_tensor_restriction C Ck i A e j

end AlgebraicGeometry
