/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientTensor
import Mathlib.RingTheory.Ideal.Maximal

/-!
# Field-point separation for a free affine action

The affine quotient is controlled by differences `g • a - a`.  This file
records the field-valued-point criterion for those differences to generate the
unit ideal, which is the input used in the canonical tensor/CRT calculation.
-/

set_option autoImplicit false

namespace MilneLib

universe u v w

variable {A : Type v} {G : Type w} [CommRing A]
  [Group G] [MulSemiringAction G A]

/-- If every field-valued point separates the action of `g`, then its action
differences generate the unit ideal. -/
theorem ideal_span_smul_sub_eq_top_of_field_points (g : G)
    (hfree : ∀ (K : Type v) [Field K] (x : A →+* K),
      ∃ a : A, x (g • a) ≠ x a) :
    Ideal.span (Set.range (fun a : A => g • a - a)) = ⊤ := by
  by_contra hspan
  obtain ⟨M, hM, hspanM⟩ := (Ideal.ne_top_iff_exists_maximal.mp hspan)
  let K := A ⧸ M
  letI : Field K := Ideal.Quotient.field M
  let x : A →+* K := Ideal.Quotient.mk M
  obtain ⟨a, ha⟩ := hfree K x
  apply ha
  apply sub_eq_zero.mp
  change (Ideal.Quotient.mk M) (g • a) - (Ideal.Quotient.mk M) a = 0
  rw [← map_sub]
  exact Ideal.Quotient.eq_zero_iff_mem.mpr
    (hspanM (Ideal.subset_span ⟨a, rfl⟩))

/-- The unit-ideal condition forces every field-valued point to separate the
action of `g`. -/
theorem field_points_of_ideal_span_smul_sub_eq_top (g : G)
    (hspan : Ideal.span (Set.range (fun a : A => g • a - a)) = ⊤)
    (K : Type v) [Field K] (x : A →+* K) :
    ∃ a : A, x (g • a) ≠ x a := by
  by_contra h
  push Not at h
  have hker : Ideal.span (Set.range (fun a : A => g • a - a)) ≤ RingHom.ker x := by
    refine Ideal.span_le.2 ?_
    rintro _ ⟨a, rfl⟩
    exact RingHom.mem_ker.mpr (by simp [map_sub, h a])
  have htopker : RingHom.ker x = ⊤ := by
    apply top_unique
    rw [← hspan]
    exact hker
  have hx1 := RingHom.mem_ker.mp
    ((Ideal.eq_top_iff_one _).mp htopker)
  have hx1' : (1 : K) = 0 := by simpa only [RingHom.map_one] using hx1
  exact (one_ne_zero : (1 : K) ≠ 0) hx1'

/-- The field-valued-point criterion for the unit difference ideal. -/
theorem ideal_span_smul_sub_eq_top_iff_field_points (g : G) :
    Ideal.span (Set.range (fun a : A => g • a - a)) = ⊤ ↔
      ∀ (K : Type v) [Field K] (x : A →+* K),
        ∃ a : A, x (g • a) ≠ x a := by
  constructor
  · intro hspan K _ x
    exact field_points_of_ideal_span_smul_sub_eq_top g hspan K x
  · exact ideal_span_smul_sub_eq_top_of_field_points g

/-- Surjectivity of the action tensor map from field-valued freeness. -/
theorem actionTensorMap_surjective_of_field_points
    (R : Type u) [CommRing R] [Algebra R A] [SMulCommClass G R A]
    [Finite G]
    (hfree : ∀ (g : G), g ≠ 1 →
      ∀ (K : Type v) [Field K] (x : A →+* K),
        ∃ a : A, x (g • a) ≠ x a) :
    Function.Surjective (actionTensorMap R A G) := by
  apply actionTensorMap_surjective R A G
  intro g hg
  exact ideal_span_smul_sub_eq_top_of_field_points g (fun K _ x => hfree g hg K x)

end MilneLib
