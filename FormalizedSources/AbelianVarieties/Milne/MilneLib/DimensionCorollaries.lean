/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Dimension
import MilneLib.BasicLemmas

/-!
# Dimension corollaries

Small consequences of the dimension infrastructure used by the isogeny
specializations.
-/

open AlgebraicGeometry

namespace MilneLib

universe u

/-- A finite surjective scheme over a field is zero-dimensional. -/
theorem topologicalKrullDim_eq_zero_of_isFinite_surjective_to_field
    {K : Type u} [Field K] {X : Scheme.{u}}
    (f : X ⟶ Spec (.of K)) [IsFinite f] [Surjective f] :
    topologicalKrullDim X = 0 := by
  rw [topologicalKrullDim_eq_of_isFinite_surjective f]
  exact topologicalKrullDim_spec_of_field K

end MilneLib
