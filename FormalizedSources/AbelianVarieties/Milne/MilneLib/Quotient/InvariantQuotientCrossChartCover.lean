/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotientCrossChart
import Mathlib.AlgebraicGeometry.Gluing
import Mathlib.CategoryTheory.Limits.Shapes.Pullback.Mono

/-!
# Cross-chart data supplied by an open cover

Mathlib's canonical gluing datum for an open cover already has the shape used
by `InvariantQuotientCrossChartDatum`.  This adapter records that fact without
claiming that an invariant quotient atlas exists: quotient-specific overlap
schemes and maps still have to be supplied separately.  The resulting bridge
lets source-cover consumers use the same `Scheme.GlueData` presentation as the
conditional invariant-quotient interface.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry

namespace MilneLib
namespace InvariantLocalization

variable {X : Scheme.{u}} (𝒰 : X.OpenCover)
variable [Finite 𝒰.I₀]

namespace InvariantQuotientCrossChartDatum

/-- Repackage the canonical overlap data of an open cover as Milne's
cross-chart datum. -/
noncomputable def ofOpenCover :
    InvariantQuotientCrossChartDatum (J := 𝒰.I₀) where
  U := 𝒰.X
  V := fun i j => pullback (𝒰.f i) (𝒰.f j)
  f := fun i j => pullback.fst _ _
  f_id := fun i => by infer_instance
  f_open := fun i j => by infer_instance
  t := fun i j => pullbackSymmetry _ _
  t_id := fun i => by
    apply Iso.ext
    exact pullbackSymmetry_hom_of_mono_eq _
  t' := fun i j k => 𝒰.gluedCoverT' i j k
  t_fac := fun i j k => by
    apply pullback.hom_ext <;> simp
  cocycle := fun i j k => 𝒰.glued_cover_cocycle i j k

/-! The adapter is definitionally the canonical open-cover glue datum. -/
@[simp]
theorem toGlueData_ofOpenCover :
    (ofOpenCover 𝒰).toGlueData = 𝒰.gluedCover := by
  rfl

end InvariantQuotientCrossChartDatum

end InvariantLocalization
end MilneLib
