/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4Nonspecial

/-!
# Hartshorne IV.3.2: numerical linear-system criteria

The geometric notions of base-point-freeness and very ampleness are represented
here by their section-rank criteria.  This keeps the API available before a
scheme-theoretic morphism-to-projective-space layer is introduced.
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

/-- Numerical base-point-freeness: deleting any closed point lowers `h⁰` by one.

This is the section-dimension formulation of Hartshorne IV.3.1.
-/
def BasePointFreeLinearSystem (D : CurveDivisor k X) : Prop :=
  ∀ (x : X.left) (hx : x ≠ genericPoint X.left),
    (CategoryTheory.Sheaf.h0 (divisorSheaf D) : ℤ) -
        CategoryTheory.Sheaf.h0
          (divisorSheaf (CurveDivisor.devissageDivisor hx D)) = 1

/-- Numerical very ampleness: deleting two (possibly equal) closed points lowers
`h⁰` by two.  This is the section-dimension formulation of Hartshorne IV.3.1.
-/
def VeryAmpleLinearSystem (D : CurveDivisor k X) : Prop :=
  ∀ (x y : X.left)
    (hx : x ≠ genericPoint X.left) (hy : y ≠ genericPoint X.left),
    (CategoryTheory.Sheaf.h0 (divisorSheaf D) : ℤ) -
        CategoryTheory.Sheaf.h0
          (divisorSheaf
            (CurveDivisor.devissageDivisor hy
              (CurveDivisor.devissageDivisor hx D))) = 2

/-- The numerical base-point-free condition makes the sections of `D - x` a
proper subspace of the global divisor sections of `D`. -/
theorem divisorSections_devissage_lt_of_basePointFree
    {D : CurveDivisor k X} (hD : BasePointFreeLinearSystem D)
    (x : X.left) (hx : x ≠ genericPoint X.left) :
    divisorSections (CurveDivisor.devissageDivisor hx D) (⊤ : X.left.Opens) <
      divisorSections D ⊤ := by
  have hdrop := hD x hx
  have hltH :
      CategoryTheory.Sheaf.h0
          (divisorSheaf (CurveDivisor.devissageDivisor hx D)) <
        CategoryTheory.Sheaf.h0 (divisorSheaf D) := by
    omega
  let eSmall := CategoryTheory.Sheaf.HModule.linearEquiv₀ isTerminalTop
    (divisorSheaf (CurveDivisor.devissageDivisor hx D))
  let eBig := CategoryTheory.Sheaf.HModule.linearEquiv₀ isTerminalTop
    (divisorSheaf D)
  have hlt :
      Module.finrank k
          ((divisorSheaf (CurveDivisor.devissageDivisor hx D)).obj.obj
            (Opposite.op (⊤ : X.left.Opens))) <
        Module.finrank k
          ((divisorSheaf D).obj.obj (Opposite.op (⊤ : X.left.Opens))) := by
    rw [← eSmall.finrank_eq, ← eBig.finrank_eq]
    exact hltH
  exact Submodule.lt_of_le_of_finrank_lt_finrank
    (divisorSections_mono (devissageDivisor_le hx D) ⊤) hlt

/-- A numerical base-point-free system has a global divisor section whose class
modulo the sections of `D - x` is nonzero. -/
theorem exists_divisorSection_not_mem_devissage_of_basePointFree
    {D : CurveDivisor k X} (hD : BasePointFreeLinearSystem D)
    (x : X.left) (hx : x ≠ genericPoint X.left) :
    ∃ s : divisorSections D (⊤ : X.left.Opens),
      (s : X.left.functionField) ∉
        divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ := by
  obtain ⟨g, hgD, hgnot⟩ := SetLike.exists_of_lt
    (divisorSections_devissage_lt_of_basePointFree hD x hx)
  exact ⟨⟨g, hgD⟩, hgnot⟩

/-! ### Two-point separation witnesses -/

/-- The numerical very-ampleness condition makes the sections of `D - x - y`
a proper subspace of the global divisor sections of `D`.

The points are allowed to coincide.  In that case the statement is the
two-jet (tangent-direction) part of the numerical criterion, while this API
deliberately records only the resulting strict section-space inclusion. -/
theorem divisorSections_twoDevissage_lt_of_veryAmple
    {D : CurveDivisor k X} (hD : VeryAmpleLinearSystem D)
    (x y : X.left) (hx : x ≠ genericPoint X.left)
    (hy : y ≠ genericPoint X.left) :
    divisorSections (CurveDivisor.devissageDivisor hy
      (CurveDivisor.devissageDivisor hx D)) (⊤ : X.left.Opens) <
      divisorSections D ⊤ := by
  have hdrop := hD x y hx hy
  have hltH :
      CategoryTheory.Sheaf.h0
          (divisorSheaf (CurveDivisor.devissageDivisor hy
            (CurveDivisor.devissageDivisor hx D))) <
        CategoryTheory.Sheaf.h0 (divisorSheaf D) := by
    omega
  let eSmall := CategoryTheory.Sheaf.HModule.linearEquiv₀ isTerminalTop
    (divisorSheaf (CurveDivisor.devissageDivisor hy
      (CurveDivisor.devissageDivisor hx D)))
  let eBig := CategoryTheory.Sheaf.HModule.linearEquiv₀ isTerminalTop
    (divisorSheaf D)
  have hlt :
      Module.finrank k
          ((divisorSheaf (CurveDivisor.devissageDivisor hy
            (CurveDivisor.devissageDivisor hx D))).obj.obj
            (Opposite.op (⊤ : X.left.Opens))) <
        Module.finrank k
          ((divisorSheaf D).obj.obj (Opposite.op (⊤ : X.left.Opens))) := by
    rw [← eSmall.finrank_eq, ← eBig.finrank_eq]
    exact hltH
  have hle1 := divisorSections_mono (devissageDivisor_le hx D)
    (⊤ : X.left.Opens)
  have hle2 := divisorSections_mono
    (devissageDivisor_le hy (CurveDivisor.devissageDivisor hx D))
    (⊤ : X.left.Opens)
  exact Submodule.lt_of_le_of_finrank_lt_finrank (hle2.trans hle1) hlt

/-- A numerically very ample system has a global divisor section outside the
sections obtained after deleting two (possibly equal) points. -/
theorem exists_divisorSection_not_mem_twoDevissage_of_veryAmple
    {D : CurveDivisor k X} (hD : VeryAmpleLinearSystem D)
    (x y : X.left) (hx : x ≠ genericPoint X.left)
    (hy : y ≠ genericPoint X.left) :
    ∃ s : divisorSections D (⊤ : X.left.Opens),
      (s : X.left.functionField) ∉
        divisorSections (CurveDivisor.devissageDivisor hy
          (CurveDivisor.devissageDivisor hx D)) ⊤ := by
  obtain ⟨g, hgD, hgnot⟩ := SetLike.exists_of_lt
    (divisorSections_twoDevissage_lt_of_veryAmple hD x y hx hy)
  exact ⟨⟨g, hgD⟩, hgnot⟩

/-- Degree at least `2g` implies numerical base-point-freeness (IV.3.2). -/
theorem basePointFreeLinearSystem_of_degree_ge_two_mul_genus
    (sd : CurveSerreDualityData (k := k) (X := X))
    {D : CurveDivisor k X}
    (hD : 2 * (curveGenus (k := k) (X := X) : ℤ) ≤
      CurveDivisor.degree D) :
    BasePointFreeLinearSystem D := by
  intro x hx
  exact h0_divisorSheaf_sub_point_sub_eq_one_of_degree_ge_two_mul_genus
    (k := k) (X := X) sd hD hx

/-- Degree at least `2g+1` implies numerical very ampleness (IV.3.2). -/
theorem veryAmpleLinearSystem_of_degree_ge_two_mul_genus_plus_one
    (sd : CurveSerreDualityData (k := k) (X := X))
    {D : CurveDivisor k X}
    (hD : 2 * (curveGenus (k := k) (X := X) : ℤ) + 1 ≤
      CurveDivisor.degree D) :
    VeryAmpleLinearSystem D := by
  intro x y hx hy
  exact h0_divisorSheaf_sub_two_points_sub_eq_two_of_degree_ge_two_mul_genus_plus_one
    (k := k) (X := X) sd hD hx hy

end
end Hartshorne
