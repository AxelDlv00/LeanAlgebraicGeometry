/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4ProjectiveCoordinateAdapter
import Mathlib.AlgebraicGeometry.AffineSpace

/-!
# Affine maps from normalized projective coordinates

The complementary coordinates of a normalized homogeneous family define an
affine-space map over `Spec k`.  This module records the map, its coordinate
pullback formula, and the algebra-generation criterion for it to be a closed
immersion.  The generation hypothesis is kept explicit: no geometric
property is inferred from normalization alone.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MvPolynomial
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

namespace IsFinite

/-- An algebra-generating family gives a closed immersion into affine space.

This is the affine-spectrum form of the chosen-generator criterion.  It is
kept local to the Hartshorne library so that downstream chart constructions
can cite the exact aeval surjectivity they use.
-/
theorem isClosedImmersion_SpecMap_aeval_of_adjoin_eq_top
    {R A : Type u} [CommRing R] [CommRing A] [Algebra R A]
    {n : Type u} (a : n → A)
    (hgen : Algebra.adjoin R (Set.range a) = ⊤) :
    IsClosedImmersion (Spec.map (CommRingCat.ofHom
      (MvPolynomial.aeval (R := R) a).toRingHom)) := by
  apply IsClosedImmersion.spec_of_surjective
  change Function.Surjective (MvPolynomial.aeval (R := R) a)
  rw [← AlgHom.range_eq_top, ← Algebra.adjoin_range_eq_range_aeval]
  exact hgen

end IsFinite

namespace ProjectiveCoordinates

variable {k B J : Type u} [Field k] [CommRing B] [Algebra k B]

/-- The structural morphism of an affine spectrum induced by its `k`-algebra
structure. -/
def specToBase : Spec (.of B) ⟶ Spec (.of k) :=
  Spec.map (CommRingCat.ofHom (algebraMap k B))

/-- The affine-space map classified by the complementary normalized
coordinates.  The index `i` is only used to remove the normalizing coordinate;
the definition itself is independent of a proof that `c i = 1`.  The target is
presented using Mathlib's fixed `AffineSpace.SpecIso`; no independence from
that chosen presentation is asserted. -/
def affineSpecMap (i : J) (c : J → B) :
    Spec (.of B) ⟶ 𝔸({j : J // j ≠ i}; Spec (.of k)) :=
  Spec.map (CommRingCat.ofHom
      (MvPolynomial.aeval (R := k)
        (fun j : {j : J // j ≠ i} ↦ c j.1)).toRingHom) ≫
    (AffineSpace.SpecIso {j : J // j ≠ i} (.of k)).inv

@[reassoc]
theorem affineSpecMap_over (i : J) (c : J → B) :
    affineSpecMap (k := k) i c ≫
        (𝔸({j : J // j ≠ i}; Spec (.of k)) ↘ Spec (.of k)) =
      specToBase := by
  rw [affineSpecMap, Category.assoc, AffineSpace.SpecIso_inv_over,
    ← Spec.map_comp]
  congr 1
  ext x
  simp

@[simp]
theorem affineSpecMap_appTop_coord (i : J) (c : J → B)
    (j : {j : J // j ≠ i}) :
    (affineSpecMap (k := k) i c).appTop
        (AffineSpace.coord (Spec (.of k)) j) =
      (Scheme.ΓSpecIso (.of B)).inv (c j.1) := by
  rw [affineSpecMap, Scheme.Hom.comp_appTop]
  change (Spec.map (CommRingCat.ofHom
      (MvPolynomial.aeval (R := k)
        (fun j : {j : J // j ≠ i} ↦ c j.1)).toRingHom)).appTop
        ((AffineSpace.SpecIso {j : J // j ≠ i} (.of k)).inv.appTop
          (AffineSpace.coord (Spec (.of k)) j)) = _
  rw [AffineSpace.SpecIso_inv_appTop_coord]
  rw [← CommRingCat.comp_apply, ← Scheme.ΓSpecIso_inv_naturality,
    CommRingCat.comp_apply, ConcreteCategory.hom_ofHom]
  exact congrArg (fun z : B ↦ (Scheme.ΓSpecIso (.of B)).inv z)
    (MvPolynomial.aeval_X
      (R := k) (fun j : {j : J // j ≠ i} ↦ c j.1) j)

/-- Algebra generation of the complementary normalized coordinates makes the
associated affine-space map a closed immersion. -/
theorem isClosedImmersion_affineSpecMap (i : J) (c : J → B)
    (hgen : Algebra.adjoin k
      (Set.range fun j : {j : J // j ≠ i} ↦ c j.1) = ⊤) :
    IsClosedImmersion (affineSpecMap (k := k) i c) := by
  dsimp [affineSpecMap]
  apply MorphismProperty.comp_mem @IsClosedImmersion
  · exact IsFinite.isClosedImmersion_SpecMap_aeval_of_adjoin_eq_top
      (R := k) (A := B) (n := {j : J // j ≠ i}) _ hgen
  · infer_instance

end ProjectiveCoordinates

end
end Hartshorne
