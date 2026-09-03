/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantLocalization
import Mathlib.AlgebraicGeometry.AffineScheme

/-!
# Transitions between invariant affine localization charts

For invariant elements `b` and `c`, an inclusion `D(c) ⊆ D(b)` makes the image of
`b` a unit in the localization away from `c`.  The universal property therefore
gives the canonical transition
`(A^G)[1/b] → (A^G)[1/c]`.  This file records its algebra-map, composition, and
identity laws for later chart and overlap constructions.
-/

set_option autoImplicit false

namespace MilneLib
namespace InvariantLocalization

universe u v

variable {k : Type u} {A : Type v} {G : Type*}
  [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

/-! ## Ring-level transitions -/

/-- The larger defining element is a unit on the smaller invariant basic open. -/
theorem invariantLocalizationTransition_isUnit
    {b c : FixedPoints.subalgebra k A G}
    (hcb : PrimeSpectrum.basicOpen c ≤ PrimeSpectrum.basicOpen b) :
    IsUnit (algebraMap (FixedPoints.subalgebra k A G)
      (Localization.Away c) b) := by
  exact (PrimeSpectrum.basicOpen_le_basicOpen_iff_algebraMap_isUnit
    (S := Localization.Away c) (f := c) (g := b)).mp hcb

/-- The canonical transition between invariant localizations for nested basic opens.

The source is the localization away from `b`, while the target is the localization
away from `c`; the hypothesis `hcb` expresses `D(c) ⊆ D(b)`. -/
noncomputable def invariantLocalizationTransition
    {b c : FixedPoints.subalgebra k A G}
    (hcb : PrimeSpectrum.basicOpen c ≤ PrimeSpectrum.basicOpen b) :
    Localization.Away b →+* Localization.Away c :=
  IsLocalization.Away.lift b (invariantLocalizationTransition_isUnit hcb)

@[simp]
theorem invariantLocalizationTransition_algebraMap
    {b c : FixedPoints.subalgebra k A G}
    (hcb : PrimeSpectrum.basicOpen c ≤ PrimeSpectrum.basicOpen b)
    (a : FixedPoints.subalgebra k A G) :
    invariantLocalizationTransition (k := k) (A := A) (G := G) hcb
        (algebraMap (FixedPoints.subalgebra k A G) (Localization.Away b) a) =
      algebraMap (FixedPoints.subalgebra k A G) (Localization.Away c) a := by
  exact IsLocalization.Away.lift_eq b
    (invariantLocalizationTransition_isUnit hcb) a

/-- Ring-hom form of `invariantLocalizationTransition_algebraMap`. -/
theorem invariantLocalizationTransition_comp_algebraMap
    {b c : FixedPoints.subalgebra k A G}
    (hcb : PrimeSpectrum.basicOpen c ≤ PrimeSpectrum.basicOpen b) :
    (invariantLocalizationTransition (k := k) (A := A) (G := G) hcb).comp
        (algebraMap (FixedPoints.subalgebra k A G) (Localization.Away b)) =
      algebraMap (FixedPoints.subalgebra k A G) (Localization.Away c) := by
  ext a
  exact invariantLocalizationTransition_algebraMap hcb a

/-- Transitions compose along inclusions of invariant basic opens. -/
theorem invariantLocalizationTransition_comp
    {b c d : FixedPoints.subalgebra k A G}
    (hcb : PrimeSpectrum.basicOpen c ≤ PrimeSpectrum.basicOpen b)
    (hdc : PrimeSpectrum.basicOpen d ≤ PrimeSpectrum.basicOpen c) :
    (invariantLocalizationTransition (k := k) (A := A) (G := G) hdc).comp
        (invariantLocalizationTransition (k := k) (A := A) (G := G) hcb) =
      invariantLocalizationTransition (k := k) (A := A) (G := G) (hdc.trans hcb) := by
  apply IsLocalization.ringHom_ext (Submonoid.powers b)
  ext a
  simp only [RingHom.comp_apply, invariantLocalizationTransition_algebraMap]

@[simp]
theorem invariantLocalizationTransition_refl
    (b : FixedPoints.subalgebra k A G) :
    invariantLocalizationTransition (k := k) (A := A) (G := G) (le_refl _) =
      RingHom.id (Localization.Away b) := by
  apply IsLocalization.ringHom_ext (Submonoid.powers b)
  ext a
  simp only [RingHom.comp_apply, RingHom.id_apply,
    invariantLocalizationTransition_algebraMap]

end InvariantLocalization
end MilneLib
