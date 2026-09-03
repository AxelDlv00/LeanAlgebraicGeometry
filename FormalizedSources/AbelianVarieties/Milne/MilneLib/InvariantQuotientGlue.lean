/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientOpen
import MilneLib.AffineQuotientOver
import Mathlib.AlgebraicGeometry.Gluing

/-!
# Gluing a stable-open cover of an affine invariant quotient

For a finite group action on an affine scheme, a family of invariant opens on the
source descends to a family of opens on the affine invariant quotient.  This file
packages the covering argument and feeds the resulting open cover to Mathlib's
canonical `Scheme.OpenCover.gluedCover` construction.  No non-affine quotient
existence statement is made here.  Thus the resulting glue datum reconstructs
the already-defined affine invariant quotient from this cover; it is not the
cross-chart quotient construction for a general scheme.
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

-- `Scheme.Cover.gluedCover` expects the index universe to agree with the
-- universe of the covered scheme (`Spec` here lives in the universe of `A`).
variable {ι : Type v}

noncomputable abbrev affineSpec : Scheme := Spec (CommRingCat.of A)
noncomputable abbrev quotientSpec : Scheme :=
  Spec (CommRingCat.of (FixedPoints.subalgebra k A G))

/-- The quotient-side open attached to each member of a stable-open family. -/
noncomputable def quotientOpenFamily (U : ι → (affineSpec (A := A)).Opens)
    (hU : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ U i = U i) :
    ι → (quotientSpec (k := k) (A := A) (G := G)).Opens :=
  fun i => quotientOpenOfStable (k := k) (A := A) (G := G) (U i) (hU i)

@[simp]
theorem quotientOpenFamily_preimage (U : ι → (affineSpec (A := A)).Opens)
    (hU : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ U i = U i) (i : ι) :
    (affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ
        quotientOpenFamily (k := k) (A := A) (G := G) U hU i = U i := by
  exact quotientOpenOfStable_preimage (k := k) (A := A) (G := G) (U i) (hU i)

/-- Pointwise intersections of stable chart families descend to intersections of
the corresponding quotient charts.  This packages the pairwise/triple overlap
operation used when assembling a finite gluing datum. -/
@[simp]
theorem quotientOpenFamily_inf
    (U V : ι → (affineSpec (A := A)).Opens)
    (hU : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ U i = U i)
    (hV : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ V i = V i) :
    quotientOpenFamily (k := k) (A := A) (G := G)
        (fun i => U i ⊓ V i)
        (fun i g => by rw [Scheme.Hom.preimage_inf, hU i g, hV i g]) =
      fun i => quotientOpenFamily (k := k) (A := A) (G := G) U hU i ⊓
        quotientOpenFamily (k := k) (A := A) (G := G) V hV i := by
  funext i
  exact quotientOpenOfStable_inf (k := k) (A := A) (G := G)
    (U i) (V i) (hU i) (hV i)

/-- A covering family descends to a covering family on the affine invariant quotient. -/
theorem iSup_quotientOpenFamily_eq_top (U : ι → (affineSpec (A := A)).Opens)
    (hU : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ U i = U i)
    (hcover : (⨆ i, U i) = ⊤) :
    (⨆ i, quotientOpenFamily (k := k) (A := A) (G := G) U hU i) = ⊤ := by
  apply le_antisymm le_top
  intro y _
  obtain ⟨x, rfl⟩ :=
    affineInvariantQuotientMap_surjective (k := k) (A := A) (G := G) y
  have hx : x ∈ (⨆ i, U i) := by
    rw [hcover]
    trivial
  rw [TopologicalSpace.Opens.mem_iSup] at hx
  obtain ⟨i, hxi⟩ := hx
  rw [TopologicalSpace.Opens.mem_iSup]
  refine ⟨i, ?_⟩
  have hpre := quotientOpenFamily_preimage (k := k) (A := A) (G := G) U hU i
  have : x ∈
      (affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ
        quotientOpenFamily (k := k) (A := A) (G := G) U hU i := by
    rw [hpre]
    exact hxi
  exact this

/-- The descended opens form a finite open cover of the affine invariant quotient. -/
noncomputable def quotientOpenCoverOfStable [Finite ι]
    (U : ι → (affineSpec (A := A)).Opens)
    (hU : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ U i = U i)
    (hcover : (⨆ i, U i) = ⊤) :
    (quotientSpec (k := k) (A := A) (G := G)).OpenCover :=
  Scheme.openCoverOfIsOpenCover _
    (quotientOpenFamily (k := k) (A := A) (G := G) U hU)
    (TopologicalSpace.IsOpenCover.mk
      (iSup_quotientOpenFamily_eq_top (k := k) (A := A) (G := G) U hU hcover))

/-- The canonical scheme gluing datum attached to the descended open cover. -/
noncomputable def quotientGlueDataOfStable [Finite ι]
    (U : ι → (affineSpec (A := A)).Opens)
    (hU : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ U i = U i)
    (hcover : (⨆ i, U i) = ⊤) : Scheme.GlueData :=
  (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).gluedCover

@[simp]
theorem quotientOpenCoverOfStable_X [Finite ι]
    (U : ι → (affineSpec (A := A)).Opens)
    (hU : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ U i = U i)
    (hcover : (⨆ i, U i) = ⊤) (i : ι) :
    (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).X i =
      (quotientOpenFamily (k := k) (A := A) (G := G) U hU i).toScheme :=
  rfl

@[simp]
theorem quotientOpenCoverOfStable_f [Finite ι]
    (U : ι → (affineSpec (A := A)).Opens)
    (hU : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ U i = U i)
    (hcover : (⨆ i, U i) = ⊤) (i : ι) :
    (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).f i =
      (quotientOpenFamily (k := k) (A := A) (G := G) U hU i).ι :=
  rfl

@[reassoc (attr := simp)]
theorem quotientGlueData_ι_fromGlued [Finite ι]
    (U : ι → (affineSpec (A := A)).Opens)
    (hU : ∀ (i : ι) (g : G), (specAction G A g).hom ⁻¹ᵁ U i = U i)
    (hcover : (⨆ i, U i) = ⊤) (i : ι) :
    (quotientGlueDataOfStable (k := k) (A := A) (G := G) U hU hcover).ι i ≫
        (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).fromGlued =
      (quotientOpenFamily (k := k) (A := A) (G := G) U hU i).ι := by
  exact (quotientOpenCoverOfStable (k := k) (A := A) (G := G) U hU hcover).ι_fromGlued i

end StableOpenFamily

end InvariantLocalization
end MilneLib
