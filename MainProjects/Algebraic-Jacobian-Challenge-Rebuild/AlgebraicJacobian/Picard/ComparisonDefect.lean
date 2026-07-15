/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.NormalizedComparison

/-!
# FRONTIER — NOT YET COMPILING; NOT IMPORTED FROM THE ROOT

This file is the (N3) frontier of brick E1 ((C2) effectivity).  Its declarations are
mathematically final (see the E1 session report in the ledger), but the `w ≫ u`
composite normal form does not currently elaborate on the `X_{B⊗B⊗B}` towers: the
composite-bound statements (`amitsurPairOpen_le_face₂₃_inl`, …) hit `whnf` timeouts at
1600000 heartbeats *in their statements*, and the pair relations hit `isDefEq` timeouts
at 4000000.  The (C1) Step-G precedent (`CoherentWitnessExists.stepG_R₂₃`) elaborates
the same composite shapes with SINGLE-point cover opens; the pair-indexed `𝒩`-overlaps
here double the composite-point occurrences.  A continuation should either (a) find the
elaboration-order trick that makes `(w ≫ u).base z` cheap (compare stepG), or
(b) restate the pair relations with the `E`-families pre-pulled to `Xcb` as opaque
defs.  Do NOT import this file into the root until it compiles.

# The Amitsur defect of a comparison cochain ((C2) effectivity, brick E1: H⁰ step)

The gluing half of the `lm:aut` coherence argument for the σ-normalized comparison: the
**Amitsur defect** `ε = (w₂₃^♯ θ₀) ⋅ (w₁₂^♯ θ₀) / (w₁₃^♯ θ₀)` of a comparison cochain
`θ₀` on the curve over `Spec (B ⊗[A] B)` — the combination of its three coface pullbacks
to the curve over the triple base `Spec (B ⊗[A] (B ⊗[A] B))` — is Čech-compatible
whenever `θ₀` cobounds the two coprojection pullbacks of the representing cocycle `γ`
(the (N1) witness relation): the three coface pullbacks of the witness relation
telescope through the landed simplicial coincidences on the curve product
(`Over.whiskerLeft_face₁₂_inl`, …).  By the `𝒪ˣ`-sheaf axiom (ζ2·P (P1)) the defect
glues to a global unit `ε̄` of `X_{B⊗B⊗B}` (`Over.exists_glued_productDefect`) — the H⁰
step of Kleiman's `lm:aut`, with **no geometric hypotheses**.

Following the ζ2·i kernel discipline, the pairwise-overlap open of the defect cover is
an opaque `def` (`Over.amitsurPairOpen`) with named `≤`-lemmas — in particular the
composite bounds `amitsurPairOpen_le_face₂₃_inl`, …, which pay the (expensive)
nested-versus-composite preimage conversion once each, in a small declaration — and the
three pulled-back relations are split into their own (private) declarations, each a
single application of the rewired abstract lemma
`Scheme.Hom.unitsAppLE_coboundary_rel_comp`: no rewrite casts over the concrete curve
towers ever enter a kernel-checked term.

The σ-restriction of `ε̄` and the coherence theorem (N3) are in
`AlgebraicJacobian.Picard.ComparisonCoherence`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory Opposite
  TopologicalSpace CategoryTheory.PresheafOfGroups

open scoped TensorProduct

namespace AlgebraicGeometry

/-- Pullback of a coboundary relation along a morphism, in composite normal form with
the output composites re-expressed along given coincidences `h₁, h₂` — the rewired form
of `Scheme.Hom.unitsAppLE_coboundary_rel`.  All spelling changes (composites, base
points, bound proofs) happen here, over abstract schemes, so the concrete
instantiations on the curve towers are single applications with no rewrite casts. -/
theorem Scheme.Hom.unitsAppLE_coboundary_rel_comp {X Y Z₁ Z₂ : Scheme.{u}}
    (φ : X ⟶ Y) (r₁ : Y ⟶ Z₁) (r₂ : Y ⟶ Z₂) (t₁ : X ⟶ Z₁) (t₂ : X ⟶ Z₂)
    {𝒞 : Y.PointedCover} (c : ∀ y : Y, Γ(Y, 𝒞.opens y)ˣ)
    (V₁ : Z₁ → Z₁ → Z₁.Opens) (V₂ : Z₂ → Z₂ → Z₂.Opens)
    (E₁ : ∀ z z', Γ(Z₁, V₁ z z')ˣ) (E₂ : ∀ z z', Γ(Z₂, V₂ z z')ˣ)
    (e₁ : ∀ y y' : Y, 𝒞.opens y ⊓ 𝒞.opens y' ≤ r₁ ⁻¹ᵁ V₁ (r₁.base y) (r₁.base y'))
    (e₂ : ∀ y y' : Y, 𝒞.opens y ⊓ 𝒞.opens y' ≤ r₂ ⁻¹ᵁ V₂ (r₂.base y) (r₂.base y'))
    (hrel : ∀ y y' : Y,
      Y.unitsRestrict (inf_le_left : 𝒞.opens y ⊓ 𝒞.opens y' ≤ 𝒞.opens y) (c y)
          * r₁.unitsAppLE (V₁ (r₁.base y) (r₁.base y')) (𝒞.opens y ⊓ 𝒞.opens y')
              (e₁ y y') (E₁ (r₁.base y) (r₁.base y'))
        = r₂.unitsAppLE (V₂ (r₂.base y) (r₂.base y')) (𝒞.opens y ⊓ 𝒞.opens y')
              (e₂ y y') (E₂ (r₂.base y) (r₂.base y'))
          * Y.unitsRestrict inf_le_right (c y'))
    (h₁ : φ ≫ r₁ = t₁) (h₂ : φ ≫ r₂ = t₂)
    (x x' : X) {O : X.Opens}
    (hO : O ≤ φ ⁻¹ᵁ (𝒞.opens (φ.base x) ⊓ 𝒞.opens (φ.base x')))
    (e₁O : O ≤ t₁ ⁻¹ᵁ V₁ (t₁.base x) (t₁.base x'))
    (e₂O : O ≤ t₂ ⁻¹ᵁ V₂ (t₂.base x) (t₂.base x')) :
    φ.unitsAppLE (𝒞.opens (φ.base x)) O (hO.trans (φ.preimage_mono inf_le_left))
        (c (φ.base x))
      * t₁.unitsAppLE (V₁ (t₁.base x) (t₁.base x')) O e₁O (E₁ (t₁.base x) (t₁.base x'))
    = t₂.unitsAppLE (V₂ (t₂.base x) (t₂.base x')) O e₂O (E₂ (t₂.base x) (t₂.base x'))
      * φ.unitsAppLE (𝒞.opens (φ.base x')) O (hO.trans (φ.preimage_mono inf_le_right))
          (c (φ.base x')) := by
  subst h₁ h₂
  exact Scheme.Hom.unitsAppLE_coboundary_rel φ r₁ r₂ c V₁ V₂ E₁ E₂ e₁ e₂ hrel x x' hO

variable {k : Type u} [Field k]
variable {A B : Type u} [CommRing A] [CommRing B] [Algebra k A] [Algebra k B]
  [Algebra A B] [IsScalarTower k A B]
variable (C : Over (Spec (.of k)))

-- product-side objects and maps
set_option quotPrecheck false in
local notation "XB" => (C ⊗ overSpec k B).left
set_option quotPrecheck false in
local notation "Xq" => (C ⊗ overSpec k (B ⊗[A] B)).left
set_option quotPrecheck false in
local notation "Xcb" => (C ⊗ overSpec k (B ⊗[A] (B ⊗[A] B))).left
set_option quotPrecheck false in
local notation "u₁" => (C ◁ Over.overSpecMap (tensorInl (A := A) (B := B))).left
set_option quotPrecheck false in
local notation "u₂" => (C ◁ Over.overSpecMap (tensorInr (A := A) (B := B))).left
set_option quotPrecheck false in
local notation "w₁₂" =>
  (C ◁ Over.overSpecMap (tensorFace₁₂ (k := k) (A := A) (B := B))).left
set_option quotPrecheck false in
local notation "w₁₃" =>
  (C ◁ Over.overSpecMap (tensorFace₁₃ (k := k) (A := A) (B := B))).left
set_option quotPrecheck false in
local notation "w₂₃" =>
  (C ◁ Over.overSpecMap (tensorFace₂₃ (k := k) (A := A) (B := B))).left

namespace Over

/-- The canonical common refinement of the three coface pullbacks of a pointed cover of
the curve over `Spec (B ⊗[A] B)`: the curve-product mirror of `amitsurCover`, a pointed
cover of the curve over the triple base.  The coherence (N3) is stated on this cover. -/
noncomputable def amitsurProductCover (𝒲 : (Xq).PointedCover) : (Xcb).PointedCover :=
  (𝒲.pullback (w₂₃) ⊓ 𝒲.pullback (w₁₂)) ⊓ 𝒲.pullback (w₁₃)

lemma amitsurProductCover_le_w₂₃ (𝒲 : (Xq).PointedCover) (z : Xcb) :
    (amitsurProductCover C 𝒲).opens z ≤ (w₂₃) ⁻¹ᵁ 𝒲.opens ((w₂₃).base z) :=
  inf_le_left.trans inf_le_left

lemma amitsurProductCover_le_w₁₂ (𝒲 : (Xq).PointedCover) (z : Xcb) :
    (amitsurProductCover C 𝒲).opens z ≤ (w₁₂) ⁻¹ᵁ 𝒲.opens ((w₁₂).base z) :=
  inf_le_left.trans inf_le_right

lemma amitsurProductCover_le_w₁₃ (𝒲 : (Xq).PointedCover) (z : Xcb) :
    (amitsurProductCover C 𝒲).opens z ≤ (w₁₃) ⁻¹ᵁ 𝒲.opens ((w₁₃).base z) :=
  inf_le_right

/-- The **Amitsur defect** of a comparison cochain `θ₀` on the curve over the double
base: the combination `(w₂₃^♯ θ₀) ⋅ (w₁₂^♯ θ₀) / (w₁₃^♯ θ₀)` of its three coface
pullbacks, a unit `0`-cochain on `amitsurProductCover 𝒲`.  A comparison is coherent
precisely when its defect is `1`. -/
noncomputable def productDefectCochain (𝒲 : (Xq).PointedCover)
    (θ₀ : ∀ x : Xq, Γ(Xq, 𝒲.opens x)ˣ) (z : Xcb) :
    Γ(Xcb, (amitsurProductCover C 𝒲).opens z)ˣ :=
  (w₂₃).unitsAppLE (𝒲.opens ((w₂₃).base z)) ((amitsurProductCover C 𝒲).opens z)
      (amitsurProductCover_le_w₂₃ C 𝒲 z) (θ₀ ((w₂₃).base z))
    * (w₁₂).unitsAppLE (𝒲.opens ((w₁₂).base z)) ((amitsurProductCover C 𝒲).opens z)
      (amitsurProductCover_le_w₁₂ C 𝒲 z) (θ₀ ((w₁₂).base z))
    / (w₁₃).unitsAppLE (𝒲.opens ((w₁₃).base z)) ((amitsurProductCover C 𝒲).opens z)
      (amitsurProductCover_le_w₁₃ C 𝒲 z) (θ₀ ((w₁₃).base z))

/-! ## The pairwise-overlap open and its bounds

The pairwise overlap of the defect cover is an opaque `def`, and every bound the pulled
relations need — in particular the composite bounds along `w ≫ u`, whose
nested-versus-composite preimage conversion is a heavy definitional-equality check on
the concrete towers — is a named lemma, so the conversion is elaborated and
kernel-checked once, in a small declaration. -/

/-- The pairwise overlap of the defect cover, as an opaque `def`. -/
noncomputable def amitsurPairOpen (𝒲 : (Xq).PointedCover) (z z' : Xcb) : (Xcb).Opens :=
  (amitsurProductCover C 𝒲).opens z ⊓ (amitsurProductCover C 𝒲).opens z'

lemma amitsurPairOpen_le_face₂₃ (𝒲 : (Xq).PointedCover) (z z' : Xcb) :
    amitsurPairOpen C 𝒲 z z'
      ≤ (w₂₃) ⁻¹ᵁ (𝒲.opens ((w₂₃).base z) ⊓ 𝒲.opens ((w₂₃).base z')) :=
  (w₂₃).le_preimage_inf
    (inf_le_left.trans (amitsurProductCover_le_w₂₃ C 𝒲 z))
    (inf_le_right.trans (amitsurProductCover_le_w₂₃ C 𝒲 z'))

lemma amitsurPairOpen_le_face₁₂ (𝒲 : (Xq).PointedCover) (z z' : Xcb) :
    amitsurPairOpen C 𝒲 z z'
      ≤ (w₁₂) ⁻¹ᵁ (𝒲.opens ((w₁₂).base z) ⊓ 𝒲.opens ((w₁₂).base z')) :=
  (w₁₂).le_preimage_inf
    (inf_le_left.trans (amitsurProductCover_le_w₁₂ C 𝒲 z))
    (inf_le_right.trans (amitsurProductCover_le_w₁₂ C 𝒲 z'))

lemma amitsurPairOpen_le_face₁₃ (𝒲 : (Xq).PointedCover) (z z' : Xcb) :
    amitsurPairOpen C 𝒲 z z'
      ≤ (w₁₃) ⁻¹ᵁ (𝒲.opens ((w₁₃).base z) ⊓ 𝒲.opens ((w₁₃).base z')) :=
  (w₁₃).le_preimage_inf
    (inf_le_left.trans (amitsurProductCover_le_w₁₃ C 𝒲 z))
    (inf_le_right.trans (amitsurProductCover_le_w₁₃ C 𝒲 z'))

section compositeBounds

variable (𝒩 : (XB).PointedCover) (𝒲 : (Xq).PointedCover)
  (hW₁ : ∀ x, 𝒲.opens x ≤ (u₁) ⁻¹ᵁ 𝒩.opens ((u₁).base x))
  (hW₂ : ∀ x, 𝒲.opens x ≤ (u₂) ⁻¹ᵁ 𝒩.opens ((u₂).base x))

include hW₁ in
set_option maxHeartbeats 1600000 in
-- One nested-versus-composite preimage conversion on the concrete towers.
/-- Composite bound along `w₂₃ ≫ u₁`. -/
lemma amitsurPairOpen_le_face₂₃_inl (z z' : Xcb) :
    amitsurPairOpen C 𝒲 z z'
      ≤ (w₂₃ ≫ (u₁)) ⁻¹ᵁ
          (𝒩.opens ((w₂₃ ≫ (u₁)).base z) ⊓ 𝒩.opens ((w₂₃ ≫ (u₁)).base z')) :=
  (amitsurPairOpen_le_face₂₃ C 𝒲 z z').trans
    ((w₂₃).preimage_mono ((u₁).le_preimage_inf
      (inf_le_left.trans (hW₁ ((w₂₃).base z)))
      (inf_le_right.trans (hW₁ ((w₂₃).base z')))))

include hW₂ in
set_option maxHeartbeats 1600000 in
-- One nested-versus-composite preimage conversion on the concrete towers.
/-- Composite bound along `w₂₃ ≫ u₂`. -/
lemma amitsurPairOpen_le_face₂₃_inr (z z' : Xcb) :
    amitsurPairOpen C 𝒲 z z'
      ≤ (w₂₃ ≫ (u₂)) ⁻¹ᵁ
          (𝒩.opens ((w₂₃ ≫ (u₂)).base z) ⊓ 𝒩.opens ((w₂₃ ≫ (u₂)).base z')) :=
  (amitsurPairOpen_le_face₂₃ C 𝒲 z z').trans
    ((w₂₃).preimage_mono ((u₂).le_preimage_inf
      (inf_le_left.trans (hW₂ ((w₂₃).base z)))
      (inf_le_right.trans (hW₂ ((w₂₃).base z')))))

include hW₁ in
set_option maxHeartbeats 1600000 in
-- One nested-versus-composite preimage conversion on the concrete towers.
/-- Composite bound along `w₁₂ ≫ u₁`. -/
lemma amitsurPairOpen_le_face₁₂_inl (z z' : Xcb) :
    amitsurPairOpen C 𝒲 z z'
      ≤ (w₁₂ ≫ (u₁)) ⁻¹ᵁ
          (𝒩.opens ((w₁₂ ≫ (u₁)).base z) ⊓ 𝒩.opens ((w₁₂ ≫ (u₁)).base z')) :=
  (amitsurPairOpen_le_face₁₂ C 𝒲 z z').trans
    ((w₁₂).preimage_mono ((u₁).le_preimage_inf
      (inf_le_left.trans (hW₁ ((w₁₂).base z)))
      (inf_le_right.trans (hW₁ ((w₁₂).base z')))))

end compositeBounds

section pairRelations

variable (𝒩 : (XB).PointedCover) (γ : (XB).unitsCocycle 𝒩) (𝒲 : (Xq).PointedCover)
  (hW₁ : ∀ x, 𝒲.opens x ≤ (u₁) ⁻¹ᵁ 𝒩.opens ((u₁).base x))
  (hW₂ : ∀ x, 𝒲.opens x ≤ (u₂) ⁻¹ᵁ 𝒩.opens ((u₂).base x))
  (θ₀ : ∀ x : Xq, Γ(Xq, 𝒲.opens x)ˣ)

set_option maxHeartbeats 4000000 in
-- The instantiated relation on the triple curve product is a large expression.
/-- The `w₂₃`-coface pullback of the witness relation, in insertion normal form.  Split
from `Over.exists_glued_productDefect` so its proof term is kernel-checked as its own
declaration. -/
private theorem productDefect_rel₂₃
    (hdown : ∀ x y : Xq,
      (Xq).unitsRestrict (inf_le_left : 𝒲.opens x ⊓ 𝒲.opens y ≤ 𝒲.opens x) (θ₀ x)
          * (u₁).unitsAppLE (𝒩.opens ((u₁).base x) ⊓ 𝒩.opens ((u₁).base y))
              (𝒲.opens x ⊓ 𝒲.opens y)
              ((u₁).le_preimage_inf (inf_le_left.trans (hW₁ x))
                (inf_le_right.trans (hW₁ y)))
              (Scheme.unitsEvInf γ ((u₁).base x) ((u₁).base y))
        = (u₂).unitsAppLE (𝒩.opens ((u₂).base x) ⊓ 𝒩.opens ((u₂).base y))
              (𝒲.opens x ⊓ 𝒲.opens y)
              ((u₂).le_preimage_inf (inf_le_left.trans (hW₂ x))
                (inf_le_right.trans (hW₂ y)))
              (Scheme.unitsEvInf γ ((u₂).base x) ((u₂).base y))
          * (Xq).unitsRestrict inf_le_right (θ₀ y))
    (z z' : Xcb) :
    (w₂₃).unitsAppLE (𝒲.opens ((w₂₃).base z)) (amitsurPairOpen C 𝒲 z z')
        ((amitsurPairOpen_le_face₂₃ C 𝒲 z z').trans ((w₂₃).preimage_mono inf_le_left))
        (θ₀ ((w₂₃).base z))
      * (w₂₃ ≫ (u₁)).unitsAppLE
          (𝒩.opens ((w₂₃ ≫ (u₁)).base z) ⊓ 𝒩.opens ((w₂₃ ≫ (u₁)).base z'))
          (amitsurPairOpen C 𝒲 z z')
          (amitsurPairOpen_le_face₂₃_inl C 𝒩 𝒲 hW₁ z z')
          (Scheme.unitsEvInf γ ((w₂₃ ≫ (u₁)).base z) ((w₂₃ ≫ (u₁)).base z'))
    = (w₂₃ ≫ (u₂)).unitsAppLE
          (𝒩.opens ((w₂₃ ≫ (u₂)).base z) ⊓ 𝒩.opens ((w₂₃ ≫ (u₂)).base z'))
          (amitsurPairOpen C 𝒲 z z')
          (amitsurPairOpen_le_face₂₃_inr C 𝒩 𝒲 hW₂ z z')
          (Scheme.unitsEvInf γ ((w₂₃ ≫ (u₂)).base z) ((w₂₃ ≫ (u₂)).base z'))
      * (w₂₃).unitsAppLE (𝒲.opens ((w₂₃).base z')) (amitsurPairOpen C 𝒲 z z')
          ((amitsurPairOpen_le_face₂₃ C 𝒲 z z').trans
            ((w₂₃).preimage_mono inf_le_right))
          (θ₀ ((w₂₃).base z')) :=
  Scheme.Hom.unitsAppLE_coboundary_rel_comp (w₂₃) (u₁) (u₂)
    (w₂₃ ≫ (u₁)) (w₂₃ ≫ (u₂)) θ₀
    (fun b b' ↦ 𝒩.opens b ⊓ 𝒩.opens b') (fun b b' ↦ 𝒩.opens b ⊓ 𝒩.opens b')
    (fun b b' ↦ Scheme.unitsEvInf γ b b') (fun b b' ↦ Scheme.unitsEvInf γ b b')
    (fun x y ↦ (u₁).le_preimage_inf (inf_le_left.trans (hW₁ x))
      (inf_le_right.trans (hW₁ y)))
    (fun x y ↦ (u₂).le_preimage_inf (inf_le_left.trans (hW₂ x))
      (inf_le_right.trans (hW₂ y)))
    hdown rfl rfl z z'
    (amitsurPairOpen_le_face₂₃ C 𝒲 z z')
    (amitsurPairOpen_le_face₂₃_inl C 𝒩 𝒲 hW₁ z z')
    (amitsurPairOpen_le_face₂₃_inr C 𝒩 𝒲 hW₂ z z')

set_option maxHeartbeats 4000000 in
-- The instantiated relation on the triple curve product is a large expression.
/-- The `w₁₂`-coface pullback of the witness relation, its second insertion collapsed
onto `w₂₃ ≫ u₁` by the simplicial coincidence `Over.whiskerLeft_face₁₂_inr`. -/
private theorem productDefect_rel₁₂
    (hdown : ∀ x y : Xq,
      (Xq).unitsRestrict (inf_le_left : 𝒲.opens x ⊓ 𝒲.opens y ≤ 𝒲.opens x) (θ₀ x)
          * (u₁).unitsAppLE (𝒩.opens ((u₁).base x) ⊓ 𝒩.opens ((u₁).base y))
              (𝒲.opens x ⊓ 𝒲.opens y)
              ((u₁).le_preimage_inf (inf_le_left.trans (hW₁ x))
                (inf_le_right.trans (hW₁ y)))
              (Scheme.unitsEvInf γ ((u₁).base x) ((u₁).base y))
        = (u₂).unitsAppLE (𝒩.opens ((u₂).base x) ⊓ 𝒩.opens ((u₂).base y))
              (𝒲.opens x ⊓ 𝒲.opens y)
              ((u₂).le_preimage_inf (inf_le_left.trans (hW₂ x))
                (inf_le_right.trans (hW₂ y)))
              (Scheme.unitsEvInf γ ((u₂).base x) ((u₂).base y))
          * (Xq).unitsRestrict inf_le_right (θ₀ y))
    (z z' : Xcb) :
    (w₁₂).unitsAppLE (𝒲.opens ((w₁₂).base z)) (amitsurPairOpen C 𝒲 z z')
        ((amitsurPairOpen_le_face₁₂ C 𝒲 z z').trans ((w₁₂).preimage_mono inf_le_left))
        (θ₀ ((w₁₂).base z))
      * (w₁₂ ≫ (u₁)).unitsAppLE
          (𝒩.opens ((w₁₂ ≫ (u₁)).base z) ⊓ 𝒩.opens ((w₁₂ ≫ (u₁)).base z'))
          (amitsurPairOpen C 𝒲 z z')
          (amitsurPairOpen_le_face₁₂_inl C 𝒩 𝒲 hW₁ z z')
          (Scheme.unitsEvInf γ ((w₁₂ ≫ (u₁)).base z) ((w₁₂ ≫ (u₁)).base z'))
    = (w₂₃ ≫ (u₁)).unitsAppLE
          (𝒩.opens ((w₂₃ ≫ (u₁)).base z) ⊓ 𝒩.opens ((w₂₃ ≫ (u₁)).base z'))
          (amitsurPairOpen C 𝒲 z z')
          (amitsurPairOpen_le_face₂₃_inl C 𝒩 𝒲 hW₁ z z')
          (Scheme.unitsEvInf γ ((w₂₃ ≫ (u₁)).base z) ((w₂₃ ≫ (u₁)).base z'))
      * (w₁₂).unitsAppLE (𝒲.opens ((w₁₂).base z')) (amitsurPairOpen C 𝒲 z z')
          ((amitsurPairOpen_le_face₁₂ C 𝒲 z z').trans
            ((w₁₂).preimage_mono inf_le_right))
          (θ₀ ((w₁₂).base z')) :=
  Scheme.Hom.unitsAppLE_coboundary_rel_comp (w₁₂) (u₁) (u₂)
    (w₁₂ ≫ (u₁)) (w₂₃ ≫ (u₁)) θ₀
    (fun b b' ↦ 𝒩.opens b ⊓ 𝒩.opens b') (fun b b' ↦ 𝒩.opens b ⊓ 𝒩.opens b')
    (fun b b' ↦ Scheme.unitsEvInf γ b b') (fun b b' ↦ Scheme.unitsEvInf γ b b')
    (fun x y ↦ (u₁).le_preimage_inf (inf_le_left.trans (hW₁ x))
      (inf_le_right.trans (hW₁ y)))
    (fun x y ↦ (u₂).le_preimage_inf (inf_le_left.trans (hW₂ x))
      (inf_le_right.trans (hW₂ y)))
    hdown rfl (Over.whiskerLeft_face₁₂_inr (k := k) (A := A) (B := B) C) z z'
    (amitsurPairOpen_le_face₁₂ C 𝒲 z z')
    (amitsurPairOpen_le_face₁₂_inl C 𝒩 𝒲 hW₁ z z')
    (amitsurPairOpen_le_face₂₃_inl C 𝒩 𝒲 hW₁ z z')

set_option maxHeartbeats 4000000 in
-- The instantiated relation on the triple curve product is a large expression.
/-- The `w₁₃`-coface pullback of the witness relation, both insertions collapsed onto
`w₁₂ ≫ u₁` and `w₂₃ ≫ u₂` by the simplicial coincidences. -/
private theorem productDefect_rel₁₃
    (hdown : ∀ x y : Xq,
      (Xq).unitsRestrict (inf_le_left : 𝒲.opens x ⊓ 𝒲.opens y ≤ 𝒲.opens x) (θ₀ x)
          * (u₁).unitsAppLE (𝒩.opens ((u₁).base x) ⊓ 𝒩.opens ((u₁).base y))
              (𝒲.opens x ⊓ 𝒲.opens y)
              ((u₁).le_preimage_inf (inf_le_left.trans (hW₁ x))
                (inf_le_right.trans (hW₁ y)))
              (Scheme.unitsEvInf γ ((u₁).base x) ((u₁).base y))
        = (u₂).unitsAppLE (𝒩.opens ((u₂).base x) ⊓ 𝒩.opens ((u₂).base y))
              (𝒲.opens x ⊓ 𝒲.opens y)
              ((u₂).le_preimage_inf (inf_le_left.trans (hW₂ x))
                (inf_le_right.trans (hW₂ y)))
              (Scheme.unitsEvInf γ ((u₂).base x) ((u₂).base y))
          * (Xq).unitsRestrict inf_le_right (θ₀ y))
    (z z' : Xcb) :
    (w₁₃).unitsAppLE (𝒲.opens ((w₁₃).base z)) (amitsurPairOpen C 𝒲 z z')
        ((amitsurPairOpen_le_face₁₃ C 𝒲 z z').trans ((w₁₃).preimage_mono inf_le_left))
        (θ₀ ((w₁₃).base z))
      * (w₁₂ ≫ (u₁)).unitsAppLE
          (𝒩.opens ((w₁₂ ≫ (u₁)).base z) ⊓ 𝒩.opens ((w₁₂ ≫ (u₁)).base z'))
          (amitsurPairOpen C 𝒲 z z')
          (amitsurPairOpen_le_face₁₂_inl C 𝒩 𝒲 hW₁ z z')
          (Scheme.unitsEvInf γ ((w₁₂ ≫ (u₁)).base z) ((w₁₂ ≫ (u₁)).base z'))
    = (w₂₃ ≫ (u₂)).unitsAppLE
          (𝒩.opens ((w₂₃ ≫ (u₂)).base z) ⊓ 𝒩.opens ((w₂₃ ≫ (u₂)).base z'))
          (amitsurPairOpen C 𝒲 z z')
          (amitsurPairOpen_le_face₂₃_inr C 𝒩 𝒲 hW₂ z z')
          (Scheme.unitsEvInf γ ((w₂₃ ≫ (u₂)).base z) ((w₂₃ ≫ (u₂)).base z'))
      * (w₁₃).unitsAppLE (𝒲.opens ((w₁₃).base z')) (amitsurPairOpen C 𝒲 z z')
          ((amitsurPairOpen_le_face₁₃ C 𝒲 z z').trans
            ((w₁₃).preimage_mono inf_le_right))
          (θ₀ ((w₁₃).base z')) :=
  Scheme.Hom.unitsAppLE_coboundary_rel_comp (w₁₃) (u₁) (u₂)
    (w₁₂ ≫ (u₁)) (w₂₃ ≫ (u₂)) θ₀
    (fun b b' ↦ 𝒩.opens b ⊓ 𝒩.opens b') (fun b b' ↦ 𝒩.opens b ⊓ 𝒩.opens b')
    (fun b b' ↦ Scheme.unitsEvInf γ b b') (fun b b' ↦ Scheme.unitsEvInf γ b b')
    (fun x y ↦ (u₁).le_preimage_inf (inf_le_left.trans (hW₁ x))
      (inf_le_right.trans (hW₁ y)))
    (fun x y ↦ (u₂).le_preimage_inf (inf_le_left.trans (hW₂ x))
      (inf_le_right.trans (hW₂ y)))
    hdown
    (Over.whiskerLeft_face₁₂_inl (k := k) (A := A) (B := B) C).symm
    (Over.whiskerLeft_face₁₃_inr (k := k) (A := A) (B := B) C) z z'
    (amitsurPairOpen_le_face₁₃ C 𝒲 z z')
    (amitsurPairOpen_le_face₁₂_inl C 𝒩 𝒲 hW₁ z z')
    (amitsurPairOpen_le_face₂₃_inr C 𝒩 𝒲 hW₂ z z')

set_option maxHeartbeats 4000000 in
-- The glued combination on the triple curve product is a large expression.
/-- **The Amitsur defect of a witness glues to a global unit of the triple curve
product** (the H⁰ step of `lm:aut`).  If `θ₀` cobounds the two coprojection pullbacks of
`γ` (`hdown`, the (N1) shape), the three coface pullbacks of that relation telescope
through the simplicial coincidences on the curve product, so the defect cochain is
Čech-compatible and glues by the `𝒪ˣ`-sheaf axiom.  No geometric hypotheses. -/
theorem exists_glued_productDefect
    (hdown : ∀ x y : Xq,
      (Xq).unitsRestrict (inf_le_left : 𝒲.opens x ⊓ 𝒲.opens y ≤ 𝒲.opens x) (θ₀ x)
          * (u₁).unitsAppLE (𝒩.opens ((u₁).base x) ⊓ 𝒩.opens ((u₁).base y))
              (𝒲.opens x ⊓ 𝒲.opens y)
              ((u₁).le_preimage_inf (inf_le_left.trans (hW₁ x))
                (inf_le_right.trans (hW₁ y)))
              (Scheme.unitsEvInf γ ((u₁).base x) ((u₁).base y))
        = (u₂).unitsAppLE (𝒩.opens ((u₂).base x) ⊓ 𝒩.opens ((u₂).base y))
              (𝒲.opens x ⊓ 𝒲.opens y)
              ((u₂).le_preimage_inf (inf_le_left.trans (hW₂ x))
                (inf_le_right.trans (hW₂ y)))
              (Scheme.unitsEvInf γ ((u₂).base x) ((u₂).base y))
          * (Xq).unitsRestrict inf_le_right (θ₀ y)) :
    ∃ εbar : Γ(Xcb, ⊤)ˣ, ∀ z : Xcb,
      (Xcb).unitsRestrict le_top εbar = productDefectCochain C 𝒲 θ₀ z := by
  apply Scheme.exists_global_unit_of_compatible (𝒰 := amitsurProductCover C 𝒲)
    (productDefectCochain C 𝒲 θ₀)
  intro z z'
  simp only [productDefectCochain, map_div, map_mul, Scheme.Hom.unitsAppLE_map]
  exact telescope_congr
    (productDefect_rel₂₃ C 𝒩 γ 𝒲 hW₁ hW₂ θ₀ hdown z z')
    (productDefect_rel₁₂ C 𝒩 γ 𝒲 hW₁ hW₂ θ₀ hdown z z')
    (productDefect_rel₁₃ C 𝒩 γ 𝒲 hW₁ hW₂ θ₀ hdown z z')

end pairRelations

end Over

end AlgebraicGeometry
