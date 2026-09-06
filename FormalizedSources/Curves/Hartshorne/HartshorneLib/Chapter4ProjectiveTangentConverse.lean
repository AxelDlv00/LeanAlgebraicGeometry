/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4LocalRatioStalkRange
import HartshorneLib.Chapter4TangentAlgebra
import HartshorneLib.Chapter4LocalRatioTangent
import HartshorneLib.Chapter4TangentSectionConverse

/-!
# Tangent separation from a surjective projective stalk map

Surjectivity of the actual projective stalk map expresses curve germs as
fractions in the regularized basis coordinates. Local polynomial algebra
then supplies a linear form whose germ is a uniformizer.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X} {n : ℕ}

namespace LocalRatioRegularization

/-- A surjective projective stalk map at a closed curve point supplies a
regularized linear form with a simple zero there. -/
theorem exists_irreducible_regularizedLinearForm_of_stalkMap_surjective
    {a : LocalRatioCoordinateData D n} (r : LocalRatioRegularization a)
    (p : a.chart.U) (hx : p.1 ≠ genericPoint X.left)
    (hsurj : Function.Surjective (r.chartMap.stalkMap p).hom) :
    ∃ c : Fin (n + 1) → k,
      Irreducible ((X.left.presheaf.germ a.chart.U p.1 p.2).hom
        (r.regularizedLinearForm c)) := by
  classical
  let R := X.left.presheaf.stalk p.1
  let g := (X.left.presheaf.germ a.chart.U p.1 p.2).hom
  let φ := g.comp (X.left.overAlgebraMap k a.chart.U)
  letI : Algebra k R := φ.toAlgebra
  letI := smoothCurve_stalk_isDiscreteValuationRing X.hom hx
  have hmid : (X.left.presheaf.germ ⊤ p.1 trivial).hom.comp
      (X.left.overAlgebraMap k ⊤) = φ := by
    rw [show X.left.presheaf.germ ⊤ p.1 trivial =
        X.left.presheaf.map (homOfLE (le_top : a.chart.U ≤ ⊤)).op ≫
          X.left.presheaf.germ a.chart.U p.1 p.2 from
        (X.left.presheaf.germ_res (homOfLE le_top) p.1 p.2).symm,
      CommRingCat.hom_comp, RingHom.comp_assoc,
      X.left.overAlgebraMap_naturality k (homOfLE le_top).op]
  have hres : Function.Surjective ((IsLocalRing.residue R).comp (algebraMap k R)) := by
    letI : SmoothOfRelativeDimension 1 (X.left ↘ Spec (CommRingCat.of k)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 X.hom)
    letI : Smooth (X.left ↘ Spec (CommRingCat.of k)) :=
      SmoothOfRelativeDimension.smooth 1 _
    letI : Module k (X.left.residueField p.1) := X.left.residueFieldOverModule k p.1
    letI := Scheme.residueDeg_finite (K := k) hx
    letI : Algebra k (X.left.residueField p.1) :=
      (X.left.residueOverAlgebraMap k p.1).toAlgebra
    letI : Algebra.IsIntegral k (X.left.residueField p.1) :=
      Algebra.IsIntegral.of_finite k _
    have hh : Function.Surjective (X.left.residueOverAlgebraMap k p.1) :=
      IsAlgClosed.algebraMap_bijective_of_isIntegral.surjective
    rw [Scheme.residueOverAlgebraMap, hmid] at hh
    exact hh
  obtain ⟨j, b, hb⟩ := exists_irreducible_sub_algebraMap_of_polynomial_fractions
    (fun j => g (r.regularized j)) hres (fun z =>
      r.exists_polynomial_stalk_fraction_of_surjective p hsurj z)
  let c : Fin (n + 1) → k := fun l =>
    (if l = j then 1 else 0) - (if l = a.denominator_index then b else 0)
  have hsingle (i : Fin (n + 1)) (d : k) :
      (∑ l, X.left.overAlgebraMap k a.chart.U (if l = i then d else 0) *
        r.regularized l) = X.left.overAlgebraMap k a.chart.U d * r.regularized i := by
    rw [Finset.sum_eq_single i]
    · simp
    · intro l _ hli
      simp [hli]
    · simp
  have hc : r.regularizedLinearForm c =
      r.regularized j - X.left.overAlgebraMap k a.chart.U b := by
    simp only [regularizedLinearForm, c, map_sub, sub_mul, Finset.sum_sub_distrib]
    rw [hsingle, hsingle, map_one, one_mul, r.regularized_denominator_eq_one, mul_one]
  refine ⟨c, ?_⟩
  rw [hc, map_sub]
  exact hb

end LocalRatioRegularization

namespace BasePointFreeLocalRatioCover

/-- Surjectivity of the actual glued map on a closed-point stalk gives the
second dimension drop at that repeated point. -/
theorem h0_sub_h0_twoDevissage_eq_one_of_gluedMap_stalkMap_surjective
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hbase : BasePointFreeLinearSystem D) (x : NonGenericPoint X)
    (hsurj : Function.Surjective
      ((gluedMap_of_smoothCurve (D := D) basis hbase).stalkMap x.1).hom) :
    (CategoryTheory.Sheaf.h0 (divisorSheaf (CurveDivisor.devissageDivisor x.2 D)) : ℤ) -
      (CategoryTheory.Sheaf.h0 (divisorSheaf
        (CurveDivisor.devissageDivisor x.2 (CurveDivisor.devissageDivisor x.2 D))) : ℤ) = 1 := by
  let a := selectedCoordinates (D := D) basis hbase x
  let r := selectedRegularization (D := D) basis hbase x
  let p : a.chart.U := ⟨x.1, (selectedOpen_spec basis hbase x).1⟩
  have hr : Function.Surjective (r.chartMap.stalkMap p).hom := by
    rw [← show a.chart.U.ι ≫ gluedMap_of_smoothCurve basis hbase = r.chartMap from
      chartOpenCover_ι_projectiveMapProducer_of_smoothCurve basis hbase x,
      Scheme.Hom.stalkMap_comp]
    exact (ConcreteCategory.bijective_of_isIso (a.chart.U.ι.stalkMap p)).2.comp hsurj
  obtain ⟨c, hc⟩ := r.exists_irreducible_regularizedLinearForm_of_stalkMap_surjective
    p x.2 hr
  exact h0_sub_h0_twoDevissage_eq_one_of_irreducible_regularizedLinearForm
    basis hbase x c hc

end BasePointFreeLocalRatioCover

end
end Hartshorne
