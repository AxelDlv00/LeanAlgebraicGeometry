/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4LocalRatioTangent
import HartshorneLib.Chapter4BasePointFreeCriterion

/-!
# A uniformizer linear form separates tangent directions

On a selected exact-order chart, a regularized linear form with irreducible
germ yields a global divisor section whose order realizes the bound for
`D - x`. Its nonzero local jump proves the second one-dimensional section drop.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X}

attribute [local instance] functionFieldOverModule

omit [IsAlgClosed k] [IsProper X.hom] in
/-- An irreducible germ on a smooth curve has a simple zero. -/
theorem orderAt_eq_exp_neg_one_of_irreducible_germ
    (W : LocalRatioOpen X) (f : Γ(X.left, W.U))
    {x : X.left} (hx : x ≠ genericPoint X.left) (hxW : x ∈ W.U)
    (hf : Irreducible ((X.left.presheaf.germ W.U x hxW).hom f)) :
    orderAt X.hom hx (localStructureValue W f) = WithZero.exp (-1 : ℤ) := by
  letI := smoothCurve_stalk_isDiscreteValuationRing X.hom hx
  letI := smoothCurve_stalk_isDedekindDomain X.hom hx
  rw [localStructureValue, germ_generic_eq_algebraMap_germ W.generic_mem hxW f,
    orderAt_eq_valuation, IsDedekindDomain.HeightOneSpectrum.valuation_of_algebraMap]
  exact (stalkHeightOne X.left x).intValuation_singleton hf.ne_zero hf.maximalIdeal_eq

namespace BasePointFreeLocalRatioCover

variable {n : ℕ}

/-- A linear form with uniformizer germ supplies a global section realizing the
first devissage bound at the selected point. -/
theorem exists_tangent_order_witness_of_irreducible_regularizedLinearForm
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hbase : BasePointFreeLinearSystem D) (x : NonGenericPoint X)
    (c : Fin (n + 1) → k)
    (hc : Irreducible ((X.left.presheaf.germ
      (selectedCoordinates (D := D) basis hbase x).chart.U x.1
      (selectedOpen_spec basis hbase x).1).hom
        ((selectedRegularization (D := D) basis hbase x).regularizedLinearForm c))) :
    ∃ s : divisorSections (CurveDivisor.devissageDivisor x.2 D) ⊤,
      orderAt X.hom x.2 (s : X.left.functionField) =
        divisorBound (CurveDivisor.devissageDivisor x.2 D) x.2 := by
  let a := selectedCoordinates (D := D) basis hbase x
  let r := selectedRegularization (D := D) basis hbase x
  let s : divisorSections D ⊤ := ∑ j, c j • basisSections (D := D) basis j
  have hsval : (s : X.left.functionField) =
      ∑ j, functionFieldOverAlgebraMap k X.left (c j) *
        (a.sections j : X.left.functionField) := by
    simp only [s, Submodule.coe_sum, Submodule.coe_smul,
      functionFieldOverModule_smul_def, a, selectedCoordinates_section_value]
  have hvalue := r.regularizedLinearForm_value c
  rw [← hsval] at hvalue
  have htorder : orderAt X.hom x.2
      (a.sections a.denominator_index : X.left.functionField) = divisorBound D x.2 := by
    rw [show (a.sections a.denominator_index : X.left.functionField) =
      (basisSections (D := D) basis (selectedIndex basis hbase x) : X.left.functionField)
      from selectedCoordinates_section_value basis hbase x _]
    exact selectedSection_orderAt basis hbase x
  have hratio := orderAt_eq_exp_neg_one_of_irreducible_germ a.chart
    (r.regularizedLinearForm c) x.2 (selectedOpen_spec basis hbase x).1 hc
  rw [hvalue, Valuation.map_div, htorder] at hratio
  have hbound : divisorBound D x.2 ≠ 0 := by
    rw [divisorBound_eq_coeffAt]
    exact WithZero.coe_ne_zero
  have hsorder : orderAt X.hom x.2 (s : X.left.functionField) =
      divisorBound (CurveDivisor.devissageDivisor x.2 D) x.2 := by
    calc
      _ = WithZero.exp (-1 : ℤ) * divisorBound D x.2 := (div_eq_iff hbound).mp hratio
      _ = _ := by
        rw [divisorBound_eq_coeffAt, divisorBound_eq_coeffAt, devissageDivisor_coeffAt]
        change WithZero.exp (-1 : ℤ) * WithZero.exp (CurveDivisor.coeffAt x.2 D) =
          WithZero.exp (CurveDivisor.coeffAt x.2 D - 1)
        rw [← WithZero.exp_add]
        congr 1
        omega
  refine ⟨⟨s, coe_mem_divisorSections_devissage x.2 D (by trivial) s ?_⟩, hsorder⟩
  rw [mem_pointLattice, hsorder, divisorBound_eq_coeffAt, devissageDivisor_coeffAt]

/-- A linear form with uniformizer germ proves the tangent-separation section drop. -/
theorem h0_sub_h0_twoDevissage_eq_one_of_irreducible_regularizedLinearForm
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hbase : BasePointFreeLinearSystem D) (x : NonGenericPoint X)
    (c : Fin (n + 1) → k)
    (hc : Irreducible ((X.left.presheaf.germ
      (selectedCoordinates (D := D) basis hbase x).chart.U x.1
      (selectedOpen_spec basis hbase x).1).hom
        ((selectedRegularization (D := D) basis hbase x).regularizedLinearForm c))) :
    (CategoryTheory.Sheaf.h0
        (divisorSheaf (CurveDivisor.devissageDivisor x.2 D)) : ℤ) -
      CategoryTheory.Sheaf.h0 (divisorSheaf (CurveDivisor.devissageDivisor x.2
        (CurveDivisor.devissageDivisor x.2 D))) = 1 := by
  apply (h0_sub_h0_devissage_eq_one_iff_exists_jumpProj_ne_zero x.2
    (CurveDivisor.devissageDivisor x.2 D)).mpr
  obtain ⟨s, hs⟩ := exists_tangent_order_witness_of_irreducible_regularizedLinearForm
    basis hbase x c hc
  exact ⟨s, (jumpProj_ne_zero_iff_orderAt_eq_divisorBound x.2 (by trivial) s).mpr hs⟩

end BasePointFreeLocalRatioCover

end
end Hartshorne
