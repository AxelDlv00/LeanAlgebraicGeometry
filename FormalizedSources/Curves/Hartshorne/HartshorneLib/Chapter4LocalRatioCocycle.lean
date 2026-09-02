/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4LocalRatioCoordinates

/-!
# Hartshorne IV.3.1: cocycles for local ratio regularizations

The coordinate file proves the pairwise transition identity.  This module
packages the functorial restriction step on a triple intersection and derives
the resulting denominator cocycle and three-step transport formula.
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
variable {n : ℕ}

namespace LocalRatioRegularization

variable {a : LocalRatioCoordinateData D n}

/-- Restriction of a structure-sheaf section along an inclusion of opens. -/
def restrictSection {U V : X.left.Opens} (hVU : V ≤ U)
    (s : Γ(X.left, U)) : Γ(X.left, V) :=
  (X.left.presheaf.map (homOfLE hVU).op).hom s

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
@[simp] theorem restrictSection_eq_map {U V : X.left.Opens} (hVU : V ≤ U)
    (s : Γ(X.left, U)) :
    restrictSection hVU s =
      (X.left.presheaf.map (homOfLE hVU).op).hom s :=
  rfl

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- Two successive restrictions agree with the direct restriction. -/
theorem restrictSection_restrictSection
    {U V W : X.left.Opens} (hVU : V ≤ U) (hWV : W ≤ V)
    (s : Γ(X.left, U)) :
    restrictSection hWV (restrictSection hVU s) =
      restrictSection (hWV.trans hVU) s := by
  change (X.left.presheaf.map (homOfLE hWV).op).hom
      ((X.left.presheaf.map (homOfLE hVU).op).hom s) =
    (X.left.presheaf.map (homOfLE (hWV.trans hVU)).op).hom s
  rw [← ConcreteCategory.comp_apply, ← X.left.presheaf.map_comp]
  rw [show (homOfLE hVU).op ≫ (homOfLE hWV).op =
      (homOfLE (hWV.trans hVU)).op by apply Subsingleton.elim]

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
private theorem restrictSection_mul
    {U V : X.left.Opens} (hVU : V ≤ U)
    (s t : Γ(X.left, U)) :
    restrictSection hVU (s * t) =
      restrictSection hVU s * restrictSection hVU t := by
  simp only [restrictSection_eq_map, map_mul]

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
private theorem restrictSection_proof_irrel
    {U V : X.left.Opens} (h₁ h₂ : V ≤ U) (s : Γ(X.left, U)) :
    restrictSection h₁ s = restrictSection h₂ s := by
  change (X.left.presheaf.map (homOfLE h₁).op).hom s =
    (X.left.presheaf.map (homOfLE h₂).op).hom s
  rw [show (homOfLE h₁).op = (homOfLE h₂).op by
    apply Subsingleton.elim]

/-- The common triple intersection of three local-ratio charts. -/
def tripleOpen (a b c : LocalRatioCoordinateData D n) : X.left.Opens :=
  a.chart.U ⊓ (b.chart.U ⊓ c.chart.U)

@[simp] theorem tripleOpen_nonempty
    (a b c : LocalRatioCoordinateData D n) :
    ((tripleOpen a b c : X.left.Opens) : Set X.left).Nonempty := by
  refine ⟨genericPoint X.left, ?_⟩
  change genericPoint X.left ∈ a.chart.U ⊓ (b.chart.U ⊓ c.chart.U)
  exact ⟨a.chart.generic_mem, b.chart.generic_mem, c.chart.generic_mem⟩

theorem tripleOpen_le_a
    (a b c : LocalRatioCoordinateData D n) :
    tripleOpen a b c ≤ a.chart.U := by
  exact inf_le_left

theorem tripleOpen_le_b
    (a b c : LocalRatioCoordinateData D n) :
    tripleOpen a b c ≤ b.chart.U := by
  exact (inf_le_right : a.chart.U ⊓ (b.chart.U ⊓ c.chart.U) ≤
    b.chart.U ⊓ c.chart.U).trans inf_le_left

theorem tripleOpen_le_c
    (a b c : LocalRatioCoordinateData D n) :
    tripleOpen a b c ≤ c.chart.U := by
  exact (inf_le_right : a.chart.U ⊓ (b.chart.U ⊓ c.chart.U) ≤
    b.chart.U ⊓ c.chart.U).trans inf_le_right

theorem tripleOpen_le_ab
    (a b c : LocalRatioCoordinateData D n) :
    tripleOpen a b c ≤ a.chart.U ⊓ b.chart.U := by
  exact inf_le_inf (le_refl _) inf_le_left

theorem tripleOpen_le_bc
    (a b c : LocalRatioCoordinateData D n) :
    tripleOpen a b c ≤ b.chart.U ⊓ c.chart.U := by
  exact inf_le_right

private theorem restrictSection_via_ab_eq_via_bc
    (a b c : LocalRatioCoordinateData D n)
    (s : Γ(X.left, b.chart.U)) :
    restrictSection (tripleOpen_le_ab a b c)
        (restrictSection
          (inf_le_right : a.chart.U ⊓ b.chart.U ≤ b.chart.U) s) =
      restrictSection (tripleOpen_le_bc a b c)
        (restrictSection
          (inf_le_left : b.chart.U ⊓ c.chart.U ≤ b.chart.U) s) := by
  rw [restrictSection_restrictSection, restrictSection_restrictSection]

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
private theorem restrictSection_pair_eq_direct
    {U V W : X.left.Opens} (hVU : V ≤ U) (hWV : W ≤ V)
    (hWU : W ≤ U) (s : Γ(X.left, U)) :
    restrictSection hWV (restrictSection hVU s) =
      restrictSection hWU s := by
  rw [restrictSection_restrictSection]

/-- On a pair overlap the two denominator transitions are inverse sections. -/
theorem transition_mul_inverse
    {b : LocalRatioCoordinateData D n}
    (r : LocalRatioRegularization a) (s : LocalRatioRegularization b)
    (h : a.SameSectionValues b) :
    restrictSection
        (inf_le_left : a.chart.U ⊓ b.chart.U ≤ a.chart.U)
        (r.regularized b.denominator_index) *
      restrictSection
        (inf_le_right : a.chart.U ⊓ b.chart.U ≤ b.chart.U)
        (s.regularized a.denominator_index) = 1 := by
  simpa [restrictSection, r.regularized_denominator_eq_one] using
    (r.restricted_regularized_eq_transition_mul s h
      a.denominator_index).symm

/-- The direct denominator transition on a triple overlap is the product of
the two successive transitions through the middle chart. -/
theorem triple_transition_cocycle
    {b c : LocalRatioCoordinateData D n}
    (r : LocalRatioRegularization a) (s : LocalRatioRegularization b)
    (h : a.SameSectionValues b) :
    restrictSection (tripleOpen_le_a a b c)
        (r.regularized c.denominator_index) =
      restrictSection (tripleOpen_le_a a b c)
        (r.regularized b.denominator_index) *
      restrictSection (tripleOpen_le_b a b c)
        (s.regularized c.denominator_index) := by
  have hp :
      restrictSection
          (inf_le_left : a.chart.U ⊓ b.chart.U ≤ a.chart.U)
          (r.regularized c.denominator_index) =
        restrictSection
          (inf_le_left : a.chart.U ⊓ b.chart.U ≤ a.chart.U)
          (r.regularized b.denominator_index) *
          restrictSection
            (inf_le_right : a.chart.U ⊓ b.chart.U ≤ b.chart.U)
            (s.regularized c.denominator_index) := by
    simpa only [restrictSection_eq_map] using
      (r.restricted_regularized_eq_transition_mul s h
        c.denominator_index)
  have hp' := congrArg
    (restrictSection (tripleOpen_le_ab a b c)) hp
  simpa only [restrictSection_restrictSection, restrictSection_mul] using hp'

/-- A regularized coordinate transports through two successive overlaps. -/
theorem triple_regularized_transport
    {b c : LocalRatioCoordinateData D n}
    (r : LocalRatioRegularization a) (s : LocalRatioRegularization b)
    (t : LocalRatioRegularization c)
    (hab : a.SameSectionValues b) (hbc : b.SameSectionValues c)
    (i : Fin (n + 1)) :
    restrictSection (tripleOpen_le_a a b c) (r.regularized i) =
      restrictSection (tripleOpen_le_a a b c)
          (r.regularized b.denominator_index) *
        (restrictSection (tripleOpen_le_b a b c)
            (s.regularized c.denominator_index) *
          restrictSection (tripleOpen_le_c a b c) (t.regularized i)) := by
  have hp_ab :
      restrictSection
          (inf_le_left : a.chart.U ⊓ b.chart.U ≤ a.chart.U)
          (r.regularized i) =
        restrictSection
          (inf_le_left : a.chart.U ⊓ b.chart.U ≤ a.chart.U)
          (r.regularized b.denominator_index) *
          restrictSection
            (inf_le_right : a.chart.U ⊓ b.chart.U ≤ b.chart.U)
            (s.regularized i) := by
    simpa only [restrictSection_eq_map] using
      (r.restricted_regularized_eq_transition_mul s hab i)
  have hp_ab' := congrArg
    (restrictSection (tripleOpen_le_ab a b c)) hp_ab
  have hp_bc :
      restrictSection
          (inf_le_left : b.chart.U ⊓ c.chart.U ≤ b.chart.U)
          (s.regularized i) =
        restrictSection
          (inf_le_left : b.chart.U ⊓ c.chart.U ≤ b.chart.U)
          (s.regularized c.denominator_index) *
          restrictSection
            (inf_le_right : b.chart.U ⊓ c.chart.U ≤ c.chart.U)
            (t.regularized i) := by
    simpa only [restrictSection_eq_map] using
      (s.restricted_regularized_eq_transition_mul t hbc i)
  have hp_bc' := congrArg
    (restrictSection (tripleOpen_le_bc a b c)) hp_bc
  calc
    restrictSection (tripleOpen_le_a a b c) (r.regularized i) =
        restrictSection (tripleOpen_le_ab a b c)
          (restrictSection
            (inf_le_left : a.chart.U ⊓ b.chart.U ≤ a.chart.U)
            (r.regularized i)) := by
      symm
      exact restrictSection_pair_eq_direct _ _ _ _
    _ = restrictSection (tripleOpen_le_ab a b c)
          (restrictSection
            (inf_le_left : a.chart.U ⊓ b.chart.U ≤ a.chart.U)
            (r.regularized b.denominator_index) *
           restrictSection
            (inf_le_right : a.chart.U ⊓ b.chart.U ≤ b.chart.U)
            (s.regularized i)) := by
      exact hp_ab'
    _ = restrictSection (tripleOpen_le_a a b c)
          (r.regularized b.denominator_index) *
        restrictSection (tripleOpen_le_ab a b c)
          (restrictSection
            (inf_le_right : a.chart.U ⊓ b.chart.U ≤ b.chart.U)
            (s.regularized i)) := by
      rw [restrictSection_mul,
        restrictSection_pair_eq_direct
          (inf_le_left : a.chart.U ⊓ b.chart.U ≤ a.chart.U)
          (tripleOpen_le_ab a b c) (tripleOpen_le_a a b c)]
    _ = restrictSection (tripleOpen_le_a a b c)
          (r.regularized b.denominator_index) *
        restrictSection (tripleOpen_le_bc a b c)
          (restrictSection
            (inf_le_left : b.chart.U ⊓ c.chart.U ≤ b.chart.U)
            (s.regularized i)) := by
      rw [restrictSection_via_ab_eq_via_bc]
    _ = restrictSection (tripleOpen_le_a a b c)
          (r.regularized b.denominator_index) *
        (restrictSection (tripleOpen_le_bc a b c)
            (restrictSection
              (inf_le_left : b.chart.U ⊓ c.chart.U ≤ b.chart.U)
              (s.regularized c.denominator_index)) *
          restrictSection (tripleOpen_le_bc a b c)
            (restrictSection
              (inf_le_right : b.chart.U ⊓ c.chart.U ≤ c.chart.U)
              (t.regularized i))) := by
      rw [hp_bc', restrictSection_mul]
    _ = restrictSection (tripleOpen_le_a a b c)
          (r.regularized b.denominator_index) *
        (restrictSection (tripleOpen_le_b a b c)
            (s.regularized c.denominator_index) *
          restrictSection (tripleOpen_le_c a b c)
            (t.regularized i)) := by
      rw [restrictSection_pair_eq_direct
            (inf_le_left : b.chart.U ⊓ c.chart.U ≤ b.chart.U)
            (tripleOpen_le_bc a b c) (tripleOpen_le_b a b c),
        restrictSection_pair_eq_direct
            (inf_le_right : b.chart.U ⊓ c.chart.U ≤ c.chart.U)
            (tripleOpen_le_bc a b c) (tripleOpen_le_c a b c)]

end LocalRatioRegularization

end
end Hartshorne
