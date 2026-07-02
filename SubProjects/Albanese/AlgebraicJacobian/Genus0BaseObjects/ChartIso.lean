/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Genus0BaseObjects.BareScheme

/-!
# Genus-`0` base objects (Stratum 2): the chart-ring iso `Away 𝒜 (X i) ≃+* k̄[u]`

This file is **Stratum 2** of the four-stratum split of the legacy
`AlgebraicJacobian.Genus0BaseObjects` (iter-175 refactor `g0bo-split`). It ships the
load-bearing chart-ring iso

```
HomogeneousLocalization.Away (projectiveLineBarGrading kbar) (MvPolynomial.X i)
  ≃+* MvPolynomial Unit kbar
```

together with the `kbar`-algebra preservation lemma. The forward direction is via
`Localization.awayLift` from the chart evaluation `X i ↦ 1`; the inverse via
`MvPolynomial.eval₂Hom` sending `X () ↦ X (otherFin i) / X i = isLocalizationElem`.

Upstream stratum: `BareScheme`. Downstream strata: `Points`, `GmScaling`.
-/

set_option autoImplicit false
set_option linter.style.setOption false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

noncomputable section

namespace AlgebraicGeometry

/-! ### The chart-ring iso: `HomogeneousLocalization.Away 𝒜 (X i) ≃+* k̄[u]` -/

/-- **The "other" `Fin 2` index** used in the chart-`i` affine coordinate `X (other i) / X i`. -/
def otherFin : Fin 2 → Fin 2
  | 0 => 1
  | 1 => 0

@[simp] private lemma otherFin_zero : otherFin 0 = 1 := rfl
@[simp] private lemma otherFin_one : otherFin 1 = 0 := rfl

private lemma otherFin_ne (i : Fin 2) : otherFin i ≠ i := by
  fin_cases i <;> decide

/-- **The chart-`i` evaluation `MvPolynomial (Fin 2) k̄ →+* MvPolynomial Unit k̄`**: sends
`X i ↦ 1` and `X (otherFin i) ↦ X ()`. -/
private noncomputable def chartEvalRingHom (kbar : Type u) [Field kbar] (i : Fin 2) :
    MvPolynomial (Fin 2) kbar →+* MvPolynomial Unit kbar :=
  MvPolynomial.eval₂Hom (algebraMap kbar (MvPolynomial Unit kbar))
    (fun j : Fin 2 => if j = i then (1 : MvPolynomial Unit kbar) else MvPolynomial.X ())

@[simp] private lemma chartEvalRingHom_X_self (kbar : Type u) [Field kbar] (i : Fin 2) :
    chartEvalRingHom kbar i (MvPolynomial.X i) = 1 := by
  simp [chartEvalRingHom]

@[simp] private lemma chartEvalRingHom_X_other (kbar : Type u) [Field kbar] (i : Fin 2) :
    chartEvalRingHom kbar i (MvPolynomial.X (otherFin i)) = MvPolynomial.X () := by
  unfold chartEvalRingHom
  rw [MvPolynomial.eval₂Hom_X']
  exact if_neg (otherFin_ne i)

@[simp] private lemma chartEvalRingHom_C (kbar : Type u) [Field kbar] (i : Fin 2) (r : kbar) :
    chartEvalRingHom kbar i (MvPolynomial.C r) = MvPolynomial.C r := by
  simp [chartEvalRingHom]

/-- **The forward direction of the chart-ring iso**: `Away 𝒜 (X i) →+* k̄[u]` via
`Localization.awayLift` from the chart evaluation `X i ↦ 1`. -/
noncomputable def homogeneousLocalizationAwayToMvPoly (kbar : Type u) [Field kbar] (i : Fin 2) :
    HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) →+*
      MvPolynomial Unit kbar :=
  (Localization.awayLift (chartEvalRingHom kbar i)
      (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)
      (by rw [chartEvalRingHom_X_self]; exact isUnit_one)).comp
    (algebraMap (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        (MvPolynomial.X i : MvPolynomial (Fin 2) kbar))
      (Localization.Away (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)))

/-- **The base ring map `k̄ →+* Away 𝒜 (X i)`** — the composite
`k̄ → 𝒜 0 → Away 𝒜 (X i)` of the algebra map into degree-`0` with `fromZeroRingHom`. -/
private noncomputable def kbarToAwayRingHom (kbar : Type u) [Field kbar] (i : Fin 2) :
    kbar →+*
      HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) :=
  (HomogeneousLocalization.fromZeroRingHom (projectiveLineBarGrading kbar)
    (Submonoid.powers (MvPolynomial.X i : MvPolynomial (Fin 2) kbar))).comp
    (algebraMap kbar ((projectiveLineBarGrading kbar) 0))

/-- **The inverse direction of the chart-ring iso**: `k̄[u] →+* Away 𝒜 (X i)` via the
universal property of `MvPolynomial Unit`, sending `X () ↦ X (otherFin i) / X i`. -/
noncomputable def mvPolyToHomogeneousLocalizationAway
    (kbar : Type u) [Field kbar] (i : Fin 2) :
    MvPolynomial Unit kbar →+*
      HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) :=
  MvPolynomial.eval₂Hom (kbarToAwayRingHom kbar i)
    (fun _ : Unit =>
      HomogeneousLocalization.Away.isLocalizationElem
        (MvPolynomial.isHomogeneous_X kbar i)
        (MvPolynomial.isHomogeneous_X kbar (otherFin i)))

/-- Round-trip on `MvPolynomial Unit kbar`: `forward ∘ inverse = id`. -/
private lemma homogeneousLocalizationAwayIso_aux_right (kbar : Type u) [Field kbar] (i : Fin 2) :
    (homogeneousLocalizationAwayToMvPoly kbar i).comp
        (mvPolyToHomogeneousLocalizationAway kbar i) =
      RingHom.id (MvPolynomial Unit kbar) := by
  apply MvPolynomial.ringHom_ext
  · intro r
    simp only [RingHom.id_apply, mvPolyToHomogeneousLocalizationAway,
      MvPolynomial.eval₂Hom_C, kbarToAwayRingHom, RingHom.comp_apply,
      homogeneousLocalizationAwayToMvPoly]
    rw [HomogeneousLocalization.algebraMap_apply]
    change (Localization.awayLift (chartEvalRingHom kbar i)
          (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) _)
        (Localization.mk ((algebraMap kbar
            ((projectiveLineBarGrading kbar) 0) r : _) : MvPolynomial (Fin 2) kbar)
          ⟨(MvPolynomial.X i : MvPolynomial (Fin 2) kbar)^0, ⟨0, rfl⟩⟩) =
      MvPolynomial.C r
    rw [Localization.awayLift_mk (f := chartEvalRingHom kbar i)
      (r := MvPolynomial.X i) (v := 1) (hv := by simp [chartEvalRingHom_X_self])]
    simp [SetLike.GradeZero.coe_algebraMap, chartEvalRingHom]
  · intro _
    simp only [RingHom.coe_comp, Function.comp_apply, RingHom.id_apply,
      mvPolyToHomogeneousLocalizationAway, MvPolynomial.eval₂Hom_X',
      homogeneousLocalizationAwayToMvPoly]
    rw [HomogeneousLocalization.algebraMap_apply,
      HomogeneousLocalization.Away.val_mk]
    change (Localization.awayLift (chartEvalRingHom kbar i)
          (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) _)
        (Localization.mk ((MvPolynomial.X (otherFin i) :
            MvPolynomial (Fin 2) kbar)^(1:ℕ))
          ⟨(MvPolynomial.X i : MvPolynomial (Fin 2) kbar)^(1:ℕ), ⟨1, rfl⟩⟩) =
      MvPolynomial.X ()
    rw [Localization.awayLift_mk (f := chartEvalRingHom kbar i)
      (r := MvPolynomial.X i) (v := 1) (hv := by simp [chartEvalRingHom_X_self])]
    simp [chartEvalRingHom_X_other, pow_one]

/-- **The inverse map `k̄[u] → Away 𝒜 (X i)` is surjective.**

Its image is `Algebra.adjoin (𝒜 0) { isLocalizationElem (X i) (X (otherFin i)) }` since
`isLocalizationElem` is the image of the single generator `X () : MvPolynomial Unit kbar`
and `kbarToAwayRingHom` covers the scalars (via the `kbar ≃ 𝒜 0` bijection). By
`Away.adjoin_mk_prod_pow_eq_top` (`Mathlib.RingTheory.GradedAlgebra.HomogeneousLocalization:1064`)
specialised to `d = 1`, `ι' = Fin 2`, `v = ![X 0, X 1]`, `dv = ![1, 1]`, this adjoin is `⊤`.

Proof structure (iter-172):
1. Apply `Away.adjoin_mk_prod_pow_eq_top` with `d = 1, v = ![X 0, X 1], dv = ![1, 1]` to
   get `Algebra.adjoin (𝒜 0) {Away.mk hf a (X 0^a₀ * X 1^a₁) _ | (a, ai) with a₀+a₁=a, ai≤1} = ⊤`.
2. Induct on adjoin membership (via `Algebra.adjoin_induction`):
   - `mem`: each generator `Away.mk hf a (X 0^a₀ * X 1^a₁) _` equals `isLocalizationElem^k`
     where `k = a₀` if i=1 else `a₁`. Hence it's `f (X ()^k)`.
   - `algebraMap`: every `algebraMap (𝒜 0) Away r` is `algebraMap (𝒜 0) Away
     (algebraMap kbar (𝒜 0) r₀) = algebraMap kbar Away r₀ = f (C r₀)` since `algebraMap kbar (𝒜 0)`
     is surjective (see `projectiveLineBar_isProper`).
   - `add`/`mul`: `f` is a ring hom. -/
private lemma mvPolyToHomogeneousLocalizationAway_surjective
    (kbar : Type u) [Field kbar] (i : Fin 2) :
    Function.Surjective (mvPolyToHomogeneousLocalizationAway kbar i) := by
  classical
  -- We avoid `set 𝒜 := ...` here because it causes type-class friction with
  -- `Subalgebra.algebraMap_mem` and the `SetLike.GradeZero` coercion machinery.
  have hfi : (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) ∈ projectiveLineBarGrading kbar 1 :=
    MvPolynomial.isHomogeneous_X kbar i
  have hgi : (MvPolynomial.X (otherFin i) : MvPolynomial (Fin 2) kbar) ∈
      projectiveLineBarGrading kbar 1 :=
    MvPolynomial.isHomogeneous_X kbar (otherFin i)
  -- The 2-generator vector and degrees for `Away.adjoin_mk_prod_pow_eq_top` (d = 1).
  let v : Fin 2 → MvPolynomial (Fin 2) kbar := ![MvPolynomial.X 0, MvPolynomial.X 1]
  let dv : Fin 2 → ℕ := ![1, 1]
  have hxd : ∀ j, v j ∈ projectiveLineBarGrading kbar (dv j) := by
    intro j; fin_cases j <;> exact MvPolynomial.isHomogeneous_X _ _
  -- Step 1: `Algebra.adjoin (𝒜 0) (range v) = ⊤` (i.e. {X 0, X 1} generates `k̄[X 0, X 1]`
  -- over `𝒜 0`). We isolate the induction inside a `have` to avoid motive contamination.
  have hx : Algebra.adjoin ↥(projectiveLineBarGrading kbar 0) (Set.range v) = ⊤ := by
    apply top_unique
    intro p _
    refine MvPolynomial.induction_on p ?C ?add ?mulX
    · -- C case: MvPolynomial.C r ∈ adjoin via algebraMap_mem.
      intro r
      have h : (algebraMap ↥(projectiveLineBarGrading kbar 0)
          (MvPolynomial (Fin 2) kbar))
          ⟨MvPolynomial.C r, MvPolynomial.isHomogeneous_C _ _⟩ = MvPolynomial.C r :=
        SetLike.GradeZero.algebraMap_apply _ _
      rw [← h]
      exact Subalgebra.algebraMap_mem _ _
    · -- add case
      intro p₁ p₂ hp₁ hp₂
      exact Subalgebra.add_mem _ hp₁ hp₂
    · -- mul_X case
      intro p₁ j hp₁
      refine Subalgebra.mul_mem _ hp₁ (Algebra.subset_adjoin ⟨j, ?_⟩)
      fin_cases j <;> simp [v]
  -- Step 2: Apply the Mathlib theorem.
  have htop := HomogeneousLocalization.Away.adjoin_mk_prod_pow_eq_top hfi (ι' := Fin 2)
    v hx dv hxd
  -- Key intermediate: surjectivity of `algebraMap kbar (𝒜 0)` (constants → degree-0 piece).
  -- Used for the `algebraMap` case of the adjoin-induction below.
  have hkbar_sur : Function.Surjective
      (algebraMap kbar ↥((MvPolynomial.homogeneousSubmodule (Fin 2) kbar) 0)) := by
    rintro ⟨v, hv⟩
    refine ⟨MvPolynomial.coeff 0 v, ?_⟩
    apply Subtype.ext
    rw [SetLike.GradeZero.coe_algebraMap]
    have key := MvPolynomial.homogeneousComponent_of_mem hv (m := 0)
    simp only [MvPolynomial.homogeneousComponent_zero, if_true] at key
    exact key
  -- Helper for the `mem` case: each generator equals `isLocalizationElem^k` for some `k`.
  -- The numerator `X 0^a₀ * X 1^a₁` of degree `a = a₀ + a₁`, denominator `X i^a`.
  -- After simplification: this equals `(X (otherFin i) / X i)^(a_{otherFin i})`
  -- where `k = a₁` if `i = 0` and `k = a₀` if `i = 1`.
  have gen_eq_pow : ∀ (a : ℕ) (ai : Fin 2 → ℕ)
      (hai : ∑ j, ai j • dv j = a • 1) (_ : ∀ j, ai j ≤ 1)
      (hP : (∏ j, v j ^ ai j) ∈ projectiveLineBarGrading kbar (a • 1)),
      HomogeneousLocalization.Away.mk (projectiveLineBarGrading kbar) hfi a (∏ j, v j ^ ai j) hP =
        (HomogeneousLocalization.Away.isLocalizationElem hfi hgi)^(ai (otherFin i)) := by
    intro a ai hai _hai_le hP
    apply HomogeneousLocalization.val_injective
    have ha_eq : ai 0 + ai 1 = a := by
      have h := hai
      simp only [Fin.sum_univ_two, smul_eq_mul, dv, Matrix.cons_val_zero,
        Matrix.cons_val_one] at h
      omega
    -- Step A: compute LHS `.val` via `Away.val_mk`.
    rw [HomogeneousLocalization.Away.val_mk]
    -- Step B: compute RHS via `val_pow` + `Away.val_mk`. Use explicit `change` to make the
    -- isLocalizationElem definitionally visible.
    rw [HomogeneousLocalization.val_pow]
    change _ = (HomogeneousLocalization.val (HomogeneousLocalization.Away.mk
        (projectiveLineBarGrading kbar) hfi 1
        (MvPolynomial.X (otherFin i) ^ 1) _))^(ai (otherFin i))
    rw [HomogeneousLocalization.Away.val_mk, Localization.mk_pow]
    simp only [pow_one]
    -- Now both sides are `Localization.mk`. Reduce via `mk_eq_mk_iff` + `r_iff_exists`.
    rw [Localization.mk_eq_mk_iff, Localization.r_iff_exists]
    refine ⟨1, ?_⟩
    -- Goal: 1 * (∏ j, v j ^ ai j) * ↑(⟨X i, _⟩^(ai (otherFin i))) =
    --       1 * X (otherFin i)^(ai (otherFin i)) * X i^a
    -- Use that `↑(⟨X i, _⟩^k) = X i^k` (defeq via `SubmonoidClass.coe_pow` + Subtype.val).
    -- Case-split via `Fin.ext + omega` to get clean `0`/`1` for `i`.
    have hi_val : i.val = 0 ∨ i.val = 1 := by omega
    rcases hi_val with hi | hi
    · -- i = 0, otherFin 0 = 1
      have heq_i : i = (0 : Fin 2) := Fin.ext hi
      subst heq_i
      simp only [otherFin_zero, Fin.prod_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one,
        v, OneMemClass.coe_one, _root_.one_mul, SubmonoidClass.coe_pow]
      -- Goal: X 0^(ai 1) * (X 0^(ai 0) * X 1^(ai 1)) = X 0^a * X 1^(ai 1)
      rw [show a = ai 0 + ai 1 from ha_eq.symm, pow_add]; ring
    · -- i = 1, otherFin 1 = 0
      have heq_i : i = (1 : Fin 2) := Fin.ext hi
      subst heq_i
      simp only [otherFin_one, Fin.prod_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one,
        v, OneMemClass.coe_one, _root_.one_mul, SubmonoidClass.coe_pow]
      -- Goal: X 1^(ai 0) * (X 0^(ai 0) * X 1^(ai 1)) = X 1^a * X 0^(ai 0)
      rw [show a = ai 0 + ai 1 from ha_eq.symm, pow_add]; ring
  -- Step 4: surjectivity. Every y is in `Algebra.adjoin (𝒜 0) {generators}` = ⊤.
  intro y
  have hy_in : y ∈ Algebra.adjoin ↥(projectiveLineBarGrading kbar 0)
      { x | ∃ (a : ℕ) (ai : Fin 2 → ℕ)
          (hai : ∑ j, ai j • dv j = a • 1) (_ : ∀ j, ai j ≤ 1),
        HomogeneousLocalization.Away.mk (projectiveLineBarGrading kbar) hfi a
          (∏ j, v j ^ ai j)
          (hai ▸ SetLike.prod_pow_mem_graded _ _ _ _ fun i _ ↦ hxd i) = x } := by
    rw [htop]; trivial
  refine Algebra.adjoin_induction
      (p := fun y _ => y ∈ Set.range (mvPolyToHomogeneousLocalizationAway kbar i))
      ?_ ?_ ?_ ?_ hy_in
  · -- mem case
    rintro x ⟨a, ai, hai, hai_le, rfl⟩
    have hgen :=
      gen_eq_pow a ai hai hai_le (hai ▸ SetLike.prod_pow_mem_graded _ _ _ _ fun i _ ↦ hxd i)
    refine ⟨MvPolynomial.X ()^(ai (otherFin i)), ?_⟩
    rw [hgen]
    have hX : (mvPolyToHomogeneousLocalizationAway kbar i) (MvPolynomial.X ()) =
        HomogeneousLocalization.Away.isLocalizationElem hfi hgi := by
      change MvPolynomial.eval₂Hom _ _ (MvPolynomial.X ()) = _
      rw [MvPolynomial.eval₂Hom_X']
    rw [map_pow, hX]
  · -- algebraMap case
    intro r
    -- r : ↥(𝒜 0). Find `r₀ ∈ kbar` with `algebraMap kbar (𝒜 0) r₀ = r`.
    obtain ⟨r₀, hr₀⟩ := hkbar_sur r
    refine ⟨MvPolynomial.C r₀, ?_⟩
    -- Goal: mvPolyToHomogeneousLocalizationAway kbar i (C r₀) = algebraMap (𝒜 0) Away r
    change MvPolynomial.eval₂Hom _ _ (MvPolynomial.C r₀) = _
    rw [MvPolynomial.eval₂Hom_C]
    change kbarToAwayRingHom kbar i r₀ = _
    simp only [kbarToAwayRingHom, RingHom.comp_apply]
    rw [hr₀]
    rfl
  · -- add case
    rintro u w _ _ ⟨pu, hpu⟩ ⟨pw, hpw⟩
    exact ⟨pu + pw, by rw [map_add, hpu, hpw]⟩
  · -- mul case
    rintro u w _ _ ⟨pu, hpu⟩ ⟨pw, hpw⟩
    exact ⟨pu * pw, by rw [map_mul, hpu, hpw]⟩

/-- Round-trip on `Away 𝒜 (X i)`: `inverse ∘ forward = id`.

Closed by the "cancel surjective" route per `analogies/gmscaling-deep.md` Q2: from
`mvPolyToHomogeneousLocalizationAway_surjective` (surjectivity of `inverse`) +
`homogeneousLocalizationAwayIso_aux_right` (`forward ∘ inverse = id` on `MvPoly Unit kbar`),
conclude `inverse ∘ forward = id` on `Away 𝒜 (X i)`. The cancellation step itself is
mechanical; the only remaining substance is the surjectivity helper above. -/
private lemma homogeneousLocalizationAwayIso_aux_left (kbar : Type u) [Field kbar] (i : Fin 2) :
    (mvPolyToHomogeneousLocalizationAway kbar i).comp
        (homogeneousLocalizationAwayToMvPoly kbar i) =
      RingHom.id _ := by
  ext x
  obtain ⟨p, rfl⟩ := mvPolyToHomogeneousLocalizationAway_surjective kbar i x
  -- Goal: ((mvPoly←Away) ∘ (Away→mvPoly)) ((mvPoly←Away) p) = (mvPoly←Away) p
  -- The inner `(Away→mvPoly) ((mvPoly←Away) p) = p` by aux_right; the result follows.
  have h : (homogeneousLocalizationAwayToMvPoly kbar i)
      ((mvPolyToHomogeneousLocalizationAway kbar i) p) = p :=
    RingHom.congr_fun (homogeneousLocalizationAwayIso_aux_right kbar i) p
  simp only [RingHom.comp_apply, RingHom.id_apply, h]

/-- **The chart-ring iso `Away 𝒜 (X i) ≃+* k̄[u]`** — built from the forward map (via
`Localization.awayLift`) and the inverse map (via `MvPolynomial.eval₂Hom`). The two
round-trips are proved at the underlying-`Localization.Away` level by
`HomogeneousLocalization.val_injective`. -/
noncomputable def homogeneousLocalizationAwayIso (kbar : Type u) [Field kbar] (i : Fin 2) :
    HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) ≃+*
      MvPolynomial Unit kbar :=
  RingEquiv.ofRingHom
    (homogeneousLocalizationAwayToMvPoly kbar i)
    (mvPolyToHomogeneousLocalizationAway kbar i)
    (homogeneousLocalizationAwayIso_aux_right kbar i)
    (homogeneousLocalizationAwayIso_aux_left kbar i)

/-- **`kbar`-algebra preservation of `homogeneousLocalizationAwayIso`** (iter-174 Sub-task A
helper per `analogies/chart-bridge-shared-helper.md` Decision 3 step 3). The forward map
`Away 𝒜 (X i) →+* MvPolynomial Unit kbar` carries `algebraMap kbar Away` to
`algebraMap kbar (MvPolynomial Unit kbar)` (i.e. `MvPolynomial.C`).

Closed via the inverse's `eval₂Hom_C` action: `inverse (C r) = kbarToAwayRingHom kbar i r =
algebraMap kbar Away r` (the last identity is definitional, by the `algebraKbarAway`
`Algebra.compHom` instance combined with `HomogeneousLocalization.algebraMap_eq`). The
forward round-trip then gives `forward (algebraMap kbar Away r) = C r`. -/
lemma homogeneousLocalizationAwayIso_algebraMap
    (kbar : Type u) [Field kbar] (i : Fin 2) :
    ((homogeneousLocalizationAwayIso kbar i).toRingHom).comp
        (algebraMap kbar
          (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
            (MvPolynomial.X i : MvPolynomial (Fin 2) kbar))) =
      algebraMap kbar (MvPolynomial Unit kbar) := by
  ext r
  -- `algebraMap kbar Away r = mvPolyToHomogeneousLocalizationAway kbar i (C r)` since
  -- the `algebraKbarAway` instance is `Algebra.compHom _ (algebraMap kbar (𝒜 0))` and
  -- `algebraMap (𝒜 0) Away = HomogeneousLocalization.fromZeroRingHom 𝒜 _` (see
  -- `HomogeneousLocalization.algebraMap_eq`), so the composite is exactly `kbarToAwayRingHom`
  -- which equals `inverse (C r)` by `MvPolynomial.eval₂Hom_C`.
  have hinv : mvPolyToHomogeneousLocalizationAway kbar i (MvPolynomial.C r) =
      algebraMap kbar
        (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
          (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)) r := by
    unfold mvPolyToHomogeneousLocalizationAway
    rw [MvPolynomial.eval₂Hom_C]
    rfl
  -- Now apply forward (= homogeneousLocalizationAwayToMvPoly) and use aux_right's roundtrip.
  have hround : (homogeneousLocalizationAwayToMvPoly kbar i)
      ((mvPolyToHomogeneousLocalizationAway kbar i) (MvPolynomial.C r)) =
      MvPolynomial.C r :=
    RingHom.congr_fun (homogeneousLocalizationAwayIso_aux_right kbar i) (MvPolynomial.C r)
  -- Combine: rewrite the inverse C r as algebraMap kbar Away r, then apply roundtrip.
  simp only [RingHom.coe_comp, Function.comp_apply, RingEquiv.toRingHom_eq_coe,
    RingEquiv.coe_toRingHom, homogeneousLocalizationAwayIso, RingEquiv.ofRingHom_apply]
  rw [← hinv, hround]
  rfl

/-! ### `SmoothOfRelativeDimension 1` instance via the 2-chart cover -/

/-- **Helper for `projectiveLineBar_smooth_chart_aux`**: parameterized by `f := X i`,
the chart morphism `Spec(Away 𝒜 f) → Spec k̄` is smooth of relative dimension `1`.

Proof: rewrite the composition `awayι ≫ Proj.toSpecZero ≫ Spec.map (algMap kbar (𝒜 0))`
via `awayι_toSpecZero` + `Spec.map_comp` to a single `Spec.map (kbarToAwayRingHom)`,
then apply `HasRingHomProperty.Spec_iff` + `RingHom.locally_of` to reduce to
`RingHom.IsStandardSmoothOfRelativeDimension 1 kbarToAwayRingHom`, which equals
`algebraMap kbar (Away)`. Close via `of_algEquiv` with `MvPolynomial (Fin 1) kbar` (using
`renameEquiv finOneEquiv` + the symm of the chart-ring iso upgraded to a `kbar`-algEquiv). -/
private lemma projectiveLineBar_smooth_chart_X (kbar : Type u) [Field kbar]
    (i : Fin 2) :
    SmoothOfRelativeDimension 1 (Proj.awayι (projectiveLineBarGrading kbar)
        (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)
        (MvPolynomial.isHomogeneous_X kbar i) Nat.one_pos ≫
      (ProjectiveLineBar kbar).hom) := by
  -- Step 1: rewrite the composition as `Spec.map (CommRingCat.ofHom kbarToAwayRingHom)`.
  rw [show ((ProjectiveLineBar kbar).hom : ProjectiveLineBarScheme kbar ⟶ _)
      = Proj.toSpecZero (projectiveLineBarGrading kbar) ≫
        Spec.map (CommRingCat.ofHom
          (algebraMap kbar ((projectiveLineBarGrading kbar) 0))) from rfl]
  rw [show (Proj.awayι (projectiveLineBarGrading kbar)
        (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)
        (MvPolynomial.isHomogeneous_X kbar i) Nat.one_pos ≫
        Proj.toSpecZero (projectiveLineBarGrading kbar) ≫
          Spec.map (CommRingCat.ofHom
            (algebraMap kbar ((projectiveLineBarGrading kbar) 0)))) =
      (Proj.awayι (projectiveLineBarGrading kbar)
            (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)
            (MvPolynomial.isHomogeneous_X kbar i) Nat.one_pos ≫
          Proj.toSpecZero (projectiveLineBarGrading kbar)) ≫
        Spec.map (CommRingCat.ofHom
          (algebraMap kbar ((projectiveLineBarGrading kbar) 0))) from
      (Category.assoc _ _ _).symm]
  rw [Proj.awayι_toSpecZero, ← Spec.map_comp]
  -- Step 2: now goal is on `Spec.map (CommRingCat.ofHom kbarToAwayRingHom)`.
  rw [HasRingHomProperty.Spec_iff (P := @SmoothOfRelativeDimension 1)]
  apply RingHom.locally_of RingHom.isStandardSmoothOfRelativeDimension_respectsIso
  -- Step 3: goal is `RingHom.IsStandardSmoothOfRelativeDimension 1 (kbarToAwayRingHom)`,
  -- which equals `algebraMap kbar (Away 𝒜 (X i))` by definitional unfolding of `algebraKbarAway`.
  change RingHom.IsStandardSmoothOfRelativeDimension 1
    (algebraMap kbar (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
      (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)))
  rw [RingHom.isStandardSmoothOfRelativeDimension_algebraMap]
  -- Step 4: build the `kbar`-algebra equivalence `MvPolynomial (Fin 1) kbar ≃ₐ[kbar] Away`
  -- and apply `of_algEquiv`. The chart-ring iso `homogeneousLocalizationAwayIso` ships
  -- `Away ≃+* MvPolynomial Unit kbar`; the `_algebraMap` lemma upgrades it to a `kbar`-algEquiv.
  -- Compose with `renameEquiv finOneEquiv` to transport across `Fin 1 ≃ Unit`.
  let eUnit : HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
      (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) ≃ₐ[kbar] MvPolynomial Unit kbar :=
    AlgEquiv.ofRingEquiv (f := homogeneousLocalizationAwayIso kbar i) <| fun r =>
      RingHom.congr_fun (homogeneousLocalizationAwayIso_algebraMap kbar i) r
  let eFin : MvPolynomial (Fin 1) kbar ≃ₐ[kbar] MvPolynomial Unit kbar :=
    MvPolynomial.renameEquiv kbar finOneEquiv
  let e : MvPolynomial (Fin 1) kbar ≃ₐ[kbar]
      HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) :=
    eFin.trans eUnit.symm
  exact Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv (n := 1) e

private lemma projectiveLineBar_smooth_chart_aux (kbar : Type u) [Field kbar]
    (i : Fin 2) :
    SmoothOfRelativeDimension 1 ((projectiveLineBarAffineCover kbar).openCover.f i ≫
      (ProjectiveLineBar kbar).hom) := by
  -- The cover's `.f i` is `Proj.awayι 𝒜 (![X 0, X 1] i) ...`; after `fin_cases i`,
  -- `(![X 0, X 1] i)` reduces definitionally to `X i`, and the morphism matches the
  -- helper `projectiveLineBar_smooth_chart_X`.
  simp only [Scheme.AffineOpenCover.openCover_f, projectiveLineBarAffineCover,
    Proj.affineOpenCoverOfIrrelevantLESpan]
  fin_cases i
  · exact projectiveLineBar_smooth_chart_X kbar 0
  · exact projectiveLineBar_smooth_chart_X kbar 1

/-- **`ℙ¹_{k̄}` is smooth of relative dimension `1` over `Spec k̄`.** Project-side scaffold.
iter-196 substrate landed: the structural reduction via the 2-chart cover is done
axiom-clean; the remaining per-chart gap is isolated in
`projectiveLineBar_smooth_chart_aux`. -/
instance projectiveLineBar_smoothOfRelDim (kbar : Type u) [Field kbar] :
    SmoothOfRelativeDimension 1 (ProjectiveLineBar kbar).hom := by
  apply IsZariskiLocalAtSource.of_openCover (projectiveLineBarAffineCover kbar).openCover
  exact projectiveLineBar_smooth_chart_aux kbar

/-! ### `GeometricallyIrreducible` instance via the 2-chart cover

The real proof of the former BareScheme scaffold `projectiveLineBar_geomIrred`
(relocated here — iter-201 — because it needs the chart-ring iso
`homogeneousLocalizationAwayIso`): for any field extension `K/k̄`, the base change
`ℙ¹_K` is covered by the two pulled-back chart opens `p ⁻¹ᵁ D₊(X i)`, each irreducible
(`≅ 𝔸¹_K = Spec (K[u])`), and the two chart opens intersect (both contain any preimage
of the generic point `⟨⊥⟩ ∈ ℙ¹_{k̄}` under the surjective projection `p : ℙ¹_K → ℙ¹_{k̄}`);
a space covered by two intersecting irreducible opens is irreducible. -/

/-- **Topological input**: a space covered by two irreducible opens with nonempty
intersection is irreducible. -/
private lemma irreducibleSpace_of_two_irreducible_opens {α : Type*} [TopologicalSpace α]
    {U V : Set α} (_hUo : IsOpen U) (hVo : IsOpen V)
    (hU : IsIrreducible U) (hV : IsIrreducible V)
    (hUV : (U ∩ V).Nonempty) (hcov : ∀ x : α, x ∈ U ∨ x ∈ V) :
    IrreducibleSpace α := by
  obtain ⟨w, hwU, hwV⟩ := hUV
  refine { toNonempty := ⟨w⟩, isPreirreducible_univ := ?_ }
  intro u v hu hv hune hvne
  obtain ⟨a, -, hau⟩ := hune
  obtain ⟨b, -, hbv⟩ := hvne
  rw [Set.univ_inter]
  -- Any nonempty open meeting `U` also meets `V` (through `U`'s irreducibility and
  -- the common point `w`); hence both `u` and `v` meet `V`, and `V`'s irreducibility
  -- closes the goal.
  have key : ∀ {u' : Set α}, IsOpen u' → ∀ {c : α}, c ∈ u' → c ∈ U →
      (U ∩ (u' ∩ V)).Nonempty := fun {u'} hu' {c} hcu' hcU =>
    hU.2 u' V hu' hVo ⟨c, hcU, hcu'⟩ ⟨w, hwU, hwV⟩
  have hu_meets_V : (V ∩ u).Nonempty := by
    rcases hcov a with haU | haV
    · obtain ⟨c, -, hcu, hcV⟩ := key hu hau haU
      exact ⟨c, hcV, hcu⟩
    · exact ⟨a, haV, hau⟩
  have hv_meets_V : (V ∩ v).Nonempty := by
    rcases hcov b with hbU | hbV
    · obtain ⟨c, -, hcv, hcV⟩ := key hv hbv hbU
      exact ⟨c, hcV, hcv⟩
    · exact ⟨b, hbV, hbv⟩
  obtain ⟨c, -, hcu, hcv⟩ := hV.2 u v hu hv hu_meets_V hv_meets_V
  exact ⟨c, hcu, hcv⟩

/-- **Ring-level input**: the chart ring `Away 𝒜 (X i) ≅ k̄[u]` stays a domain after base
change to any field extension `K/k̄` (via `k̄[u] ⊗[k̄] K ≅ K[u]`). -/
private lemma chartAway_tensor_isDomain (kbar : Type u) [Field kbar] (i : Fin 2)
    (K : Type u) [Field K] [Algebra kbar K] :
    IsDomain (TensorProduct kbar
      (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)) K) := by
  -- `k̄[u] ⊗[k̄] K ≅ K[u]` is a domain.
  haveI hMv : IsDomain (TensorProduct kbar (MvPolynomial Unit kbar) K) := by
    haveI : IsDomain (MvPolynomial Unit K) := inferInstance
    have e2 : TensorProduct kbar (MvPolynomial Unit kbar) K ≃+*
        TensorProduct kbar K (MvPolynomial Unit kbar) :=
      (Algebra.TensorProduct.comm kbar (MvPolynomial Unit kbar) K).toRingEquiv
    have e1 : TensorProduct kbar K (MvPolynomial Unit kbar) ≃+* MvPolynomial Unit K :=
      (MvPolynomial.algebraTensorAlgEquiv kbar K).toRingEquiv
    exact Function.Injective.isDomain (e1.toRingHom.comp e2.toRingHom)
      (e1.injective.comp e2.injective)
  -- Transport along `congr` of the chart-ring iso (upgraded to a `kbar`-algEquiv).
  let eUnit : HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
      (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) ≃ₐ[kbar] MvPolynomial Unit kbar :=
    AlgEquiv.ofRingEquiv (f := homogeneousLocalizationAwayIso kbar i) <| fun r =>
      RingHom.congr_fun (homogeneousLocalizationAwayIso_algebraMap kbar i) r
  have e : TensorProduct kbar
      (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)) K ≃+*
      TensorProduct kbar (MvPolynomial Unit kbar) K :=
    (Algebra.TensorProduct.congr eUnit AlgEquiv.refl).toRingEquiv
  exact Function.Injective.isDomain e.toRingHom e.injective

set_option backward.isDefEq.respectTransparency false in
/-- **Per-chart geometric irreducibility**: the chart structure morphism
`Spec (Away 𝒜 (X i)) ⟶ Spec k̄` is geometrically irreducible. Mirrors
`projectiveLineBar_smooth_chart_X`'s Step-1 rewrite to a single
`Spec.map (algebraMap k̄ (Away 𝒜 (X i)))`, then computes the pullback along any
`Spec K ⟶ Spec k̄` as `Spec (Away 𝒜 (X i) ⊗[k̄] K)` via `pullbackSpecIso` — irreducible
since the tensor is a domain (`chartAway_tensor_isDomain`). -/
private lemma chartAway_geomIrred (kbar : Type u) [Field kbar] (i : Fin 2) :
    GeometricallyIrreducible (Proj.awayι (projectiveLineBarGrading kbar)
        (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)
        (MvPolynomial.isHomogeneous_X kbar i) Nat.one_pos ≫
      (ProjectiveLineBar kbar).hom) := by
  -- Step 1: rewrite the composition as `Spec.map (algebraMap k̄ (Away 𝒜 (X i)))`.
  rw [show ((ProjectiveLineBar kbar).hom : ProjectiveLineBarScheme kbar ⟶ _)
      = Proj.toSpecZero (projectiveLineBarGrading kbar) ≫
        Spec.map (CommRingCat.ofHom
          (algebraMap kbar ((projectiveLineBarGrading kbar) 0))) from rfl]
  rw [Proj.awayι_toSpecZero_assoc, ← Spec.map_comp]
  change GeometricallyIrreducible (Spec.map (CommRingCat.ofHom
    (algebraMap kbar (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
      (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)))))
  -- Step 2: direct geometric computation (as in `affineLine_geomIrred`).
  refine ⟨?_⟩
  rw [geometrically_iff_of_commRing_of_isClosedUnderIsomorphisms]
  intro K _ _
  haveI := chartAway_tensor_isDomain kbar i K
  haveI hirr : IrreducibleSpace (Spec (CommRingCat.of (TensorProduct kbar
      (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)) K))) := by
    change IrreducibleSpace (PrimeSpectrum (TensorProduct kbar
      (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)) K))
    infer_instance
  exact (pullbackSpecIso kbar _ K).symm.hom.homeomorph.irreducibleSpace_iff.mp hirr

/-- **The generic point of `ℙ¹_{k̄}`**: the zero homogeneous prime of the polynomial ring
(a domain), which does not contain the irrelevant ideal (`X 0 ≠ 0`). Typed as a point of
the scheme `ProjectiveLineBarScheme` (defeq to `ProjectiveSpectrum`). -/
private noncomputable def projectiveLineBarGenericPt (kbar : Type u) [Field kbar] :
    ↥(ProjectiveLineBarScheme kbar) :=
  show ProjectiveSpectrum (projectiveLineBarGrading kbar) from
    ⟨⊥, Ideal.isPrime_bot, fun hle => by
      have h0 := hle (HomogeneousIdeal.mem_irrelevant_of_mem _ Nat.zero_lt_one
        (MvPolynomial.isHomogeneous_X kbar 0))
      rw [← HomogeneousIdeal.mem_iff, HomogeneousIdeal.toIdeal_bot, Ideal.mem_bot] at h0
      exact MvPolynomial.X_ne_zero (R := kbar) _ h0⟩

set_option backward.isDefEq.respectTransparency false in
/-- The generic point lies in each chart open `D₊(X i)` (`X i ∉ ⊥`). -/
private lemma projectiveLineBar_genericPt_mem_basicOpen (kbar : Type u) [Field kbar]
    (f : MvPolynomial (Fin 2) kbar) (hf : f ≠ 0) :
    projectiveLineBarGenericPt kbar ∈
      Proj.basicOpen (projectiveLineBarGrading kbar) f := by
  rw [Proj.mem_basicOpen]
  intro hmem
  rw [show (projectiveLineBarGenericPt kbar).asHomogeneousIdeal =
      (⊥ : HomogeneousIdeal (projectiveLineBarGrading kbar)) from rfl,
    ← HomogeneousIdeal.mem_iff, HomogeneousIdeal.toIdeal_bot, Ideal.mem_bot] at hmem
  exact hf hmem

set_option backward.isDefEq.respectTransparency false in
/-- **`ℙ¹_{k̄}` is geometrically irreducible over `Spec k̄`.** Formerly a BareScheme
scaffold sorry; relocated here (iter-201) with the real proof via the 2-chart cover:
the base change `ℙ¹_K` is covered by the two pulled-back chart opens, each irreducible
(`≅ Spec (K[u])` by `chartAway_geomIrred`), and both contain any preimage of the generic
point of `ℙ¹_{k̄}` under the (surjective, by base change) projection. -/
instance projectiveLineBar_geomIrred (kbar : Type u) [Field kbar] :
    GeometricallyIrreducible (ProjectiveLineBar kbar).hom := by
  rw [geometricallyIrreducible_iff]
  intro K _ y Z fst snd h
  suffices hmain : IrreducibleSpace ↥(pullback (ProjectiveLineBar kbar).hom y) by
    exact h.isoPullback.hom.homeomorph.irreducibleSpace_iff.mpr hmain
  -- Notation: `p` is the base-change projection `ℙ¹_K ⟶ ℙ¹_{k̄}`; `c i` the chart
  -- open immersion `Spec (Away 𝒜 (X i)) ⟶ ℙ¹_{k̄}`; `V i` the pulled-back chart opens.
  let p : pullback (ProjectiveLineBar kbar).hom y ⟶ ProjectiveLineBarScheme kbar :=
    pullback.fst (ProjectiveLineBar kbar).hom y
  let c := fun i : Fin 2 => Proj.awayι (projectiveLineBarGrading kbar)
    (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)
    (MvPolynomial.isHomogeneous_X kbar i) Nat.one_pos
  let V : Fin 2 → Set ↥(pullback (ProjectiveLineBar kbar).hom y) :=
    fun i => (p ⁻¹ᵁ Proj.basicOpen (projectiveLineBarGrading kbar)
      (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) : TopologicalSpace.Opens _)
  -- Each pulled-back chart open is irreducible.
  have hVirr : ∀ i : Fin 2, IsIrreducible (V i) := by
    intro i
    haveI hWi : IrreducibleSpace ↥(pullback p (c i)) := by
      haveI := chartAway_geomIrred kbar i
      have hpb : IrreducibleSpace ↥(pullback ((c i) ≫ (ProjectiveLineBar kbar).hom) y) :=
        pullback_of_geometrically GeometricallyIrreducible.geometrically_irreducibleSpace K y
      exact ((pullbackSymmetry p (c i)) ≪≫
        pullbackRightPullbackFstIso (ProjectiveLineBar kbar).hom y
          (c i)).hom.homeomorph.irreducibleSpace_iff.mpr hpb
    have hr := IsOpenImmersion.range_pullbackFst (f := c i) (g := p)
    rw [Proj.opensRange_awayι] at hr
    change IsIrreducible ((p ⁻¹ᵁ Proj.basicOpen (projectiveLineBarGrading kbar)
      (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) :
        TopologicalSpace.Opens ↥(pullback (ProjectiveLineBar kbar).hom y)) :
        Set ↥(pullback (ProjectiveLineBar kbar).hom y))
    rw [← hr, ← Set.image_univ]
    exact (IrreducibleSpace.isIrreducible_univ _).image _
      (pullback.fst p (c i)).continuous.continuousOn
  -- The two pulled-back chart opens cover.
  have htop : (⨆ i, Proj.basicOpen (projectiveLineBarGrading kbar)
      ((![MvPolynomial.X 0, MvPolynomial.X 1] : Fin 2 → MvPolynomial (Fin 2) kbar) i)) = ⊤ :=
    Proj.iSup_basicOpen_eq_top (projectiveLineBarGrading kbar)
      ![MvPolynomial.X 0, MvPolynomial.X 1] (projectiveLineBarAffineCover_span kbar)
  have hcov : ∀ z' : ↥(pullback (ProjectiveLineBar kbar).hom y),
      z' ∈ V 0 ∨ z' ∈ V 1 := by
    intro z'
    have hmem : p.base z' ∈ (⊤ : TopologicalSpace.Opens ↥(ProjectiveLineBarScheme kbar)) :=
      trivial
    rw [← htop] at hmem
    obtain ⟨i, hi⟩ := TopologicalSpace.Opens.mem_iSup.mp hmem
    fin_cases i
    · refine Or.inl ?_
      change p.base z' ∈ Proj.basicOpen (projectiveLineBarGrading kbar)
        (MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar)
      simpa using hi
    · refine Or.inr ?_
      change p.base z' ∈ Proj.basicOpen (projectiveLineBarGrading kbar)
        (MvPolynomial.X 1 : MvPolynomial (Fin 2) kbar)
      simpa using hi
  -- They intersect: `p` is surjective (base change of the surjective `y`), and any
  -- preimage of the generic point lies in both chart opens.
  haveI hy_surj : Surjective y := by
    constructor
    intro q
    obtain ⟨x⟩ : Nonempty ↥(Spec (CommRingCat.of K)) := inferInstance
    exact ⟨x, Subsingleton.elim _ _⟩
  haveI hp_surj : Surjective p := MorphismProperty.pullback_fst _ _ hy_surj
  obtain ⟨z0, hz0⟩ := p.surjective (projectiveLineBarGenericPt kbar)
  have hz0i : ∀ i : Fin 2, z0 ∈ V i := by
    intro i
    change p.base z0 ∈ Proj.basicOpen (projectiveLineBarGrading kbar)
      (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)
    rw [hz0]
    exact projectiveLineBar_genericPt_mem_basicOpen kbar _ (MvPolynomial.X_ne_zero i)
  exact irreducibleSpace_of_two_irreducible_opens
    (p ⁻¹ᵁ Proj.basicOpen (projectiveLineBarGrading kbar)
      (MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar)).isOpen
    (p ⁻¹ᵁ Proj.basicOpen (projectiveLineBarGrading kbar)
      (MvPolynomial.X 1 : MvPolynomial (Fin 2) kbar)).isOpen
    (hVirr 0) (hVirr 1) ⟨z0, hz0i 0, hz0i 1⟩ hcov


end AlgebraicGeometry

end
