/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotientOpen
import MilneLib.Quotient.InvariantQuotientTransitionsOver

/-!
# Cross-coordinate compatibility for invariant quotient charts

An equivariant affine coordinate equivalence transports basic opens on the
source and on the invariant quotient.  The induced maps on the corresponding
restricted quotient charts form a commuting square.  This is the concrete
cross-coordinate overlap input for later finite gluing; it does not construct
a non-affine quotient.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry Topology TopologicalSpace

namespace MilneLib
namespace InvariantLocalization

variable {k A B G : Type u}
  [CommRing k] [CommRing A] [CommRing B] [Algebra k A] [Algebra k B]
  [Group G] [MulSemiringAction G A] [MulSemiringAction G B]
  [SMulCommClass G k A] [SMulCommClass G k B]

/-! ## Transport of basic opens -/

/-- A source basic open is transported by an affine coordinate equivalence. -/
@[simp]
theorem affineCoordinateIso_preimage_basicOpen
    (e : B ≃ₐ[k] A) (b : B) :
    (Spec.map (CommRingCat.ofHom e.toRingEquiv.toRingHom)) ⁻¹ᵁ
        (PrimeSpectrum.basicOpen b :
          (Spec (CommRingCat.of B)).Opens) =
      (PrimeSpectrum.basicOpen (e b) :
        (Spec (CommRingCat.of A)).Opens) := by
  rfl

/-- The induced quotient-chart isomorphism transports invariant basic opens. -/
@[simp]
theorem affineInvariantQuotientIso_preimage_basicOpen
    [Finite G]
    (e : B ≃ₐ[k] A)
    (hEquiv : ∀ (g : G) (b : B), g • e b = e (g • b))
    (b : FixedPoints.subalgebra k B G) :
    (affineInvariantQuotientIso (k := k) (G := G)
      e.toRingEquiv hEquiv).hom ⁻¹ᵁ
        (PrimeSpectrum.basicOpen b :
          (Spec (CommRingCat.of (FixedPoints.subalgebra k B G))).Opens) =
      (PrimeSpectrum.basicOpen
        (equivariantFixedRingEquiv (k := k) (G := G)
          e.toRingEquiv hEquiv b) :
        (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens) := by
  rw [affineInvariantQuotientIso_hom]
  rfl

/-- The quotient open descended from an invariant basic open is transported by
the quotient-chart isomorphism. -/
@[simp]
theorem affineInvariantQuotientIso_preimage_quotientOpenOfStable_basicOpen
    [Finite G]
    (e : B ≃ₐ[k] A)
    (hEquiv : ∀ (g : G) (b : B), g • e b = e (g • b))
    (b : FixedPoints.subalgebra k B G) :
    (affineInvariantQuotientIso (k := k) (G := G)
      e.toRingEquiv hEquiv).hom ⁻¹ᵁ
        quotientOpenOfStable (k := k) (A := B) (G := G)
          (PrimeSpectrum.basicOpen (b : B))
          (fun g => specAction_preimage_basicOpen_fixed b g) =
      quotientOpenOfStable (k := k) (A := A) (G := G)
        (PrimeSpectrum.basicOpen
          ((equivariantFixedRingEquiv (k := k) (G := G)
            e.toRingEquiv hEquiv b : _) : A))
        (fun g => specAction_preimage_basicOpen_fixed
          (equivariantFixedRingEquiv (k := k) (G := G)
            e.toRingEquiv hEquiv b) g) := by
  rw [quotientOpenOfStable_basicOpen_fixed,
    quotientOpenOfStable_basicOpen_fixed]
  exact affineInvariantQuotientIso_preimage_basicOpen e hEquiv b

/-! ## Isomorphisms on corresponding basic opens -/

/-- An equivariant affine coordinate equivalence restricts to the corresponding
source basic opens. -/
noncomputable def affineCoordinateBasicOpenIso
    [Finite G]
    (e : B ≃ₐ[k] A)
    (hEquiv : ∀ (g : G) (b : B), g • e b = e (g • b))
    (b : FixedPoints.subalgebra k B G) :
    let bA := equivariantFixedRingEquiv (k := k) (G := G)
      e.toRingEquiv hEquiv b
    let U : (Spec (CommRingCat.of A)).Opens :=
      PrimeSpectrum.basicOpen (bA : A)
    let V : (Spec (CommRingCat.of B)).Opens :=
      PrimeSpectrum.basicOpen (b : B)
    U.toScheme ≅ V.toScheme := by
  let bA := equivariantFixedRingEquiv (k := k) (G := G)
    e.toRingEquiv hEquiv b
  let U : (Spec (CommRingCat.of A)).Opens :=
    PrimeSpectrum.basicOpen (bA : A)
  let V : (Spec (CommRingCat.of B)).Opens :=
    PrimeSpectrum.basicOpen (b : B)
  let s := Spec.map e.toRingEquiv.toCommRingCatIso.hom
  have hSource : s ⁻¹ᵁ V = U := by
    dsimp [s, U, V, bA]
    rw [AlgebraicGeometry.SpecMap_preimage_basicOpen]
    change PrimeSpectrum.basicOpen (e (b : B)) =
      PrimeSpectrum.basicOpen
        ((equivariantFixedRingEquiv (k := k) (G := G)
          e.toRingEquiv hEquiv b : _) : A)
    rw [equivariantFixedRingEquiv_apply_coe]
    rfl
  exact ((Spec (CommRingCat.of A)).isoOfEq hSource.symm).trans
    (s.preimageIso V)

/-- The restricted source isomorphism agrees with the ambient affine
coordinate isomorphism after the open inclusions. -/
@[reassoc]
theorem affineCoordinateBasicOpenIso_hom_ι
    [Finite G]
    (e : B ≃ₐ[k] A)
    (hEquiv : ∀ (g : G) (b : B), g • e b = e (g • b))
    (b : FixedPoints.subalgebra k B G) :
    let bA := equivariantFixedRingEquiv (k := k) (G := G)
      e.toRingEquiv hEquiv b
    let U : (Spec (CommRingCat.of A)).Opens :=
      PrimeSpectrum.basicOpen (bA : A)
    let V : (Spec (CommRingCat.of B)).Opens :=
      PrimeSpectrum.basicOpen (b : B)
    (affineCoordinateBasicOpenIso (k := k) (G := G) e hEquiv b).hom ≫ V.ι =
      U.ι ≫ Spec.map (CommRingCat.ofHom e.toRingEquiv.toRingHom) := by
  dsimp
  unfold affineCoordinateBasicOpenIso
  simp

/-- The invariant quotient-chart isomorphism restricts to the quotient opens
descended from corresponding invariant basic opens. -/
noncomputable def affineInvariantQuotientBasicOpenIso
    [Finite G]
    (e : B ≃ₐ[k] A)
    (hEquiv : ∀ (g : G) (b : B), g • e b = e (g • b))
    (b : FixedPoints.subalgebra k B G) :
    let bA := equivariantFixedRingEquiv (k := k) (G := G)
      e.toRingEquiv hEquiv b
    let U : (Spec (CommRingCat.of A)).Opens :=
      PrimeSpectrum.basicOpen (bA : A)
    let V : (Spec (CommRingCat.of B)).Opens :=
      PrimeSpectrum.basicOpen (b : B)
    let hU : ∀ (g : G), (specAction G A g).hom ⁻¹ᵁ U = U :=
      fun g => specAction_preimage_basicOpen_fixed bA g
    let hV : ∀ (g : G), (specAction G B g).hom ⁻¹ᵁ V = V :=
      fun g => specAction_preimage_basicOpen_fixed b g
    let WU := quotientOpenOfStable (k := k) (A := A) (G := G) U hU
    let WV := quotientOpenOfStable (k := k) (A := B) (G := G) V hV
    WU.toScheme ≅ WV.toScheme := by
  let bA := equivariantFixedRingEquiv (k := k) (G := G)
    e.toRingEquiv hEquiv b
  let U : (Spec (CommRingCat.of A)).Opens :=
    PrimeSpectrum.basicOpen (bA : A)
  let V : (Spec (CommRingCat.of B)).Opens :=
    PrimeSpectrum.basicOpen (b : B)
  let hU : ∀ (g : G), (specAction G A g).hom ⁻¹ᵁ U = U :=
    fun g => specAction_preimage_basicOpen_fixed bA g
  let hV : ∀ (g : G), (specAction G B g).hom ⁻¹ᵁ V = V :=
    fun g => specAction_preimage_basicOpen_fixed b g
  let WU := quotientOpenOfStable (k := k) (A := A) (G := G) U hU
  let WV := quotientOpenOfStable (k := k) (A := B) (G := G) V hV
  let t := affineInvariantQuotientIso (k := k) (G := G)
    e.toRingEquiv hEquiv
  have hQuotient : t.hom ⁻¹ᵁ WV = WU := by
    dsimp [t, WU, WV, U, V, hU, hV, bA]
    exact affineInvariantQuotientIso_preimage_quotientOpenOfStable_basicOpen
      (k := k) (G := G) e hEquiv b
  exact ((Spec (CommRingCat.of
      (FixedPoints.subalgebra k A G))).isoOfEq hQuotient.symm).trans
    (t.hom.preimageIso WV)

/-- The restricted quotient isomorphism agrees with the ambient invariant
quotient-chart isomorphism after the open inclusions. -/
@[reassoc]
theorem affineInvariantQuotientBasicOpenIso_hom_ι
    [Finite G]
    (e : B ≃ₐ[k] A)
    (hEquiv : ∀ (g : G) (b : B), g • e b = e (g • b))
    (b : FixedPoints.subalgebra k B G) :
    let bA := equivariantFixedRingEquiv (k := k) (G := G)
      e.toRingEquiv hEquiv b
    let U : (Spec (CommRingCat.of A)).Opens :=
      PrimeSpectrum.basicOpen (bA : A)
    let V : (Spec (CommRingCat.of B)).Opens :=
      PrimeSpectrum.basicOpen (b : B)
    let hU : ∀ (g : G), (specAction G A g).hom ⁻¹ᵁ U = U :=
      fun g => specAction_preimage_basicOpen_fixed bA g
    let hV : ∀ (g : G), (specAction G B g).hom ⁻¹ᵁ V = V :=
      fun g => specAction_preimage_basicOpen_fixed b g
    let WU := quotientOpenOfStable (k := k) (A := A) (G := G) U hU
    let WV := quotientOpenOfStable (k := k) (A := B) (G := G) V hV
    (affineInvariantQuotientBasicOpenIso
        (k := k) (G := G) e hEquiv b).hom ≫ WV.ι =
      WU.ι ≫ (affineInvariantQuotientIso (k := k) (G := G)
        e.toRingEquiv hEquiv).hom := by
  dsimp
  unfold affineInvariantQuotientBasicOpenIso
  simp

/-- The affine invariant quotient maps on corresponding basic opens commute
with the restricted source and quotient isomorphisms. -/
@[reassoc]
theorem affineInvariantQuotientMapRestrict_basicOpen_iso_naturality
    [Finite G]
    (e : B ≃ₐ[k] A)
    (hEquiv : ∀ (g : G) (b : B), g • e b = e (g • b))
    (b : FixedPoints.subalgebra k B G) :
    let bA := equivariantFixedRingEquiv (k := k) (G := G)
      e.toRingEquiv hEquiv b
    let U : (Spec (CommRingCat.of A)).Opens :=
      PrimeSpectrum.basicOpen (bA : A)
    let V : (Spec (CommRingCat.of B)).Opens :=
      PrimeSpectrum.basicOpen (b : B)
    let hU : ∀ (g : G), (specAction G A g).hom ⁻¹ᵁ U = U :=
      fun g => specAction_preimage_basicOpen_fixed bA g
    let hV : ∀ (g : G), (specAction G B g).hom ⁻¹ᵁ V = V :=
      fun g => specAction_preimage_basicOpen_fixed b g
    affineInvariantQuotientMapRestrictStable
        (k := k) (A := A) (G := G) U hU ≫
      (affineInvariantQuotientBasicOpenIso
        (k := k) (G := G) e hEquiv b).hom =
    (affineCoordinateBasicOpenIso (k := k) (G := G) e hEquiv b).hom ≫
      affineInvariantQuotientMapRestrictStable
        (k := k) (A := B) (G := G) V hV := by
  dsimp
  let bA : FixedPoints.subalgebra k A G :=
    equivariantFixedRingEquiv (k := k) (G := G)
      e.toRingEquiv hEquiv b
  let U : (Spec (CommRingCat.of A)).Opens :=
    PrimeSpectrum.basicOpen (bA : A)
  let V : (Spec (CommRingCat.of B)).Opens :=
    PrimeSpectrum.basicOpen (b : B)
  let hU : ∀ (g : G), (specAction G A g).hom ⁻¹ᵁ U = U :=
    fun g => specAction_preimage_basicOpen_fixed bA g
  let hV : ∀ (g : G), (specAction G B g).hom ⁻¹ᵁ V = V :=
    fun g => specAction_preimage_basicOpen_fixed b g
  let qA := affineInvariantQuotientMapRestrictStable
    (k := k) (A := A) (G := G) U hU
  let qB := affineInvariantQuotientMapRestrictStable
    (k := k) (A := B) (G := G) V hV
  let WU := quotientOpenOfStable (k := k) (A := A) (G := G) U hU
  let WV := quotientOpenOfStable (k := k) (A := B) (G := G) V hV
  let s := Spec.map (CommRingCat.ofHom e.toRingEquiv.toRingHom)
  let t := (affineInvariantQuotientIso (k := k) (G := G)
    e.toRingEquiv hEquiv).hom
  change qA ≫ (affineInvariantQuotientBasicOpenIso
      (k := k) (G := G) e hEquiv b).hom =
    (affineCoordinateBasicOpenIso
      (k := k) (G := G) e hEquiv b).hom ≫ qB
  apply (cancel_mono WV.ι).1
  calc
    (qA ≫ (affineInvariantQuotientBasicOpenIso
        (k := k) (G := G) e hEquiv b).hom) ≫ WV.ι =
        qA ≫ ((affineInvariantQuotientBasicOpenIso
          (k := k) (G := G) e hEquiv b).hom ≫ WV.ι) :=
      Category.assoc _ _ _
    _ = qA ≫ (WU.ι ≫ t) := by
      rw [affineInvariantQuotientBasicOpenIso_hom_ι]
    _ = (qA ≫ WU.ι) ≫ t := (Category.assoc _ _ _).symm
    _ = (U.ι ≫ affineInvariantQuotientMap
        (k := k) (A := A) (G := G)) ≫ t := by
      rw [affineInvariantQuotientMapRestrictStable_fac]
    _ = U.ι ≫ (affineInvariantQuotientMap
        (k := k) (A := A) (G := G) ≫ t) := Category.assoc _ _ _
    _ = U.ι ≫ (s ≫ affineInvariantQuotientMap
        (k := k) (A := B) (G := G)) := by
      rw [affineInvariantQuotientMap_comp_iso]
    _ = (U.ι ≫ s) ≫ affineInvariantQuotientMap
        (k := k) (A := B) (G := G) :=
      (Category.assoc _ _ _).symm
    _ = ((affineCoordinateBasicOpenIso
          (k := k) (G := G) e hEquiv b).hom ≫ V.ι) ≫
        affineInvariantQuotientMap
          (k := k) (A := B) (G := G) := by
      rw [affineCoordinateBasicOpenIso_hom_ι]
    _ = (affineCoordinateBasicOpenIso
          (k := k) (G := G) e hEquiv b).hom ≫
        (V.ι ≫ affineInvariantQuotientMap
          (k := k) (A := B) (G := G)) := Category.assoc _ _ _
    _ = (affineCoordinateBasicOpenIso
          (k := k) (G := G) e hEquiv b).hom ≫ (qB ≫ WV.ι) := by
      rw [affineInvariantQuotientMapRestrictStable_fac]
    _ = ((affineCoordinateBasicOpenIso
          (k := k) (G := G) e hEquiv b).hom ≫ qB) ≫ WV.ι :=
      (Category.assoc _ _ _).symm

/-! ## The restricted overlap square -/

/-- For stable opens in two equivariantly equivalent affine presentations, the
restricted quotient maps commute with the induced restricted coordinate map.
The two preimage inequalities are explicit because `resLE` depends on them. -/
theorem affineInvariantQuotientMapRestrictStable_resLE_naturality
    [Finite G]
    (e : B ≃ₐ[k] A)
    (hEquiv : ∀ (g : G) (b : B), g • e b = e (g • b))
    {U : (Spec (CommRingCat.of A)).Opens}
    {V : (Spec (CommRingCat.of B)).Opens}
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U)
    (hV : ∀ g : G, (specAction G B g).hom ⁻¹ᵁ V = V)
    (hSource : U ≤
      (Spec.map (CommRingCat.ofHom e.toRingEquiv.toRingHom)) ⁻¹ᵁ V)
    (hQuotient :
      quotientOpenOfStable (k := k) (A := A) (G := G) U hU ≤
        (affineInvariantQuotientIso (k := k) (G := G)
          e.toRingEquiv hEquiv).hom ⁻¹ᵁ
          quotientOpenOfStable (k := k) (A := B) (G := G) V hV) :
    affineInvariantQuotientMapRestrictStable
        (k := k) (A := A) (G := G) U hU ≫
      (affineInvariantQuotientIso (k := k) (G := G)
        e.toRingEquiv hEquiv).hom.resLE
        (quotientOpenOfStable (k := k) (A := B) (G := G) V hV)
        (quotientOpenOfStable (k := k) (A := A) (G := G) U hU)
        hQuotient =
      (Spec.map (CommRingCat.ofHom e.toRingEquiv.toRingHom)).resLE
        V U hSource ≫
        affineInvariantQuotientMapRestrictStable
          (k := k) (A := B) (G := G) V hV := by
  let qA := affineInvariantQuotientMapRestrictStable
    (k := k) (A := A) (G := G) U hU
  let qB := affineInvariantQuotientMapRestrictStable
    (k := k) (A := B) (G := G) V hV
  let t := (affineInvariantQuotientIso (k := k) (G := G)
    e.toRingEquiv hEquiv).hom
  let s := Spec.map (CommRingCat.ofHom e.toRingEquiv.toRingHom)
  let WU := quotientOpenOfStable (k := k) (A := A) (G := G) U hU
  let WV := quotientOpenOfStable (k := k) (A := B) (G := G) V hV
  change qA ≫ t.resLE WV WU hQuotient = s.resLE V U hSource ≫ qB
  apply (cancel_mono WV.ι).1
  calc
    (qA ≫ t.resLE WV WU hQuotient) ≫ WV.ι =
        qA ≫ (t.resLE WV WU hQuotient ≫ WV.ι) :=
      Category.assoc _ _ _
    _ = qA ≫ (WU.ι ≫ t) := by
      rw [Scheme.Hom.resLE_comp_ι]
    _ = (qA ≫ WU.ι) ≫ t := (Category.assoc _ _ _).symm
    _ = (U.ι ≫ affineInvariantQuotientMap
        (k := k) (A := A) (G := G)) ≫ t := by
      rw [affineInvariantQuotientMapRestrictStable_fac]
    _ = U.ι ≫ (affineInvariantQuotientMap
        (k := k) (A := A) (G := G) ≫ t) := Category.assoc _ _ _
    _ = U.ι ≫ (s ≫ affineInvariantQuotientMap
        (k := k) (A := B) (G := G)) := by
      rw [affineInvariantQuotientMap_comp_iso]
    _ = (U.ι ≫ s) ≫ affineInvariantQuotientMap
        (k := k) (A := B) (G := G) :=
      (Category.assoc _ _ _).symm
    _ = (s.resLE V U hSource ≫ V.ι) ≫
        affineInvariantQuotientMap (k := k) (A := B) (G := G) := by
      rw [Scheme.Hom.resLE_comp_ι]
    _ = s.resLE V U hSource ≫ (V.ι ≫
        affineInvariantQuotientMap (k := k) (A := B) (G := G)) :=
      Category.assoc _ _ _
    _ = s.resLE V U hSource ≫ (qB ≫ WV.ι) := by
      rw [affineInvariantQuotientMapRestrictStable_fac]
    _ = (s.resLE V U hSource ≫ qB) ≫ WV.ι :=
      (Category.assoc _ _ _).symm

/-! ## A concrete basic-open overlap witness -/

/-- For a globally equivariantly equivalent pair of affine presentations, every
invariant basic open has corresponding source and quotient inclusion witnesses
and a commuting square of restricted quotient maps.  This is the concrete
coordinate-compatibility producer; it does not construct the open-immersion or
cocycle fields required by `InvariantQuotientCrossChartDatum`, and it does not
construct a global quotient. -/
theorem affineInvariantQuotient_basicOpen_crossChart
    [Finite G]
    (e : B ≃ₐ[k] A)
    (hEquiv : ∀ (g : G) (b : B), g • e b = e (g • b))
    (b : FixedPoints.subalgebra k B G) :
    let eR := e.toRingEquiv
    let hR : ∀ (g : G) (b : B), g • eR b = eR (g • b) := hEquiv
    let bA := equivariantFixedRingEquiv (k := k) (G := G) eR hR b
    let U : (Spec (CommRingCat.of A)).Opens :=
      PrimeSpectrum.basicOpen (bA : A)
    let V : (Spec (CommRingCat.of B)).Opens :=
      PrimeSpectrum.basicOpen (b : B)
    let hU : ∀ (g : G), (specAction G A g).hom ⁻¹ᵁ U = U :=
      fun g => specAction_preimage_basicOpen_fixed bA g
    let hV : ∀ (g : G), (specAction G B g).hom ⁻¹ᵁ V = V :=
      fun g => specAction_preimage_basicOpen_fixed b g
    let WU := quotientOpenOfStable (k := k) (A := A) (G := G) U hU
    let WV := quotientOpenOfStable (k := k) (A := B) (G := G) V hV
    let s := Spec.map (CommRingCat.ofHom eR.toRingHom)
    let t := (affineInvariantQuotientIso (k := k) (G := G)
      eR hR).hom
    ∃ hSource : U ≤ s ⁻¹ᵁ V, ∃ hQuotient : WU ≤ t ⁻¹ᵁ WV,
      affineInvariantQuotientMapRestrictStable
          (k := k) (A := A) (G := G) U hU ≫
        t.resLE WV WU hQuotient =
      s.resLE V U hSource ≫
        affineInvariantQuotientMapRestrictStable
          (k := k) (A := B) (G := G) V hV := by
  dsimp
  let eR := e.toRingEquiv
  let hR : ∀ (g : G) (b : B), g • eR b = eR (g • b) := hEquiv
  let bA : FixedPoints.subalgebra k A G :=
    equivariantFixedRingEquiv (k := k) (G := G) eR hR b
  let U : (Spec (CommRingCat.of A)).Opens :=
    PrimeSpectrum.basicOpen (bA : A)
  let V : (Spec (CommRingCat.of B)).Opens :=
    PrimeSpectrum.basicOpen (b : B)
  let hU : ∀ (g : G), (specAction G A g).hom ⁻¹ᵁ U = U :=
    fun g => specAction_preimage_basicOpen_fixed bA g
  let hV : ∀ (g : G), (specAction G B g).hom ⁻¹ᵁ V = V :=
    fun g => specAction_preimage_basicOpen_fixed b g
  let WU := quotientOpenOfStable (k := k) (A := A) (G := G) U hU
  let WV := quotientOpenOfStable (k := k) (A := B) (G := G) V hV
  let s := Spec.map (CommRingCat.ofHom eR.toRingHom)
  let t := (affineInvariantQuotientIso (k := k) (G := G)
    eR hR).hom
  have hSourceEq : s ⁻¹ᵁ V = U := by
    rw [AlgebraicGeometry.SpecMap_preimage_basicOpen]
    change PrimeSpectrum.basicOpen (e (b : B)) =
      PrimeSpectrum.basicOpen (bA : A)
    rw [equivariantFixedRingEquiv_apply_coe]
    rfl
  have hSource : U ≤ s ⁻¹ᵁ V := by
    rw [hSourceEq]
  have hQuotientEq : t ⁻¹ᵁ WV = WU := by
    dsimp [t, WU, WV, U, V, hU, hV, bA]
    rw [quotientOpenOfStable_basicOpen_fixed,
      quotientOpenOfStable_basicOpen_fixed]
    rw [affineInvariantQuotientIso_hom]
    rfl
  have hQuotient : WU ≤ t ⁻¹ᵁ WV := by
    rw [hQuotientEq]
  refine ⟨hSource, hQuotient, ?_⟩
  change
    affineInvariantQuotientMapRestrictStable
        (k := k) (A := A) (G := G) U hU ≫
      t.resLE WV WU hQuotient =
    s.resLE V U hSource ≫
      affineInvariantQuotientMapRestrictStable
        (k := k) (A := B) (G := G) V hV
  have hQuotientIso :
      (affineInvariantQuotientBasicOpenIso
          (k := k) (G := G) e hEquiv b).hom =
        t.resLE WV WU hQuotient := by
    apply (cancel_mono WV.ι).1
    rw [affineInvariantQuotientBasicOpenIso_hom_ι,
      Scheme.Hom.resLE_comp_ι]
  have hSourceIso :
      (affineCoordinateBasicOpenIso
          (k := k) (G := G) e hEquiv b).hom =
        s.resLE V U hSource := by
    apply (cancel_mono V.ι).1
    rw [affineCoordinateBasicOpenIso_hom_ι,
      Scheme.Hom.resLE_comp_ι]
  rw [← hQuotientIso, ← hSourceIso]
  exact affineInvariantQuotientMapRestrict_basicOpen_iso_naturality
    (k := k) (G := G) e hEquiv b

end InvariantLocalization
end MilneLib
