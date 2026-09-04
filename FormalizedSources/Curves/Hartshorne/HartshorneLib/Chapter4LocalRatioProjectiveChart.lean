/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4LocalRatioRegularization
import HartshorneLib.Chapter4ProjectiveMapProducer
import HartshorneLib.Chapter4ProjectiveCoordinateAdapter

/-!
# Hartshorne IV.3.1: projective maps on denominator charts

An honest regularization of divisor-section ratios on a nonempty open gives
structure-sheaf sections on the corresponding open subscheme.  The selected
denominator is normalized to `1`, so the irrelevant ideal condition required by
`Proj.fromOfGlobalSections` follows internally.  This module constructs the
resulting projective morphism over `Spec k` and records the preimage of each
projective basic open.  Those preimages can be consumed alongside the
corresponding chart restriction; compatibility between different denominator
charts remains the separate restriction and gluing step.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry
open MvPolynomial

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X}
variable {n : ℕ}

attribute [local instance] MvPolynomial.gradedAlgebra

namespace LocalRatioRegularization

variable {a : LocalRatioCoordinateData D n}

/-! ### The chart as an object over the coefficient field -/

/-- The open subscheme underlying a local-ratio chart, over `Spec k`. -/
noncomputable def chartOver (a : LocalRatioCoordinateData D n) :
    Over (Spec (CommRingCat.of k)) :=
  Over.mk (a.chart.U.ι ≫ X.hom)

/-! ### Normalized sections and the irrelevant ideal -/

noncomputable local instance chartAlgebra : Algebra k Γ(a.chart.U, ⊤) :=
  (a.chart.U.toScheme.overAlgebraMap k (⊤ : a.chart.U.toScheme.Opens)).toAlgebra

/-- Transport a regularized section on `a.chart.U` to global sections of the
open subscheme. -/
noncomputable def chartSection (r : LocalRatioRegularization a)
    (i : Fin (n + 1)) : Γ(a.chart.U, ⊤) :=
  a.chart.U.topIso.inv.hom (r.regularized i)

@[simp] theorem chartSection_denominator_eq_one
    (r : LocalRatioRegularization a) :
    r.chartSection a.denominator_index = 1 := by
  simp [chartSection, r.regularized_denominator_eq_one]

/-- Evaluation of homogeneous coordinates at the normalized chart sections. -/
noncomputable def chartEval (r : LocalRatioRegularization a) :
    MvPolynomial (Fin (n + 1)) k →+* Γ(a.chart.U, ⊤) :=
  (MvPolynomial.aeval r.chartSection).toRingHom

@[simp] theorem chartEval_X (r : LocalRatioRegularization a)
    (i : Fin (n + 1)) :
    r.chartEval (MvPolynomial.X i) = r.chartSection i := by
  simp [chartEval]

/-- The normalized denominator makes the irrelevant ideal generate the whole
ring of sections, with no additional base-point-free assumption. -/
theorem chartEval_irrelevant_span (r : LocalRatioRegularization a) :
    (HomogeneousIdeal.irrelevant
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)).toIdeal.map
        r.chartEval = ⊤ := by
  change (HomogeneousIdeal.irrelevant
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)).toIdeal.map
      (ProjectiveCoordinates.eval (k := k) r.chartSection) = ⊤
  exact ProjectiveCoordinates.eval_irrelevant_span_of_normalized
    (k := k) (B := Γ(a.chart.U, ⊤)) a.denominator_index r.chartSection
    r.chartSection_denominator_eq_one

/-! ### The local projective morphism -/

/-- The `Proj.fromOfGlobalSections` input supplied by a regularized chart. -/
noncomputable def projectiveMapData (r : LocalRatioRegularization a) :
    GlobalSectionsProjectiveMapData (k := k) (X := chartOver a) n :=
  { sections := r.chartSection
    irrelevant_span := r.chartEval_irrelevant_span }

/-- The projective morphism defined by the regularized local coordinates. -/
noncomputable def chartMap (r : LocalRatioRegularization a) :
    a.chart.U.toScheme ⟶ projectiveSpace k n :=
  r.projectiveMapData.map

/-! ### Independence from the chosen regularization -/

/-- The projective chart map only depends on the regularized section family, not
    on the proof that its generic values are the prescribed ratios. -/
theorem chartMap_eq_of_regularized_eq
    (r s : LocalRatioRegularization a)
    (h : ∀ i, r.regularized i = s.regularized i) :
    r.chartMap = s.chartMap := by
  have hfun : r.regularized = s.regularized := funext h
  cases r with
  | mk rsections hrules =>
    cases s with
    | mk ssections hrules =>
      dsimp at hfun
      cases hfun
      rfl

/-- The chart map obtained from the zero-divisor bound is independent of the
    auxiliary representatives selected by `of_zeroBound`. -/
theorem of_zeroBound_chartMap_eq
    (hbound : ∀ i, a.coordinate i ∈
      divisorSections (X := X) (0 : CurveDivisor k X) a.chart.U)
    (r : LocalRatioRegularization a) :
    (of_zeroBound (a := a) hbound).chartMap = r.chartMap := by
  rw [of_zeroBound_eq hbound r]

@[reassoc (attr := simp)] theorem chartMap_over
    (r : LocalRatioRegularization a) :
    r.chartMap ≫ projectiveSpaceStructureMap k n = a.chart.U.ι ≫ X.hom := by
  exact r.projectiveMapData.map_over

/-- The preimage of each projective basic open is the corresponding basic open
of the normalized section on the source chart. -/
@[simp] theorem chartMap_preimage_basicOpen (r : LocalRatioRegularization a)
    (j : Fin (n + 1)) :
    r.chartMap ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j) =
      a.chart.U.toScheme.basicOpen (r.chartSection j) := by
  let f : MvPolynomial (Fin (n + 1)) k →+* Γ(a.chart.U, ⊤) :=
    (MvPolynomial.aeval r.chartSection).toRingHom
  have hf :
      (HomogeneousIdeal.irrelevant
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)).toIdeal.map f = ⊤ := by
    exact chartEval_irrelevant_span (a := a) r
  change (Proj.fromOfGlobalSections
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      f hf) ⁻¹ᵁ
      Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X j) = _
  have hpre :
      Proj.fromOfGlobalSections
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) f hf ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j) =
      a.chart.U.toScheme.basicOpen (f (MvPolynomial.X j)) :=
    Proj.fromOfGlobalSections_preimage_basicOpen
      (𝒜 := MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      (f := f) (hf := hf) (r := MvPolynomial.X j) (n := 1)
      Nat.zero_lt_one
      ((MvPolynomial.mem_homogeneousSubmodule _ _).mpr
        (MvPolynomial.isHomogeneous_X k j))
  simpa [f] using hpre

/-! ### Ambient basic opens -/

/-- The chart preimage agrees with the ambient basic open cut out by the
    corresponding regularized section. -/
@[simp] theorem chartMap_preimage_basicOpen_ambient
    (r : LocalRatioRegularization a) (j : Fin (n + 1)) :
    r.chartMap ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j) =
      a.chart.U.ι ⁻¹ᵁ X.left.basicOpen (r.regularized j) := by
  rw [r.chartMap_preimage_basicOpen]
  change a.chart.U.toScheme.basicOpen
      (a.chart.U.topIso.inv.hom (r.regularized j)) =
    a.chart.U.ι ⁻¹ᵁ X.left.basicOpen (r.regularized j)
  rw [← Scheme.Opens.ι_image_basicOpen_topIso_inv
    (X := X.left) (U := a.chart.U) (r.regularized j)]
  exact (a.chart.U.ι.preimage_image_eq _).symm

/-! ### Overlap basic opens -/

/-- On an overlap, corresponding restricted regularized coordinates cut out
    the same basic open. -/
theorem restricted_basicOpen_eq
    {b : LocalRatioCoordinateData D n}
    (r : LocalRatioRegularization a) (s : LocalRatioRegularization b)
    (h : a.SameSectionValues b) (i : Fin (n + 1)) :
    X.left.basicOpen
        ((X.left.presheaf.map
          (homOfLE (show a.chart.U ⊓ b.chart.U ≤ a.chart.U from
            inf_le_left)).op).hom (r.regularized i)) =
      X.left.basicOpen
        ((X.left.presheaf.map
          (homOfLE (show a.chart.U ⊓ b.chart.U ≤ b.chart.U from
            inf_le_right)).op).hom (s.regularized i)) := by
  rw [r.restricted_regularized_eq_transition_mul s h i,
    Scheme.basicOpen_mul,
    X.left.basicOpen_of_isUnit (r.restricted_transition_isUnit s h)]
  exact inf_eq_right.mpr (X.left.basicOpen_le _)

/-- The two chart maps restricted to an overlap have the same inverse image of
    every standard projective basic open. -/
theorem overlap_chartMap_preimage_basicOpen_eq
    {b : LocalRatioCoordinateData D n}
    (r : LocalRatioRegularization a) (s : LocalRatioRegularization b)
    (h : a.SameSectionValues b) (i : Fin (n + 1)) :
    (X.left.homOfLE
          (show a.chart.U ⊓ b.chart.U ≤ a.chart.U from inf_le_left) ≫
        r.chartMap) ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X i) =
      (X.left.homOfLE
          (show a.chart.U ⊓ b.chart.U ≤ b.chart.U from inf_le_right) ≫
        s.chartMap) ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X i) := by
  rw [Scheme.Hom.comp_preimage, Scheme.Hom.comp_preimage,
    r.chartMap_preimage_basicOpen_ambient,
    s.chartMap_preimage_basicOpen_ambient,
    ← Scheme.Hom.comp_preimage, ← Scheme.Hom.comp_preimage,
    X.left.homOfLE_ι, X.left.homOfLE_ι]
  apply (a.chart.U ⊓ b.chart.U).ι.image_injective
  change (a.chart.U ⊓ b.chart.U).ι ''ᵁ
        ((a.chart.U ⊓ b.chart.U).ι ⁻¹ᵁ
          X.left.basicOpen (r.regularized i)) =
      (a.chart.U ⊓ b.chart.U).ι ''ᵁ
        ((a.chart.U ⊓ b.chart.U).ι ⁻¹ᵁ
          X.left.basicOpen (s.regularized i))
  calc
    _ = (a.chart.U ⊓ b.chart.U) ⊓
        X.left.basicOpen (r.regularized i) := by
      rw [Scheme.Hom.image_preimage_eq_opensRange_inf,
        Scheme.Opens.opensRange_ι]
    _ = (a.chart.U ⊓ b.chart.U) ⊓
        X.left.basicOpen (s.regularized i) := by
      simpa only [Scheme.basicOpen_res] using r.restricted_basicOpen_eq s h i
    _ = _ := by
      rw [Scheme.Hom.image_preimage_eq_opensRange_inf,
        Scheme.Opens.opensRange_ι]

/-! ### Overlap compatibility for the normalized open-source maps -/

/-- The two normalized coordinate families define the same projective morphism
after restriction to a chart overlap.  The transition factor is the restricted
denominator section, whose invertibility is supplied by the local-ratio data. -/
theorem overlap_fromOpen_eq
    {b : LocalRatioCoordinateData D n}
    (r : LocalRatioRegularization a) (s : LocalRatioRegularization b)
    (h : a.SameSectionValues b) :
    X.left.homOfLE
          (show a.chart.U ⊓ b.chart.U ≤ a.chart.U from inf_le_left) ≫
        ProjectiveCoordinates.fromOpen (k := k) (J := Fin (n + 1)) (Z := X.left)
          a.chart.U
          (X.left.overAlgebraMap k a.chart.U) a.denominator_index r.regularized
          r.regularized_denominator_eq_one =
      X.left.homOfLE
          (show a.chart.U ⊓ b.chart.U ≤ b.chart.U from inf_le_right) ≫
        ProjectiveCoordinates.fromOpen (k := k) (J := Fin (n + 1)) (Z := X.left)
          b.chart.U
          (X.left.overAlgebraMap k b.chart.U) b.denominator_index s.regularized
          (by exact s.regularized_denominator_eq_one) := by
  let W : X.left.Opens := a.chart.U ⊓ b.chart.U
  let αW : k →+* Γ(X.left, W) := X.left.overAlgebraMap k W
  have hleft := ProjectiveCoordinates.homOfLE_fromOpen (k := k)
    (J := Fin (n + 1)) (Z := X.left) (U := a.chart.U) (V := W)
    (X.left.overAlgebraMap k a.chart.U) αW inf_le_left
    (X.left.overAlgebraMap_naturality k
      (homOfLE (show W ≤ a.chart.U from inf_le_left)).op)
    a.denominator_index r.regularized r.regularized_denominator_eq_one
  have hright := ProjectiveCoordinates.homOfLE_fromOpen (k := k)
    (J := Fin (n + 1)) (Z := X.left) (U := b.chart.U) (V := W)
    (X.left.overAlgebraMap k b.chart.U) αW inf_le_right
    (X.left.overAlgebraMap_naturality k
      (homOfLE (show W ≤ b.chart.U from inf_le_right)).op)
    b.denominator_index s.regularized s.regularized_denominator_eq_one
  calc
    X.left.homOfLE
          (show a.chart.U ⊓ b.chart.U ≤ a.chart.U from inf_le_left) ≫
        ProjectiveCoordinates.fromOpen (k := k) (J := Fin (n + 1)) (Z := X.left)
          a.chart.U
          (X.left.overAlgebraMap k a.chart.U) a.denominator_index r.regularized
          r.regularized_denominator_eq_one =
      ProjectiveCoordinates.fromOpen (k := k) (J := Fin (n + 1)) (Z := X.left)
        W αW a.denominator_index
        (fun j => (X.left.presheaf.map
          (homOfLE (show W ≤ a.chart.U from inf_le_left)).op).hom
            (r.regularized j))
        (by rw [r.regularized_denominator_eq_one, map_one]) := hleft
    _ = ProjectiveCoordinates.fromOpen (k := k) (J := Fin (n + 1)) (Z := X.left)
        W αW b.denominator_index
        (fun j => (X.left.presheaf.map
          (homOfLE (show W ≤ b.chart.U from inf_le_right)).op).hom
            (s.regularized j))
        (by rw [s.regularized_denominator_eq_one, map_one]) := by
      apply ProjectiveCoordinates.fromOpen_eq_of_unit_smul
        (k := k) (J := Fin (n + 1)) W αW a.denominator_index b.denominator_index
        _ _ _ _
      · exact r.restricted_transition_isUnit s h
      · intro j
        exact r.restricted_regularized_eq_transition_mul s h j
    _ = X.left.homOfLE
          (show a.chart.U ⊓ b.chart.U ≤ b.chart.U from inf_le_right) ≫
        ProjectiveCoordinates.fromOpen (k := k) (J := Fin (n + 1)) (Z := X.left)
          b.chart.U
          (X.left.overAlgebraMap k b.chart.U) b.denominator_index s.regularized
          s.regularized_denominator_eq_one := hright.symm

end LocalRatioRegularization

end
end Hartshorne
