/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientOpen

/-!
# Transitions between stable-open quotient charts

For nested stable opens in an affine scheme, this file packages the canonical open-subscheme
maps on the source and on the descended quotient.  The restricted affine invariant quotient maps
form a commuting square, and the transition maps satisfy the expected composition and identity
laws.  No non-affine quotient existence is used here.
-/

set_option autoImplicit false

universe u v

open CategoryTheory AlgebraicGeometry Topology TopologicalSpace

namespace MilneLib
namespace InvariantLocalization

variable {k : Type u} {A : Type v} {G : Type*}
  [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

/-! ## Source and quotient transitions -/

/-- The canonical transition between nested open subschemes of the affine source. -/
noncomputable def stableOpenHom
    {U V : (Spec (CommRingCat.of A)).Opens} (hUV : U ≤ V) : U.toScheme ⟶ V.toScheme :=
  (Spec (CommRingCat.of A)).homOfLE hUV

@[simp, reassoc]
theorem stableOpenHom_ι
    {U V : (Spec (CommRingCat.of A)).Opens} (hUV : U ≤ V) :
    stableOpenHom (A := A) hUV ≫ V.ι = U.ι := by
  change (Spec (CommRingCat.of A)).homOfLE hUV ≫ V.ι = U.ι
  exact Scheme.homOfLE_ι (Spec (CommRingCat.of A)) hUV

/-- The canonical transition between the descended quotient opens attached to
nested stable opens. -/
noncomputable def quotientOpenOfStableHom [Finite G]
    {U V : (Spec (CommRingCat.of A)).Opens}
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U)
    (hV : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ V = V)
    (hUV : U ≤ V) :
  (quotientOpenOfStable (k := k) (A := A) (G := G) U hU).toScheme ⟶
      (quotientOpenOfStable (k := k) (A := A) (G := G) V hV).toScheme :=
  (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).homOfLE
    (quotientOpenOfStable_mono (k := k) (A := A) (G := G) hU hV hUV)

@[simp, reassoc]
theorem quotientOpenOfStableHom_ι [Finite G]
    {U V : (Spec (CommRingCat.of A)).Opens}
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U)
    (hV : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ V = V)
    (hUV : U ≤ V) :
    quotientOpenOfStableHom (k := k) (A := A) (G := G) hU hV hUV ≫
        (quotientOpenOfStable (k := k) (A := A) (G := G) V hV).ι =
      (quotientOpenOfStable (k := k) (A := A) (G := G) U hU).ι := by
  change (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).homOfLE _ ≫
      (quotientOpenOfStable (k := k) (A := A) (G := G) V hV).ι = _
  exact Scheme.homOfLE_ι (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))) _

/-! ## The overlap square -/

/-- Restriction of the affine invariant quotient map is natural for nested stable opens. -/
@[reassoc]
theorem affineInvariantQuotientMapRestrictStable_naturality [Finite G]
    {U V : (Spec (CommRingCat.of A)).Opens}
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U)
    (hV : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ V = V)
    (hUV : U ≤ V) :
    stableOpenHom (A := A) hUV ≫
        affineInvariantQuotientMapRestrictStable (k := k) (A := A) (G := G) V hV =
      affineInvariantQuotientMapRestrictStable (k := k) (A := A) (G := G) U hU ≫
        quotientOpenOfStableHom (k := k) (A := A) (G := G) hU hV hUV := by
  rw [← cancel_mono (quotientOpenOfStable (k := k) (A := A) (G := G) V hV).ι]
  simp only [Category.assoc, affineInvariantQuotientMapRestrictStable_fac]
  rw [← Category.assoc, stableOpenHom_ι]
  rw [quotientOpenOfStableHom_ι, affineInvariantQuotientMapRestrictStable_fac]

/-! ## Composition and identity laws -/

@[simp, reassoc]
theorem stableOpenHom_comp
    {U V W : (Spec (CommRingCat.of A)).Opens}
    (hUV : U ≤ V) (hVW : V ≤ W) :
    stableOpenHom (A := A) hUV ≫ stableOpenHom (A := A) hVW =
      stableOpenHom (A := A) (hUV.trans hVW) := by
  change (Spec (CommRingCat.of A)).homOfLE hUV ≫
      (Spec (CommRingCat.of A)).homOfLE hVW =
    (Spec (CommRingCat.of A)).homOfLE (hUV.trans hVW)
  exact Scheme.homOfLE_homOfLE (Spec (CommRingCat.of A)) hUV hVW

@[simp]
theorem stableOpenHom_id (U : (Spec (CommRingCat.of A)).Opens) :
    stableOpenHom (A := A) (le_refl U) = 𝟙 U.toScheme := by
  change (Spec (CommRingCat.of A)).homOfLE (le_refl U) = 𝟙 U.toScheme
  exact Scheme.homOfLE_rfl (Spec (CommRingCat.of A)) U

@[simp, reassoc]
theorem quotientOpenOfStableHom_comp [Finite G]
    {U V W : (Spec (CommRingCat.of A)).Opens}
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U)
    (hV : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ V = V)
    (hW : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ W = W)
    (hUV : U ≤ V) (hVW : V ≤ W) :
    quotientOpenOfStableHom (k := k) (A := A) (G := G) hU hV hUV ≫
        quotientOpenOfStableHom (k := k) (A := A) (G := G) hV hW hVW =
      quotientOpenOfStableHom (k := k) (A := A) (G := G) hU hW (hUV.trans hVW) := by
  change (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).homOfLE _ ≫
      (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).homOfLE _ =
    (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).homOfLE _
  rw [Scheme.homOfLE_homOfLE]

@[simp]
theorem quotientOpenOfStableHom_id [Finite G]
    (U : (Spec (CommRingCat.of A)).Opens)
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U) :
    quotientOpenOfStableHom (k := k) (A := A) (G := G) hU hU (le_refl U) =
      𝟙 (quotientOpenOfStable (k := k) (A := A) (G := G) U hU).toScheme := by
  change (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).homOfLE _ = 𝟙 _
  exact Scheme.homOfLE_rfl (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))) _

end InvariantLocalization
end MilneLib
