/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageStableGluePackage

/-!
# A stable finite-stage gluing over its field of definition

This is the scheme-level consumer of `Pic0FiniteStageStableGluePackage`.  It projects the
already selected map and slice object from the pinned affine presentation; it does not
reconstruct chart algebras, scalar towers, or a second multicoequalizer map.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

namespace Pic0FiniteStageStableGluePackage

variable {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]

/-- The selected finite-stage gluing and its structure map.

The map is indexed by the exact affine presentation.  Its slice object is derived below rather
than stored independently, keeping the source definitionally equal to the selected gluing.
-/
structure GluedOverData (P : Pic0FiniteStageStableGluePackage C F) where
  mapData : AlgebraicJacobian.GluedMapData P.presentation.glueData
    (Spec (.of P.context.triple.N.1))

namespace GluedOverData

/-- The exact glue datum indexed by the packaged structure map. -/
def glueData {P : Pic0FiniteStageStableGluePackage C F}
    (_Q : GluedOverData C P) : Scheme.GlueData :=
  P.presentation.glueData

/-- The structure map carried by the packaged finite-stage gluing. -/
def map {P : Pic0FiniteStageStableGluePackage C F}
    (Q : GluedOverData C P) :
    P.presentation.glueData.glued ⟶ Spec (.of P.context.triple.N.1) :=
  Q.mapData.map

/-- The packaged gluing as an object over its finite-stage field. -/
def asOver {P : Pic0FiniteStageStableGluePackage C F}
    (Q : GluedOverData C P) : Over (Spec (.of P.context.triple.N.1)) :=
  Over.mk Q.map

@[simp]
theorem asOver_hom {P : Pic0FiniteStageStableGluePackage C F}
    (Q : GluedOverData C P) : Q.asOver.hom = Q.map :=
  rfl

@[simp]
theorem chartMap_factor {P : Pic0FiniteStageStableGluePackage C F}
    (Q : GluedOverData C P) (i : P.presentation.glueData.J) :
    P.presentation.glueData.ι i ≫ Q.map = Q.mapData.chartMap i :=
  Q.mapData.chartMap_factor i

end GluedOverData

/-- Project the stable gluing and map without reopening their construction. -/
def gluedOverData (P : Pic0FiniteStageStableGluePackage C F) : GluedOverData C P :=
  { mapData := P.presentation.mapData }

@[simp]
theorem gluedOverData_map (P : Pic0FiniteStageStableGluePackage C F) :
    (P.gluedOverData C).map = P.presentation.map :=
  rfl

@[simp]
theorem gluedOverData_asOver (P : Pic0FiniteStageStableGluePackage C F) :
    (P.gluedOverData C).asOver = P.presentation.over :=
  rfl

end Pic0FiniteStageStableGluePackage

end

end AlgebraicGeometry
