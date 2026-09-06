/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientGlue
import Mathlib.AlgebraicGeometry.Gluing

/-!
# The affine quotient map into its canonical glued presentation

For a finite stable-open cover of an affine source, the descended quotient
opens have a canonical `Scheme.GlueData` presentation.  This file feeds the
already constructed affine invariant quotient map through the canonical
`fromGlued` isomorphism and records its restrictions to the source charts.
The construction is affine and conditional only on the displayed cover; it
does not assert existence of a quotient for a general (non-affine) scheme.
-/

set_option autoImplicit false

universe u v

open CategoryTheory AlgebraicGeometry Topology TopologicalSpace

namespace MilneLib
namespace InvariantLocalization

variable {k : Type u} {A : Type v} {G : Type*}
  [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A] [Finite G]

section StableOpenFamily

-- The gluing index must live in the universe of `Spec A`.
variable {ι : Type v} [Finite ι]

noncomputable abbrev stableSourceSpec : Scheme := Spec (CommRingCat.of A)

noncomputable abbrev stableQuotientGlueData
    (U : ι → (stableSourceSpec (A := A)).Opens)
    (hU : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ U i = U i)
    (hcover : (⨆ i, U i) = ⊤) : Scheme.GlueData :=
  quotientGlueDataOfStable (k := k) (A := A) (G := G) U hU hcover

noncomputable abbrev stableSourceCover
    (U : ι → (stableSourceSpec (A := A)).Opens)
    (hcover : (⨆ i, U i) = ⊤) : (stableSourceSpec (A := A)).OpenCover :=
  Scheme.openCoverOfIsOpenCover _ U
    (TopologicalSpace.IsOpenCover.mk hcover)

/-- The affine invariant quotient map viewed in the canonical glued
presentation of a stable-open cover. -/
noncomputable def affineInvariantQuotientMapToGlued
    (U : ι → (stableSourceSpec (A := A)).Opens)
    (hU : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ U i = U i)
    (hcover : (⨆ i, U i) = ⊤) :
    stableSourceSpec (A := A) ⟶
      (stableQuotientGlueData (k := k) (A := A) (G := G) U hU hcover).glued :=
  by
    change stableSourceSpec (A := A) ⟶
      (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).gluedCover.glued
    exact affineInvariantQuotientMap (k := k) (A := A) (G := G) ≫
      inv (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).fromGlued

@[reassoc (attr := simp)]
theorem affineInvariantQuotientMapToGlued_comp_fromGlued
    (U : ι → (stableSourceSpec (A := A)).Opens)
    (hU : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ U i = U i)
    (hcover : (⨆ i, U i) = ⊤) :
    affineInvariantQuotientMapToGlued (k := k) (A := A) (G := G) U hU hcover ≫
        (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).fromGlued =
      affineInvariantQuotientMap (k := k) (A := A) (G := G) := by
  change (affineInvariantQuotientMap (k := k) (A := A) (G := G) ≫
      inv (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).fromGlued) ≫
      (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).fromGlued = _
  letI : IsIso (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).fromGlued :=
    Scheme.Cover.instIsIsoFromGlued _
  rw [Category.assoc, IsIso.inv_hom_id, Category.comp_id]

/-! ## Chart restrictions -/

@[reassoc]
theorem affineInvariantQuotientMapToGlued_restrict
    (U : ι → (stableSourceSpec (A := A)).Opens)
    (hU : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ U i = U i)
    (hcover : (⨆ i, U i) = ⊤) (i : ι) :
    (U i).ι ≫
        affineInvariantQuotientMapToGlued (k := k) (A := A) (G := G) U hU hcover =
      affineInvariantQuotientMapRestrictStable (k := k) (A := A) (G := G)
          (U i) (hU i) ≫
    (stableQuotientGlueData (k := k) (A := A) (G := G) U hU hcover).ι i := by
  apply (cancel_mono
    (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).fromGlued).1
  change ((U i).ι ≫ affineInvariantQuotientMapToGlued
      (k := k) (A := A) (G := G) U hU hcover) ≫
      (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).fromGlued =
    (affineInvariantQuotientMapRestrictStable (k := k) (A := A) (G := G)
        (U i) (hU i) ≫
      (quotientGlueDataOfStable (k := k) (A := A) (G := G) U hU hcover).ι i) ≫
      (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).fromGlued
  have hι := quotientGlueData_ι_fromGlued
    (k := k) (A := A) (G := G) U hU hcover i
  calc
    ((U i).ι ≫ affineInvariantQuotientMapToGlued
        (k := k) (A := A) (G := G) U hU hcover) ≫
        (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).fromGlued =
      (U i).ι ≫ affineInvariantQuotientMap (k := k) (A := A) (G := G) := by
        rw [Category.assoc, affineInvariantQuotientMapToGlued_comp_fromGlued]
    _ = affineInvariantQuotientMapRestrictStable (k := k) (A := A) (G := G)
        (U i) (hU i) ≫
        (quotientOpenFamily (k := k) (A := A) (G := G) U hU i).ι :=
      by
        change (U i).ι ≫ affineInvariantQuotientMap (k := k) (A := A) (G := G) =
          affineInvariantQuotientMapRestrictStable (k := k) (A := A) (G := G)
            (U i) (hU i) ≫
            (quotientOpenOfStable (k := k) (A := A) (G := G) (U i) (hU i)).ι
        exact (affineInvariantQuotientMapRestrictStable_fac
          (k := k) (A := A) (G := G) (U i) (hU i)).symm
    _ = affineInvariantQuotientMapRestrictStable (k := k) (A := A) (G := G)
        (U i) (hU i) ≫
        ((quotientGlueDataOfStable (k := k) (A := A) (G := G) U hU hcover).ι i ≫
          (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).fromGlued) := by
      change affineInvariantQuotientMapRestrictStable (k := k) (A := A) (G := G)
          (U i) (hU i) ≫
          (quotientOpenOfStable (k := k) (A := A) (G := G) (U i) (hU i)).ι =
        affineInvariantQuotientMapRestrictStable (k := k) (A := A) (G := G)
          (U i) (hU i) ≫
          ((quotientGlueDataOfStable (k := k) (A := A) (G := G) U hU hcover).ι i ≫
            (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).fromGlued)
      exact congrArg
        (fun q => affineInvariantQuotientMapRestrictStable (k := k) (A := A) (G := G)
          (U i) (hU i) ≫ q) hι.symm
    _ = (affineInvariantQuotientMapRestrictStable (k := k) (A := A) (G := G)
        (U i) (hU i) ≫
        (quotientGlueDataOfStable (k := k) (A := A) (G := G) U hU hcover).ι i) ≫
          (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).fromGlued := by
      rw [Category.assoc]

/-! ## Uniqueness from the source cover -/

theorem affineInvariantQuotientMapToGlued_unique
    (U : ι → (stableSourceSpec (A := A)).Opens)
    (hU : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ U i = U i)
    (hcover : (⨆ i, U i) = ⊤)
    (g : stableSourceSpec (A := A) ⟶
      (stableQuotientGlueData (k := k) (A := A) (G := G) U hU hcover).glued)
    (hg : ∀ i,
      (U i).ι ≫ g =
        affineInvariantQuotientMapRestrictStable (k := k) (A := A) (G := G)
            (U i) (hU i) ≫
          (stableQuotientGlueData (k := k) (A := A) (G := G) U hU hcover).ι i) :
    g = affineInvariantQuotientMapToGlued (k := k) (A := A) (G := G) U hU hcover := by
  apply (stableSourceCover (A := A) U hcover).hom_ext
  change ∀ i : ι, (U i).ι ≫ g = (U i).ι ≫
    affineInvariantQuotientMapToGlued (k := k) (A := A) (G := G) U hU hcover
  intro i
  rw [hg i, affineInvariantQuotientMapToGlued_restrict]

end StableOpenFamily

end InvariantLocalization
end MilneLib
