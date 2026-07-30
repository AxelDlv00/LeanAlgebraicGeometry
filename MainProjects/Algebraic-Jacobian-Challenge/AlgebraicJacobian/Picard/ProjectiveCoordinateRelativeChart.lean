/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.FiniteMorphismEmbedding
import AlgebraicJacobian.Picard.ProjectiveSpaceAffineChartAt

/-!
# Relative projective coordinate charts

A normalized homogeneous coordinate family over a field defines a morphism to
relative projective space and a canonical factor through the chart where the
normalizing coordinate is nonzero.  The corresponding affine-space map is a
closed immersion as soon as the remaining coordinates algebra-generate the
source ring.
-/

set_option autoImplicit false

noncomputable section

universe u

open CategoryTheory Limits MvPolynomial

namespace AlgebraicGeometry.ProjectiveSpace.Coordinates

variable {k B J : Type u} [Field k] [CommRing B] [Algebra k B]

/-- The structural morphism of an affine spectrum induced by its `k`-algebra
structure. -/
def specToBase : Spec (.of B) ⟶ Spec (.of k) :=
  Spec.map (CommRingCat.ofHom (algebraMap k B))

/-- A normalized integral coordinate map paired with the structural morphism
to the base field. -/
def relativeFromSpec (i : J) (c : J → B) (hi : c i = 1) :
    Spec (.of B) ⟶ ℙ(J; Spec (.of k)) :=
  pullback.lift specToBase (fromSpec i c hi) (Subsingleton.elim _ _)

@[reassoc]
theorem relativeFromSpec_over (i : J) (c : J → B) (hi : c i = 1) :
    relativeFromSpec i c hi ≫ (ℙ(J; Spec (.of k)) ↘ Spec (.of k)) =
      specToBase := by
  rw [ProjectiveSpace.over_eq_fst]
  exact pullback.lift_fst _ _ _

@[reassoc]
theorem relativeFromSpec_toProjInt (i : J) (c : J → B) (hi : c i = 1) :
    relativeFromSpec i c hi ≫ ProjectiveSpace.toProjInt J (Spec (.of k)) =
      fromSpec i c hi := by
  rw [ProjectiveSpace.toProjInt_eq_snd]
  exact pullback.lift_snd _ _ _

/-- The normalized coordinate map factored through its relative standard
chart. -/
def toAffineChartAt (i : J) (c : J → B) (hi : c i = 1) :
    Spec (.of B) ⟶ ProjectiveSpace.affineChartAt J i (Spec (.of k)) :=
  pullback.lift (relativeFromSpec i c hi)
    (Spec.map (CommRingCat.ofHom (chartHom i c hi))) (by
      rw [relativeFromSpec_toProjInt]
      rfl)

@[reassoc]
theorem toAffineChartAt_incl (i : J) (c : J → B) (hi : c i = 1) :
    toAffineChartAt i c hi ≫
        ProjectiveSpace.affineChartAt.incl J i (Spec (.of k)) =
      relativeFromSpec i c hi :=
  pullback.lift_fst _ _ _

@[reassoc]
theorem toAffineChartAt_specAway (i : J) (c : J → B) (hi : c i = 1) :
    toAffineChartAt i c hi ≫
        pullback.snd (ProjectiveSpace.toProjInt J (Spec (.of k)))
          (Proj.awayι (homogeneousSubmodule J (ULift.{u} ℤ)) (X i)
            (X_mem_deg_one i) Nat.zero_lt_one) =
      Spec.map (CommRingCat.ofHom (chartHom i c hi)) :=
  pullback.lift_snd _ _ _

/-- The affine-space map classified by the complementary normalized
coordinates. -/
def affineSpecMap (i : J) (c : J → B) :
    Spec (.of B) ⟶ 𝔸({j : J // j ≠ i}; Spec (.of k)) :=
  Spec.map (CommRingCat.ofHom
      (MvPolynomial.aeval (R := k) (fun j : {j : J // j ≠ i} ↦ c j.1)).toRingHom) ≫
    (AffineSpace.SpecIso {j : J // j ≠ i} (.of k)).inv

/-- Algebra generation of the complementary normalized coordinates makes the
associated affine-space map a closed immersion. -/
theorem isClosedImmersion_affineSpecMap (i : J) (c : J → B)
    (hgen : Algebra.adjoin k (Set.range fun j : {j : J // j ≠ i} ↦ c j.1) = ⊤) :
    IsClosedImmersion (affineSpecMap (k := k) i c) := by
  dsimp [affineSpecMap]
  apply MorphismProperty.comp_mem @IsClosedImmersion
  · exact IsFinite.isClosedImmersion_SpecMap_aeval_of_adjoin_eq_top
      (R := k) (A := B) (n := {j : J // j ≠ i}) _ hgen
  · infer_instance

end AlgebraicGeometry.ProjectiveSpace.Coordinates
