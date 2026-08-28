/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageGluePackage

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

private abbrev gluedChartRing
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U : Pic0FiniteStageChartIndex C) : Type u :=
  Pic0FiniteStageChartBaseChangeRing C P.L P.n P.m P.relation P.M P.N U

private abbrev gluedOverlapRing
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) : Type u :=
  Pic0FiniteStageOverlapBaseChangeRing C P.L P.n P.m P.relation P.M P.N U V

set_option linter.style.setOption false
set_option synthInstance.maxHeartbeats 3200000 in
-- Projecting the dependent scalar towers from `P` requires a larger local synthesis budget.
set_option maxHeartbeats 12800000 in
/-- The structure map from the finite-stage glued scheme to its field of definition. -/
noncomputable def gluedMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    P.glueData.glued ⟶ Spec (.of P.N.1) := by
  letI : Algebra.IsAlgebraic P.L.1 k := by infer_instance
  letI : Algebra.IsAlgebraic P.M.1 k := by infer_instance
  let r : ∀ U V, gluedChartRing C P U →ₐ[P.N.1] gluedOverlapRing C P U V := fun U V =>
    pic0FiniteStageRestrictionBaseChange
      C P.L P.n P.m P.relation P.M P.mapM P.N U V
  letI : ∀ U V, Algebra (gluedChartRing C P U) (gluedOverlapRing C P U V) := fun U V =>
    pic0FiniteStageAlgebraOfMap (r U V)
  letI : ∀ U V, IsScalarTower P.N.1 (gluedChartRing C P U) (gluedOverlapRing C P U V) := fun U V =>
    pic0FiniteStageTowerOfMap (r U V)
  let tau : ∀ U V, gluedOverlapRing C P V U →ₐ[P.N.1] gluedOverlapRing C P U V := fun U V =>
    pic0FiniteStageTransitionBaseChange
      C P.L P.n P.m P.relation P.M P.mapM P.N U V
  fapply Multicoequalizer.desc
  · intro U
    change Pic0FiniteStageChartIndex C at U
    exact Spec.map (CommRingCat.ofHom (algebraMap P.N.1 (gluedChartRing C P U)))
  · rintro ⟨U, V⟩
    change Pic0FiniteStageChartIndex C at U V
    change
      Spec.map (CommRingCat.ofHom (algebraMap (gluedChartRing C P U)
        (gluedOverlapRing C P U V))) ≫
          Spec.map (CommRingCat.ofHom (algebraMap P.N.1 (gluedChartRing C P U))) =
        (Spec.map (CommRingCat.ofHom (tau U V).toRingHom) ≫
          Spec.map (CommRingCat.ofHom (algebraMap (gluedChartRing C P V)
            (gluedOverlapRing C P V U)))) ≫
            Spec.map (CommRingCat.ofHom (algebraMap P.N.1 (gluedChartRing C P V)))
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
    rw [Category.assoc, ← Spec.map_comp, ← CommRingCat.ofHom_comp]
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
    congr 1
    ext x
    simp only [CommRingCat.ofHom_comp, CommRingCat.hom_comp,
      ConcreteCategory.hom_ofHom, RingHom.coe_comp, Function.comp_apply,
      AlgHom.toRingHom_eq_coe, Category.assoc, RingHom.coe_coe]
    rw [← IsScalarTower.algebraMap_apply P.N.1 (gluedChartRing C P U)
      (gluedOverlapRing C P U V)]
    rw [← IsScalarTower.algebraMap_apply P.N.1 (gluedChartRing C P V)
      (gluedOverlapRing C P V U)]
    exact (tau U V).commutes x |>.symm

/-- The finite-stage Picard glue, retained over the finite field `P.N.1`. -/
noncomputable def gluedOver
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) : Over (Spec (.of P.N.1)) :=
  Over.mk P.gluedMap

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
