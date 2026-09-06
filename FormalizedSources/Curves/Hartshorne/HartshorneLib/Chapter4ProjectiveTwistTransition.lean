/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4ProjectiveCoordinateAdapter
import HartshorneLib.Chapter2AffineCech

/-!
# Coordinate transitions for the projective twisting sheaf

The standard frame on `D_+(X_i)` is `X_i`. Its change to the frame `X_j`
is multiplication by `X_i / X_j`. The fractions and their cocycle below
live in the structure sheaf of the existing coefficient-field `Proj` model.
For a gluing convention `s_i = g_ij * s_j`, the appropriate multiplier is
the inverse of `transition i j`, namely `X_j / X_i` on the same intersection.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Opposite MvPolynomial HomogeneousLocalization
open AlgebraicGeometry

namespace Hartshorne.ProjectiveTwist

noncomputable section

variable {k : Type (max u v)} [Field k] {J : Type v}

attribute [local instance] MvPolynomial.gradedAlgebra

/-- The standard projective chart on which `X_i` is nonzero. -/
abbrev chart (i : J) : (Proj (homogeneousSubmodule J k)).Opens :=
  Proj.basicOpen (homogeneousSubmodule J k) (X i)

/-- The standard coordinate charts cover the projective spectrum. -/
theorem iSup_chart : ⨆ i : J, chart (k := k) i = ⊤ := by
  refine Proj.iSup_basicOpen_eq_top' _ _
    (fun i => ⟨1, ProjectiveCoordinates.X_mem_deg_one i⟩) ?_
  rw [eq_top_iff]
  rintro a -
  have ha : a ∈ Algebra.adjoin k (Set.range (X : J → MvPolynomial J k)) := by
    rw [MvPolynomial.adjoin_range_X]
    trivial
  induction ha using Algebra.adjoin_induction with
  | mem x hx => exact Algebra.subset_adjoin hx
  | algebraMap r =>
      have hr : algebraMap k (MvPolynomial J k) r ∈ homogeneousSubmodule J k 0 := by
        rw [MvPolynomial.algebraMap_eq]
        exact isHomogeneous_C _ _
      exact Subalgebra.algebraMap_mem
        (Algebra.adjoin (homogeneousSubmodule J k 0)
          (Set.range (X : J → MvPolynomial J k)))
        (⟨_, hr⟩ : homogeneousSubmodule J k 0)
  | add x y _ _ hx hy => exact add_mem hx hy
  | mul x y _ _ hx hy => exact mul_mem hx hy

/-- The regular coordinate `X_j / X_i` on the `i`-th projective chart. -/
def coordinate (i j : J) : Γ(Proj (homogeneousSubmodule J k), chart i) :=
  Proj.awayToSection (homogeneousSubmodule J k) (X i)
    (ProjectiveCoordinates.chartCoord i j)

@[simp] theorem coordinate_self (i : J) : coordinate (k := k) i i = 1 := by
  have h : ProjectiveCoordinates.chartCoord (k := k) i i = 1 := by
    apply HomogeneousLocalization.val_injective
    simp only [ProjectiveCoordinates.chartCoord, Away.val_mk,
      HomogeneousLocalization.val_one, pow_one]
    exact Localization.mk_self
      (⟨X i, 1, pow_one _⟩ : Submonoid.powers (X i : MvPolynomial J k))
  simp [coordinate, h]

/-- Pointwise description of a standard projective coordinate. -/
theorem coordinate_val (i j : J) (x : chart (k := k) i) :
    ((coordinate (k := k) i j).val x).val =
      Localization.mk (X j : MvPolynomial J k)
        (⟨X i, x.property⟩ : x.val.asHomogeneousIdeal.toIdeal.primeCompl) := by
  unfold coordinate Proj.awayToSection
  erw [ProjectiveSpectrum.Proj.awayToSection_apply]
  rw [ProjectiveCoordinates.chartCoord, Away.val_mk,
    Localization.mk_eq_mk', IsLocalization.map_mk', ← Localization.mk_eq_mk']
  simp only [pow_one, RingHom.id_apply]

/-- Cancellation of the middle homogeneous coordinate on every common open. -/
theorem coordinate_mul {W : (Proj (homogeneousSubmodule J k)).Opens}
    (i j l : J) (hi : W ≤ chart i) (hj : W ≤ chart j) :
    (Proj (homogeneousSubmodule J k)).resHom hi (coordinate i j) *
        (Proj (homogeneousSubmodule J k)).resHom hj (coordinate j l) =
      (Proj (homogeneousSubmodule J k)).resHom hi (coordinate i l) := by
  apply Subtype.ext
  funext x
  apply HomogeneousLocalization.val_injective
  erw [Proj.mul_apply, HomogeneousLocalization.val_mul]
  change ((coordinate (k := k) i j).val ⟨x.val, hi x.property⟩).val *
      ((coordinate (k := k) j l).val ⟨x.val, hj x.property⟩).val =
    ((coordinate (k := k) i l).val ⟨x.val, hi x.property⟩).val
  rw [coordinate_val, coordinate_val, coordinate_val, Localization.mk_mul,
    Localization.mk_eq_mk_iff, Localization.r_iff_exists]
  refine ⟨1, ?_⟩
  simp only [OneMemClass.coe_one, one_mul, Submonoid.coe_mul]
  ring

/-- The transition from the `i`-frame to the `j`-frame, namely `X_i / X_j`. -/
def transition (i j : J) :
    Γ(Proj (homogeneousSubmodule J k), chart i ⊓ chart j)ˣ where
  val := (Proj (homogeneousSubmodule J k)).resHom inf_le_right (coordinate j i)
  inv := (Proj (homogeneousSubmodule J k)).resHom inf_le_left (coordinate i j)
  val_inv := by
    rw [coordinate_mul j i j inf_le_right inf_le_left, coordinate_self, map_one]
  inv_val := by
    rw [coordinate_mul i j i inf_le_left inf_le_right, coordinate_self, map_one]

@[simp] theorem transition_val (i j : J) :
    (transition (k := k) i j).val =
      (Proj (homogeneousSubmodule J k)).resHom inf_le_right (coordinate j i) := rfl

@[simp] theorem transition_self (i : J) : transition (k := k) i i = 1 := by
  apply Units.ext
  simp [transition]

/-- The transition identity on an arbitrary open in three projective charts. -/
theorem transition_cocycle {W : (Proj (homogeneousSubmodule J k)).Opens}
    (i j l : J) (hi : W ≤ chart i) (hj : W ≤ chart j) (hl : W ≤ chart l) :
    (Proj (homogeneousSubmodule J k)).resHom (le_inf hi hj) (transition i j).val *
        (Proj (homogeneousSubmodule J k)).resHom (le_inf hj hl) (transition j l).val =
      (Proj (homogeneousSubmodule J k)).resHom (le_inf hi hl) (transition i l).val := by
  simp only [transition_val, Scheme.resHom_resHom]
  rw [mul_comm]
  exact coordinate_mul l j i hl hj

/-- Local representatives `X_l / X_i` of a homogeneous coordinate match under
the transition from frame `X_i` to frame `X_j`. -/
theorem coordinate_transition {W : (Proj (homogeneousSubmodule J k)).Opens}
    (i j l : J) (hi : W ≤ chart i) (hj : W ≤ chart j) :
    (Proj (homogeneousSubmodule J k)).resHom hi (coordinate i l) *
        (Proj (homogeneousSubmodule J k)).resHom (le_inf hi hj) (transition i j).val =
      (Proj (homogeneousSubmodule J k)).resHom hj (coordinate j l) := by
  simp only [transition_val, Scheme.resHom_resHom]
  rw [mul_comm]
  exact coordinate_mul j i l hj hi

end

end Hartshorne.ProjectiveTwist
