/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageStableGluePackage

/-!
# Stable finite-stage gluing producer compatibility import

The authoritative constructor is
`Pic0FiniteStageStableGluePackage.ofContext`.  Keeping that constructor beside the package
lets Lean infer the dependent affine presentation from the package field and avoids a second
producer API that restates its tensor carrier.  This module remains as a compatibility import
for downstream files that previously imported the producer directly.
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

/-! The expensive assembly belongs at the producer edge.  Once a producer has selected its
`GluedMapData`, this constructor records that value with the canonical context and gives
consumers a proof-independent presentation boundary. -/

/-- Pin an already selected affine glue map to a canonical finite-stage context.

The map datum determines its `Scheme.GlueData` through its dependent type.  Packaging it
here avoids rebuilding the affine gluing proof when a downstream theorem only needs the
selected presentation. -/
noncomputable def ofContextMapData
    (D : Pic0FiniteStageCanonicalGlueContext C F)
    {G : Scheme.GlueData}
    (M : AlgebraicJacobian.GluedMapData G (Spec (.of D.N.1))) :
    Pic0FiniteStageStableGluePackage C F :=
  { context := D
    presentation := AlgebraicJacobian.AffineRingGluePresentation.ofMapData M }

@[simp]
theorem ofContextMapData_context
    (D : Pic0FiniteStageCanonicalGlueContext C F)
    {G : Scheme.GlueData}
    (M : AlgebraicJacobian.GluedMapData G (Spec (.of D.N.1))) :
    (ofContextMapData C D M).context = D :=
  rfl

@[simp]
theorem ofContextMapData_presentation
    (D : Pic0FiniteStageCanonicalGlueContext C F)
    {G : Scheme.GlueData}
    (M : AlgebraicJacobian.GluedMapData G (Spec (.of D.N.1))) :
    (ofContextMapData C D M).presentation =
      AlgebraicJacobian.AffineRingGluePresentation.ofMapData M :=
  rfl

end Pic0FiniteStageStableGluePackage

end

end AlgebraicGeometry
