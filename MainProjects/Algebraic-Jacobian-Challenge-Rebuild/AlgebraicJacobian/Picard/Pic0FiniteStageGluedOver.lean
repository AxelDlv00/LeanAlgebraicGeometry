/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGluePackage
import AlgebraicJacobian.Descent.GluedMapData

/-!
# The finite-stage Picard glue as a scheme over its field of definition

The finite-stage glue package already contains affine algebras over its final finite
subextension `P.N.1`.  Their structure maps agree on overlaps, so they descend to the
glued scheme.  This retains the finite-stage object over `Spec P.N.1`, which is the
object-level input for the scalar-extension comparison with the separably closed atlas.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TensorProduct
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

namespace Pic0FiniteStageGluePackage

set_option linter.style.setOption false
set_option synthInstance.maxHeartbeats 3200000 in
-- Projecting the dependent scalar towers from `P` requires a larger local synthesis budget.
set_option maxHeartbeats 12800000 in
/-- The structure map from the finite-stage glued scheme to its field of definition. -/
noncomputable def gluedMapData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    AlgebraicJacobian.GluedMapData P.glueData (Spec (.of P.N.1)) := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  let A : Pic0FiniteStageChartIndex C -> Type u := fun U =>
    Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U
  let B : Pic0FiniteStageChartIndex C -> Pic0FiniteStageChartIndex C -> Type u :=
    fun U V =>
      Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V
  letI : ∀ U, Algebra P.M.1
      (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U) := fun U =>
    by
      dsimp only [Pic0FiniteStageChartModelRing, Pic0FiniteStageModelRing]
      exact Algebra.TensorProduct.leftAlgebra
        (R := P.L.1) (S := P.M.1) (A := P.M.1)
        (B := DatG0.FiniteRelationAlgebra P.L.1
          (P.n (Sum.inl U)) (P.m (Sum.inl U))
          (P.relation (Sum.inl U)))
  letI : ∀ U, CommRing
      (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U) :=
    fun U => by
      letI : CommRing
          (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U) := inferInstance
      letI : CommSemiring
          (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U) :=
        (inferInstance : CommRing
          (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U)).toCommSemiring
      dsimp only [Pic0FiniteStageChartBaseChangeRing]
      exact Algebra.TensorProduct.instCommRing
  letI : ∀ U, Algebra P.N.1
      (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U) :=
    fun U => by
      letI : Algebra P.M.1
          (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U) :=
        Algebra.TensorProduct.leftAlgebra
          (R := P.L.1) (S := P.M.1) (A := P.M.1)
          (B := DatG0.FiniteRelationAlgebra P.L.1
            (P.n (Sum.inl U)) (P.m (Sum.inl U))
            (P.relation (Sum.inl U)))
      letI : CommRing
          (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U) := inferInstance
      letI : CommSemiring
          (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U) :=
        (inferInstance : CommRing
          (Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U)).toCommSemiring
      dsimp only [Pic0FiniteStageChartBaseChangeRing]
      exact Algebra.TensorProduct.leftAlgebra
        (R := P.M.1) (S := P.N.1) (A := P.N.1)
        (B := Pic0FiniteStageChartModelRing C P.L P.n P.m P.relation P.M U)
  let r : ∀ U V, A U →ₐ[P.N.1] B U V := fun U V =>
    pic0FiniteStageRestrictionBaseChange
      C P.L P.n P.m P.relation P.M P.mapM P.N U V
  /- Pin the carrier witnesses before constructing the scalar tower.  These
     aliases are dependent tensor products, so an inferred propositionally equal
     instance is not interchangeable with the one used by `r`. -/
  letI (U : Pic0FiniteStageChartIndex C) : CommRing (A U) :=
    pic0FiniteStageChartBaseChangeCommRing
      C P.L P.n P.m P.relation P.M P.N U
  letI (U V : Pic0FiniteStageChartIndex C) : CommRing (B U V) :=
    pic0FiniteStageOverlapBaseChangeCommRing
      C P.L P.n P.m P.relation P.M P.N U V
  letI (U : Pic0FiniteStageChartIndex C) : Algebra P.N.1 (A U) :=
    pic0FiniteStageChartBaseChangeAlgebra
      C P.L P.n P.m P.relation P.M P.N U
  letI (U V : Pic0FiniteStageChartIndex C) : Algebra P.N.1 (B U V) :=
    pic0FiniteStageOverlapBaseChangeAlgebra
      C P.L P.n P.m P.relation P.M P.N U V
  letI : ∀ U V, Algebra (A U) (B U V) := fun U V =>
    @pic0FiniteStageAlgebraOfMap P.N.1 (A U) (B U V)
      (inferInstance : CommRing P.N.1)
      (inferInstance : CommRing (A U))
      (inferInstance : CommRing (B U V))
      (inferInstance : Algebra P.N.1 (A U))
      (inferInstance : Algebra P.N.1 (B U V))
      (r U V)
  letI : ∀ U V, IsScalarTower P.N.1 (A U) (B U V) := fun U V =>
    @pic0FiniteStageTowerOfMap P.N.1 (A U) (B U V)
      (inferInstance : CommRing P.N.1)
      (inferInstance : CommRing (A U))
      (inferInstance : CommRing (B U V))
      (inferInstance : Algebra P.N.1 (A U))
      (inferInstance : Algebra P.N.1 (B U V))
      (r U V)
  let tau : ∀ U V, B V U →ₐ[P.N.1] B U V := fun U V =>
    pic0FiniteStageTransitionBaseChange
      C P.L P.n P.m P.relation P.M P.mapM P.N U V
  refine AlgebraicJacobian.GluedMapData.ofChartMaps ?_ ?_
  · intro U
    change Pic0FiniteStageChartIndex C at U
    exact Spec.map (CommRingCat.ofHom (algebraMap P.N.1 (A U)))
  · intro U V
    change Pic0FiniteStageChartIndex C at U V
    change
      Spec.map (CommRingCat.ofHom (algebraMap (A U) (B U V))) ≫
          Spec.map (CommRingCat.ofHom (algebraMap P.N.1 (A U))) =
        (Spec.map (CommRingCat.ofHom (tau U V).toRingHom) ≫
          Spec.map (CommRingCat.ofHom (algebraMap (A V) (B V U)))) ≫
            Spec.map (CommRingCat.ofHom (algebraMap P.N.1 (A V)))
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
    rw [Category.assoc, ← Spec.map_comp, ← CommRingCat.ofHom_comp]
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
    congr 1
    ext x
    simp only [CommRingCat.ofHom_comp, CommRingCat.hom_comp,
      ConcreteCategory.hom_ofHom, RingHom.coe_comp, Function.comp_apply,
      AlgHom.toRingHom_eq_coe, Category.assoc, RingHom.coe_coe]
    rw [← IsScalarTower.algebraMap_apply P.N.1 (A U) (B U V)]
    rw [← IsScalarTower.algebraMap_apply P.N.1 (A V) (B V U)]
    exact (tau U V).commutes x |>.symm

/-! ## Stable presentation boundary

The legacy package computes a dependent `GluedMapData` whose glue datum is fixed by its
type.  Pin that value immediately into the generic presentation API.  Downstream code can
then carry one value with a proof-independent projection type instead of reopening the
assembly definition through `P.glueData`.
-/

set_option synthInstance.maxHeartbeats 400000 in
-- The presentation body contains the legacy nested tensor witnesses.
set_option maxHeartbeats 12800000 in
-- The presentation body unfolds the legacy map datum once, at this boundary.
/-- The selected affine gluing presentation attached to a legacy finite-stage package. -/
noncomputable def presentation
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    AlgebraicJacobian.AffineRingGluePresentation P.N.1 :=
  AlgebraicJacobian.AffineRingGluePresentation.ofMapData P.gluedMapData

set_option maxHeartbeats 12800000 in
-- The projection reduces a dependent `GluedMapData` once, so keep it out of client files.
@[simp]
theorem presentation_glueData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    P.presentation.glueData = P.glueData :=
  rfl

set_option maxHeartbeats 12800000 in
-- The projection is definitionally the selected map datum.
@[simp]
theorem presentation_mapData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    P.presentation.mapData = P.gluedMapData :=
  rfl

/-! The old wrapper stored `GluedMapData P.glueData` directly.  That repeated the
dependent glue construction at every use site.  Reuse the pinned presentation instead:
the carrier and map are now indexed by one selected value, with no producer proofs in the
consumer-facing type. -/
abbrev GluedOverData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :=
  AlgebraicJacobian.AffineRingGluePresentation P.N.1

namespace GluedOverData

/-- The structure map carried by the selected presentation. -/
def map
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    {P : Pic0FiniteStageGluePackage C F}
    (Q : GluedOverData C P) : Q.glueData.glued ⟶ Spec (.of P.N.1) :=
  AlgebraicJacobian.AffineRingGluePresentation.map Q

/-- The selected glue as an object of the slice over its finite-stage field. -/
def «over»
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    {P : Pic0FiniteStageGluePackage C F}
    (Q : GluedOverData C P) : Over (Spec (.of P.N.1)) :=
  AlgebraicJacobian.AffineRingGluePresentation.over Q

@[simp]
theorem map_eq
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    {P : Pic0FiniteStageGluePackage C F}
    (Q : GluedOverData C P) : Q.map = Q.mapData.map :=
  rfl

/-- The chart-factor equation exposed without opening the generic map package. -/
theorem chartMap_factor
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    {P : Pic0FiniteStageGluePackage C F}
    (Q : GluedOverData C P) (U : Q.glueData.J) :
    Q.glueData.ι U ≫ Q.map = Q.mapData.chartMap U := by
  exact AlgebraicJacobian.AffineRingGluePresentation.chartMap_factor Q U

end GluedOverData

/-- The canonical finite-stage glue package, built once from `P.gluedMapData`. -/
noncomputable def gluedOverData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) : GluedOverData C P :=
  P.presentation

/-- The structure map from the finite-stage glued scheme to its field of definition. -/
noncomputable def gluedMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    P.glueData.glued ⟶ Spec (.of P.N.1) :=
  P.gluedMapData.map

@[simp]
theorem gluedMapData_chartMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U : Pic0FiniteStageChartIndex C) :
    P.gluedMapData.chartMap U =
      (letI : CommRing
          (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U) :=
        pic0FiniteStageChartBaseChangeRingCommRing
          C P.L P.n P.m P.relation P.M P.N U
       letI : Algebra P.N.1
          (Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U) :=
        pic0FiniteStageChartBaseChangeRingAlgebra
          C P.L P.n P.m P.relation P.M P.N U
       Spec.map (CommRingCat.ofHom
         (@algebraMap P.N.1
           (Pic0FiniteStageChartBaseChangeRing
             C P.L P.n P.m P.relation P.M P.N U)
           (inferInstance : CommSemiring P.N.1)
           (pic0FiniteStageChartBaseChangeRingCommRing
             C P.L P.n P.m P.relation P.M P.N U).toSemiring
           (pic0FiniteStageChartBaseChangeRingAlgebra
             C P.L P.n P.m P.relation P.M P.N U)))) := by
  rfl

/-- The finite-stage Picard glue, retained over the finite field `P.N.1`. -/
noncomputable def gluedOver
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) : Over (Spec (.of P.N.1)) :=
  Over.mk P.gluedMap

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
