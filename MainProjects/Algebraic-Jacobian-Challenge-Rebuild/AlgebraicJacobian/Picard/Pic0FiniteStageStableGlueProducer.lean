/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageStableGluePackage

/-!
# Package a selected finite-stage gluing presentation

The finite-stage assembly theorem is intentionally kept in its own module: it is the
expensive boundary where all dependent tensor-product coherence is proved.  This module
provides the small constructor used by downstream scheme-level code once that presentation
has been selected.  In particular, consumers do not need to reopen the assembly proof or
reconstruct any of its instance arguments.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

namespace Pic0FiniteStageGlueContext

variable {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]

/-- Package a context and its selected affine presentation at one stable boundary.

The presentation is an explicit argument so that changing a proof used to construct it
does not change the type of the package or of any downstream projection.
-/
noncomputable def ofPresentation
    (D : Pic0FiniteStageGlueContext C F)
    (P : AlgebraicJacobian.AffineRingGluePresentation D.triple.N.1) :
    Pic0FiniteStageStableGluePackage C F :=
  Pic0FiniteStageStableGluePackage.ofContext C D P

@[simp]
theorem ofPresentation_context
    (D : Pic0FiniteStageGlueContext C F)
    (P : AlgebraicJacobian.AffineRingGluePresentation D.triple.N.1) :
    (D.ofPresentation C P).context = D :=
  rfl

@[simp]
theorem ofPresentation_presentation
    (D : Pic0FiniteStageGlueContext C F)
    (P : AlgebraicJacobian.AffineRingGluePresentation D.triple.N.1) :
    (D.ofPresentation C P).presentation = P :=
  rfl

end Pic0FiniteStageGlueContext

end

end AlgebraicGeometry
