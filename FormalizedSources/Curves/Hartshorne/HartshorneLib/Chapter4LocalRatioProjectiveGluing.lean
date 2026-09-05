/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4LocalRatioCanonicalBridge

/-!
# Hartshorne IV.3.1: gluing normalized local-ratio charts

An indexed family of regularized local-ratio charts whose opens cover the
curve and whose divisor-section values agree defines a global morphism to
projective space.  The local maps are first glued in their explicit normalized
`ProjectiveCoordinates.fromOpen` form, so their pullback compatibility follows
from `LocalRatioRegularization.overlap_fromOpen_eq`.  The canonical comparison
then identifies every restriction of the glued map with the corresponding
`Proj.fromOfGlobalSections` chart map.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Limits TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X}
variable {n : ℕ} {ι : Type v}

namespace LocalRatioProjectiveGluing

variable (a : ι → LocalRatioCoordinateData D n)
variable (r : (i : ι) → LocalRatioRegularization (a i))
variable (hcover : IsOpenCover fun i => (a i).chart.U)

/-- The open cover supplied by an indexed family of local-ratio charts. -/
noncomputable def chartOpenCover : X.left.OpenCover :=
  X.left.openCoverOfIsOpenCover (fun i => (a i).chart.U) hcover

/-- The explicit normalized projective morphism on one member of the chart
cover. -/
noncomputable def fromOpenFamily (i : ι) :
    (chartOpenCover a hcover).X i ⟶ projectiveSpace k n := by
  change (a i).chart.U.toScheme ⟶
    Proj (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
  exact ProjectiveCoordinates.fromOpen (k := k) (J := Fin (n + 1))
    (Z := X.left) (a i).chart.U
    (X.left.overAlgebraMap k (a i).chart.U) (a i).denominator_index
    (r i).regularized (r i).regularized_denominator_eq_one

/-- The explicit normalized chart maps agree on the pullback of every pair of
members of the chart cover. -/
theorem fromOpenFamily_compat
    (hsame : ∀ i j, (a i).SameSectionValues (a j)) :
    ∀ i j,
      pullback.fst ((chartOpenCover a hcover).f i)
          ((chartOpenCover a hcover).f j) ≫ fromOpenFamily a r hcover i =
        pullback.snd ((chartOpenCover a hcover).f i)
          ((chartOpenCover a hcover).f j) ≫ fromOpenFamily a r hcover j := by
  intro i j
  change pullback.fst ((a i).chart.U.ι) ((a j).chart.U.ι) ≫
        ProjectiveCoordinates.fromOpen (k := k) (J := Fin (n + 1))
          (Z := X.left) (a i).chart.U
          (X.left.overAlgebraMap k (a i).chart.U) (a i).denominator_index
          (r i).regularized (r i).regularized_denominator_eq_one =
      pullback.snd ((a i).chart.U.ι) ((a j).chart.U.ι) ≫
        ProjectiveCoordinates.fromOpen (k := k) (J := Fin (n + 1))
          (Z := X.left) (a j).chart.U
          (X.left.overAlgebraMap k (a j).chart.U) (a j).denominator_index
          (r j).regularized (r j).regularized_denominator_eq_one
  have hpb := isPullback_opens_inf (a i).chart.U (a j).chart.U
  rw [← cancel_epi hpb.isoPullback.hom, ← Category.assoc, ← Category.assoc,
    hpb.isoPullback_hom_fst, hpb.isoPullback_hom_snd]
  exact LocalRatioRegularization.overlap_fromOpen_eq
    (r i) (r j) (hsame i j)

/-- Glue a covering family of compatible normalized local-ratio maps to a
global projective morphism. -/
noncomputable def gluedFromOpen
    (hsame : ∀ i j, (a i).SameSectionValues (a j)) :
    X.left ⟶ projectiveSpace k n :=
  (chartOpenCover a hcover).glueMorphisms (fromOpenFamily a r hcover)
    (fromOpenFamily_compat a r hcover hsame)

/-- The glued morphism restricts to the explicit normalized morphism on every
member of the chart cover. -/
@[reassoc (attr := simp)]
theorem chartOpenCover_ι_gluedFromOpen
    (hsame : ∀ i j, (a i).SameSectionValues (a j)) (i : ι) :
    (chartOpenCover a hcover).f i ≫ gluedFromOpen a r hcover hsame =
      fromOpenFamily a r hcover i := by
  exact Scheme.Cover.ι_glueMorphisms (chartOpenCover a hcover)
    (fromOpenFamily a r hcover) (fromOpenFamily_compat a r hcover hsame) i

/-- The glued morphism restricts to the canonical `Proj.fromOfGlobalSections`
map on every member of the local-ratio cover. -/
@[reassoc]
theorem chartOpenCover_ι_gluedFromOpen_eq_chartMap
    (hsame : ∀ i j, (a i).SameSectionValues (a j)) (i : ι) :
    (chartOpenCover a hcover).f i ≫ gluedFromOpen a r hcover hsame =
      (r i).chartMap := by
  rw [chartOpenCover_ι_gluedFromOpen]
  exact (r i).chartMap_eq_fromOpen.symm

/-- The morphism obtained by gluing the local-ratio charts is over the
coefficient field. -/
@[reassoc (attr := simp)]
theorem gluedFromOpen_over
    (hsame : ∀ i j, (a i).SameSectionValues (a j)) :
    gluedFromOpen a r hcover hsame ≫ projectiveSpaceStructureMap k n = X.hom := by
  apply Scheme.Cover.hom_ext (chartOpenCover a hcover)
  intro i
  rw [← Category.assoc, chartOpenCover_ι_gluedFromOpen_eq_chartMap]
  exact (r i).chartMap_over

end LocalRatioProjectiveGluing

end
end Hartshorne
