/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4LocalRatioTangent
import HartshorneLib.Chapter4LocalRatioStalkRange

/-!
# Tangent separation for the glued projective morphism

The tangent-order witness is a linear form in the regularized coordinates, so
it lifts to the actual projective target stalk. Its image is a uniformizer in
the curve stalk. Consequently the target maximal ideal generates the curve's
maximal ideal at every closed point.
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

namespace BasePointFreeLocalRatioCover

/-- The stalk map of the actual glued projective morphism has a uniformizer
in its image at every non-generic point. -/
theorem gluedMap_exists_irreducible_stalkMap_image_of_veryAmple
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : VeryAmpleLinearSystem D) (x : X.left)
    (hx : x ≠ genericPoint X.left) :
    let f := gluedMap_of_smoothCurve (D := D) basis
      (basePointFreeLinearSystem_of_veryAmple hD)
    ∃ t, Irreducible ((f.stalkMap x).hom t) := by
  let hbase := basePointFreeLinearSystem_of_veryAmple hD
  let f := gluedMap_of_smoothCurve (D := D) basis hbase
  let q : NonGenericPoint X := ⟨x, hx⟩
  let a := selectedCoordinates (D := D) basis hbase q
  let r := selectedRegularization (D := D) basis hbase q
  let p : a.chart.U := ⟨x, (selectedOpen_spec basis hbase q).1⟩
  obtain ⟨c, hc⟩ := exists_regularizedLinearForm_irreducible_germ_of_veryAmple
    basis hD q
  let s := (X.left.presheaf.germ a.chart.U x p.2).hom (r.regularizedLinearForm c)
  have hrange : ∃ t, ((a.chart.U.ι ≫ f).stalkMap p).hom t =
      (a.chart.U.ι.stalkMap p).hom s := by
    rw [show a.chart.U.ι ≫ f = r.chartMap from
      chartOpenCover_ι_projectiveMapProducer_of_smoothCurve basis hbase q]
    exact r.germ_regularizedLinearForm_mem_range_stalkMap p c
  obtain ⟨t, ht⟩ := hrange
  have hts : (f.stalkMap x).hom t = s := by
    apply (ConcreteCategory.bijective_of_isIso (a.chart.U.ι.stalkMap p)).1
    rw [Scheme.Hom.stalkMap_comp] at ht
    exact ht
  refine ⟨t, ?_⟩
  rw [hts]
  exact hc

/-- Tangent separation makes the projective maximal ideal generate the
maximal ideal of the curve stalk at every closed point. -/
theorem gluedMap_stalkMap_map_maximalIdeal_of_veryAmple
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : VeryAmpleLinearSystem D) (x : X.left)
    (hx : x ≠ genericPoint X.left) :
    let f := gluedMap_of_smoothCurve (D := D) basis
      (basePointFreeLinearSystem_of_veryAmple hD)
    Ideal.map (f.stalkMap x).hom
        (IsLocalRing.maximalIdeal ((projectiveSpace k n).presheaf.stalk (f x))) =
      IsLocalRing.maximalIdeal (X.left.presheaf.stalk x) := by
  let f := gluedMap_of_smoothCurve (D := D) basis
    (basePointFreeLinearSystem_of_veryAmple hD)
  letI := smoothCurve_stalk_isDiscreteValuationRing X.hom hx
  obtain ⟨t, ht⟩ := gluedMap_exists_irreducible_stalkMap_image_of_veryAmple basis hD x hx
  apply le_antisymm
  · exact ((IsLocalRing.local_hom_TFAE (f.stalkMap x).hom).out 0 2 rfl rfl).mp
      inferInstance
  · rw [ht.maximalIdeal_eq, Ideal.span_singleton_le_iff_mem]
    exact Ideal.mem_map_of_mem (f.stalkMap x).hom
      (fun hu => ht.not_isUnit (hu.map (f.stalkMap x).hom))

end BasePointFreeLocalRatioCover

end
end Hartshorne
