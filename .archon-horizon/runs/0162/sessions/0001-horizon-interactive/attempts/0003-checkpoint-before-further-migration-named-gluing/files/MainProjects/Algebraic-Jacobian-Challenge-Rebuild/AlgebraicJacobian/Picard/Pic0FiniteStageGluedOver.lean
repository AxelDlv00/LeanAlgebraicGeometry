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

/-- The structure map from the finite-stage glued scheme to its field of definition. -/
noncomputable def gluedMapData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    AlgebraicJacobian.GluedMapData P.glueData (Spec (.of P.N.1)) :=
  Pic0FiniteStageGluePackage.canonicalGluedMapData C P

/-- The finite-stage glue datum and its structure map, retained as one dependent value.

The `mapData` field is indexed by `P.glueData` itself.  This is intentional: consumers can
pass the package projections together without transporting a map across a propositionally
equal copy of the glue datum or rebuilding the chart-factor proof.
-/
structure GluedOverData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) where
  mapData : AlgebraicJacobian.GluedMapData P.glueData (Spec (.of P.N.1))

namespace GluedOverData

/-- The exact glue datum indexed by the packaged map. -/
abbrev glueData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    {P : Pic0FiniteStageGluePackage C F}
    (_Q : GluedOverData C P) : Scheme.GlueData :=
  P.glueData

/-- The map carried by the packaged glue datum. -/
def map
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    {P : Pic0FiniteStageGluePackage C F}
    (Q : GluedOverData C P) : P.glueData.glued ⟶ Spec (.of P.N.1) :=
  Q.mapData.map

/-- The packaged glue as an object of the slice over its finite-stage field. -/
def over
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    {P : Pic0FiniteStageGluePackage C F}
    (Q : GluedOverData C P) : Over (Spec (.of P.N.1)) :=
  Over.mk Q.map

@[simp]
theorem map_eq
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    {P : Pic0FiniteStageGluePackage C F}
    (Q : GluedOverData C P) : Q.map = Q.mapData.map :=
  rfl

@[simp]
theorem chartMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    {P : Pic0FiniteStageGluePackage C F}
    (Q : GluedOverData C P) (U : Pic0FiniteStageChartIndex C) :
    Q.mapData.chartMap U =
      Spec.map (CommRingCat.ofHom
        (algebraMap P.N.1
          (Pic0FiniteStageChartBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U))) := by
  rfl

/-- The chart-factor equation exposed without opening the generic map package. -/
theorem chartMap_factor
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    {P : Pic0FiniteStageGluePackage C F}
    (Q : GluedOverData C P) (U : Pic0FiniteStageChartIndex C) :
    P.glueData.ι U ≫ Q.map = Q.mapData.chartMap U := by
  exact Q.mapData.chartMap_factor U

end GluedOverData

/-- The canonical finite-stage glue package, built once from `P.gluedMapData`. -/
noncomputable def gluedOverData
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) : GluedOverData C P :=
  ⟨P.gluedMapData⟩

/-- The structure map from the finite-stage glued scheme to its field of definition. -/
noncomputable def gluedMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) :
    P.glueData.glued ⟶ Spec (.of P.N.1) :=
  P.gluedOverData.map

@[simp]
theorem gluedMapData_chartMap
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U : Pic0FiniteStageChartIndex C) :
    P.gluedMapData.chartMap U =
      Spec.map (CommRingCat.ofHom
        (algebraMap P.N.1
          (Pic0FiniteStageChartBaseChangeRing
            C P.L P.n P.m P.relation P.M P.N U))) := by
  rfl

/-- The finite-stage Picard glue, retained over the finite field `P.N.1`. -/
noncomputable def gluedOver
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F) : Over (Spec (.of P.N.1)) :=
  P.gluedOverData.over

end Pic0FiniteStageGluePackage

end

end AlgebraicGeometry
