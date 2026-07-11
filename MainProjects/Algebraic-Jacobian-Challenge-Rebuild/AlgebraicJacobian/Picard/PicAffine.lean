/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicAffineCover
import AlgebraicJacobian.Picard.FamilyCoboundary

/-!
# The Čech–Picard dictionary for affine schemes: the descent homomorphism

For an affine scheme `X`, this file assembles the Picard classes of unit Čech cocycles
along basic refinements (`AlgebraicJacobian.Picard.PicAffineCover`) into an injective
group homomorphism

* `AlgebraicGeometry.Scheme.CechPic.toPic : X.CechPic →* CommRing.Pic Γ(X, ⊤)`

from the definitional Čech Picard group into mathlib's Picard group of the global
sections.  (Surjectivity — hence the full dictionary `X.CechPic ≃* CommRing.Pic Γ(X, ⊤)`
— is the invertible-module-trivialization direction, treated separately.)

The core is the **independence of the descent Picard class from every choice**
(`BasicRefinement.pic_congr`): representing cocycle of the `H¹` class, basic refinement,
and pointed cover.  All comparisons are routed through three elementary moves:

* `pic_res` — replacing the pointed cover by a finer one and restricting the cocycle
  does not change the refinement data nor the class (the restricted evaluations agree on
  the nose);
* `pic_eq_of_isCohomologous` — cohomologous cocycles give equal classes (the comparison
  restricts to an index-wise coboundary; coboundary invariance of the descended module);
* `pic_interFst` / `pic_inter` / `pic_interFst_eq_inter` — any two basic refinements of
  the same cover are dominated by their merge, on which the two point-selections differ
  by the index-wise coboundary of the cross evaluations `γ (pt i, pt' j)`; hence all
  refinements give the same class.

Injectivity is refinement injectivity: a trivial descent class makes the descent unit a
coboundary (`Module.IsDescentCocycle.picClass_eq_one_iff`), whose components glue back to
a coboundary on the pointed cover itself
(`AlgebraicGeometry.Scheme.unitsH1_eq_one_of_family`).
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite TopologicalSpace CategoryTheory.PresheafOfGroups

namespace AlgebraicGeometry

namespace Scheme

namespace PointedCover.BasicRefinement

variable {X : Scheme.{u}}

/-! ## Lifting refinements along cover refinement -/

/-- A basic refinement of a finer pointed cover is one of the coarser cover. -/
@[simps ι pt r]
def ofLE {𝒰 𝒱 : X.PointedCover} (h : 𝒱 ≤ 𝒰) (P : 𝒱.BasicRefinement) :
    𝒰.BasicRefinement where
  ι := P.ι
  pt := P.pt
  r := P.r
  basicOpen_le i := (P.basicOpen_le i).trans (h (P.pt i))
  iSup_eq := P.iSup_eq

/-- The merge of two basic refinements pointed by the **first** factor. -/
@[simps ι pt r]
def interFst {𝒰 𝒱 : X.PointedCover} (P : 𝒰.BasicRefinement) (Q : 𝒱.BasicRefinement) :
    𝒰.BasicRefinement where
  ι := P.ι × Q.ι
  pt p := P.pt p.1
  r p := P.r p.1 * Q.r p.2
  basicOpen_le p := ((X.basicOpen_mul _ _).trans_le inf_le_left).trans (P.basicOpen_le p.1)
  iSup_eq := (P.inter Q).iSup_eq

section pic

variable [IsAffine X] {𝒰 𝒱 : X.PointedCover}

/-! ## Move 1: restriction along a refinement of pointed covers -/

/-- Restricting the cocycle to a finer pointed cover and lifting the basic refinement
back does not change the Picard class: the two cover cocycles agree on the nose. -/
theorem pic_ofLE (h : 𝒱 ≤ 𝒰) (P : 𝒱.BasicRefinement) (γ : X.unitsCocycle 𝒰) :
    (P.ofLE h).pic γ = P.pic (γ.res fun x ↦ homOfLE (h x)) := by
  -- Both sides are `picClass` of `isDescentCocycle_cocycleUnit` for the same data:
  -- `coverCocycle` of the restricted cocycle is the composed restriction of the same
  -- evaluations (`res_unitsEvInf`, `unitsRestrict_unitsRestrict`, proof irrelevance).
  sorry

/-! ## Move 2: cohomologous cocycles -/

/-- Cohomologous unit cocycles have the same Picard class along any basic refinement. -/
theorem pic_eq_of_isCohomologous (P : 𝒰.BasicRefinement) {γ γ' : X.unitsCocycle 𝒰}
    (h : γ.IsCohomologous γ') : P.pic γ = P.pic γ' := by
  -- Extract `α` with the evaluation-wise comparison
  -- (`OneCocycle.isCohomologous_iff_evInf`), restrict to the members of `P`, and apply
  -- `IsLocalization.AwayCover.picClass_eq_of_coboundary` with
  -- `β i := X.unitsRestrict (P.basicOpen_le i) (α (P.pt i))`; the component relation is
  -- the restriction of the comparison at the pair `(P.pt i, P.pt j)`, with the canonical
  -- maps rewritten to restrictions via `Scheme.basicOpen_algHom_ext`.
  sorry

/-! ## Move 3: change of basic refinement -/

/-- Refine-compare along the first projection: the merge pointed by `P` has the same
Picard class as `P`. -/
theorem pic_interFst (P : 𝒰.BasicRefinement) (Q : 𝒱.BasicRefinement)
    (γ : X.unitsCocycle 𝒰) : (P.interFst Q).pic γ = P.pic γ := by
  -- `IsLocalization.AwayCover.picClass_map_refine`-style comparison along
  -- `τ := Prod.fst`; the points agree (`interFst.pt = P.pt ∘ Prod.fst`), so the fine
  -- cover cocycle is on the nose the `refineOverlapAlgHom`-image of the coarse one
  -- (canonical maps = restrictions, `Scheme.basicOpen_algHom_ext`).
  sorry

/-- Refine-compare along the second projection: the merge pointed by `Q` has the same
Picard class as `Q`. -/
theorem pic_inter (P : 𝒰.BasicRefinement) (Q : 𝒱.BasicRefinement)
    (γ : X.unitsCocycle 𝒱) : (P.inter Q).pic γ = Q.pic γ := by
  sorry

/-- The two point-selections on the merge of two refinements of the same cover give the
same Picard class: they differ by the index-wise coboundary of the cross evaluations
`γ (P.pt i, Q.pt j)`. -/
theorem pic_interFst_eq_inter (P Q : 𝒰.BasicRefinement) (γ : X.unitsCocycle 𝒰) :
    (P.interFst Q).pic γ = (P.inter Q).pic γ := by
  -- `IsLocalization.AwayCover.picClass_eq_of_coboundary` with
  -- `β p := X.unitsRestrict _ (unitsEvInf γ (P.pt p.1) (Q.pt p.2))`; the component
  -- relation follows from two applications of `unitsEvInf_trans` (at
  -- `(P.pt p.1, Q.pt p.2, Q.pt q.2)` and `(P.pt p.1, P.pt q.1, Q.pt q.2)`) restricted to
  -- the double overlap.
  sorry

/-- **Any two basic refinements of the same pointed cover give the same Picard
class.** -/
theorem pic_eq_pic (P Q : 𝒰.BasicRefinement) (γ : X.unitsCocycle 𝒰) :
    P.pic γ = Q.pic γ :=
  ((pic_interFst P Q γ).symm.trans (pic_interFst_eq_inter P Q γ)).trans (pic_inter P Q γ)

/-! ## The master comparison -/

/-- **Full choice-independence of the descent Picard class**: if two cocycles on two
pointed covers restrict to cohomologous cocycles on a common refinement, their Picard
classes along arbitrary basic refinements agree. -/
theorem pic_congr {𝒲 : X.PointedCover} (h₁ : 𝒲 ≤ 𝒰) (h₂ : 𝒲 ≤ 𝒱)
    (P : 𝒰.BasicRefinement) (Q : 𝒱.BasicRefinement)
    {γ : X.unitsCocycle 𝒰} {γ' : X.unitsCocycle 𝒱}
    (h : (γ.res fun x ↦ homOfLE (h₁ x)).IsCohomologous (γ'.res fun x ↦ homOfLE (h₂ x))) :
    P.pic γ = Q.pic γ' := by
  obtain ⟨R⟩ := BasicRefinement.nonempty 𝒲
  calc
    P.pic γ = (R.ofLE h₁).pic γ := pic_eq_pic P (R.ofLE h₁) γ
    _ = R.pic (γ.res fun x ↦ homOfLE (h₁ x)) := pic_ofLE h₁ R γ
    _ = R.pic (γ'.res fun x ↦ homOfLE (h₂ x)) := pic_eq_of_isCohomologous R h
    _ = (R.ofLE h₂).pic γ' := (pic_ofLE h₂ R γ').symm
    _ = Q.pic γ' := pic_eq_pic (R.ofLE h₂) Q γ'

/-! ## Multiplicativity and normalization on a fixed refinement -/

/-- The Picard class of the trivial cocycle is trivial. -/
theorem pic_one (P : 𝒰.BasicRefinement) : P.pic (1 : X.unitsCocycle 𝒰) = 1 := by
  -- `coverCocycle 1 = 1` (evaluations of the trivial cocycle are `1`), `cocycleUnit` is
  -- multiplicative-unital, and `Module.IsDescentCocycle.picClass_one` applies through
  -- `picClass_congr`.
  sorry

/-- The Picard class is multiplicative in the cocycle. -/
theorem pic_mul (P : 𝒰.BasicRefinement) (γ γ' : X.unitsCocycle 𝒰) :
    P.pic (γ * γ') = P.pic γ * P.pic γ' := by
  -- `coverCocycle` is multiplicative (evaluations and restriction are), then
  -- `IsLocalization.AwayCover.cocycleUnit_mul` and
  -- `Module.IsDescentCocycle.picClass_mul` through `picClass_congr`.
  sorry

/-! ## Triviality detection -/

/-- If the Picard class of a cocycle vanishes, the cocycle is a coboundary: its `H¹`
class is trivial. -/
theorem class_eq_one_of_pic_eq_one (P : 𝒰.BasicRefinement) (γ : X.unitsCocycle 𝒰)
    (h : P.pic γ = 1) : γ.class = (1 : X.unitsH1 𝒰) := by
  -- `Module.IsDescentCocycle.picClass_eq_one_iff` produces a unit `β` of the cover
  -- algebra with `cocycleUnit (coverCocycle γ) = descentCoboundary β`;
  -- `IsLocalization.AwayCover.exists_units_of_cocycleUnit_eq_descentCoboundary` turns it
  -- into the index-wise relation, whose restriction to `D(r i) ⊓ D(r j)` is (after
  -- commuting the two unit factors) the hypothesis of `unitsH1_eq_one_of_family` with
  -- `E i := X.basicOpen (P.r i)`, `p := P.pt` and `α := MulEquiv.piUnits β`.
  sorry

end pic

end PointedCover.BasicRefinement

/-! ## The descent homomorphism -/

namespace CechPic

open PointedCover

variable (X : Scheme.{u}) [IsAffine X]

/-- The underlying function of `CechPic.toPic`: descend along a chosen basic refinement
of a chosen representative. -/
noncomputable def toPicFun : X.CechPic → CommRing.Pic Γ(X, ⊤) :=
  Quotient.lift
    (fun p : Σ 𝒰 : X.PointedCover, X.unitsH1 𝒰 ↦
      (BasicRefinement.nonempty p.1).some.pic p.2.out)
    (by
      rintro ⟨𝒰, a⟩ ⟨𝒱, b⟩ ⟨𝒲, h₁, h₂, e⟩
      -- The restrictions of the chosen representatives to `𝒲` are cohomologous:
      -- their `H¹` classes are `unitsRes h₁ a = unitsRes h₂ b`.
      sorry)

variable {X}

@[simp]
lemma toPicFun_mk (𝒰 : X.PointedCover) (γ : X.unitsCocycle 𝒰)
    (P : 𝒰.BasicRefinement) : toPicFun X (CechPic.mk 𝒰 γ.class) = P.pic γ := by
  -- The chosen data compare to `(P, γ)` by `BasicRefinement.pic_congr` with `𝒲 := 𝒰`
  -- (the representative `Quot.out (γ.class)` is cohomologous to `γ`).
  sorry

variable (X)

/-- **The Čech–Picard descent homomorphism** of an affine scheme: from the definitional
Čech Picard group to mathlib's Picard group of the global sections, by faithfully flat
descent along finite basic covers. -/
noncomputable def toPic : X.CechPic →* CommRing.Pic Γ(X, ⊤) where
  toFun := toPicFun X
  map_one' := by
    have h : (1 : X.CechPic) = CechPic.mk ⊤ (OneCocycle.class 1) := rfl
    obtain ⟨P⟩ := BasicRefinement.nonempty (⊤ : X.PointedCover)
    rw [h, toPicFun_mk _ _ P]
    exact P.pic_one
  map_mul' x y := by
    induction x using CechPic.ind with | _ 𝒰 a =>
    induction y using CechPic.ind with | _ 𝒱 b =>
    obtain ⟨P⟩ := BasicRefinement.nonempty (𝒰 ⊓ 𝒱)
    induction a using Quot.ind with | _ γ =>
    induction b using Quot.ind with | _ δ =>
    -- rewrite the product as a single class on `𝒰 ⊓ 𝒱` and apply `pic_mul`
    sorry

variable {X}

@[simp]
lemma toPic_mk (𝒰 : X.PointedCover) (γ : X.unitsCocycle 𝒰) (P : 𝒰.BasicRefinement) :
    toPic X (CechPic.mk 𝒰 γ.class) = P.pic γ :=
  toPicFun_mk 𝒰 γ P

/-- **Injectivity of the descent homomorphism**: refinement injectivity for the Čech
Picard group against mathlib's Picard group. -/
theorem toPic_injective : Function.Injective (toPic X) := by
  rw [injective_iff_map_eq_one]
  intro x hx
  induction x using CechPic.ind with | _ 𝒰 a =>
  induction a using Quot.ind with | _ γ =>
  obtain ⟨P⟩ := BasicRefinement.nonempty 𝒰
  rw [show Quot.mk _ γ = OneCocycle.class γ from rfl] at hx ⊢
  rw [toPic_mk 𝒰 γ P] at hx
  rw [BasicRefinement.class_eq_one_of_pic_eq_one P γ hx]
  exact CechPic.mk_one 𝒰

end CechPic

end Scheme

end AlgebraicGeometry
