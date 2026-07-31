/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Curve.P1DegreeZeroTrivial
import AlgebraicJacobian.Picard.Pic0VanishingAffineReduction

/-!
# `Pic⁰(ℙ¹)` VANISHES AT EVERY FIELD TEST — the first producer of the hypothesis at a curve

`hvan : ∀ T, Subsingleton (pic0Subgroup C T)` is where both live routes to a `rep` producer
meet, and it has had **no producer at any curve**.  This file supplies it at `ℙ¹` for every
test of the form `overSpec k K` with `K/k` a field extension:

  `Subsingleton (pic0Subgroup (P1.asOver k) (overSpec k K))`.

That is a genuine instance of the hypothesis, not a reformulation of it: nothing here assumes
a vanishing, a chart atlas, a coverage clause, a divisor representability, or a rational point.

## Why the field case is not the fibrewise case

`Curve/P1DegreeZeroTrivial.lean` proves that a Čech Picard class on `ℙ¹_K` of degree `0` is
trivial.  That is a statement about `CechPic`, and `pic0Subgroup` is three constructions above
it: `pic0Subgroup C T ≤ picEt C T`, `picEt C T` is a compatible family of `PicEtAff C Γ(T,U)`
over the affine opens of `T`, and `PicEtAff C A` is the one-step étale **plus** of
`relPic C (overSpec k A)`, itself a quotient of `CechPic ((C ⊗ overSpec k A).left)`.  Getting
from the bottom to the top is the content below, and each of the three steps is a real one.

## The three steps

1. **`relPic`** (`relPic_eq_one_of_relPicDeg_eq_zero`).  `relPic` is `CechPic` modulo classes
   pulled back from the base, so a class is `relPicMk L`; `relPicDeg` of it is `classDeg L` by
   the anchor, and the degree-zero triviality applies to `L` itself.

2. **`PicEtAff`** (`picEtAff_eq_one_of_degAff_eq_zero`), the step with actual content.  A plus
   class is represented on an *étale cover* `E`, not on a field, and `relPic` triviality is
   only available over fields.  The bridge is that field covers are **cofinal**
   (`Algebra.EtaleCover.exists_finiteSeparableField_algHom`): refine `E` into a finite
   separable field extension `L/K`, where `degAff_mk` says the degree is `relPicDeg L` of the
   transported representative.  Step 1 at `L` kills it, and `mk_descentMap` says the plus class
   computed on the refinement is the same class.

   One detail worth recording because it removes an obligation: the transport is pushed
   **forward** along the inverse of the carrier identification `ofFieldEquiv`, so no
   injectivity of `relPicAlgMap` is needed — and the tree proves none.

3. **`pic0Subgroup`** (`subsingleton_pic0Subgroup_overSpec`).  At `T = overSpec k K` the
   membership condition is quantified over *all* field points of `T`, and the identity
   `𝟙 (overSpec k K)` **is** one of them.  So the hypothesis, instantiated at the identity,
   gives exactly `degAff = 0` for the plus class through `picEtAffineEquiv` — the degree
   condition at a single well-chosen point is the whole of what step 2 consumes.

## What remains, stated exactly

`jacobianData_of_overSpec_subsingleton` (`Pic0VanishingAffineReduction.lean:266`) needs the
same statement at every commutative `k`-**algebra** `A`, not only at fields, and that is *not*
what this file proves.  The surviving gap is therefore sharp and singular:

  `∀ (A : Type u) [CommRing A] [Algebra k A],`
  `  Subsingleton (pic0Subgroup (P1.asOver k) (overSpec k A))`

and its content is `Pic(ℙ¹_A) ≅ Pic(A) × ℤ` — cohomology and base change.  Two routes are
**foreclosed** rather than merely unattempted, and both were priced before this file:

* the chart route does not extend, because chart triviality over `A` requires
  `Pic(A[t]) = Pic(A)`, i.e. Traverso's theorem, true exactly for **seminormal** `A` — false in
  general, and mathlib contains no seminormality at all;
* the `picEt`-level reduction `subsingleton_pic0_of_affine` (`Pic0VanishingRoute.lean:283`)
  runs one way and its hypothesis is vanishing of the *whole* `picEt`, which is false at `ℙ¹`
  since a degree-one class exists there.

What this file does buy toward the ring case is that the degree machinery is now known to be
*sharp* at this curve over every field: any counterexample over a ring cannot come from a
fibre.

## Main declarations

* `AlgebraicGeometry.P1.relPic_eq_one_of_relPicDeg_eq_zero` — step 1.
* `AlgebraicGeometry.P1.picEtAff_eq_one_of_degAff_eq_zero` — step 2, through cofinal field
  covers.
* `AlgebraicGeometry.P1.subsingleton_pic0Subgroup_overSpec` — **the producer**: `Pic⁰(ℙ¹)`
  vanishes at every field test.
* `AlgebraicGeometry.P1.pic0Subgroup_overSpec_eq_bot` — the `= ⊥` spelling, which is the one
  `Albanese/Genus0Terminal.lean` consumes.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

namespace P1

variable (k : Type u) [Field k] (K : Type u) [Field K] [Algebra k K]

/-! ## Step 1: the relative Picard group over a field -/

/-- **A degree-zero relative Picard class of `ℙ¹` over a field extension is trivial.**

`relPic` is `CechPic` modulo the classes pulled back from the base, and `relPicDeg` is
`classDeg` on a representative (`relPicDeg_relPicMk`), so this is
`eq_one_of_classDeg_eq_zero_baseChange` composed with the quotient map. -/
theorem relPic_eq_one_of_relPicDeg_eq_zero
    (x : relPic (P1.asOver k) (overSpec k K)) (hx : relPicDeg K x = 0) : x = 1 := by
  induction x using relPic.ind with
  | mk L =>
    rw [relPicDeg_relPicMk] at hx
    rw [eq_one_of_classDeg_eq_zero_baseChange k K L hx]
    exact map_one _

/-! ## Step 2: the étale plus construction, through cofinal field covers -/

/-- **A degree-zero plus class of `ℙ¹` at a field is trivial.**

The step that is not formal.  A plus class lives on an étale cover `E` of `K`, where step 1 is
unavailable — `relPic` triviality needs a *field*.  Field covers are cofinal, so refine `E`
into a finite separable extension `L/K`; there `degAff_mk` computes the degree as `relPicDeg L`
of the transported representative, step 1 applies, and `mk_descentMap` identifies the plus class
computed on the refinement with the original.

The transport is pushed forward along `ofFieldEquiv.symm` rather than reflected back, so no
injectivity of `relPicAlgMap` is required (the tree proves none). -/
theorem picEtAff_eq_one_of_degAff_eq_zero
    (z : PicEtAff (P1.asOver k) K) (hz : PicEtAff.degAff K z = 0) : z = 1 := by
  induction z using PicEtAff.ind with
  | _ E x =>
    obtain ⟨L, _, _, _, _, ⟨j⟩⟩ := E.exists_finiteSeparableField_algHom
    letI : Algebra k L := ((algebraMap K L).comp (algebraMap k K)).toAlgebra
    haveI : IsScalarTower k K L := .of_algebraMap_eq fun _ => rfl
    -- the field cover of `L`, whose carrier is `L` itself
    set F : Algebra.EtaleCover K := Algebra.EtaleCover.ofField (K := K) L with hF
    set jF : E.Carrier →ₐ[K] F.Carrier :=
      (Algebra.EtaleCover.ofFieldEquiv (K := K) L).symm.toAlgHom.comp j with hjF
    have hdeg := PicEtAff.degAff_mk (C := P1.asOver k) (K := K) E x L j
    rw [hz] at hdeg
    rw [← PicEtAff.mk_descentMap (C := P1.asOver k) jF x]
    have h1 : relPicAlgMap (P1.asOver k) (AlgHom.restrictScalars k j)
        (x : relPic (P1.asOver k) (overSpec k E.Carrier)) = 1 :=
      relPic_eq_one_of_relPicDeg_eq_zero k L _ hdeg.symm
    -- push forward along the inverse carrier identification
    have h2 := congrArg (relPicAlgMap (P1.asOver k)
      ((Algebra.EtaleCover.ofFieldEquiv (K := K) L).symm.toAlgHom.restrictScalars k)) h1
    rw [map_one, ← relPicAlgMap_comp] at h2
    have hcomp :
        ((Algebra.EtaleCover.ofFieldEquiv (K := K) L).symm.toAlgHom.restrictScalars k).comp
          (AlgHom.restrictScalars k j) = AlgHom.restrictScalars k jF := rfl
    rw [hcomp] at h2
    have hone : descentMap (P1.asOver k) jF x = 1 := by
      apply Subtype.ext
      show (descentMap (P1.asOver k) jF x : relPic (P1.asOver k) (overSpec k F.Carrier))
        = ((1 : descentClasses (P1.asOver k) F) : relPic (P1.asOver k) (overSpec k F.Carrier))
      rw [descentMap_coe]
      exact h2
    rw [hone]
    exact PicEtAff.mk_one _ _

/-! ## Step 3: the producer -/

/-- **`Pic⁰(ℙ¹)` vanishes at every field test.**  The first producer of the `hvan` hypothesis
at any curve in this project.

The degree-zero condition is quantified over all field points of the test, and at
`T = overSpec k K` the **identity** is one of them.  Instantiating there and transporting
through the affine comparison `picEtAffineEquiv` gives exactly the `degAff = 0` that step 2
consumes.  So the single well-chosen point carries the whole hypothesis; no cover, no gluing,
and no naturality is used. -/
theorem subsingleton_pic0Subgroup_overSpec :
    Subsingleton (pic0Subgroup (P1.asOver k) (overSpec k K)) := by
  refine ⟨fun s t => Subtype.ext ?_⟩
  refine (picEtAffineEquiv (P1.asOver k) K).injective ?_
  have hs : PicEtAff.degAff K (picEtAffineEquiv (P1.asOver k) K s.1) = 0 := by
    have hid := s.2 K (𝟙 (overSpec k K))
    rw [degAt, picEtMap_id] at hid
    exact hid
  have ht : PicEtAff.degAff K (picEtAffineEquiv (P1.asOver k) K t.1) = 0 := by
    have hid := t.2 K (𝟙 (overSpec k K))
    rw [degAt, picEtMap_id] at hid
    exact hid
  rw [picEtAff_eq_one_of_degAff_eq_zero k K _ hs, picEtAff_eq_one_of_degAff_eq_zero k K _ ht]

/-- The `= ⊥` spelling, which is the form `Albanese/Genus0Terminal.lean` consumes. -/
theorem pic0Subgroup_overSpec_eq_bot :
    pic0Subgroup (P1.asOver k) (overSpec k K) = ⊥ :=
  pic0Subgroup_eq_bot_of_subsingleton (subsingleton_pic0Subgroup_overSpec k K)

end P1

end AlgebraicGeometry
