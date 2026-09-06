/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4AffineChartClosedImmersion

/-!
# Normalized maps into a projective basic open

The coordinate adapter first produces a map into `Proj`.  This file records
the corresponding factor through the standard affine basic open and the
closed-immersion criterion for that affine factor.  Surjectivity of the chart
ring map is deliberately an explicit hypothesis; the global closed immersion
and chart-gluing argument are separate producers.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Limits MvPolynomial HomogeneousLocalization
open AlgebraicGeometry

namespace Hartshorne
namespace ProjectiveCoordinates

noncomputable section

variable {J : Type v} {k B : Type (max u v)} [Field k] [CommRing B] [Algebra k B]

attribute [local instance] MvPolynomial.gradedAlgebra

/-- The normalized coordinate map, viewed as a morphism into its standard
affine basic open in projective space. -/
def toBasicOpen (i : J) (c : J → B) (hi : c i = 1) :
    Spec (.of B) ⟶
      (Proj.basicOpen (homogeneousSubmodule J k) (X i)).toScheme :=
  Spec.map (CommRingCat.ofHom (chartHom (k := k) i c hi)) ≫
    (Proj.basicOpenIsoSpec (homogeneousSubmodule J k) (X i)
      (X_mem_deg_one (k := k) i) Nat.zero_lt_one).inv

/-- The basic-open factor composes with the open immersion to the coordinate
map from the adapter. -/
@[reassoc]
theorem toBasicOpen_ι (i : J) (c : J → B) (hi : c i = 1) :
    toBasicOpen (k := k) i c hi ≫
        (Proj.basicOpen (homogeneousSubmodule J k) (X i)).ι =
      fromSpec (k := k) i c hi := by
  rw [toBasicOpen, Category.assoc, Proj.basicOpenIsoSpec_inv_ι]
  rfl

/-- If the normalized coordinates generate the affine coordinate algebra, the
localized chart ring map is surjective.  The coefficient case is represented
by a degree-zero homogeneous constant in the chart ring. -/
theorem chartHom_surjective_of_adjoin_eq_top
    (i : J) (c : J → B) (hi : c i = 1)
    (hgen : Algebra.adjoin k (Set.range c) = ⊤) :
    Function.Surjective (chartHom (k := k) i c hi) := by
  have coeff_preimage : ∀ r : k, ∃ x : Away (homogeneousSubmodule J k) (X i),
      chartHom (k := k) i c hi x = algebraMap k B r := by
    intro r
    refine ⟨Away.mk (homogeneousSubmodule J k)
        (X_mem_deg_one (k := k) i) 0
        (algebraMap k (MvPolynomial J k) r) ?_, ?_⟩
    · rw [zero_smul]
      exact (MvPolynomial.mem_homogeneousSubmodule _ _).mpr (by
        rw [MvPolynomial.algebraMap_eq]
        exact MvPolynomial.isHomogeneous_C _ r)
    · rw [chartHom_mk (k := k) i c hi
        (X_mem_deg_one (k := k) i) 0
        (algebraMap k (MvPolynomial J k) r)]
      simp [eval]
  intro b
  have hb : b ∈ Algebra.adjoin k (Set.range c) := by
    rw [hgen]
    trivial
  induction hb using Algebra.adjoin_induction with
  | mem x hx =>
      obtain ⟨j, rfl⟩ := hx
      exact ⟨chartCoord (k := k) i j,
        chartHom_chartCoord (k := k) i j c hi⟩
  | algebraMap r =>
      exact coeff_preimage r
  | add x y hx hy hx' hy' =>
      obtain ⟨px, hpx⟩ := hx'
      obtain ⟨py, hpy⟩ := hy'
      exact ⟨px + py, by rw [map_add, hpx, hpy]⟩
  | mul x y hx hy hx' hy' =>
      obtain ⟨px, hpx⟩ := hx'
      obtain ⟨py, hpy⟩ := hy'
      exact ⟨px * py, by rw [map_mul, hpx, hpy]⟩

/-- Generation by the complementary normalized coordinates is enough, since
the distinguished coordinate contributes only the unit `1`. -/
theorem chartHom_surjective_of_complement_adjoin_eq_top
    (i : J) (c : J → B) (hi : c i = 1)
    (hgen : Algebra.adjoin k
      (Set.range fun j : {j : J // j ≠ i} => c j.1) = ⊤) :
    Function.Surjective (chartHom (k := k) i c hi) := by
  have hsubset : Set.range (fun j : {j : J // j ≠ i} => c j.1) ⊆
      Algebra.adjoin k (Set.range c) := by
    rintro x ⟨j, rfl⟩
    exact Algebra.subset_adjoin ⟨j.1, rfl⟩
  have hfull : Algebra.adjoin k (Set.range c) = ⊤ := by
    apply top_unique
    rw [← hgen]
    exact Algebra.adjoin_le hsubset
  exact chartHom_surjective_of_adjoin_eq_top i c hi hfull

/-- A surjective chart ring map gives a closed immersion into the affine
standard chart. -/
theorem toBasicOpen_isClosedImmersion_of_surjective
    (i : J) (c : J → B) (hi : c i = 1)
    (hchart : Function.Surjective (chartHom (k := k) i c hi)) :
    IsClosedImmersion (toBasicOpen (k := k) i c hi) := by
  unfold toBasicOpen
  apply MorphismProperty.comp_mem @IsClosedImmersion
  · apply IsClosedImmersion.spec_of_surjective
    exact hchart
  · infer_instance

/-- Algebra generation of the normalized coordinates supplies the chart
surjectivity needed for the affine closed-immersion criterion. -/
theorem toBasicOpen_isClosedImmersion_of_adjoin_eq_top
    (i : J) (c : J → B) (hi : c i = 1)
    (hgen : Algebra.adjoin k (Set.range c) = ⊤) :
    IsClosedImmersion (toBasicOpen (k := k) i c hi) :=
  toBasicOpen_isClosedImmersion_of_surjective i c hi
    (chartHom_surjective_of_adjoin_eq_top i c hi hgen)

/-- The complementary-coordinate generation hypothesis gives the same
closed-immersion conclusion for the normalized chart. -/
theorem toBasicOpen_isClosedImmersion_of_complement_adjoin_eq_top
    (i : J) (c : J → B) (hi : c i = 1)
    (hgen : Algebra.adjoin k
      (Set.range fun j : {j : J // j ≠ i} => c j.1) = ⊤) :
    IsClosedImmersion (toBasicOpen (k := k) i c hi) :=
  toBasicOpen_isClosedImmersion_of_surjective i c hi
    (chartHom_surjective_of_complement_adjoin_eq_top i c hi hgen)

/-! ### Affine-space comparison

The following bridge uses a common universe for the coordinate type and the
coefficient algebras, matching the fixed `AffineSpace.SpecIso` presentation
used by the affine producer.  It is a compatibility theorem, not a claim of
independence from that presentation.
-/

namespace AffineChartBridge

universe w

variable {J k B : Type w} [Field k] [CommRing B] [Algebra k B]

attribute [local instance] MvPolynomial.gradedAlgebra

/-- The coefficient inclusion into the degree-zero homogeneous localization. -/
def coeffAway (i : J) : k →+* Away (homogeneousSubmodule J k) (X i) :=
  (HomogeneousLocalization.fromZeroRingHom
    (homogeneousSubmodule J k) (Submonoid.powers (X i))).comp
    (algebraMap k (homogeneousSubmodule J k 0))

/-- The polynomial map sending each complementary variable to its normalized
projective coordinate. -/
def polyToAway (i : J) :
    MvPolynomial {j : J // j ≠ i} k →+*
      Away (homogeneousSubmodule J k) (X i) :=
  MvPolynomial.eval₂Hom (coeffAway (k := k) i)
    (fun j => chartCoord (k := k) i j.1)

/-- Evaluation of complementary variables in the target affine algebra. -/
def complementEval (i : J) (c : J → B) :
    MvPolynomial {j : J // j ≠ i} k →+* B :=
  MvPolynomial.eval₂Hom (algebraMap k B) (fun j => c j.1)

/-- The localized chart map followed by the polynomial-coordinate map is the
ordinary affine evaluation map on the complementary coordinates. -/
theorem chartHom_comp_polyToAway (i : J) (c : J → B) (hi : c i = 1) :
    (ProjectiveCoordinates.chartHom (k := k) i c hi).comp
        (polyToAway (k := k) i) =
      complementEval (k := k) i c := by
  apply MvPolynomial.ringHom_ext
  · intro r
    change ProjectiveCoordinates.chartHom (k := k) i c hi
        (polyToAway (k := k) i (MvPolynomial.C r)) =
      complementEval (k := k) i c (MvPolynomial.C r)
    simp only [polyToAway, complementEval, MvPolynomial.eval₂Hom_C]
    change ProjectiveCoordinates.chartHom (k := k) i c hi
        ((HomogeneousLocalization.fromZeroRingHom
          (homogeneousSubmodule J k) (Submonoid.powers (X i)))
          (algebraMap k (homogeneousSubmodule J k 0) r)) =
      algebraMap k B r
    change ProjectiveCoordinates.chartHom (k := k) i c hi
        (Away.mk (homogeneousSubmodule J k)
          (ProjectiveCoordinates.X_mem_deg_one (k := k) i) 0
          (algebraMap k (MvPolynomial J k) r) _) = _
    rw [ProjectiveCoordinates.chartHom_mk (k := k) i c hi
      (ProjectiveCoordinates.X_mem_deg_one (k := k) i) 0
      (algebraMap k (MvPolynomial J k) r)]
    simp [ProjectiveCoordinates.eval]
  · intro j
    simp [polyToAway, complementEval,
      ProjectiveCoordinates.chartHom_chartCoord]

/-- The standard projective basic open maps to affine space through its
homogeneous localization and the complementary polynomial coordinates. -/
def basicOpenToAffineSpace (i : J) :
    (Proj.basicOpen (homogeneousSubmodule J k) (X i)).toScheme ⟶
      𝔸({j : J // j ≠ i}; Spec (.of k)) :=
  (Proj.basicOpenIsoSpec (homogeneousSubmodule J k) (X i)
      (ProjectiveCoordinates.X_mem_deg_one (k := k) i) Nat.zero_lt_one).hom ≫
    Spec.map (CommRingCat.ofHom (polyToAway (k := k) i)) ≫
    (AffineSpace.SpecIso {j : J // j ≠ i} (.of k)).inv

/-- The basic-open factor is compatible with the affine normalized-coordinate
producer. -/
theorem toBasicOpen_comp_basicOpenToAffineSpace
    (i : J) (c : J → B) (hi : c i = 1) :
    ProjectiveCoordinates.toBasicOpen (k := k) i c hi ≫
        basicOpenToAffineSpace (k := k) i =
      ProjectiveCoordinates.affineSpecMap (k := k) i c := by
  unfold ProjectiveCoordinates.toBasicOpen basicOpenToAffineSpace
    ProjectiveCoordinates.affineSpecMap
  simp only [Category.assoc, Iso.inv_hom_id_assoc]
  change (Spec.map (CommRingCat.ofHom
      (ProjectiveCoordinates.chartHom (k := k) i c hi)) ≫
      Spec.map (CommRingCat.ofHom (polyToAway (k := k) i))) ≫
      (AffineSpace.SpecIso {j : J // j ≠ i} (.of k)).inv =
    Spec.map (CommRingCat.ofHom (complementEval (k := k) i c)) ≫
      (AffineSpace.SpecIso {j : J // j ≠ i} (.of k)).inv
  rw [← Spec.map_comp, ← CommRingCat.ofHom_comp,
    chartHom_comp_polyToAway]

/-- Complementary-coordinate algebra generation yields a closed immersion of
the projective basic-open factor, by the affine-space closed-immersion
producer and the separated affine comparison map. -/
theorem toBasicOpen_isClosedImmersion_of_complement_adjoin_eq_top_via_affine
    (i : J) (c : J → B) (hi : c i = 1)
    (hgen : Algebra.adjoin k
      (Set.range fun j : {j : J // j ≠ i} => c j.1) = ⊤) :
    IsClosedImmersion (ProjectiveCoordinates.toBasicOpen (k := k) i c hi) := by
  have hcomp : IsClosedImmersion
      (ProjectiveCoordinates.toBasicOpen (k := k) i c hi ≫
        basicOpenToAffineSpace (k := k) i) := by
    rw [toBasicOpen_comp_basicOpenToAffineSpace]
    exact ProjectiveCoordinates.isClosedImmersion_affineSpecMap
      (k := k) i c hgen
  letI : IsClosedImmersion
      (ProjectiveCoordinates.toBasicOpen (k := k) i c hi ≫
        basicOpenToAffineSpace (k := k) i) := hcomp
  letI : IsSeparated (basicOpenToAffineSpace (k := k) i) := by
    unfold basicOpenToAffineSpace
    infer_instance
  exact IsClosedImmersion.of_comp
    (ProjectiveCoordinates.toBasicOpen (k := k) i c hi)
    (basicOpenToAffineSpace (k := k) i)

end AffineChartBridge

end
end ProjectiveCoordinates
end Hartshorne
