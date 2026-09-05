/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientOpen
import MilneLib.InvariantQuotientTransitions

/-!
# Open embeddings between affine invariant quotients

This file packages the topological descent step for an equivariant affine open.
The generic lemma is deliberately independent of schemes: quotient maps, a
saturated open embedding, and the induced fiber relation are the exact
topological hypotheses used below.  The affine invariant quotient instance
supplies those hypotheses from the existing orbit-fiber API.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry Topology TopologicalSpace
open scoped Pointwise

namespace MilneLib
namespace InvariantLocalization

/-! ## A topological descent lemma -/

/--
An open embedding between spaces descends to an open embedding between quotient
spaces when the source and target maps are quotient maps, the open embedding
has saturated image, and its fibers agree with the quotient fibers.

The range formula is part of the conclusion.  Keeping the saturation and
fiber hypotheses explicit makes this lemma applicable beyond affine schemes
without smuggling in an unproved quotient-existence assertion.
-/
theorem isOpenEmbedding_of_quotient_square
    {X Y Xq Yq : Type*} [TopologicalSpace X] [TopologicalSpace Y]
    [TopologicalSpace Xq] [TopologicalSpace Yq]
    (qX : X → Xq) (qY : Y → Yq) (s : X → Y) (t : Xq → Yq)
    (hqX : IsQuotientMap qX) (hqY : IsQuotientMap qY)
    (hs : IsOpenEmbedding s)
    (hsq : ∀ x, t (qX x) = qY (s x))
    (hsat : qY ⁻¹' (qY '' Set.range s) = Set.range s)
    (hfiber : ∀ x y, qY (s x) = qY (s y) ↔ qX x = qX y) :
    IsOpenEmbedding t ∧ Set.range t = qY '' Set.range s := by
  have hpre (O : Set Xq) :
      qY ⁻¹' (t '' O) = s '' (qX ⁻¹' O) := by
    ext y
    constructor
    · rintro ⟨p, hpO, hpy⟩
      obtain ⟨x, rfl⟩ := hqX.surjective p
      have hqys : qY (s x) = qY y := by
        rw [← hsq x]
        exact hpy
      have hySat : y ∈ qY ⁻¹' (qY '' Set.range s) := by
        exact ⟨s x, ⟨x, rfl⟩, hqys⟩
      rw [hsat] at hySat
      obtain ⟨z, hzy⟩ := hySat
      have hqxy : qX x = qX z := (hfiber x z).mp
        (by simpa [hzy] using hqys)
      refine ⟨z, ?_, hzy⟩
      change qX z ∈ O
      rw [← hqxy]
      exact hpO
    · rintro ⟨z, hzO, rfl⟩
      change qY (s z) ∈ t '' O
      refine ⟨qX z, hzO, ?_⟩
      exact hsq z
  have hopenmap : IsOpenMap t := by
    intro O hO
    apply (hqY.isCoinducing.isOpen_preimage).mp
    rw [hpre]
    exact hs.isOpenMap _ (hqX.continuous.isOpen_preimage _ hO)
  have hinj : Function.Injective t := by
    intro p q hpq
    obtain ⟨x, rfl⟩ := hqX.surjective p
    obtain ⟨y, rfl⟩ := hqX.surjective q
    apply (hfiber x y).mp
    rw [← hsq x, ← hsq y, hpq]
  have htcont : Continuous t := by
    apply hqX.continuous_iff.mpr
    have hcomp : t ∘ qX = qY ∘ s := by
      funext x
      exact hsq x
    rw [hcomp]
    exact hqY.continuous.comp hs.continuous
  refine ⟨IsOpenEmbedding.of_continuous_injective_isOpenMap
    htcont hinj hopenmap, ?_⟩
  ext y
  constructor
  · rintro ⟨p, rfl⟩
    obtain ⟨x, rfl⟩ := hqX.surjective p
    exact ⟨s x, ⟨x, rfl⟩, (hsq x).symm⟩
  · rintro ⟨y, ⟨x, rfl⟩, rfl⟩
    exact ⟨qX x, hsq x⟩

/-! ## Equivariant affine maps -/

variable {k A B G : Type u}
  [CommRing k] [CommRing A] [CommRing B]
  [Algebra k A] [Algebra k B]
  [Group G] [MulSemiringAction G A] [MulSemiringAction G B]
  [SMulCommClass G k A] [SMulCommClass G k B]

/-- The spectrum map of an equivariant ring hom commutes with the induced
spectrum actions. -/
theorem equivariantSpecMap_specAction_naturality
    (φ : B →+* A)
    (hφ : ∀ (g : G) (b : B), g • φ b = φ (g • b))
    (g : G) :
    (specAction G A g).hom ≫ Spec.map (CommRingCat.ofHom φ) =
      Spec.map (CommRingCat.ofHom φ) ≫ (specAction G B g).hom := by
  rw [specAction_hom, specAction_hom, ← Spec.map_comp, ← CommRingCat.ofHom_comp,
    ← Spec.map_comp, ← CommRingCat.ofHom_comp]
  apply congrArg Spec.map
  apply CommRingCat.hom_ext
  ext b
  exact hφ g⁻¹ b

/-- An equivariant affine open descends to an open embedding on the affine
invariant quotients.  The explicit range hypothesis records that the chosen
open `U` is exactly the image of the affine `Spec.map`; `hStable` records its
group stability. -/
theorem equivariantFixedSpecMap_isOpenEmbedding
    [Finite G]
    (φ : B →+* A)
    (hφ : ∀ (g : G) (b : B), g • φ b = φ (g • b))
    (hSpec : IsOpenEmbedding
      (Spec.map (CommRingCat.ofHom φ)).base)
    (U : (Spec (CommRingCat.of B)).Opens)
    (hRange : (U : Set (Spec (CommRingCat.of B))) =
      Set.range (Spec.map (CommRingCat.ofHom φ)).base)
    (hStable : ∀ g : G, (specAction G B g).hom ⁻¹ᵁ U = U) :
    IsOpenEmbedding (Spec.map (CommRingCat.ofHom
      (equivariantFixedRingHom (k := k) (G := G) φ hφ))).base ∧
      Set.range (Spec.map (CommRingCat.ofHom
        (equivariantFixedRingHom (k := k) (G := G) φ hφ))).base =
        (quotientOpenOfStable (k := k) (A := B) (G := G) U hStable : Set _) := by
  let s : Spec (CommRingCat.of A) ⟶ Spec (CommRingCat.of B) :=
    Spec.map (CommRingCat.ofHom φ)
  let t : Spec (CommRingCat.of (FixedPoints.subalgebra k A G)) ⟶
      Spec (CommRingCat.of (FixedPoints.subalgebra k B G)) :=
    Spec.map (CommRingCat.ofHom
      (equivariantFixedRingHom (k := k) (G := G) φ hφ))
  let qA : Spec (CommRingCat.of A) →
      Spec (CommRingCat.of (FixedPoints.subalgebra k A G)) :=
    (affineInvariantQuotientMap (k := k) (A := A) (G := G)).base
  let qB : Spec (CommRingCat.of B) →
      Spec (CommRingCat.of (FixedPoints.subalgebra k B G)) :=
    (affineInvariantQuotientMap (k := k) (A := B) (G := G)).base
  have hs : IsOpenEmbedding s.base := by
    simpa [s] using hSpec
  have hsq : ∀ x, t.base (qA x) = qB (s.base x) := by
    intro x
    have hbase := congrArg (fun f => f.base x)
      (affineInvariantQuotientMap_naturality (k := k) (G := G) φ hφ)
    simpa only [Scheme.Hom.comp_apply, s, t, qA, qB] using hbase
  have hsat : qB ⁻¹' (qB '' Set.range s.base) = Set.range s.base := by
    rw [← hRange]
    change (affineInvariantQuotientMap (k := k) (A := B) (G := G)).base ⁻¹'
      ((affineInvariantQuotientMap (k := k) (A := B) (G := G)).base ''
        (U : Set _)) = (U : Set _)
    exact preimage_image_eq_of_stable (k := k) (A := B) (G := G) U hStable
  have hfiber : ∀ x y, qB (s.base x) = qB (s.base y) ↔ qA x = qA y := by
    intro x y
    constructor
    · intro hxy
      obtain ⟨g, hg⟩ :=
        (affineInvariantQuotientMap_eq_iff_exists_specAction
          (k := k) (A := B) (G := G) (s.base x) (s.base y)).mp hxy
      have hact :
          s.base ((specAction G A g).hom.base x) =
            (specAction G B g).hom.base (s.base x) := by
        have h := congrArg (fun f => f.base x)
          (equivariantSpecMap_specAction_naturality (G := G) φ hφ g)
        simpa only [Scheme.Hom.comp_apply, s] using h
      have hsxy : s.base ((specAction G A g).hom.base x) = s.base y := by
        rw [hact, hg]
      have hxy' : (specAction G A g).hom.base x = y :=
        hs.injective hsxy
      exact (affineInvariantQuotientMap_eq_iff_exists_specAction
        (k := k) (A := A) (G := G) x y).mpr ⟨g, hxy'⟩
    · intro hxy
      obtain ⟨g, hg⟩ :=
        (affineInvariantQuotientMap_eq_iff_exists_specAction
          (k := k) (A := A) (G := G) x y).mp hxy
      apply (affineInvariantQuotientMap_eq_iff_exists_specAction
        (k := k) (A := B) (G := G) (s.base x) (s.base y)).mpr
      refine ⟨g, ?_⟩
      have hact :
          s.base ((specAction G A g).hom.base x) =
            (specAction G B g).hom.base (s.base x) := by
        have h := congrArg (fun f => f.base x)
          (equivariantSpecMap_specAction_naturality (G := G) φ hφ g)
        simpa only [Scheme.Hom.comp_apply, s] using h
      rw [← hact, hg]
  have hqA : IsQuotientMap qA := by
    simpa [qA] using
      (affineInvariantQuotientMap_isQuotientMap
        (k := k) (A := A) (G := G))
  have hqB : IsQuotientMap qB := by
    simpa [qB] using
      (affineInvariantQuotientMap_isQuotientMap
        (k := k) (A := B) (G := G))
  obtain ⟨ht, hr⟩ := isOpenEmbedding_of_quotient_square
    qA qB s.base t.base hqA hqB hs hsq hsat hfiber
  refine ⟨?_, ?_⟩
  · simpa [t] using ht
  · have hsRange : (U : Set _) = Set.range s.base := by
      simpa [s] using hRange
    change Set.range t.base = qB '' (U : Set _)
    rw [hsRange]
    simpa [qB] using hr

end InvariantLocalization
end MilneLib
