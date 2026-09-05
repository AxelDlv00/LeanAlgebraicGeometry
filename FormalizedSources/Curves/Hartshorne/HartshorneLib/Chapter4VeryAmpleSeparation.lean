/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4BasePointFreeLocalJump

/-!
# Hartshorne IV.3.1: intrinsic two-point separation

The two-point dévissage of a divisor sheaf is the intersection of the two
one-point section spaces when the points are distinct.  Combined with the
numerical very-ampleness drop, this gives an explicit section separating two
points in the intrinsic divisor-section model.  No projective immersion or
chosen line-bundle trivialization is asserted here.
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

attribute [local instance] functionFieldOverModule

/-- Dévissage at two points commutes at the divisor level. -/
lemma devissageDivisor_comm {D : CurveDivisor k X} (x y : X.left)
    (hx : x ≠ genericPoint X.left) (hy : y ≠ genericPoint X.left) :
    CurveDivisor.devissageDivisor hy (CurveDivisor.devissageDivisor hx D) =
      CurveDivisor.devissageDivisor hx (CurveDivisor.devissageDivisor hy D) := by
  rw [CurveDivisor.devissageDivisor_eq_sub, CurveDivisor.devissageDivisor_eq_sub,
      CurveDivisor.devissageDivisor_eq_sub, CurveDivisor.devissageDivisor_eq_sub]
  abel

/-- Two-point dévissage is contained in each one-point section space. -/
lemma divisorSections_twoDevissage_le_inf {D : CurveDivisor k X}
    (x y : X.left) (hx : x ≠ genericPoint X.left)
    (hy : y ≠ genericPoint X.left) :
    divisorSections (CurveDivisor.devissageDivisor hy
      (CurveDivisor.devissageDivisor hx D)) (⊤ : X.left.Opens) ≤
      divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ ⊓
        divisorSections (CurveDivisor.devissageDivisor hy D) ⊤ := by
  refine le_inf ?_ ?_
  · exact divisorSections_mono
      (devissageDivisor_le hy (CurveDivisor.devissageDivisor hx D)) ⊤
  · rw [devissageDivisor_comm x y hx hy]
    exact divisorSections_mono
      (devissageDivisor_le hx (CurveDivisor.devissageDivisor hy D)) ⊤

/-- For distinct points, membership in both one-point spaces implies the
two-point dévissage bound. -/
lemma divisorSections_inf_le_twoDevissage_of_ne {D : CurveDivisor k X}
    (x y : X.left) (hx : x ≠ genericPoint X.left)
    (hy : y ≠ genericPoint X.left) (hxy : x ≠ y) :
    divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ ⊓
        divisorSections (CurveDivisor.devissageDivisor hy D) ⊤ ≤
      divisorSections (CurveDivisor.devissageDivisor hy
        (CurveDivisor.devissageDivisor hx D)) ⊤ := by
  intro g hg
  have hgm := Submodule.mem_inf.mp hg
  rw [mem_divisorSections_of_nonempty (by simp)]
  intro z hz hzTop
  have hxmem := (mem_divisorSections_of_nonempty
    (D := CurveDivisor.devissageDivisor hx D) (U := (⊤ : X.left.Opens))
    (by simp)).mp hgm.1 z hz hzTop
  have hymem := (mem_divisorSections_of_nonempty
    (D := CurveDivisor.devissageDivisor hy D) (U := (⊤ : X.left.Opens))
    (by simp)).mp hgm.2 z hz hzTop
  by_cases hzx : z = x
  · subst z
    have hyx : (⟨x, hx⟩ : {p : X.left // p ≠ genericPoint X.left}) ≠ ⟨y, hy⟩ := by
      intro h
      exact hxy (congrArg Subtype.val h)
    rw [divisorBound_devissageDivisor_of_ne hy hx hyx
      (CurveDivisor.devissageDivisor hx D)]
    exact hxmem
  · by_cases hzy : z = y
    · subst z
      have hxy' : (⟨y, hy⟩ : {p : X.left // p ≠ genericPoint X.left}) ≠ ⟨x, hx⟩ := by
        intro h
        exact hxy (congrArg Subtype.val h).symm
      rw [devissageDivisor_comm x y hx hy]
      rw [divisorBound_devissageDivisor_of_ne hx hy hxy'
        (CurveDivisor.devissageDivisor hy D)]
      exact hymem
    · have hzx' : (⟨z, hz⟩ : {p : X.left // p ≠ genericPoint X.left}) ≠ ⟨x, hx⟩ := by
        intro h
        exact hzx (congrArg Subtype.val h)
      have hzy' : (⟨z, hz⟩ : {p : X.left // p ≠ genericPoint X.left}) ≠ ⟨y, hy⟩ := by
        intro h
        exact hzy (congrArg Subtype.val h)
      have hxmem' := hxmem
      rw [divisorBound_devissageDivisor_of_ne hx hz hzx' D] at hxmem'
      rw [divisorBound_devissageDivisor_of_ne hy hz hzy'
        (CurveDivisor.devissageDivisor hx D),
        divisorBound_devissageDivisor_of_ne hx hz hzx' D]
      exact hxmem'

/-- Under very ampleness the two-point section space is strictly smaller than
the first one-point space. -/
lemma twoDevissage_lt_first {D : CurveDivisor k X}
    (hD : VeryAmpleLinearSystem D) (x y : X.left)
    (hx : x ≠ genericPoint X.left) (hy : y ≠ genericPoint X.left) :
    divisorSections (CurveDivisor.devissageDivisor hy
      (CurveDivisor.devissageDivisor hx D)) ⊤ <
      divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ := by
  have hdrop := hD x y hx hy
  have hupper := h0_le_h0_sub_point_add_one_of_smoothProperIntegralCurve hx D
  have hltH : CategoryTheory.Sheaf.h0 (divisorSheaf (CurveDivisor.devissageDivisor hy
      (CurveDivisor.devissageDivisor hx D))) <
      CategoryTheory.Sheaf.h0 (divisorSheaf (CurveDivisor.devissageDivisor hx D)) := by
    omega
  let eSmall := CategoryTheory.Sheaf.HModule.linearEquiv₀ isTerminalTop
    (divisorSheaf (CurveDivisor.devissageDivisor hy
      (CurveDivisor.devissageDivisor hx D)))
  let eBig := CategoryTheory.Sheaf.HModule.linearEquiv₀ isTerminalTop
    (divisorSheaf (CurveDivisor.devissageDivisor hx D))
  have hlt : Module.finrank k ((divisorSheaf (CurveDivisor.devissageDivisor hy
      (CurveDivisor.devissageDivisor hx D))).obj.obj
      (Opposite.op (⊤ : X.left.Opens))) <
      Module.finrank k ((divisorSheaf (CurveDivisor.devissageDivisor hx D)).obj.obj
      (Opposite.op (⊤ : X.left.Opens))) := by
    rw [← eSmall.finrank_eq, ← eBig.finrank_eq]
    exact hltH
  exact Submodule.lt_of_le_of_finrank_lt_finrank
    (divisorSections_mono
      (devissageDivisor_le hy (CurveDivisor.devissageDivisor hx D)) ⊤) hlt

/-- For distinct points, very ampleness supplies a section vanishing at `x`
but not at `y` in the intrinsic dévissage model. -/
lemma exists_section_devissage_x_not_devissage_y {D : CurveDivisor k X}
    (hD : VeryAmpleLinearSystem D) (x y : X.left)
    (hx : x ≠ genericPoint X.left) (hy : y ≠ genericPoint X.left)
    (hxy : x ≠ y) :
    ∃ s : divisorSections (CurveDivisor.devissageDivisor hx D) ⊤,
      (s : X.left.functionField) ∉
        divisorSections (CurveDivisor.devissageDivisor hy D) ⊤ := by
  have hnot : ¬ divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ ≤
      divisorSections (CurveDivisor.devissageDivisor hy D) ⊤ := by
    intro hxySub
    have hfirst : divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ ≤
        divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ ⊓
          divisorSections (CurveDivisor.devissageDivisor hy D) ⊤ :=
      le_inf le_rfl hxySub
    have hsecond := divisorSections_inf_le_twoDevissage_of_ne (D := D)
      x y hx hy hxy
    have hle : divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ ≤
        divisorSections (CurveDivisor.devissageDivisor hy
          (CurveDivisor.devissageDivisor hx D)) ⊤ := hfirst.trans hsecond
    exact (not_le_of_gt (twoDevissage_lt_first hD x y hx hy)) hle
  obtain ⟨g, hgx, hgynot⟩ := (SetLike.not_le_iff_exists).mp hnot
  exact ⟨⟨g, hgx⟩, hgynot⟩

end
end Hartshorne
