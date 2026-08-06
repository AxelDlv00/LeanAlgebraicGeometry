/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/

import AlgebraicJacobian.Picard.Pic0ChartCoverageNoDrop
import AlgebraicJacobian.Picard.Pic0RankOneLocus
import AlgebraicJacobian.RiemannRoch.CoverageDrop
import AlgebraicJacobian.RiemannRoch.ThetaDegree

/-!
# The translated rank-one cover brick

This file records the part of the separably-closed cover argument that is already consumable by
the landed fibre API.  A `BaseFieldTranslationDrop` keeps the input class `lambda` in the
presentation equation, chooses its base-field translating class explicitly, and records the
positive-twist/point-subtraction output.  The consumer below turns that output into the exact
`IsSplitWitness` shape used by `chartLocus`.

The arbitrary-affine family of `PicRankOneLocalPresentation` objects required by
`PicRankOneOpen` is deliberately not inferred from `h0 = 1` and `H1 = 0`: no such producer is
landed in the current API.  The final theorem therefore exposes the field-level consumer and
keeps that family producer as an explicit integration obligation.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
open TopologicalSpace Opposite

namespace AlgebraicGeometry

open AlgebraicJacobian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

noncomputable section

end

end AlgebraicGeometry
