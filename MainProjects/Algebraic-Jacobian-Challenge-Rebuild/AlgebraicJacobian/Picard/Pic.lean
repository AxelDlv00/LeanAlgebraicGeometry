/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.CechH1

/-!
# The definitional Picard group: Čech `H¹` of the units presheaf

For a scheme `X`, this file defines the Picard group of record of this development:
the Čech cohomology `Ȟ¹(X, 𝒪_X^*)` on the small Zariski site, computed on **pointed
covers** (one open per point of `X`) and stabilized along the refinement preorder.
Pointed covers keep everything in `Type u` (the index type is the carrier of `X`),
refine indexwise (no reindexing functions), and are directed by pointwise `⊓`.

## Main declarations

* `AlgebraicGeometry.Scheme.PointedCover`: one open per point, containing it; a
  `SemilatticeInf` with an `OrderTop`, refinement `𝒱 ≤ 𝒰 ↔ ∀ x, 𝒱.opens x ≤ 𝒰.opens x`.
* `AlgebraicGeometry.Scheme.unitsCocycle`, `Scheme.unitsH1`: unit-valued Čech 1-cocycles
  and `H¹` on a pointed cover; `Scheme.unitsRes`: restriction along a refinement,
  a group homomorphism, strictly functorial (`unitsRes_unitsRes`).
* `AlgebraicGeometry.Scheme.CechPic`: the Picard group `Ȟ¹(X, 𝒪_X^*)` as the quotient
  of `Σ 𝒰, X.unitsH1 𝒰` by agreement on a common refinement, with its `CommGroup`
  structure and the constructor/eliminator API `CechPic.mk`, `CechPic.ind`,
  `CechPic.mk_eq_mk_iff`, `CechPic.mk_unitsRes`.
* `AlgebraicGeometry.Scheme.CechPic.map`: contravariant functoriality — for
  `f : X ⟶ Y` the pullback `Y.CechPic →* X.CechPic` — with the strict functor laws
  `CechPic.map_id` and `CechPic.map_comp` (the lane keystone).
* `AlgebraicGeometry.Scheme.CechPic.subsingleton_of_subsingleton`: on a scheme with a
  subsingleton underlying space (e.g. `Spec` of a field) the Picard group is trivial.
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite CategoryTheory.PresheafOfGroups

namespace AlgebraicGeometry

namespace Scheme

variable {X Y Z : Scheme.{u}}

/-! ## Pointed covers -/

/-- A pointed open cover of a scheme: one open per point, containing it. Pointed covers
are the index discipline of `Scheme.CechPic`: the index type is the carrier of `X` (so
everything stays in `Type u`), refinement is indexwise, and pointwise `⊓` makes the
refinement order directed. -/
structure PointedCover (X : Scheme.{u}) : Type u where
  /-- The member of the cover attached to a point. -/
  opens : X → X.Opens
  /-- Each point lies in its member. -/
  mem_opens : ∀ x, x ∈ opens x

namespace PointedCover

@[ext]
lemma ext {𝒰 𝒱 : X.PointedCover} (h : ∀ x, 𝒰.opens x = 𝒱.opens x) : 𝒰 = 𝒱 := by
  cases 𝒰; cases 𝒱
  simpa using funext h

instance : SemilatticeInf X.PointedCover where
  le 𝒱 𝒰 := ∀ x, 𝒱.opens x ≤ 𝒰.opens x
  le_refl 𝒰 x := le_rfl
  le_trans 𝒰 𝒱 𝒲 h₁ h₂ x := (h₁ x).trans (h₂ x)
  le_antisymm 𝒰 𝒱 h₁ h₂ := ext fun x ↦ le_antisymm (h₁ x) (h₂ x)
  inf 𝒰 𝒱 :=
    { opens := fun x ↦ 𝒰.opens x ⊓ 𝒱.opens x
      mem_opens := fun x ↦ ⟨𝒰.mem_opens x, 𝒱.mem_opens x⟩ }
  inf_le_left 𝒰 𝒱 x := inf_le_left
  inf_le_right 𝒰 𝒱 x := inf_le_right
  le_inf 𝒰 𝒱 𝒲 h₁ h₂ x := le_inf (h₁ x) (h₂ x)

instance : OrderTop X.PointedCover where
  top := { opens := fun _ ↦ ⊤, mem_opens := fun _ ↦ trivial }
  le_top 𝒰 x := le_top

lemma le_def {𝒰 𝒱 : X.PointedCover} : 𝒱 ≤ 𝒰 ↔ ∀ x, 𝒱.opens x ≤ 𝒰.opens x :=
  Iff.rfl

@[simp]
lemma inf_opens (𝒰 𝒱 : X.PointedCover) (x : X) :
    (𝒰 ⊓ 𝒱).opens x = 𝒰.opens x ⊓ 𝒱.opens x :=
  rfl

@[simp]
lemma top_opens (x : X) : (⊤ : X.PointedCover).opens x = ⊤ :=
  rfl

/-- The pullback of a pointed cover along a morphism of schemes: the pointed cover by
preimages, `x ↦ f ⁻¹ᵁ 𝒰.opens (f x)`. -/
def pullback (f : X ⟶ Y) (𝒰 : Y.PointedCover) : X.PointedCover where
  opens x := f ⁻¹ᵁ 𝒰.opens (f.base x)
  mem_opens x := 𝒰.mem_opens (f.base x)

@[simp]
lemma pullback_opens (f : X ⟶ Y) (𝒰 : Y.PointedCover) (x : X) :
    (𝒰.pullback f).opens x = f ⁻¹ᵁ 𝒰.opens (f.base x) :=
  rfl

lemma pullback_mono (f : X ⟶ Y) {𝒰 𝒱 : Y.PointedCover} (h : 𝒱 ≤ 𝒰) :
    𝒱.pullback f ≤ 𝒰.pullback f :=
  fun x ↦ ((TopologicalSpace.Opens.map f.base).map (homOfLE (h (f.base x)))).le

end PointedCover

/-! ## Unit cocycles on a pointed cover and their restriction -/

/-- The unit-valued Čech 1-cocycles of `X` on a pointed cover. -/
abbrev unitsCocycle (X : Scheme.{u}) (𝒰 : X.PointedCover) : Type u :=
  PresheafOfGroups.OneCocycle (X.unitsPresheaf ⋙ forget₂ CommGrpCat GrpCat) 𝒰.opens

/-- The unit-valued Čech `H¹` of `X` on a pointed cover. -/
abbrev unitsH1 (X : Scheme.{u}) (𝒰 : X.PointedCover) : Type u :=
  PresheafOfGroups.H1 (X.unitsPresheaf ⋙ forget₂ CommGrpCat GrpCat) 𝒰.opens

/-- Restriction of unit Čech classes along a refinement of pointed covers, as a group
homomorphism. -/
def unitsRes {𝒰 𝒱 : X.PointedCover} (h : 𝒱 ≤ 𝒰) : X.unitsH1 𝒰 →* X.unitsH1 𝒱 :=
  H1.resHom fun x ↦ homOfLE (h x)

/-- Restriction along refinements of pointed covers is strictly functorial. -/
@[simp]
lemma unitsRes_unitsRes {𝒰 𝒱 𝒲 : X.PointedCover} (h₁ : 𝒱 ≤ 𝒰) (h₂ : 𝒲 ≤ 𝒱)
    (a : X.unitsH1 𝒰) : unitsRes h₂ (unitsRes h₁ a) = unitsRes (h₂.trans h₁) a :=
  H1.res_res _ _ a

@[simp]
lemma unitsRes_rfl {𝒰 : X.PointedCover} {h : 𝒰 ≤ 𝒰} (a : X.unitsH1 𝒰) :
    unitsRes h a = a :=
  H1.res_id a

/-! ## The Picard group -/

instance cechPicSetoid (X : Scheme.{u}) : Setoid (Σ 𝒰 : X.PointedCover, X.unitsH1 𝒰) where
  r p q := ∃ (𝒲 : X.PointedCover) (h₁ : 𝒲 ≤ p.1) (h₂ : 𝒲 ≤ q.1),
    unitsRes h₁ p.2 = unitsRes h₂ q.2
  iseqv := by
    constructor
    · exact fun p ↦ ⟨p.1, le_rfl, le_rfl, rfl⟩
    · rintro p q ⟨𝒲, h₁, h₂, e⟩
      exact ⟨𝒲, h₂, h₁, e.symm⟩
    · rintro p q r ⟨𝒲₁, h₁, h₂, e₁⟩ ⟨𝒲₂, h₃, h₄, e₂⟩
      refine ⟨𝒲₁ ⊓ 𝒲₂, inf_le_left.trans h₁, inf_le_right.trans h₄, ?_⟩
      have e₁' := congrArg (unitsRes (inf_le_left : 𝒲₁ ⊓ 𝒲₂ ≤ 𝒲₁)) e₁
      have e₂' := congrArg (unitsRes (inf_le_right : 𝒲₁ ⊓ 𝒲₂ ≤ 𝒲₂)) e₂
      simp only [unitsRes_unitsRes] at e₁' e₂'
      exact e₁'.trans e₂'

/-- The definitional Picard group of a scheme: Čech `H¹` of the units presheaf,
stabilized along refinement of pointed covers. -/
def CechPic (X : Scheme.{u}) : Type u :=
  Quotient (cechPicSetoid X)

namespace CechPic

/-- The Picard class of a unit Čech `H¹` class on a pointed cover. -/
def mk (𝒰 : X.PointedCover) (a : X.unitsH1 𝒰) : X.CechPic :=
  ⟦⟨𝒰, a⟩⟧

@[elab_as_elim]
theorem ind {motive : X.CechPic → Prop}
    (mk : ∀ (𝒰 : X.PointedCover) (a : X.unitsH1 𝒰), motive (mk 𝒰 a)) (x : X.CechPic) :
    motive x :=
  Quotient.ind (fun p ↦ by obtain ⟨𝒰, a⟩ := p; exact mk 𝒰 a) x

theorem mk_eq_mk_iff {𝒰 𝒱 : X.PointedCover} {a : X.unitsH1 𝒰} {b : X.unitsH1 𝒱} :
    mk 𝒰 a = mk 𝒱 b ↔
      ∃ (𝒲 : X.PointedCover) (h₁ : 𝒲 ≤ 𝒰) (h₂ : 𝒲 ≤ 𝒱),
        unitsRes h₁ a = unitsRes h₂ b :=
  Quotient.eq

/-- Two classes agreeing after restriction to a common refinement are equal; in
particular `mk` is invariant under restriction. -/
@[simp]
theorem mk_unitsRes {𝒰 𝒱 : X.PointedCover} (h : 𝒱 ≤ 𝒰) (a : X.unitsH1 𝒰) :
    mk 𝒱 (unitsRes h a) = mk 𝒰 a :=
  Quotient.sound ⟨𝒱, le_rfl, h, unitsRes_rfl _⟩

private def mulSig (p q : Σ 𝒰 : X.PointedCover, X.unitsH1 𝒰) :
    Σ 𝒰 : X.PointedCover, X.unitsH1 𝒰 :=
  ⟨p.1 ⊓ q.1, unitsRes inf_le_left p.2 * unitsRes inf_le_right q.2⟩

private lemma mulSig_compat {p p' q q' : Σ 𝒰 : X.PointedCover, X.unitsH1 𝒰}
    (hp : p ≈ p') (hq : q ≈ q') : mulSig p q ≈ mulSig p' q' := by
  obtain ⟨𝒲₁, h₁, h₂, e₁⟩ := hp
  obtain ⟨𝒲₂, h₃, h₄, e₂⟩ := hq
  refine ⟨𝒲₁ ⊓ 𝒲₂, inf_le_inf (inf_le_left.trans h₁) (inf_le_right.trans h₃),
    inf_le_inf (inf_le_left.trans h₂) (inf_le_right.trans h₄), ?_⟩
  have e₁' := congrArg (unitsRes (inf_le_left : 𝒲₁ ⊓ 𝒲₂ ≤ 𝒲₁)) e₁
  have e₂' := congrArg (unitsRes (inf_le_right : 𝒲₁ ⊓ 𝒲₂ ≤ 𝒲₂)) e₂
  simp only [unitsRes_unitsRes] at e₁' e₂'
  simp only [mulSig, map_mul, unitsRes_unitsRes]
  rw [e₁', e₂']

instance : CommGroup X.CechPic where
  mul := Quotient.map₂ mulSig (fun _ _ hp _ _ hq ↦ mulSig_compat hp hq)
  one := mk ⊤ 1
  inv := Quotient.map (fun p ↦ ⟨p.1, p.2⁻¹⟩) (by
    rintro p p' ⟨𝒲, h₁, h₂, e⟩
    exact ⟨𝒲, h₁, h₂, by simp only [map_inv, e]⟩)
  mul_assoc a b c := by
    induction a using CechPic.ind with | _ 𝒰 a =>
    induction b using CechPic.ind with | _ 𝒱 b =>
    induction c using CechPic.ind with | _ 𝒳 c =>
    refine Quotient.sound ⟨𝒰 ⊓ 𝒱 ⊓ 𝒳, le_rfl, le_inf (inf_le_left.trans inf_le_left)
      (inf_le_inf (inf_le_left.trans inf_le_right) le_rfl), ?_⟩
    simp only [mulSig, map_mul, unitsRes_unitsRes, unitsRes_rfl]
    exact mul_assoc _ _ _
  one_mul a := by
    induction a using CechPic.ind with | _ 𝒰 a =>
    refine Quotient.sound ⟨⊤ ⊓ 𝒰, le_rfl, inf_le_right, ?_⟩
    simp only [mulSig, map_mul, map_one, unitsRes_unitsRes, unitsRes_rfl, one_mul]
  mul_one a := by
    induction a using CechPic.ind with | _ 𝒰 a =>
    refine Quotient.sound ⟨𝒰 ⊓ ⊤, le_rfl, inf_le_left, ?_⟩
    simp only [mulSig, map_mul, map_one, unitsRes_unitsRes, unitsRes_rfl, mul_one]
  inv_mul_cancel a := by
    induction a using CechPic.ind with | _ 𝒰 a =>
    refine Quotient.sound ⟨𝒰 ⊓ 𝒰, le_rfl, le_top, ?_⟩
    simp only [mulSig, map_mul, map_inv, map_one, unitsRes_unitsRes, unitsRes_rfl]
    exact inv_mul_cancel _
  mul_comm a b := by
    induction a using CechPic.ind with | _ 𝒰 a =>
    induction b using CechPic.ind with | _ 𝒱 b =>
    refine Quotient.sound ⟨𝒰 ⊓ 𝒱, le_rfl, le_inf inf_le_right inf_le_left, ?_⟩
    simp only [mulSig, map_mul, unitsRes_unitsRes, unitsRes_rfl]
    exact mul_comm _ _

lemma one_def : (1 : X.CechPic) = mk ⊤ 1 :=
  rfl

@[simp]
lemma mk_one (𝒰 : X.PointedCover) : mk 𝒰 (1 : X.unitsH1 𝒰) = 1 :=
  Quotient.sound ⟨𝒰, le_rfl, le_top, by simp only [map_one, unitsRes_rfl]⟩

@[simp]
lemma mk_mul_mk (𝒰 : X.PointedCover) (a b : X.unitsH1 𝒰) :
    mk 𝒰 a * mk 𝒰 b = mk 𝒰 (a * b) := by
  refine Quotient.sound ⟨𝒰 ⊓ 𝒰, le_rfl, inf_le_left, ?_⟩
  simp only [mulSig, map_mul, unitsRes_unitsRes, unitsRes_rfl]

@[simp]
lemma mk_inv (𝒰 : X.PointedCover) (a : X.unitsH1 𝒰) : (mk 𝒰 a)⁻¹ = mk 𝒰 a⁻¹ :=
  rfl

end CechPic

/-! ## Functoriality: pullback of unit cocycles and Picard classes -/

/-- If `U` is contained in the preimages of two opens, it is contained in the preimage
of their intersection. -/
lemma Hom.le_preimage_inf (f : X.Hom Y) {U : X.Opens} {V₁ V₂ : Y.Opens}
    (h₁ : U ≤ f ⁻¹ᵁ V₁) (h₂ : U ≤ f ⁻¹ᵁ V₂) : U ≤ f ⁻¹ᵁ (V₁ ⊓ V₂) :=
  fun x hx ↦ ⟨h₁ hx, h₂ hx⟩

namespace Hom

variable (f : X ⟶ Y) {𝒰 𝒲 : Y.PointedCover}

/-- The pullback of a unit 1-cocycle along a morphism of schemes, on the pulled-back
pointed cover. -/
def pullbackUnitsCocycle (f : X ⟶ Y) (γ : Y.unitsCocycle 𝒰) :
    X.unitsCocycle (𝒰.pullback f) where
  ev x y _ a b :=
    f.unitsAppLE (𝒰.opens (f.base x) ⊓ 𝒰.opens (f.base y)) _
      (f.le_preimage_inf a.le b.le) (γ.evInf (f.base x) (f.base y))
  ev_precomp x y T T' φ a b := by simp
  ev_trans x y z T a b c := by
    have h := congrArg
      (f.unitsAppLE (𝒰.opens (f.base x) ⊓ 𝒰.opens (f.base y) ⊓ 𝒰.opens (f.base z)) T
        (f.le_preimage_inf (f.le_preimage_inf a.le b.le) c.le))
      (γ.evInf_trans (f.base x) (f.base y) (f.base z))
    simpa using h

@[simp]
lemma pullbackUnitsCocycle_ev (γ : Y.unitsCocycle 𝒰) (x y : X) {T : X.Opens}
    (a : T ⟶ (𝒰.pullback f).opens x) (b : T ⟶ (𝒰.pullback f).opens y) :
    (f.pullbackUnitsCocycle γ).ev x y a b
      = f.unitsAppLE (𝒰.opens (f.base x) ⊓ 𝒰.opens (f.base y)) T
          (f.le_preimage_inf a.le b.le) (γ.evInf (f.base x) (f.base y)) :=
  rfl

@[simp]
lemma pullbackUnitsCocycle_evInf (γ : Y.unitsCocycle 𝒰) (x y : X) :
    (f.pullbackUnitsCocycle γ).evInf x y
      = f.unitsAppLE (𝒰.opens (f.base x) ⊓ 𝒰.opens (f.base y))
          ((𝒰.pullback f).opens x ⊓ (𝒰.pullback f).opens y)
          (f.le_preimage_inf inf_le_left inf_le_right)
          (γ.evInf (f.base x) (f.base y)) :=
  rfl

@[simp]
lemma pullbackUnitsCocycle_one :
    f.pullbackUnitsCocycle (1 : Y.unitsCocycle 𝒰) = 1 := by
  ext x y T a b
  simp

@[simp]
lemma pullbackUnitsCocycle_mul (γ₁ γ₂ : Y.unitsCocycle 𝒰) :
    f.pullbackUnitsCocycle (γ₁ * γ₂)
      = f.pullbackUnitsCocycle γ₁ * f.pullbackUnitsCocycle γ₂ := by
  ext x y T a b
  simp

/-- Pullback of unit cocycles commutes with restriction along a refinement. -/
lemma pullbackUnitsCocycle_res (h : 𝒲 ≤ 𝒰) (γ : Y.unitsCocycle 𝒰) :
    (f.pullbackUnitsCocycle γ).res (fun x ↦ homOfLE (PointedCover.pullback_mono f h x))
      = f.pullbackUnitsCocycle (γ.res (fun y ↦ homOfLE (h y))) := by
  ext x y T a b
  simp only [OneCocycle.res_toOneCochain, OneCochain.res_ev, pullbackUnitsCocycle_ev,
    OneCocycle.res_evInf]
  simp

/-- Pullback of a cohomology relation along a morphism of schemes. -/
lemma pullbackUnitsCocycle_isCohomologous {γ₁ γ₂ : Y.unitsCocycle 𝒰}
    (h : γ₁.IsCohomologous γ₂) :
    (f.pullbackUnitsCocycle γ₁).IsCohomologous (f.pullbackUnitsCocycle γ₂) := by
  obtain ⟨α, hα⟩ := h
  refine ⟨fun x ↦ f.unitsAppLE (𝒰.opens (f.base x)) ((𝒰.pullback f).opens x) le_rfl
    (α (f.base x)), fun x y T a b ↦ ?_⟩
  have h' := congrArg
    (f.unitsAppLE (𝒰.opens (f.base x) ⊓ 𝒰.opens (f.base y)) T
      (f.le_preimage_inf a.le b.le))
    (hα (f.base x) (f.base y) (homOfLE inf_le_left) (homOfLE inf_le_right))
  simpa using h'

/-- The pullback of unit Čech `H¹` classes along a morphism of schemes. -/
def pullbackUnitsH1 (f : X ⟶ Y) (𝒰 : Y.PointedCover) :
    Y.unitsH1 𝒰 →* X.unitsH1 (𝒰.pullback f) where
  toFun := Quot.map f.pullbackUnitsCocycle
    (fun _ _ h ↦ f.pullbackUnitsCocycle_isCohomologous h)
  map_one' := congrArg OneCocycle.class f.pullbackUnitsCocycle_one
  map_mul' a b := by
    induction a using Quot.ind with | _ γ₁ =>
    induction b using Quot.ind with | _ γ₂ =>
    exact congrArg (Quot.mk _) (f.pullbackUnitsCocycle_mul γ₁ γ₂)

@[simp]
lemma pullbackUnitsH1_class (γ : Y.unitsCocycle 𝒰) :
    f.pullbackUnitsH1 𝒰 γ.class = (f.pullbackUnitsCocycle γ).class :=
  rfl

/-- Pullback of unit `H¹` classes commutes with restriction along a refinement. -/
lemma unitsRes_pullbackUnitsH1 (h : 𝒲 ≤ 𝒰) (a : Y.unitsH1 𝒰) :
    unitsRes (PointedCover.pullback_mono f h) (f.pullbackUnitsH1 𝒰 a)
      = f.pullbackUnitsH1 𝒲 (unitsRes h a) := by
  induction a using Quot.ind with
  | _ γ => exact congrArg (Quot.mk _) (f.pullbackUnitsCocycle_res h γ)

end Hom

namespace CechPic

/-- Contravariant functoriality of the Čech Picard group: pull the cover back pointwise,
pull the unit cocycles back through `f`, restrict. -/
def map (f : X ⟶ Y) : Y.CechPic →* X.CechPic where
  toFun := Quotient.map (fun p ↦ ⟨p.1.pullback f, f.pullbackUnitsH1 p.1 p.2⟩) (by
    rintro ⟨𝒰, a⟩ ⟨𝒱, b⟩ ⟨𝒲, h₁, h₂, e⟩
    refine ⟨𝒲.pullback f, PointedCover.pullback_mono f h₁,
      PointedCover.pullback_mono f h₂, ?_⟩
    rw [Hom.unitsRes_pullbackUnitsH1, Hom.unitsRes_pullbackUnitsH1, e])
  map_one' := by
    refine Quotient.sound ⟨(⊤ : Y.PointedCover).pullback f, le_rfl, le_top, ?_⟩
    simp only [map_one, unitsRes_rfl]
  map_mul' a b := by
    induction a using CechPic.ind with | _ 𝒰 a =>
    induction b using CechPic.ind with | _ 𝒱 b =>
    refine Quotient.sound ⟨𝒰.pullback f ⊓ 𝒱.pullback f,
      fun x ↦ f.le_preimage_inf inf_le_left inf_le_right, le_rfl, ?_⟩
    simp only [mulSig, map_mul, ← Hom.unitsRes_pullbackUnitsH1, unitsRes_unitsRes,
      unitsRes_rfl]

@[simp]
lemma map_mk (f : X ⟶ Y) (𝒰 : Y.PointedCover) (a : Y.unitsH1 𝒰) :
    map f (mk 𝒰 a) = mk (𝒰.pullback f) (f.pullbackUnitsH1 𝒰 a) :=
  rfl

/-- Pullback of Picard classes along the identity is the identity. -/
@[simp]
theorem map_id (X : Scheme.{u}) : map (𝟙 X) = MonoidHom.id X.CechPic := by
  refine MonoidHom.ext fun x ↦ ?_
  induction x using CechPic.ind with | _ 𝒰 a =>
  refine mk_eq_mk_iff.mpr ⟨𝒰, fun x ↦ le_rfl, le_rfl, ?_⟩
  induction a using Quot.ind with | _ γ =>
  refine congrArg (Quot.mk _) ?_
  ext x y T a b
  rw [OneCocycle.res_toOneCochain, OneCochain.res_ev, Hom.pullbackUnitsCocycle_ev,
    id_unitsAppLE, ← unitsPresheaf_forget₂_map_apply]
  exact (γ.toOneCochain.ev_eq_evInf _ _ a b).symm

/-- Pullback of Picard classes along a composite (the lane keystone). -/
@[simp]
theorem map_comp (f : X ⟶ Y) (g : Y ⟶ Z) : map (f ≫ g) = (map f).comp (map g) := by
  refine MonoidHom.ext fun x ↦ ?_
  induction x using CechPic.ind with | _ 𝒰 a =>
  refine mk_eq_mk_iff.mpr ⟨𝒰.pullback (f ≫ g), le_rfl, fun x ↦ le_rfl, ?_⟩
  induction a using Quot.ind with | _ γ =>
  refine congrArg (Quot.mk _) ?_
  ext x y T a b
  rw [OneCocycle.res_toOneCochain, OneCochain.res_ev, Hom.pullbackUnitsCocycle_ev,
    Hom.pullbackUnitsCocycle_ev, Hom.pullbackUnitsCocycle_evInf, unitsAppLE_unitsAppLE]
  rfl

/-! ## Sanity gate: triviality over a field -/

/-- On a scheme with a subsingleton underlying space — e.g. `Spec` of a field — the
Čech Picard group is trivial: every pointed cover is a cover by a single open, on which
every unit cocycle is a coboundary. -/
instance subsingleton_of_subsingleton (X : Scheme.{u}) [Subsingleton X] :
    Subsingleton X.CechPic := by
  refine ⟨fun p q ↦ ?_⟩
  induction p using CechPic.ind with | _ 𝒰 a =>
  induction q using CechPic.ind with | _ 𝒱 b =>
  refine mk_eq_mk_iff.mpr ⟨𝒰 ⊓ 𝒱, inf_le_left, inf_le_right, ?_⟩
  have := H1.subsingleton_of_forall_le (X.unitsPresheaf ⋙ forget₂ CommGrpCat GrpCat)
    (𝒰 ⊓ 𝒱).opens (fun i j ↦ le_of_eq (congrArg _ (Subsingleton.elim i j)))
  exact Subsingleton.elim _ _

/-- The Čech Picard group of the spectrum of a field is trivial. -/
theorem eq_one_of_subsingleton (X : Scheme.{u}) [Subsingleton X] (x : X.CechPic) :
    x = 1 :=
  Subsingleton.elim x 1

example {K : Type u} [Field K] (x : (Spec (CommRingCat.of K)).CechPic) : x = 1 :=
  eq_one_of_subsingleton _ x

end CechPic

end Scheme

end AlgebraicGeometry
