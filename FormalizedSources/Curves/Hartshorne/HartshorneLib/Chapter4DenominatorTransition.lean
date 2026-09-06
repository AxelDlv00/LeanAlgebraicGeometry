/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4DenominatorTrivialization
import HartshorneLib.Chapter4LocalRatioCocycle

/-!
# Transitions between denominator trivializations

The existing divisor-module chart isomorphisms are evaluated on ambient
subopens by the image/preimage identification for open immersions. On every
common subopen, division by the two specified denominators differs by the
regular transition coordinate. These identities hold for arbitrary sections,
including the unique section over the empty open.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne

noncomputable section

attribute [local instance] functionFieldOverModule Scheme.overModule

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

namespace LocalRatioCoordinateData

variable {D : CurveDivisor k X} {n : ℕ} (a : LocalRatioCoordinateData D n)
variable (hden : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ a.chart.U →
  orderAt X.hom hz (a.sections a.denominator_index : X.left.functionField) =
    divisorBound D hz)

private lemma image_preimage_of_le {W : X.left.Opens} (hW : W ≤ a.chart.U) :
    a.chart.U.ι ''ᵁ (a.chart.U.ι ⁻¹ᵁ W) = W := by
  rw [Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι,
    inf_eq_right.mpr hW]

/-- The inverse module comparison multiplies a rational representative by
the specified denominator. -/
lemma denominatorIsoZero_inv_app_coe
    (V : a.chart.U.toScheme.Opens)
    (hV : (a.chart.U.ι ''ᵁ V : Set X.left).Nonempty)
    (s : Γ((Scheme.Modules.restrictFunctor a.chart.U.ι).obj
      (divisorModule (0 : CurveDivisor k X)), V)) :
    ((show divisorSections D (a.chart.U.ι ''ᵁ V) from
      (a.denominatorIsoZero hden).inv.app V s) : X.left.functionField) =
      (a.sections a.denominator_index : X.left.functionField) *
        ((show divisorSections (0 : CurveDivisor k X) (a.chart.U.ι ''ᵁ V)
          from s) : X.left.functionField) := by
  have hid : (a.denominatorIsoZero hden).hom.app V
      ((a.denominatorIsoZero hden).inv.app V s) = s := by
    rw [← ConcreteCategory.comp_apply, ← Scheme.Modules.Hom.comp_app,
      Iso.inv_hom_id, Scheme.Modules.Hom.id_app]
    rfl
  have hv := a.denominatorIsoZero_hom_app_coe hden V hV
    ((a.denominatorIsoZero hden).inv.app V s)
  rw [hid] at hv
  exact (eq_div_iff a.denominator_value_ne_zero).mp hv |>.symm.trans (mul_comm _ _)

/-- The component of the actual denominator isomorphism on an ambient
subopen of its chart, transported along the image/preimage identification. -/
def denominatorIsoZeroOnApp {W : X.left.Opens} (hW : W ≤ a.chart.U)
    (s : divisorSections D W) : divisorSections (0 : CurveDivisor k X) W :=
  divisorSectionsRes 0 (a.image_preimage_of_le hW).ge
    ((a.denominatorIsoZero hden).hom.app (a.chart.U.ι ⁻¹ᵁ W)
      (show Γ((Scheme.Modules.restrictFunctor a.chart.U.ι).obj
          (divisorModule D), a.chart.U.ι ⁻¹ᵁ W) from
        divisorSectionsRes D (a.image_preimage_of_le hW).le s))

/-- The ambient-open component still divides rational values by the
specified denominator. -/
lemma denominatorIsoZeroOnApp_coe {W : X.left.Opens} (hW : W ≤ a.chart.U)
    (hWne : (W : Set X.left).Nonempty) (s : divisorSections D W) :
    (a.denominatorIsoZeroOnApp hden hW s : X.left.functionField) =
      (s : X.left.functionField) /
        (a.sections a.denominator_index : X.left.functionField) := by
  have hI : (a.chart.U.ι ''ᵁ (a.chart.U.ι ⁻¹ᵁ W) : Set X.left).Nonempty := by
    rwa [a.image_preimage_of_le hW]
  rw [denominatorIsoZeroOnApp, divisorSectionsRes_coe _ hWne,
    a.denominatorIsoZero_hom_app_coe hden _ hI, divisorSectionsRes_coe _ hI]

/-- The inverse component on an ambient subopen, evaluated from the inverse
of the same divisor-module isomorphism. -/
def denominatorIsoZeroOnInvApp {W : X.left.Opens} (hW : W ≤ a.chart.U)
    (s : divisorSections (0 : CurveDivisor k X) W) : divisorSections D W :=
  divisorSectionsRes D (a.image_preimage_of_le hW).ge
    ((a.denominatorIsoZero hden).inv.app (a.chart.U.ι ⁻¹ᵁ W)
      (show Γ((Scheme.Modules.restrictFunctor a.chart.U.ι).obj
          (divisorModule (0 : CurveDivisor k X)), a.chart.U.ι ⁻¹ᵁ W) from
        divisorSectionsRes 0 (a.image_preimage_of_le hW).le s))

lemma denominatorIsoZeroOnInvApp_coe {W : X.left.Opens} (hW : W ≤ a.chart.U)
    (hWne : (W : Set X.left).Nonempty)
    (s : divisorSections (0 : CurveDivisor k X) W) :
    (a.denominatorIsoZeroOnInvApp hden hW s : X.left.functionField) =
      (a.sections a.denominator_index : X.left.functionField) *
        (s : X.left.functionField) := by
  have hI : (a.chart.U.ι ''ᵁ (a.chart.U.ι ⁻¹ᵁ W) : Set X.left).Nonempty := by
    rwa [a.image_preimage_of_le hW]
  rw [denominatorIsoZeroOnInvApp, divisorSectionsRes_coe _ hWne,
    a.denominatorIsoZero_inv_app_coe hden _ hI, divisorSectionsRes_coe _ hI]

@[simp] lemma denominatorIsoZeroOnApp_inv {W : X.left.Opens}
    (hW : W ≤ a.chart.U) (s : divisorSections (0 : CurveDivisor k X) W) :
    a.denominatorIsoZeroOnApp hden hW (a.denominatorIsoZeroOnInvApp hden hW s) = s := by
  by_cases hWne : (W : Set X.left).Nonempty
  · apply Subtype.ext
    rw [denominatorIsoZeroOnApp_coe a hden hW hWne,
      denominatorIsoZeroOnInvApp_coe a hden hW hWne]
    exact mul_div_cancel_left₀ _ a.denominator_value_ne_zero
  · letI := divisorSections_subsingleton_of_empty
      (D := (0 : CurveDivisor k X)) hWne
    exact Subsingleton.elim _ _

@[simp] lemma denominatorIsoZeroOnInvApp_hom {W : X.left.Opens}
    (hW : W ≤ a.chart.U) (s : divisorSections D W) :
    a.denominatorIsoZeroOnInvApp hden hW (a.denominatorIsoZeroOnApp hden hW s) = s := by
  by_cases hWne : (W : Set X.left).Nonempty
  · apply Subtype.ext
    rw [denominatorIsoZeroOnInvApp_coe a hden hW hWne,
      denominatorIsoZeroOnApp_coe a hden hW hWne]
    exact mul_div_cancel₀ _ a.denominator_value_ne_zero
  · letI := divisorSections_subsingleton_of_empty (D := D) hWne
    exact Subsingleton.elim _ _

/-- Denominator division is compatible with every further restriction. -/
lemma denominatorIsoZeroOnApp_restrict {W V : X.left.Opens}
    (hW : W ≤ a.chart.U) (hVW : V ≤ W) (s : divisorSections D W) :
    a.denominatorIsoZeroOnApp hden (hVW.trans hW) (divisorSectionsRes D hVW s) =
      divisorSectionsRes 0 hVW (a.denominatorIsoZeroOnApp hden hW s) := by
  by_cases hV : (V : Set X.left).Nonempty
  · apply Subtype.ext
    rw [denominatorIsoZeroOnApp_coe a hden _ hV,
      divisorSectionsRes_coe _ hV, divisorSectionsRes_coe _ hV,
      denominatorIsoZeroOnApp_coe a hden _ (hV.mono hVW)]
  · letI := divisorSections_subsingleton_of_empty
      (D := (0 : CurveDivisor k X)) hV
    exact Subsingleton.elim _ _

/-- On any common subopen, the two actual denominator trivializations
differ by the regular coordinate `s_b / s_a`, acting on every section. -/
theorem denominatorIsoZeroOnApp_transition
    (b : LocalRatioCoordinateData D n)
    (hb : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ b.chart.U →
      orderAt X.hom hz (b.sections b.denominator_index : X.left.functionField) =
        divisorBound D hz)
    (r : LocalRatioRegularization a) (hab : a.SameSectionValues b)
    {W : X.left.Opens} (hWa : W ≤ a.chart.U) (hWb : W ≤ b.chart.U)
    (s : divisorSections D W) :
    a.denominatorIsoZeroOnApp hden hWa s =
      divisorSectionAction 0 W
        (LocalRatioRegularization.restrictSection hWa
          (r.regularized b.denominator_index))
        (b.denominatorIsoZeroOnApp hb hWb s) := by
  by_cases hW : (W : Set X.left).Nonempty
  · letI : Nonempty W := by simpa using hW
    apply Subtype.ext
    rw [denominatorIsoZeroOnApp_coe a hden _ hW,
      divisorSectionAction_coe_of_nonempty _ _ hW,
      denominatorIsoZeroOnApp_coe b hb _ hW]
    have hr := r.restricted_value_eq hWa hW b.denominator_index
    change (X.left.germToFunctionField W).hom
      (LocalRatioRegularization.restrictSection hWa
        (r.regularized b.denominator_index)) = _ at hr
    rw [hr]
    change (s : X.left.functionField) /
        (a.sections a.denominator_index : X.left.functionField) =
      ((a.sections b.denominator_index : X.left.functionField) /
        (a.sections a.denominator_index : X.left.functionField)) *
      ((s : X.left.functionField) /
        (b.sections b.denominator_index : X.left.functionField))
    rw [hab b.denominator_index]
    field_simp [a.denominator_value_ne_zero, b.denominator_value_ne_zero]
  · letI := divisorSections_subsingleton_of_empty
      (D := (0 : CurveDivisor k X)) hW
    exact Subsingleton.elim _ _

/-- Changing the divisor-module trivialization from denominator `b` to
denominator `a` is multiplication by the regular transition coordinate. -/
theorem denominatorIsoZeroOnApp_changeOfChart
    (b : LocalRatioCoordinateData D n)
    (hb : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ b.chart.U →
      orderAt X.hom hz (b.sections b.denominator_index : X.left.functionField) =
        divisorBound D hz)
    (r : LocalRatioRegularization a) (hab : a.SameSectionValues b)
    {W : X.left.Opens} (hWa : W ≤ a.chart.U) (hWb : W ≤ b.chart.U)
    (s : divisorSections (0 : CurveDivisor k X) W) :
    a.denominatorIsoZeroOnApp hden hWa (b.denominatorIsoZeroOnInvApp hb hWb s) =
      divisorSectionAction 0 W
        (LocalRatioRegularization.restrictSection hWa
          (r.regularized b.denominator_index)) s := by
  rw [a.denominatorIsoZeroOnApp_transition hden b hb r hab hWa hWb,
    b.denominatorIsoZeroOnApp_inv hb hWb]

end LocalRatioCoordinateData

namespace BasePointFreeLocalRatioCover

variable {D : CurveDivisor k X} {n : ℕ}

/-- On the denominator cover used to construct the fixed-basis projective
morphism, the actual divisor-module charts have its regular coordinate as
their transition factor, for every section on every common subopen. -/
theorem selectedDenominatorIsoZeroOnApp_transition
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x y : NonGenericPoint X)
    {W : X.left.Opens}
    (hWx : W ≤ (selectedCoordinates (D := D) basis hD x).chart.U)
    (hWy : W ≤ (selectedCoordinates (D := D) basis hD y).chart.U)
    (s : divisorSections D W) :
    (selectedCoordinates (D := D) basis hD x).denominatorIsoZeroOnApp
        (selectedCoordinates_denominatorOrderEq basis hD x) hWx s =
      divisorSectionAction 0 W
        (LocalRatioRegularization.restrictSection hWx
          ((selectedRegularization basis hD x).regularized
            (selectedCoordinates (D := D) basis hD y).denominator_index))
        ((selectedCoordinates (D := D) basis hD y).denominatorIsoZeroOnApp
          (selectedCoordinates_denominatorOrderEq basis hD y) hWy s) :=
  LocalRatioCoordinateData.denominatorIsoZeroOnApp_transition _
    (selectedCoordinates_denominatorOrderEq basis hD x) _
    (selectedCoordinates_denominatorOrderEq basis hD y)
    (selectedRegularization basis hD x)
    (selectedCoordinates_sameSectionValues basis hD x y) hWx hWy s

end BasePointFreeLocalRatioCover

end
end Hartshorne
