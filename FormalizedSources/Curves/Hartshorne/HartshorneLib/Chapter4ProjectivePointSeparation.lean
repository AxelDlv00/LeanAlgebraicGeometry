/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4BasePointFreeLocalRatioCoverUnconditional
import HartshorneLib.Chapter4LocalRatioHyperplane
import HartshorneLib.Chapter4LocalRatioNonvanishing
import HartshorneLib.Chapter4VeryAmpleSeparation

/-!
# Point separation by the divisor-section projective map

The hyperplane associated to a section in a fixed basis pulls back to that
section's vanishing locus. Consequently the two-point section-separation
criterion in Hartshorne IV.3.1 distinguishes the images of closed points under
the actual glued morphism. A nonzero section vanishing at a closed point also
distinguishes that point from the generic point, giving injectivity everywhere.
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
variable {D : CurveDivisor k X} {n : ℕ}

attribute [local instance] functionFieldOverModule MvPolynomial.gradedAlgebra

namespace BasePointFreeLocalRatioCover

/-- Expanding a global divisor section in the fixed basis also expands its
value in the function field. -/
theorem basisSections_sum_repr
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (s : divisorSections D ⊤) :
    (∑ j, functionFieldOverAlgebraMap k X.left
      (basis.repr ((divisorSectionSpaceEquiv (D := D)).symm s) j) *
        (basisSections (D := D) basis j : X.left.functionField)) =
      (s : X.left.functionField) := by
  have hsum := congrArg (divisorSectionSpaceEquiv (D := D))
    (basis.sum_repr ((divisorSectionSpaceEquiv (D := D)).symm s))
  simp only [map_sum, map_smul, LinearEquiv.apply_symm_apply] at hsum
  have hval := congrArg
    (fun t : divisorSections D ⊤ => (t : X.left.functionField)) hsum
  simpa only [Submodule.coe_sum, Submodule.coe_smul,
    functionFieldOverModule_smul_def, basisSections] using hval

/-- A section's basis linear form is nonvanishing at the projective image of
a closed point exactly when the section has nonzero local jump there. -/
theorem gluedMap_mem_linearForm_basicOpen_iff_jumpProj_ne_zero
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (s : divisorSections D ⊤)
    (x : X.left) (hx : x ≠ genericPoint X.left) :
    gluedMap_of_smoothCurve (D := D) basis hD x ∈
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (ProjectiveCoordinates.linearForm
            (basis.repr ((divisorSectionSpaceEquiv (D := D)).symm s))) ↔
      jumpProj hx D ⊤ trivial s ≠ 0 := by
  let q : NonGenericPoint X := ⟨x, hx⟩
  let a := selectedCoordinates (D := D) basis hD q
  let r := selectedRegularization (D := D) basis hD q
  let c : Fin (n + 1) → k :=
    basis.repr ((divisorSectionSpaceEquiv (D := D)).symm s)
  have hxU : x ∈ a.chart.U := (selectedOpen_spec basis hD q).1
  let p : a.chart.U := ⟨x, hxU⟩
  have hrestrict : a.chart.U.ι ≫ gluedMap_of_smoothCurve basis hD = r.chartMap :=
    chartOpenCover_ι_projectiveMapProducer_of_smoothCurve basis hD q
  have himage : r.chartMap p = gluedMap_of_smoothCurve basis hD x :=
    (congrArg (fun f => f p) hrestrict).symm
  change gluedMap_of_smoothCurve basis hD x ∈
      Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (ProjectiveCoordinates.linearForm c) ↔ _
  rw [← himage]
  change p ∈ r.chartMap ⁻¹ᵁ
      Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (ProjectiveCoordinates.linearForm c) ↔ _
  rw [r.chartMap_preimage_linearForm_basicOpen_regularized]
  change x ∈ X.left.basicOpen (r.regularizedLinearForm c) ↔ _
  have hvalue : localStructureValue a.chart (r.regularizedLinearForm c) =
      (s : X.left.functionField) /
        (a.sections a.denominator_index : X.left.functionField) := by
    rw [r.regularizedLinearForm_value]
    congr 1
    simpa only [a, selectedCoordinates_section_value] using basisSections_sum_repr basis s
  have hden : orderAt X.hom hx
      (a.sections a.denominator_index : X.left.functionField) = divisorBound D hx := by
    rw [show (a.sections a.denominator_index : X.left.functionField) =
      (basisSections (D := D) basis (selectedIndex basis hD q) : X.left.functionField)
      from selectedCoordinates_section_value basis hD q _]
    exact selectedSection_orderAt basis hD q
  rw [mem_basicOpen_ratio_iff_orderAt_eq_divisorBound a.chart _ _ _ hvalue hx hxU hden,
    jumpProj_ne_zero_iff_orderAt_eq_divisorBound (U := ⊤) hx trivial s]

/-- Numerical point separation makes the glued morphism injective on the
non-generic (equivalently, closed) points of the smooth proper curve. -/
theorem gluedMap_injective_on_nonGenericPoints_of_veryAmple
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : VeryAmpleLinearSystem D) :
    Function.Injective (fun x : NonGenericPoint X =>
      gluedMap_of_smoothCurve (D := D) basis
        (basePointFreeLinearSystem_of_veryAmple hD) x.1) := by
  intro x y heq
  dsimp only at heq
  apply Subtype.ext
  by_contra hxy
  obtain ⟨s, hs⟩ := exists_section_devissage_x_not_devissage_y
    hD x.1 y.1 x.2 y.2 hxy
  let t : divisorSections D ⊤ := ⟨s,
    divisorSections_mono (devissageDivisor_le x.2 D) ⊤ s.2⟩
  have htx : ¬ jumpProj x.2 D ⊤ trivial t ≠ 0 := by
    rw [jumpProj_ne_zero_iff_not_mem_divisorSections_devissage]
    exact not_not_intro s.2
  have hty : jumpProj y.2 D ⊤ trivial t ≠ 0 :=
    (jumpProj_ne_zero_iff_not_mem_divisorSections_devissage y.2 D t).mpr hs
  have hxmem := (gluedMap_mem_linearForm_basicOpen_iff_jumpProj_ne_zero basis
    (basePointFreeLinearSystem_of_veryAmple hD) t x.1 x.2)
  have hymem := (gluedMap_mem_linearForm_basicOpen_iff_jumpProj_ne_zero basis
    (basePointFreeLinearSystem_of_veryAmple hD) t y.1 y.2).mpr hty
  rw [← heq] at hymem
  exact htx (hxmem.mp hymem)

/-- The generic image lies in the basic open of a section's linear form
exactly when the section is nonzero in the function field. -/
theorem gluedMap_genericPoint_mem_linearForm_basicOpen_iff
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (s : divisorSections D ⊤) :
    gluedMap_of_smoothCurve (D := D) basis hD (genericPoint X.left) ∈
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (ProjectiveCoordinates.linearForm
            (basis.repr ((divisorSectionSpaceEquiv (D := D)).symm s))) ↔
      (s : X.left.functionField) ≠ 0 := by
  let q : NonGenericPoint X :=
    Classical.choice (nonempty_nonGenericPoint_of_smoothCurve (X := X))
  let a := selectedCoordinates (D := D) basis hD q
  let r := selectedRegularization (D := D) basis hD q
  let c : Fin (n + 1) → k :=
    basis.repr ((divisorSectionSpaceEquiv (D := D)).symm s)
  let p : a.chart.U := ⟨genericPoint X.left, a.chart.generic_mem⟩
  have hrestrict : a.chart.U.ι ≫ gluedMap_of_smoothCurve basis hD = r.chartMap :=
    chartOpenCover_ι_projectiveMapProducer_of_smoothCurve basis hD q
  have himage : r.chartMap p =
      gluedMap_of_smoothCurve basis hD (genericPoint X.left) :=
    (congrArg (fun f => f p) hrestrict).symm
  change gluedMap_of_smoothCurve basis hD (genericPoint X.left) ∈
      Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (ProjectiveCoordinates.linearForm c) ↔ _
  rw [← himage]
  change p ∈ r.chartMap ⁻¹ᵁ
      Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (ProjectiveCoordinates.linearForm c) ↔ _
  rw [r.chartMap_preimage_linearForm_basicOpen_regularized]
  change genericPoint X.left ∈ X.left.basicOpen (r.regularizedLinearForm c) ↔ _
  rw [X.left.mem_basicOpen _ _ a.chart.generic_mem]
  change IsUnit (localStructureValue a.chart (r.regularizedLinearForm c)) ↔ _
  rw [isUnit_iff_ne_zero, r.regularizedLinearForm_value, div_ne_zero_iff]
  have hsum : (∑ j, functionFieldOverAlgebraMap k X.left (c j) *
      (a.sections j : X.left.functionField)) = (s : X.left.functionField) := by
    simpa only [a, selectedCoordinates_section_value] using basisSections_sum_repr basis s
  rw [hsum]
  exact and_iff_left a.denominator_value_ne_zero

/-- A very ample system distinguishes the generic point from every closed
point using a nonzero section vanishing at that closed point. -/
theorem gluedMap_genericPoint_ne_of_veryAmple
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : VeryAmpleLinearSystem D) (x : X.left)
    (hx : x ≠ genericPoint X.left) :
    gluedMap_of_smoothCurve (D := D) basis
        (basePointFreeLinearSystem_of_veryAmple hD) (genericPoint X.left) ≠
      gluedMap_of_smoothCurve (D := D) basis
        (basePointFreeLinearSystem_of_veryAmple hD) x := by
  obtain ⟨s, hs⟩ := exists_tangent_order_witness_of_veryAmple hD x hx
  have hsne : (s : X.left.functionField) ≠ 0 := by
    intro hzero
    rw [hzero, map_zero, divisorBound_eq_coeffAt] at hs
    exact WithZero.coe_ne_zero hs.symm
  let t : divisorSections D ⊤ := ⟨s,
    divisorSections_mono (devissageDivisor_le hx D) ⊤ s.2⟩
  have hgen := (gluedMap_genericPoint_mem_linearForm_basicOpen_iff basis
    (basePointFreeLinearSystem_of_veryAmple hD) t).mpr hsne
  intro heq
  rw [heq] at hgen
  have hjump := (gluedMap_mem_linearForm_basicOpen_iff_jumpProj_ne_zero basis
    (basePointFreeLinearSystem_of_veryAmple hD) t x hx).mp hgen
  exact (jumpProj_ne_zero_iff_not_mem_divisorSections_devissage hx D t).mp hjump s.2

/-- The projective morphism constructed from a fixed basis of a numerically
very ample system is injective on all scheme points. -/
theorem gluedMap_injective_of_veryAmple
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : VeryAmpleLinearSystem D) :
    Function.Injective (gluedMap_of_smoothCurve (D := D) basis
      (basePointFreeLinearSystem_of_veryAmple hD)) := by
  intro x y hxy
  by_cases hx : x = genericPoint X.left
  · subst x
    by_cases hy : y = genericPoint X.left
    · exact hy.symm
    · exact (gluedMap_genericPoint_ne_of_veryAmple basis hD y hy hxy).elim
  · by_cases hy : y = genericPoint X.left
    · subst y
      exact (gluedMap_genericPoint_ne_of_veryAmple basis hD x hx hxy.symm).elim
    · exact congrArg Subtype.val
        (gluedMap_injective_on_nonGenericPoints_of_veryAmple basis hD
          (a₁ := ⟨x, hx⟩) (a₂ := ⟨y, hy⟩) hxy)

end BasePointFreeLocalRatioCover

end
end Hartshorne
