/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Descent.AffineRingGlueData
import AlgebraicJacobian.Picard.Pic0FiniteStageGlueContext

/-!
# Stable finite-stage gluing boundary

The historical `Pic0FiniteStageGluePackage` repeats every finite-stage witness as a
field and reconstructs the affine gluing presentation from those fields.  That makes
the type of each downstream projection depend on a large collection of instance
choices.  This facade carries the already bundled `Pic0FiniteStageGlueContext` and
one `AffineRingGluePresentation` instead.

The two fields are independent values: consumers can use the context for algebraic
maps and the presentation for scheme data without reopening either construction.
The legacy package remains available as an adapter while its producer is migrated.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

/-- A finite-stage context together with its selected affine gluing presentation.

Unlike the legacy package, this boundary has no raw stage parameters and no
instance-producing `let` expressions in its public fields.
-/
structure Pic0FiniteStageStableGluePackage
    (F : Type u) [Field F] [Algebra F k] [Algebra.IsAlgebraic F k] where
  context : Pic0FiniteStageGlueContext C F
  presentation : AlgebraicJacobian.AffineRingGluePresentation context.triple.N.1

namespace Pic0FiniteStageStableGluePackage

variable {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]

/-- Build the stable package from a context and an already selected presentation. -/
noncomputable def ofContext
    (D : Pic0FiniteStageGlueContext C F)
    (P : AlgebraicJacobian.AffineRingGluePresentation D.triple.N.1) :
    Pic0FiniteStageStableGluePackage C F :=
  { context := D, presentation := P }

/-! The following accessors are ordinary definitions rather than reducible aliases.
This keeps expensive tensor carriers behind the package boundary. -/

def models (P : Pic0FiniteStageStableGluePackage C F) :
    Pic0FiniteStageTransitionModelsData C F :=
  P.context.models

def triple (P : Pic0FiniteStageStableGluePackage C F) :
    Pic0FiniteStageTripleTransitionFamilyData
      C P.context.models.L P.context.models.n P.context.models.m
      P.context.models.relation P.context.models.M P.context.models.mapM P.context.Q :=
  P.context.triple

def L (P : Pic0FiniteStageStableGluePackage C F) := P.context.models.L
def n (P : Pic0FiniteStageStableGluePackage C F) := P.context.models.n
def m (P : Pic0FiniteStageStableGluePackage C F) := P.context.models.m
def relation (P : Pic0FiniteStageStableGluePackage C F) := P.context.models.relation
def e (P : Pic0FiniteStageStableGluePackage C F) := P.context.models.e
def M (P : Pic0FiniteStageStableGluePackage C F) := P.context.models.M
def mapM (P : Pic0FiniteStageStableGluePackage C F) := P.context.models.mapM
def N (P : Pic0FiniteStageStableGluePackage C F) := P.context.triple.N
def thetaN (P : Pic0FiniteStageStableGluePackage C F) := P.context.triple.thetaN

def glueData (P : Pic0FiniteStageStableGluePackage C F) : Scheme.GlueData :=
  P.presentation.glueData

def mapData (P : Pic0FiniteStageStableGluePackage C F) :
    AlgebraicJacobian.GluedMapData P.presentation.glueData
      (Spec (.of P.context.triple.N.1)) :=
  P.presentation.mapData

def gluedMap (P : Pic0FiniteStageStableGluePackage C F) :
    P.presentation.glueData.glued ⟶ Spec (.of P.context.triple.N.1) :=
  P.presentation.map

def asOver (P : Pic0FiniteStageStableGluePackage C F) :
    Over (Spec (.of P.context.triple.N.1)) :=
  P.presentation.over

@[simp]
theorem chartMap_factor
    (P : Pic0FiniteStageStableGluePackage C F)
    (i : P.presentation.glueData.J) :
    P.presentation.glueData.ι i ≫ P.gluedMap = P.mapData.chartMap i :=
  P.presentation.chartMap_factor i

@[simp]
theorem comparison
    (P : Pic0FiniteStageStableGluePackage C F)
    (q : Pic0FiniteStageMapIndex C) :
    Pic0FiniteStageTransitionModelComparison C
      P.context.models.L P.context.models.n P.context.models.m
      P.context.models.relation P.context.models.e P.context.models.M
      P.context.models.mapM q :=
  P.context.models.comparison q

@[simp]
theorem openImmersion
    (P : Pic0FiniteStageStableGluePackage C F)
    (i : Pic0FiniteStageRestrictionIndex C) :
    Pic0FiniteStageTransitionOpenImmersion C
      P.context.models.L P.context.models.n P.context.models.m
      P.context.models.relation P.context.models.M P.context.models.mapM i :=
  P.context.models.openImmersion i

@[simp]
theorem tripleComparison
    (P : Pic0FiniteStageStableGluePackage C F)
    (p : Pic0FiniteStageTripleTransitionIndex C) :
    Pic0FiniteStageTripleTransitionFamilyComparison
      C P.context.models.L P.context.models.n P.context.models.m
      P.context.models.relation P.context.models.M P.context.models.mapM
      P.context.Q P.context.triple.N p (P.context.triple.thetaN p) :=
  P.context.triple.comparison p

end Pic0FiniteStageStableGluePackage

end

end AlgebraicGeometry
