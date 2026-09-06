/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.AlgebraicGeometry.AffineScheme
import Mathlib.AlgebraicGeometry.OpenImmersion
import Mathlib.AlgebraicGeometry.Morphisms.IsIso
import Mathlib.AlgebraicGeometry.Restrict
import MilneLib.Affine.InvariantLocalization
import MilneLib.Quotient.InvariantQuotientNormOpen
import MilneLib.Quotient.InvariantQuotientOpenEmbedding
import MilneLib.Quotient.InvariantQuotientTransitions

/-!
# Open immersions on principal affine charts

This file records the scheme-theoretic producer used by the invariant quotient
charts.  A bijective localization-away map identifies the restricted spectrum
map with an isomorphism, hence gives an open immersion.  The localization
hypothesis is explicit; no quotient-existence or global invariant-theory
assumption is hidden in the statement.
-/

set_option autoImplicit false

open CategoryTheory AlgebraicGeometry Topology

namespace MilneLib
namespace InvariantLocalization

universe u v w

variable {G : Type u} {A : Type v} {B : Type w}
  [Group G] [CommRing A] [CommRing B]
  [MulSemiringAction G A] [MulSemiringAction G B]

/-! ## Equivariant localization -/

/-- The canonical map between away localizations agrees with the coefficient
map on elements coming from the source ring. -/
theorem localizationAwayMap_algebraMap
    (f : B →+* A) (b a : B) :
    Localization.awayMap f b (algebraMap B (Localization.Away b) a) =
      algebraMap A (Localization.Away (f b)) (f a) := by
  let hpow : Submonoid.powers b ≤
      Submonoid.comap f (Submonoid.powers (f b)) := by
    rintro _ ⟨n, rfl⟩
    exact ⟨n, (map_pow f b n).symm⟩
  simpa only [Localization.awayMap, IsLocalization.Away.map] using
    (IsLocalization.map_eq (Q := Localization.Away (f b)) hpow a)

/-- Localization at an invariant element preserves equivariance. -/
theorem localizationAwayMap_equivariant
    (f : B →+* A)
    (hf : ∀ (g : G) (a : B), g • f a = f (g • a))
    (b : B) (hb : ∀ g : G, g • b = b) (g : G) :
    let hfb : ∀ g : G, g • f b = f b :=
      fun g => (hf g b).trans (congrArg f (hb g))
    (awayMap (f b) hfb g).comp (Localization.awayMap f b) =
      (Localization.awayMap f b).comp (awayMap b hb g) := by
  dsimp only
  refine IsLocalization.ringHom_ext (Submonoid.powers b) ?_
  ext a
  simp only [RingHom.coe_comp, Function.comp_apply]
  rw [localizationAwayMap_algebraMap]
  rw [awayMap_algebraMap]
  rw [hf]
  rw [← localizationAwayMap_algebraMap]
  rw [awayMap_algebraMap]

/-- An equivariant localization map restricts to the fixed subrings. -/
noncomputable def fixedAwayMap
    (f : B →+* A)
    (hf : ∀ (g : G) (a : B), g • f a = f (g • a))
    (b : B) (hb : ∀ g : G, g • b = b) :
    let hfb : ∀ g : G, g • f b = f b :=
      fun g => (hf g b).trans (congrArg f (hb g))
    fixedAway b hb →+* fixedAway (f b) hfb := by
  let hfb : ∀ g : G, g • f b = f b :=
    fun g => (hf g b).trans (congrArg f (hb g))
  refine ((Localization.awayMap f b).comp (fixedAway b hb).subtype).codRestrict
    (fixedAway (f b) hfb) ?_
  intro x
  rw [mem_fixedAway]
  intro g
  have hcomm := DFunLike.congr_fun
    (localizationAwayMap_equivariant f hf b hb g) x.1
  change awayMap (f b) hfb g (Localization.awayMap f b x.1) =
    Localization.awayMap f b x.1
  calc
    awayMap (f b) hfb g (Localization.awayMap f b x.1) =
        Localization.awayMap f b (awayMap b hb g x.1) := by
      simpa only [RingHom.comp_apply] using hcomm
    _ = Localization.awayMap f b x.1 := congrArg _ (x.2 g)

/-- A bijective equivariant localization map induces a bijection on its fixed
subrings. -/
theorem fixedAwayMap_bijective
    (f : B →+* A)
    (hf : ∀ (g : G) (a : B), g • f a = f (g • a))
    (b : B) (hb : ∀ g : G, g • b = b)
    (hmap : Function.Bijective (Localization.awayMap f b)) :
    Function.Bijective (fixedAwayMap f hf b hb) := by
  constructor
  · intro x y hxy
    apply Subtype.ext
    apply hmap.1
    exact congrArg Subtype.val hxy
  · intro y
    obtain ⟨x, hx⟩ := hmap.2 y.1
    have hxfixed : x ∈ fixedAway b hb := by
      rw [mem_fixedAway]
      intro g
      apply hmap.1
      have hcomm := DFunLike.congr_fun
        (localizationAwayMap_equivariant f hf b hb g) x
      calc
        Localization.awayMap f b (awayMap b hb g x) =
            awayMap (f b)
              (fun g => (hf g b).trans (congrArg f (hb g))) g
              (Localization.awayMap f b x) := by
          simpa only [RingHom.comp_apply] using hcomm.symm
        _ = awayMap (f b)
              (fun g => (hf g b).trans (congrArg f (hb g))) g y.1 := by
          rw [hx]
        _ = y.1 := y.2 g
        _ = Localization.awayMap f b x := hx.symm
    refine ⟨⟨x, hxfixed⟩, ?_⟩
    apply Subtype.ext
    exact hx

/-- If an equivariant localization map is bijective, then so is the induced
localization map between the invariant subrings. -/
theorem localizationAwayMap_fixedRing_bijective
    {k A' B' G' : Type u} [CommRing k] [CommRing A'] [CommRing B']
    [Algebra k A'] [Algebra k B'] [Group G']
    [MulSemiringAction G' A'] [MulSemiringAction G' B']
    [SMulCommClass G' k A'] [SMulCommClass G' k B'] [Finite G']
    (f : B' →+* A')
    (hf : ∀ (g : G') (a : B'), g • f a = f (g • a))
    (b : FixedPoints.subalgebra k B' G')
    (hmap : Function.Bijective (Localization.awayMap f (b : B'))) :
    Function.Bijective (Localization.awayMap
      (equivariantFixedRingHom (k := k) (G := G') f hf) b) := by
  let fG := equivariantFixedRingHom (k := k) (G := G') f hf
  let bA := fG b
  let eB := localizationAwayFixedRingEquiv b
  let eA := localizationAwayFixedRingEquiv bA
  have hcomm :
      eA.toRingHom.comp (Localization.awayMap fG b) =
        (fixedAwayMap f hf (b : B') b.property).comp eB.toRingHom := by
    refine IsLocalization.ringHom_ext (Submonoid.powers b) ?_
    ext a
    simp only [RingHom.comp_apply]
    rw [localizationAwayMap_algebraMap]
    have hEA : eA (algebraMap (FixedPoints.subalgebra k A' G')
        (Localization.Away bA) (fG a)) = invariantToFixedAway bA (fG a) :=
      localizationAwayFixedRingEquiv_algebraMap bA (fG a)
    change (eA (algebraMap (FixedPoints.subalgebra k A' G')
      (Localization.Away bA) (fG a))).1 = _
    rw [hEA]
    have hEB : eB (algebraMap (FixedPoints.subalgebra k B' G')
        (Localization.Away b) a) = invariantToFixedAway b a :=
      localizationAwayFixedRingEquiv_algebraMap b a
    change ((invariantToFixedAway bA) (fG a)).1 =
      ((fixedAwayMap f hf (b : B') b.property)
        (eB (algebraMap (FixedPoints.subalgebra k B' G')
          (Localization.Away b) a))).1
    rw [hEB]
    change algebraMap A' (Localization.Away (f (b : B'))) (f (a : B')) =
      Localization.awayMap f (b : B')
        (algebraMap B' (Localization.Away (b : B')) (a : B'))
    rw [localizationAwayMap_algebraMap]
  have hbottom := fixedAwayMap_bijective f hf (b : B') b.property hmap
  have hright : Function.Bijective
      ((fixedAwayMap f hf (b : B') b.property).comp eB.toRingHom) :=
    hbottom.comp eB.bijective
  have hleft : Function.Bijective
      (eA.toRingHom.comp (Localization.awayMap fG b)) := by
    rw [hcomm]
    exact hright
  change Function.Bijective (Localization.awayMap fG b)
  exact (eA.bijective.of_comp_iff' _).mp hleft

/-- For an affine open immersion, localizing over a target basic open contained
in its range gives a ring isomorphism. -/
theorem localizationAwayMap_bijective_of_basicOpen_le_opensRange
    {R S : CommRingCat.{u}} (f : R ⟶ S) (r : R)
    [IsOpenImmersion (Spec.map f)]
    (hr : (PrimeSpectrum.basicOpen r : (Spec R).Opens) ≤
      (Spec.map f).opensRange) :
    Function.Bijective (Localization.awayMap f.hom r) := by
  let F : Spec S ⟶ Spec R := Spec.map f
  let U : (Spec R).Opens := PrimeSpectrum.basicOpen r
  have hsurj : Function.Surjective (F ∣_ U).base := by
    intro y
    have hy : (y.1 : Spec R) ∈ F.opensRange := hr y.property
    obtain ⟨x, hx⟩ := hy
    let x' : (F ⁻¹ᵁ U).toScheme := ⟨x, by
      change F.base x ∈ U
      rw [hx]
      exact y.property⟩
    refine ⟨x', ?_⟩
    apply Subtype.ext
    exact (morphismRestrict_base_coe F U x').trans hx
  have hopen : (F ∣_ U).opensRange = ⊤ := by
    apply TopologicalSpace.Opens.ext
    ext y
    constructor
    · intro _
      trivial
    · intro _
      exact Scheme.Hom.mem_opensRange.mpr (hsurj y)
  haveI : IsIso (F ∣_ U) :=
    isIso_of_isOpenImmersion_of_opensRange_eq_top (F ∣_ U) hopen
  haveI : IsIso (Spec.map (CommRingCat.ofHom
      (Localization.awayMap f.hom r))) := by
    have hArrow := SpecMapRestrictBasicOpenIso f r
    haveI : IsIso (Spec.map f ∣_ U) := inferInstance
    exact (MorphismProperty.isomorphisms Scheme).arrow_mk_iso_iff hArrow |>.mp
      inferInstance
  exact isIso_SpecMap_iff.mp (inferInstance :
    IsIso (Spec.map (CommRingCat.ofHom (Localization.awayMap f.hom r))))

/-- A spectrum map restricts to an open immersion on a principal chart whenever
the corresponding localization-away ring map is bijective. -/
theorem isOpenImmersion_restrictBasicOpen_of_bijective
    {R S : CommRingCat} (f : R ⟶ S) (r : R)
    (h : Function.Bijective (Localization.awayMap f.hom r)) :
    IsOpenImmersion (Spec.map f ∣_ (PrimeSpectrum.basicOpen r)) := by
  rw [MorphismProperty.arrow_mk_iso_iff @IsOpenImmersion
    (SpecMapRestrictBasicOpenIso f r)]
  haveI : IsIso (Spec.map (CommRingCat.ofHom
      (Localization.awayMap f.hom r))) :=
    (isIso_SpecMap_iff.mpr h)
  infer_instance

/-- An equivariant affine open immersion remains an open immersion after
passing to fixed rings and restricting over an invariant basic open contained
in the original range. -/
theorem isOpenImmersion_fixedRing_restrictBasicOpen
    {k A' B' G' : Type u} [CommRing k] [CommRing A'] [CommRing B']
    [Algebra k A'] [Algebra k B'] [Group G']
    [MulSemiringAction G' A'] [MulSemiringAction G' B']
    [SMulCommClass G' k A'] [SMulCommClass G' k B'] [Finite G']
    (f : B' →+* A')
    (hf : ∀ (g : G') (a : B'), g • f a = f (g • a))
    [IsOpenImmersion (Spec.map (CommRingCat.ofHom f))]
    (b : FixedPoints.subalgebra k B' G')
    (hb : (PrimeSpectrum.basicOpen (b : B') :
      (Spec (CommRingCat.of B')).Opens) ≤
        (Spec.map (CommRingCat.ofHom f)).opensRange) :
    IsOpenImmersion
      (Spec.map (CommRingCat.ofHom
        (equivariantFixedRingHom (k := k) (G := G') f hf)) ∣_
          PrimeSpectrum.basicOpen b) := by
  apply isOpenImmersion_restrictBasicOpen_of_bijective
  apply localizationAwayMap_fixedRing_bijective f hf b
  exact localizationAwayMap_bijective_of_basicOpen_le_opensRange
    (CommRingCat.ofHom f) (b : B') hb

/-- An equivariant affine open immersion with stable range descends to an open
immersion between the affine invariant quotients. -/
theorem equivariantFixedSpecMap_isOpenImmersion
    {k A' B' G' : Type u} [CommRing k] [CommRing A'] [CommRing B']
    [Algebra k A'] [Algebra k B'] [Group G']
    [MulSemiringAction G' A'] [MulSemiringAction G' B']
    [SMulCommClass G' k A'] [SMulCommClass G' k B'] [Finite G']
    (f : B' →+* A')
    (hf : ∀ (g : G') (a : B'), g • f a = f (g • a))
    [IsOpenImmersion (Spec.map (CommRingCat.ofHom f))]
    (U : (Spec (CommRingCat.of B')).Opens)
    (hRange : (U : Set (Spec (CommRingCat.of B'))) =
      Set.range (Spec.map (CommRingCat.ofHom f)).base)
    (hStable : ∀ g : G', (specAction G' B' g).hom ⁻¹ᵁ U = U) :
    IsOpenImmersion (Spec.map (CommRingCat.ofHom
      (equivariantFixedRingHom (k := k) (G := G') f hf))) := by
  let s : Spec (CommRingCat.of A') ⟶ Spec (CommRingCat.of B') :=
    Spec.map (CommRingCat.ofHom f)
  let t : Spec (CommRingCat.of (FixedPoints.subalgebra k A' G')) ⟶
      Spec (CommRingCat.of (FixedPoints.subalgebra k B' G')) :=
    Spec.map (CommRingCat.ofHom
      (equivariantFixedRingHom (k := k) (G := G') f hf))
  let qA := affineInvariantQuotientMap (k := k) (A := A') (G := G')
  let qB := affineInvariantQuotientMap (k := k) (A := B') (G := G')
  have hs : IsOpenEmbedding s.base := by
    change IsOpenEmbedding (Spec.map (CommRingCat.ofHom f)).base
    exact (inferInstance : IsOpenImmersion
      (Spec.map (CommRingCat.ofHom f))).base_open
  have ht : IsOpenEmbedding t.base := by
    exact (equivariantFixedSpecMap_isOpenEmbedding
      (k := k) (G := G') f hf hs U hRange hStable).1
  apply IsOpenImmersion.of_forall_source_exists t ht.injective
  intro x
  obtain ⟨y, hy⟩ := affineInvariantQuotientMap_surjective
    (k := k) (A := A') (G := G') x
  have hsyU : s.base y ∈ U := by
    change (Spec.map (CommRingCat.ofHom f)).base y ∈
      (U : Set (Spec (CommRingCat.of B')))
    rw [hRange]
    exact ⟨y, rfl⟩
  obtain ⟨b, hsyb, hbU⟩ := exists_invariant_basicOpen_le
    (k := k) (G := G') U hStable (s.base y) hsyU
  let V : (Spec (CommRingCat.of
      (FixedPoints.subalgebra k B' G'))).Opens :=
    PrimeSpectrum.basicOpen b
  have hbRange : (PrimeSpectrum.basicOpen (b : B') :
      (Spec (CommRingCat.of B')).Opens) ≤ s.opensRange := by
    intro z hz
    apply Scheme.Hom.mem_opensRange.mpr
    have hzU := hbU hz
    have hzU' : z ∈ (U : Set (Spec (CommRingCat.of B'))) := hzU
    rw [hRange] at hzU'
    obtain ⟨w, hw⟩ := hzU'
    exact ⟨w, by simpa only [s] using hw⟩
  have hlocal : IsOpenImmersion (t ∣_ V) := by
    dsimp only [t, V]
    exact isOpenImmersion_fixedRing_restrictBasicOpen f hf b
      (by simpa only [s] using hbRange)
  have hqBmem : qB.base (s.base y) ∈ V := by
    change s.base y ∈ qB ⁻¹ᵁ V
    dsimp only [qB, V]
    rw [affineInvariantQuotientMap_preimage_basicOpen_fixed]
    exact hsyb
  have hnat := congrArg (fun m => m.base y)
    (affineInvariantQuotientMap_naturality
      (k := k) (G := G') f hf)
  change t.base (qA.base y) = qB.base (s.base y) at hnat
  have htx : t.base x ∈ V := by
    rw [← hy, hnat]
    exact hqBmem
  let W := t ⁻¹ᵁ V
  refine ⟨W.toScheme, W.ι, inferInstance, ?_, ?_⟩
  · rw [Scheme.Opens.opensRange_ι]
    exact htx
  · dsimp only [W]
    rw [← morphismRestrict_ι t V]
    letI : IsOpenImmersion (t ∣_ V) := hlocal
    infer_instance

end InvariantLocalization
end MilneLib
