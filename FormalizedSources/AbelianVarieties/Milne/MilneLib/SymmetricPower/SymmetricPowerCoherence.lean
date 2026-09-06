/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.SymmetricPower.SymmetricPower

/-!
# Coherence of supplied relative symmetric-power data

The quotient interface in `SymmetricPower` is intentionally data-valued: a
construction may supply more than one carrier for the same relative power.
This file records the comparison and functoriality equations needed to use
those carriers in a gluing diagram.  Every statement is conditional on the
given `SymmetricPowerData` objects; no quotient existence assertion is added.
-/

set_option autoImplicit false

universe u

open CategoryTheory CategoryTheory.Limits
open AlgebraicGeometry

namespace MilneLib

namespace SymmetricPowerData

variable {S : Scheme.{u}} {V W : Over S} {n : ℕ}

/-- Quotient maps are natural in the chosen presentation of each symmetric
power.  Thus replacing either carrier by its universal-property comparison
does not change the induced map. -/
theorem map_comp_canonicalIso_naturality
    (DV EV : SymmetricPowerData V n) (DW EW : SymmetricPowerData W n)
    (f : V ⟶ W) :
    DV.map DW f ≫ (canonicalIso DW EW).hom =
      (canonicalIso DV EV).hom ≫ EV.map EW f := by
  let h : relativePower V n ⟶ EW.carrier :=
    relativePowerMap f n ≫ EW.projection
  have hsym : IsSymmetric V n h := by
    dsimp [h]
    exact isSymmetric_comp_relativePowerMap f EW.projection
      EW.projection_symmetric
  have hleft :
      DV.projection ≫ (DV.map DW f ≫ (canonicalIso DW EW).hom) = h := by
    simp [h]
  have hright :
      DV.projection ≫ ((canonicalIso DV EV).hom ≫ EV.map EW f) = h := by
    rw [← Category.assoc, projection_comp_canonicalIso_hom,
      projection_comp_map]
  exact
    (DV.factor_unique h hsym _ hleft).trans
      (DV.factor_unique h hsym _ hright).symm

/-! The same comparison isomorphism equation in the reverse direction. -/

theorem canonicalIso_inv_comp_map_naturality
    (DV EV : SymmetricPowerData V n) (DW EW : SymmetricPowerData W n)
    (f : V ⟶ W) :
    (canonicalIso DV EV).inv ≫ DV.map DW f =
      EV.map EW f ≫ (canonicalIso DW EW).inv := by
  have h := map_comp_canonicalIso_naturality DV EV DW EW f
  calc
    (canonicalIso DV EV).inv ≫ DV.map DW f =
        (canonicalIso DV EV).inv ≫
          (DV.map DW f ≫ (canonicalIso DW EW).hom) ≫
            (canonicalIso DW EW).inv := by
      simp [Category.assoc]
    _ = (canonicalIso DV EV).inv ≫
          ((canonicalIso DV EV).hom ≫ EV.map EW f) ≫
            (canonicalIso DW EW).inv := by rw [h]
    _ = EV.map EW f ≫ (canonicalIso DW EW).inv := by
      simp [Category.assoc]

/-- Canonical comparisons between supplied quotient presentations compose as
expected on triple overlaps. -/
theorem canonicalIso_hom_trans
    (D E F : SymmetricPowerData V n) :
    (canonicalIso D E).hom ≫ (canonicalIso E F).hom =
      (canonicalIso D F).hom := by
  apply canonicalIso_hom_unique D F
  rw [← Category.assoc, projection_comp_canonicalIso_hom,
    projection_comp_canonicalIso_hom]

end SymmetricPowerData

end MilneLib
