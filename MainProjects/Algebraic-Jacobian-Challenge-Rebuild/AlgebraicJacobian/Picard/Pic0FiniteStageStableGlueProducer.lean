/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageStableGluePackage

/-!
# Stable finite-stage gluing producer compatibility import

The stable package is now constructed from a canonical context alone; its presentation is
derived by the package boundary.  This module remains as a compatibility import for clients
that used to import a separate producer module.  The former `ofContextMapData` constructor is
intentionally retired because it accepted an arbitrary map datum unrelated to the context.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [IsSepClosed k]

end

end AlgebraicGeometry
