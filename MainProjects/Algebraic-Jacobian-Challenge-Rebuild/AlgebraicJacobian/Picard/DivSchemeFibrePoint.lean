/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.DivSchemeFamilySide
import AlgebraicJacobian.Cohomology.RelativeSectionsLinear
import AlgebraicJacobian.Curve.BaseFieldTransition

/-!
# A residue-field point over a relative-curve point

For a point `z` of `C_R`, this file records the canonical point of the residue-field
base-change `C_{κ(p)}` lying over `z`, where `p` is the image of `z` in `Spec R`.
The construction is point-free at the scheme level: the residue-field map of the structure
morphism supplies the second leg, and the relative-curve pullback square supplies the lift.
This is the small geometric bridge needed when a fibre-order statement is proved first over
`κ(p)` and then consumed at a total-space point.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Limits TopologicalSpace MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k]
variable (C : Over (Spec (.of k)))
variable (R : Type u) [CommRing R] [Algebra k R]

/-- The base point of `z : C_R`, viewed as a point of `Spec R`. -/
noncomputable def relCurveBasePoint (z : relCurve C R) : PrimeSpectrum R :=
  (snd C (overSpec k R)).left z

/-- The lift of `z` to the residue-field base-change of the relative curve. -/
noncomputable def relCurveResiduePoint
    (z : relCurve C R) :
    relCurve C (relCurveBasePoint C R z).asIdeal.ResidueField := by
  let f : relCurve C R ⟶ Spec (CommRingCat.of R) :=
    (snd C (overSpec k R)).left
  let p : Spec (CommRingCat.of R) := relCurveBasePoint C R z
  let K := p.asIdeal.ResidueField
  let e := Scheme.Spec.residueFieldIso (CommRingCat.of R) p
  let q : Spec ((relCurve C R).residueField z) ⟶ Spec (CommRingCat.of K) :=
    Spec.map (e.inv ≫ f.residueFieldMap z)
  have hq :
      (relCurve C R).fromSpecResidueField z ≫ f =
        q ≫ Spec.map (CommRingCat.ofHom (algebraMap R K)) := by
    rw [← Scheme.Hom.SpecMap_residueFieldMap_fromSpecResidueField]
    rw [← Scheme.Spec.map_residueFieldIso_inv_eq_fromSpecResidueField]
    simp only [q, e, K, Category.assoc, ← Spec.map_comp]
    rfl
  let hpb := Over.isPullback_whiskerLeft_left C (overSpecMap (k := k) R K)
  let l : Spec ((relCurve C R).residueField z) ⟶ relCurve C K :=
    hpb.lift ((relCurve C R).fromSpecResidueField z) q hq
  exact l (default : Spec ((relCurve C R).residueField z))

/-- The residue-field point maps back to the original total-space point. -/
theorem relCurveMap_relCurveResiduePoint
    (z : relCurve C R) :
    (relCurveMap C R (relCurveBasePoint C R z).asIdeal.ResidueField)
        (relCurveResiduePoint C R z) = z := by
  let f : relCurve C R ⟶ Spec (CommRingCat.of R) :=
    (snd C (overSpec k R)).left
  let p : Spec (CommRingCat.of R) := relCurveBasePoint C R z
  let K := p.asIdeal.ResidueField
  let e := Scheme.Spec.residueFieldIso (CommRingCat.of R) p
  let q : Spec ((relCurve C R).residueField z) ⟶ Spec (CommRingCat.of K) :=
    Spec.map (e.inv ≫ f.residueFieldMap z)
  have hq :
      (relCurve C R).fromSpecResidueField z ≫ f =
        q ≫ Spec.map (CommRingCat.ofHom (algebraMap R K)) := by
    rw [← Scheme.Hom.SpecMap_residueFieldMap_fromSpecResidueField]
    rw [← Scheme.Spec.map_residueFieldIso_inv_eq_fromSpecResidueField]
    simp only [q, e, K, Category.assoc, ← Spec.map_comp]
    rfl
  let hpb := Over.isPullback_whiskerLeft_left C (overSpecMap (k := k) R K)
  let l : Spec ((relCurve C R).residueField z) ⟶ relCurve C K :=
    hpb.lift ((relCurve C R).fromSpecResidueField z) q hq
  have hl : l ≫ relCurveMap C R K = (relCurve C R).fromSpecResidueField z :=
    hpb.lift_fst _ _ _
  change (relCurveMap C R K) (l default) = z
  rw [← Scheme.Hom.comp_apply, hl]
  exact Scheme.fromSpecResidueField_apply _ _

/-- Relative-curve base change pulls a pinned chart back to the corresponding pinned chart.
This is the Bool-indexed form of `relCurveMap_preimage`. -/
theorem relCurveMap_preimage_relPinnedChart
    {π : C.left ⟶ P1 k} [IsFinite π]
    (b : Bool) (R' : Type u) [CommRing R'] [Algebra k R'] [Algebra R R']
    [IsScalarTower k R R'] :
    relCurveMap C R R' ⁻¹ᵁ relPinnedChart C R π b = relPinnedChart C R' π b := by
  cases b
  · exact relCurveMap_preimage C R R' (fiberChart₀ π)
  · exact relCurveMap_preimage C R R' (fiberChart₁ π)

/-- A point in a pinned chart lifts to the corresponding residue-field pinned chart. -/
theorem relCurveResiduePoint_mem_relPinnedChart
    {π : C.left ⟶ P1 k} [IsFinite π] (b : Bool)
    {z : relCurve C R} (hz : z ∈ relPinnedChart C R π b) :
    relCurveResiduePoint C R z ∈
      relPinnedChart C (relCurveBasePoint C R z).asIdeal.ResidueField π b := by
  rw [← relCurveMap_preimage_relPinnedChart C R b]
  change (relCurveMap C R (relCurveBasePoint C R z).asIdeal.ResidueField)
      (relCurveResiduePoint C R z) ∈ relPinnedChart C R π b
  rwa [relCurveMap_relCurveResiduePoint]

end AlgebraicGeometry
