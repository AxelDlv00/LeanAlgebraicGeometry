/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyPullback
import MumfordLib.SingularCohomologyExterior

/-!
# Naturality of the exterior-power cup comparison

Pullback along a continuous map preserves the iterated cup of integral
degree-one classes, including the empty product. Consequently it commutes
with the exterior-power cup comparison in every degree.

This is the naturality of the comparison maps in Mumford, Chapter I,
Section 1, p. 3. It does not assert their bijectivity for tori.
-/

set_option autoImplicit false

noncomputable section

open CategoryTheory

namespace Mumford.Analytic

variable {X Y : TopCat}

@[simp]
theorem singularCohomologyPullback_one (f : X ⟶ Y) :
    singularCohomologyPullback f 0 (singularCohomologyOne Y) = singularCohomologyOne X := by
  simp only [singularCohomologyOne, singularCohomologyPullback_class,
    singularCocyclePullback_one]

/-- Pullback preserves ordered iterated cups of integral degree-one classes. -/
theorem singularCohomologyIteratedCup_naturality (f : X ⟶ Y) (n : ℕ)
    (v : Fin n → IntegralSingularCohomology Y 1) :
    singularCohomologyPullback f n (singularCohomologyIteratedCup Y n v) =
      singularCohomologyIteratedCup X n (fun i => singularCohomologyPullback f 1 (v i)) := by
  induction n with
  | zero => exact singularCohomologyPullback_one f
  | succ n ih =>
    simp only [singularCohomologyIteratedCup, singularCohomologyPullback_cup, ih]

/-- The exterior-power cup comparison commutes with pullback along every
continuous map. -/
theorem singularCohomologyExteriorPower_naturality (f : X ⟶ Y) (n : ℕ) :
    (singularCohomologyPullback f n).comp (singularCohomologyExteriorPower Y n) =
      (singularCohomologyExteriorPower X n).comp
        (exteriorPower.map n (singularCohomologyPullback f 1)) := by
  apply exteriorPower.linearMap_ext
  ext v
  change singularCohomologyPullback f n
      (singularCohomologyExteriorPower Y n (exteriorPower.ιMulti ℤ n v)) =
    singularCohomologyExteriorPower X n
      (exteriorPower.map n (singularCohomologyPullback f 1) (exteriorPower.ιMulti ℤ n v))
  rw [singularCohomologyExteriorPower_ιMulti, exteriorPower.map_apply_ιMulti,
    singularCohomologyExteriorPower_ιMulti]
  exact singularCohomologyIteratedCup_naturality f n v

end Mumford.Analytic
