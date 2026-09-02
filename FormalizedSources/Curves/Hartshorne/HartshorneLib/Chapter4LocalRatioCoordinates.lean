/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4DivisorSectionCoordinates

/-!
# Hartshorne IV.3.1: local ratios of divisor sections

This file records the local algebra behind the usual projective-coordinate
construction.  A denominator is required to be nonzero in the function field;
all regularity and gluing information is supplied as certificate data rather
than inferred from a divisor section.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X}

/-! ### Nonempty opens and generic-point values -/

omit [IsAlgClosed k] [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom] in
/-- On an integral scheme, every nonempty open contains the generic point.

The statement is kept local to this API so that users can construct a local
ratio from the nonemptiness certificate carried by `LocalRatioOpen` without
supplying a second topological proof.
-/
lemma localRatio_genericPoint_mem_of_nonempty {U : X.left.Opens}
    (hU : (U : Set X.left).Nonempty) :
    genericPoint X.left ∈ U :=
  ((genericPoint_spec X.left).mem_open_set_iff (U := (↑U : Set X.left)) U.isOpen).mpr
    (by simpa using hU)

/-- An open together with the certificates needed for taking a generic-point
germ.  The generic-point field is explicit to make later restriction data
independent of proof-term elaboration. -/
structure LocalRatioOpen (X : Over (Spec (CommRingCat.of k))) [IsIntegral X.left] where
  U : X.left.Opens
  nonempty : (U : Set X.left).Nonempty
  generic_mem : genericPoint X.left ∈ U

namespace LocalRatioOpen

/-- Construct a local-ratio open from its nonemptiness proof. -/
def of_nonempty (U : X.left.Opens) (hU : (U : Set X.left).Nonempty) :
    LocalRatioOpen X :=
  ⟨U, hU, localRatio_genericPoint_mem_of_nonempty hU⟩

omit [IsAlgClosed k] [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom] in
@[simp] theorem coe_U (W : LocalRatioOpen X) :
    ((W.U : X.left.Opens) : Set X.left) = (W.U : Set X.left) :=
  rfl

end LocalRatioOpen

/-- The generic-point value of a regular structure-sheaf section on a local
ratio open. -/
noncomputable def localStructureValue (W : LocalRatioOpen X)
    (s : Γ(X.left, W.U)) : X.left.functionField :=
  (X.left.presheaf.germ W.U (genericPoint X.left) W.generic_mem).hom s

omit [IsAlgClosed k] [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom] in
@[simp] lemma localStructureValue_eq_germ (W : LocalRatioOpen X)
    (s : Γ(X.left, W.U)) :
    localStructureValue W s =
      (X.left.presheaf.germ W.U (genericPoint X.left) W.generic_mem).hom s :=
  rfl

omit [IsAlgClosed k] [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom] in
/-- A regular function on a nonempty open of an integral scheme is determined
by its generic-point value. -/
theorem localStructureValue_injective (W : LocalRatioOpen X) :
    Function.Injective (localStructureValue W) := by
  intro s t h
  apply AlgebraicGeometry.germ_injective_of_isIntegral
    (X := X.left) (genericPoint X.left) W.generic_mem
  exact h

omit [IsAlgClosed k] [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom] in
@[simp] theorem localStructureValue_one (W : LocalRatioOpen X) :
    localStructureValue W (1 : Γ(X.left, W.U)) = 1 := by
  simp [localStructureValue]

omit [IsAlgClosed k] [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom] in
@[simp] theorem localStructureValue_mul (W : LocalRatioOpen X)
    (s t : Γ(X.left, W.U)) :
    localStructureValue W (s * t) =
      localStructureValue W s * localStructureValue W t := by
  simp [localStructureValue]

/-! ### A numerator, denominator, and their function-field ratio -/

/-- Two sections of `𝒪(D)` on a nonempty open, with an explicitly nonzero
denominator value. -/
structure LocalDivisorSectionRatio (D : CurveDivisor k X) where
  chart : LocalRatioOpen X
  numerator : divisorSections D chart.U
  denominator : divisorSections D chart.U
  denominator_value_ne_zero :
    (denominator : X.left.functionField) ≠ 0

namespace LocalDivisorSectionRatio

/-- The numerator value in the function field. -/
def numeratorValue (r : LocalDivisorSectionRatio D) : X.left.functionField :=
  (r.numerator : X.left.functionField)

/-- The denominator value in the function field. -/
def denominatorValue (r : LocalDivisorSectionRatio D) : X.left.functionField :=
  (r.denominator : X.left.functionField)

/-- The local affine coordinate obtained by dividing numerator by denominator. -/
noncomputable def ratio (r : LocalDivisorSectionRatio D) : X.left.functionField :=
  r.numeratorValue / r.denominatorValue

@[simp] theorem numeratorValue_eq_divisorVal (r : LocalDivisorSectionRatio D) :
    r.numeratorValue = divisorVal (D := D) (W := r.chart.U) r.numerator :=
  rfl

@[simp] theorem denominatorValue_eq_divisorVal (r : LocalDivisorSectionRatio D) :
    r.denominatorValue = divisorVal (D := D) (W := r.chart.U) r.denominator :=
  rfl

@[simp] theorem denominatorValue_ne_zero (r : LocalDivisorSectionRatio D) :
    r.denominatorValue ≠ 0 :=
  r.denominator_value_ne_zero

@[simp] theorem ratio_mul_denominator (r : LocalDivisorSectionRatio D) :
    r.ratio * r.denominatorValue = r.numeratorValue := by
  exact div_mul_cancel₀ _ r.denominator_value_ne_zero

@[simp] theorem denominator_mul_ratio (r : LocalDivisorSectionRatio D) :
    r.denominatorValue * r.ratio = r.numeratorValue := by
  rw [mul_comm]
  exact r.ratio_mul_denominator

/-- Two local ratios are equal exactly when their cross-products agree. -/
theorem ratio_eq_iff (r s : LocalDivisorSectionRatio D) :
    r.ratio = s.ratio ↔
      r.numeratorValue * s.denominatorValue =
        s.numeratorValue * r.denominatorValue := by
  rw [ratio, ratio]
  exact div_eq_div_iff r.denominator_value_ne_zero s.denominator_value_ne_zero

/-- Restrict a local ratio to a smaller nonempty open. -/
def restrict (r : LocalDivisorSectionRatio D) {V : X.left.Opens}
    (hVU : V ≤ r.chart.U) (hV : (V : Set X.left).Nonempty) :
    LocalDivisorSectionRatio D :=
  { chart := LocalRatioOpen.of_nonempty V hV
    numerator := divisorSectionsRes D hVU r.numerator
    denominator := divisorSectionsRes D hVU r.denominator
    denominator_value_ne_zero := by
      rw [divisorSectionsRes_coe hVU hV]
      exact r.denominator_value_ne_zero }

@[simp] theorem restrict_numeratorValue (r : LocalDivisorSectionRatio D)
    {V : X.left.Opens} (hVU : V ≤ r.chart.U)
    (hV : (V : Set X.left).Nonempty) :
    (r.restrict hVU hV).numeratorValue = r.numeratorValue := by
  change ((divisorSectionsRes D hVU r.numerator : divisorSections D V) :
    X.left.functionField) = r.numeratorValue
  exact divisorSectionsRes_coe hVU hV r.numerator

@[simp] theorem restrict_denominatorValue (r : LocalDivisorSectionRatio D)
    {V : X.left.Opens} (hVU : V ≤ r.chart.U)
    (hV : (V : Set X.left).Nonempty) :
    (r.restrict hVU hV).denominatorValue = r.denominatorValue := by
  change ((divisorSectionsRes D hVU r.denominator : divisorSections D V) :
    X.left.functionField) = r.denominatorValue
  exact divisorSectionsRes_coe hVU hV r.denominator

@[simp] theorem restrict_ratio (r : LocalDivisorSectionRatio D)
    {V : X.left.Opens} (hVU : V ≤ r.chart.U)
    (hV : (V : Set X.left).Nonempty) :
    (r.restrict hVU hV).ratio = r.ratio := by
  rw [ratio, ratio, restrict_numeratorValue, restrict_denominatorValue]

end LocalDivisorSectionRatio

/-! ### Finite coordinate families and supplied regularization -/

variable {n : ℕ}

/-- A finite family of local divisor sections with a chosen nonvanishing
denominator coordinate. -/
structure LocalRatioCoordinateData (D : CurveDivisor k X) (n : ℕ) where
  chart : LocalRatioOpen X
  sections : Fin (n + 1) → divisorSections D chart.U
  denominator_index : Fin (n + 1)
  denominator_value_ne_zero :
    (sections denominator_index : X.left.functionField) ≠ 0

namespace LocalRatioCoordinateData

/-- The ratio datum represented by one coordinate of a family. -/
def ratioAt (a : LocalRatioCoordinateData D n) (i : Fin (n + 1)) :
    LocalDivisorSectionRatio D :=
  { chart := a.chart
    numerator := a.sections i
    denominator := a.sections a.denominator_index
    denominator_value_ne_zero := a.denominator_value_ne_zero }

/-- The normalized local coordinate attached to one family member. -/
noncomputable def coordinate (a : LocalRatioCoordinateData D n)
    (i : Fin (n + 1)) : X.left.functionField :=
  (a.ratioAt i).ratio

@[simp] theorem coordinate_eq_ratio (a : LocalRatioCoordinateData D n)
    (i : Fin (n + 1)) :
    a.coordinate i = (a.ratioAt i).ratio :=
  rfl

@[simp] theorem coordinate_denominator (a : LocalRatioCoordinateData D n) :
    a.coordinate a.denominator_index = 1 := by
  change ((a.sections a.denominator_index : X.left.functionField) /
      (a.sections a.denominator_index : X.left.functionField)) = 1
  exact div_self a.denominator_value_ne_zero

@[simp] theorem at_numeratorValue (a : LocalRatioCoordinateData D n)
    (i : Fin (n + 1)) :
    (a.ratioAt i).numeratorValue = (a.sections i : X.left.functionField) :=
  rfl

@[simp] theorem at_denominatorValue (a : LocalRatioCoordinateData D n)
    (i : Fin (n + 1)) :
    (a.ratioAt i).denominatorValue =
      (a.sections a.denominator_index : X.left.functionField) :=
  rfl

/-- Two local coordinate data represent the same homogeneous section family
when all of their divisor sections have the same function-field values. -/
def SameSectionValues (a b : LocalRatioCoordinateData D n) : Prop :=
  ∀ i, (a.sections i : X.left.functionField) =
    (b.sections i : X.left.functionField)

@[refl] theorem sameSectionValues_refl (a : LocalRatioCoordinateData D n) :
    a.SameSectionValues a := fun _ => rfl

@[symm] theorem SameSectionValues.symm {a b : LocalRatioCoordinateData D n}
    (h : a.SameSectionValues b) : b.SameSectionValues a :=
  fun i => (h i).symm

/-- On two charts representing the same homogeneous sections, normalized
coordinates differ by the ratio of the two denominator coordinates. -/
theorem coordinate_transition (a b : LocalRatioCoordinateData D n)
    (h : a.SameSectionValues b) (i : Fin (n + 1)) :
    a.coordinate i =
      a.coordinate b.denominator_index * b.coordinate i := by
  change (a.sections i : X.left.functionField) /
      (a.sections a.denominator_index : X.left.functionField) =
    ((a.sections b.denominator_index : X.left.functionField) /
        (a.sections a.denominator_index : X.left.functionField)) *
      ((b.sections i : X.left.functionField) /
        (b.sections b.denominator_index : X.left.functionField))
  rw [h i, h b.denominator_index]
  field_simp [a.denominator_value_ne_zero, b.denominator_value_ne_zero]

/-- The transition ratios in opposite directions multiply to one. -/
theorem transition_mul_transition (a b : LocalRatioCoordinateData D n)
    (h : a.SameSectionValues b) :
    a.coordinate b.denominator_index *
        b.coordinate a.denominator_index = 1 := by
  calc
    a.coordinate b.denominator_index *
        b.coordinate a.denominator_index =
      a.coordinate a.denominator_index :=
        (a.coordinate_transition b h a.denominator_index).symm
    _ = 1 := a.coordinate_denominator

/-- Two nonempty local-ratio charts have nonempty intersection: both contain
the generic point. -/
theorem chart_inf_nonempty (a b : LocalRatioCoordinateData D n) :
    ((a.chart.U ⊓ b.chart.U : X.left.Opens) : Set X.left).Nonempty := by
  exact ⟨genericPoint X.left, a.chart.generic_mem, b.chart.generic_mem⟩

end LocalRatioCoordinateData

/-- A supplied regularization of local ratios by honest structure-sheaf
sections.  Restriction compatibility is automatic from functoriality of germs;
only the actual regularity and value comparison are supplied as data. -/
structure LocalRatioRegularization
    (a : LocalRatioCoordinateData D n) where
  /-- Structure-sheaf sections representing the coordinates on the chart. -/
  regularized : Fin (n + 1) → Γ(X.left, a.chart.U)
  /-- The generic-point values are the corresponding divisor-section ratios. -/
  regularized_value_eq : ∀ i,
    localStructureValue a.chart (regularized i) = a.coordinate i

namespace LocalRatioRegularization

variable {a : LocalRatioCoordinateData D n}

theorem regularized_denominator_eq_one (r : LocalRatioRegularization a) :
    r.regularized a.denominator_index = 1 := by
  apply AlgebraicGeometry.germ_injective_of_isIntegral
    (X := X.left) (genericPoint X.left)
    a.chart.generic_mem
  change localStructureValue a.chart
      (r.regularized a.denominator_index) =
    localStructureValue a.chart (1 : Γ(X.left, a.chart.U))
  rw [r.regularized_value_eq, a.coordinate_denominator]
  exact (localStructureValue_one a.chart).symm

theorem regularized_value_eq_ratio (r : LocalRatioRegularization a)
    (i : Fin (n + 1)) :
    localStructureValue a.chart (r.regularized i) = a.coordinate i := by
  exact r.regularized_value_eq i

/-- Taking the generic-point value commutes with restriction to a smaller
nonempty open.  This is presheaf functoriality, not additional regularization
data. -/
theorem localStructureValue_restrict (r : LocalRatioRegularization a)
    {V : X.left.Opens} (hVU : V ≤ a.chart.U)
    (hV : (V : Set X.left).Nonempty) (i : Fin (n + 1)) :
    localStructureValue (LocalRatioOpen.of_nonempty V hV)
      ((X.left.presheaf.map (homOfLE hVU).op).hom (r.regularized i)) =
      localStructureValue a.chart (r.regularized i) := by
  exact X.left.presheaf.germ_res_apply (homOfLE hVU)
    (genericPoint X.left)
    (localRatio_genericPoint_mem_of_nonempty hV) (r.regularized i)

theorem restricted_value_eq (r : LocalRatioRegularization a)
    {V : X.left.Opens} (hVU : V ≤ a.chart.U)
    (hV : (V : Set X.left).Nonempty) (i : Fin (n + 1)) :
    localStructureValue (LocalRatioOpen.of_nonempty V hV)
      ((X.left.presheaf.map (homOfLE hVU).op).hom (r.regularized i)) =
      a.coordinate i := by
  rw [r.localStructureValue_restrict hVU hV i, r.regularized_value_eq i]

/-- Regularized coordinates for the same homogeneous section family satisfy
the expected transition equation on the overlap of their charts. -/
theorem restricted_regularized_eq_transition_mul
    {b : LocalRatioCoordinateData D n}
    (r : LocalRatioRegularization a) (s : LocalRatioRegularization b)
    (h : a.SameSectionValues b) (i : Fin (n + 1)) :
    (X.left.presheaf.map
      (homOfLE (show a.chart.U ⊓ b.chart.U ≤ a.chart.U from inf_le_left)).op).hom
        (r.regularized i) =
      (X.left.presheaf.map
        (homOfLE (show a.chart.U ⊓ b.chart.U ≤ a.chart.U from inf_le_left)).op).hom
          (r.regularized b.denominator_index) *
        (X.left.presheaf.map
          (homOfLE (show a.chart.U ⊓ b.chart.U ≤ b.chart.U from inf_le_right)).op).hom
          (s.regularized i) := by
  have hV := a.chart_inf_nonempty b
  apply localStructureValue_injective
    (LocalRatioOpen.of_nonempty (a.chart.U ⊓ b.chart.U) hV)
  calc
    localStructureValue (LocalRatioOpen.of_nonempty
        (a.chart.U ⊓ b.chart.U) hV)
        ((X.left.presheaf.map
          (homOfLE (show a.chart.U ⊓ b.chart.U ≤ a.chart.U from inf_le_left)).op).hom
            (r.regularized i)) =
      a.coordinate i := r.restricted_value_eq inf_le_left hV i
    _ = a.coordinate b.denominator_index * b.coordinate i :=
      a.coordinate_transition b h i
    _ = localStructureValue (LocalRatioOpen.of_nonempty
          (a.chart.U ⊓ b.chart.U) hV)
          ((X.left.presheaf.map
            (homOfLE (show a.chart.U ⊓ b.chart.U ≤ a.chart.U from inf_le_left)).op).hom
              (r.regularized b.denominator_index)) *
        localStructureValue (LocalRatioOpen.of_nonempty
          (a.chart.U ⊓ b.chart.U) hV)
          ((X.left.presheaf.map
            (homOfLE (show a.chart.U ⊓ b.chart.U ≤ b.chart.U from inf_le_right)).op).hom
              (s.regularized i)) := by
        rw [r.restricted_value_eq inf_le_left hV b.denominator_index,
          s.restricted_value_eq inf_le_right hV i]
    _ = localStructureValue (LocalRatioOpen.of_nonempty
          (a.chart.U ⊓ b.chart.U) hV)
          ((X.left.presheaf.map
            (homOfLE (show a.chart.U ⊓ b.chart.U ≤ a.chart.U from inf_le_left)).op).hom
              (r.regularized b.denominator_index) *
            (X.left.presheaf.map
            (homOfLE (show a.chart.U ⊓ b.chart.U ≤ b.chart.U from inf_le_right)).op).hom
              (s.regularized i)) :=
        (localStructureValue_mul (LocalRatioOpen.of_nonempty
          (a.chart.U ⊓ b.chart.U) hV) _ _).symm

/-- The transition section on an overlap is a unit; the opposite normalized
coordinate is an explicit inverse. -/
theorem restricted_transition_isUnit
    {b : LocalRatioCoordinateData D n}
    (r : LocalRatioRegularization a) (s : LocalRatioRegularization b)
    (h : a.SameSectionValues b) :
    IsUnit ((X.left.presheaf.map
      (homOfLE (show a.chart.U ⊓ b.chart.U ≤ a.chart.U from inf_le_left)).op).hom
        (r.regularized b.denominator_index)) := by
  apply IsUnit.of_mul_eq_one
    ((X.left.presheaf.map
      (homOfLE (show a.chart.U ⊓ b.chart.U ≤ b.chart.U from inf_le_right)).op).hom
        (s.regularized a.denominator_index))
  simpa [r.regularized_denominator_eq_one] using
    (r.restricted_regularized_eq_transition_mul s h
      a.denominator_index).symm

end LocalRatioRegularization

end
end Hartshorne
