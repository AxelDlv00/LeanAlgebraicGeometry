/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageTripleModelComparison
import AlgebraicJacobian.Picard.Pic0FiniteStageGaloisClasses
import Mathlib.Algebra.Category.CommAlgCat.Basic

/-!
# Universal Picard classes on finite-stage model algebras

The actual chart and overlap models are commutative algebras over their model field.
Their restriction morphisms and ambient comparison equivalences retain those algebra
structures. This fixes the algebra family before constructing compatible universal
classes and descending them to a stage Galois over the original field.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {F K : Type u} [Field F] [Field K] [Algebra F K]
  [Algebra.IsAlgebraic F K] [IsSepClosed K]
  (Ck : Over (Spec (.of K))) [SmoothOfRelativeDimension 1 Ck.hom]
  [IsProper Ck.hom] [GeometricallyIrreducible Ck.hom]
  (D : Pic0FiniteStageTransitionModelsData Ck F)

/-- The actual model rings, viewed as commutative algebras over the model field. -/
def pic0FiniteStageModelAlgebra (j : Pic0FiniteStageRingIndex Ck) :
    CommAlgCat.{u} D.M.1 :=
  CommAlgCat.of D.M.1 (Pic0FiniteStageModelRing Ck D.L D.n D.m D.relation D.M j)

/-- The two actual restriction morphisms of the model atlas, with their endpoints fixed. -/
def pic0FiniteStageModelRestriction (j : Pic0FiniteStageRestrictionIndex Ck) :
    pic0FiniteStageModelAlgebra Ck D (Pic0FiniteStageRestrictionSource Ck j) ⟶
      pic0FiniteStageModelAlgebra Ck D (Pic0FiniteStageRestrictionTarget Ck j) := by
  cases j with
  | inl UV => exact CommAlgCat.ofHom (D.mapM (Sum.inl (Sum.inl UV)))
  | inr UV => exact CommAlgCat.ofHom (D.mapM (Sum.inl (Sum.inr UV)))

/-- Scalar extension identifies each actual model algebra with its pinned exact ring. -/
def pic0FiniteStageModelAlgebraEquiv (j : Pic0FiniteStageRingIndex Ck) :
    K ⊗[D.M.1] (pic0FiniteStageModelAlgebra Ck D j) ≃ₐ[K]
      Pic0FiniteStageRing Ck j :=
  pic0FiniteStageModelBaseChangeEquiv Ck D.L D.n D.m D.relation D.e D.M j

/-- The algebra comparisons identify every scalar-extended model restriction with the
canonical restriction of the exact atlas. -/
theorem pic0FiniteStageModelAlgebraEquiv_naturality
    (j : Pic0FiniteStageRestrictionIndex Ck) :
    (pic0FiniteStageModelAlgebraEquiv Ck D (Pic0FiniteStageRestrictionTarget Ck j)).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom (R := D.M.1) (K := K)
          (pic0FiniteStageModelRestriction Ck D j).hom) =
      (pic0FiniteStageRestriction Ck j).comp
        (pic0FiniteStageModelAlgebraEquiv Ck D
          (Pic0FiniteStageRestrictionSource Ck j)).toAlgHom := by
  cases j with
  | inl UV =>
    exact pic0FiniteStageModelBaseChangeEquiv_naturality
      (F := F) Ck D.L D.n D.m D.relation D.e D.M D.mapM D.comparison
      (Sum.inl (Sum.inl UV))
  | inr UV =>
    exact pic0FiniteStageModelBaseChangeEquiv_naturality
      (F := F) Ck D.L D.n D.m D.relation D.e D.M D.mapM D.comparison
      (Sum.inl (Sum.inr UV))

/-- Conjugating a model restriction by its comparison equivalences recovers its tensor map. -/
theorem pic0FiniteStageModelRestriction_comparison
    (j : Pic0FiniteStageRestrictionIndex Ck) :
    let e := pic0FiniteStageModelAlgebraEquiv Ck D
    Algebra.TensorProduct.map (AlgHom.id D.M.1 K)
        (pic0FiniteStageModelRestriction Ck D j).hom =
      ((e (Pic0FiniteStageRestrictionTarget Ck j)).symm.toAlgHom.comp
        ((pic0FiniteStageRestriction Ck j).comp
          (e (Pic0FiniteStageRestrictionSource Ck j)).toAlgHom)).restrictScalars D.M.1 := by
  intro e
  have h := pic0FiniteStageModelAlgebraEquiv_naturality Ck D j
  apply DFunLike.ext
  intro z
  apply (e (Pic0FiniteStageRestrictionTarget Ck j)).injective
  change (e (Pic0FiniteStageRestrictionTarget Ck j))
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (pic0FiniteStageModelRestriction Ck D j).hom z) =
    (e (Pic0FiniteStageRestrictionTarget Ck j))
      ((e (Pic0FiniteStageRestrictionTarget Ck j)).symm
        (pic0FiniteStageRestriction Ck j
          (e (Pic0FiniteStageRestrictionSource Ck j) z)))
  rw [AlgEquiv.apply_symm_apply]
  exact DFunLike.congr_fun h z

variable (CM : Over (Spec (.of D.M.1))) [SmoothOfRelativeDimension 1 CM.hom]
  [IsProper CM.hom] [GeometricallyIrreducible CM.hom]

/-- The pinned universal class transported to an ambient model algebra. -/
def pic0FiniteStageUniversalModelClass
    (i : (baseChange D.M.1 K).obj CM ≅ Ck)
    (j : Pic0FiniteStageRingIndex Ck) :
    pic0Subgroup CM (overSpec D.M.1
      (K ⊗[D.M.1] (pic0FiniteStageModelAlgebra Ck D j))) :=
  pic0Map CM
    (mapOverSpecIso D.M.1 K (K ⊗[D.M.1] (pic0FiniteStageModelAlgebra Ck D j))).inv
    (pic0CrossBaseEquiv D.M.1 K CM
      (overSpec K (K ⊗[D.M.1] (pic0FiniteStageModelAlgebra Ck D j)))
      (pic0Pullback i.hom
        (overSpec K (K ⊗[D.M.1] (pic0FiniteStageModelAlgebra Ck D j)))
        (pic0Map Ck (Over.overSpecMap (pic0FiniteStageModelAlgebraEquiv Ck D j).symm.toAlgHom)
          (pic0FiniteStageUniversalRingClass Ck j))))

/-- The actual ambient universal values respect both model restriction morphisms. -/
theorem pic0FiniteStageUniversalModelClass_restriction
    (i : (baseChange D.M.1 K).obj CM ≅ Ck)
    (j : Pic0FiniteStageRestrictionIndex Ck) :
    pic0Map CM (Over.overSpecMap
      (Algebra.TensorProduct.map (AlgHom.id D.M.1 K)
        (pic0FiniteStageModelRestriction Ck D j).hom))
        (pic0FiniteStageUniversalModelClass Ck D CM i
          (Pic0FiniteStageRestrictionSource Ck j)) =
      pic0FiniteStageUniversalModelClass Ck D CM i
        (Pic0FiniteStageRestrictionTarget Ck j) := by
  refine (congrArg
    (fun f => pic0Map CM (Over.overSpecMap f)
      (pic0FiniteStageUniversalModelClass Ck D CM i
        (Pic0FiniteStageRestrictionSource Ck j)))
    (pic0FiniteStageModelRestriction_comparison Ck D j)).trans ?_
  exact pic0FiniteStageUniversalRingClass_tensor_restriction
    (F := D.M.1) (K := K) CM Ck i
    (fun j => (pic0FiniteStageModelAlgebra Ck D j : Type u))
    (pic0FiniteStageModelAlgebraEquiv Ck D) j

local instance : IsScalarTower F D.M.1 K :=
  IsScalarTower.of_algebraMap_eq fun _ => rfl

local instance : FiniteDimensional F D.M.1 := by
  letI : FiniteDimensional F D.L.1 := D.L.2
  letI : FiniteDimensional D.L.1 D.M.1 := D.M.2
  exact FiniteDimensional.trans F D.L.1 D.M.1

/-- Compatible pinned classes on the actual model algebras descend to a stage Galois
over the original field, retaining every coefficient in the prescribed stage. -/
theorem exists_pic0FiniteStageUniversalModelClass_compatible_isGalois [IsGalois F K]
    (i : (baseChange D.M.1 K).obj CM ≅ Ck)
    (S₀ : DatG0.FiniteStageData D.M.1 K) :
    ∃ S : DatG0.FiniteStageData D.M.1 K, S₀.stage ≤ S.stage ∧ IsGalois F S.stage ∧
      ∃ xS : ∀ j, pic0Subgroup CM
          (overSpec D.M.1 (S.stage ⊗[D.M.1] (pic0FiniteStageModelAlgebra Ck D j))),
        (∀ j, pic0Map CM (Over.overSpecMap
            (S.tensorMap (A := pic0FiniteStageModelAlgebra Ck D j))) (xS j) =
          pic0FiniteStageUniversalModelClass Ck D CM i j) ∧
        ∀ j : Pic0FiniteStageRestrictionIndex Ck,
          pic0Map CM (Over.overSpecMap
            (Algebra.TensorProduct.map (AlgHom.id D.M.1 S.stage)
              (pic0FiniteStageModelRestriction Ck D j).hom))
            (xS (Pic0FiniteStageRestrictionSource Ck j)) =
              xS (Pic0FiniteStageRestrictionTarget Ck j) := by
  exact exists_pic0Subgroup_tensorStage_compatible_isGalois
    (F₀ := F) (F := D.M.1) (K := K) CM
    (fun j => (pic0FiniteStageModelAlgebra Ck D j : Type u))
    (Pic0FiniteStageRestrictionSource Ck) (Pic0FiniteStageRestrictionTarget Ck)
    (fun j => (pic0FiniteStageModelRestriction Ck D j).hom) S₀
    (pic0FiniteStageUniversalModelClass Ck D CM i)
    (pic0FiniteStageUniversalModelClass_restriction Ck D CM i)

end

end AlgebraicGeometry
