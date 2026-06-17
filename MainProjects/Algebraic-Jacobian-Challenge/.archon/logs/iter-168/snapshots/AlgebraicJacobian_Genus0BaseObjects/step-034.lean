/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Genus-`0` base objects: `ℙ¹`, `Ga`, `Gm`, and the `Gm`-scaling action `σ_×`

This file ships the concrete genus-`0` base-case infrastructure (iter-165 lane) that
`AlgebraicJacobian.AbelianVarietyRigidity.morphism_P1_to_grpScheme_const` consumes via
the **`𝔾_m`-scaling shortcut** (Milne, *Abelian Varieties*, Proposition 3.10): the total
scaling action `σ_× : ℙ¹ × 𝔾_m → ℙ¹`, `(x, λ) ↦ λx`, feeds the proven Cor 1.5
(`hom_additive_decomp_of_rigidity`); the `W`-axis collapses at the scaling fixed point
`0 ∈ ℙ¹`, giving `f(λx) = f(x)`; density of `𝔾_m ⊆ ℙ¹` plus `A` separated
(`ext_of_eqOnOpen`) force `f` constant. NO theorem of the cube, NO Milne Thm 3.2, NO
`Hom(𝔾_a, A) = 0`, char-general. See `blueprint/src/chapters/AbelianVarietyRigidity.tex`
(`def:genus0_base_objects`, `def:gaTranslationP1`).

The file is **upstream** of `AbelianVarietyRigidity.lean` (the mathlib-analogist
`gm-scaling-p1` D4 verdict: split into a focused file per scheme construction, mirroring
the precedent of `Mathlib.AlgebraicGeometry.Group.{Smooth,Abelian}`). The AVR.lean refactor +
proof of `morphism_P1_to_grpScheme_const` is iter-166's lane and does NOT happen here.

## The four declarations

1. `ProjectiveLineBar` — the projective line `ℙ¹` over `Spec k̄`, encoded as `Proj 𝒜` of
   the standard ℕ-graded `MvPolynomial (Fin 2) k̄`, viewed as an object of
   `Over (Spec (.of kbar))`. `IsProper` is FREE from
   `AlgebraicGeometry.Proj.instIsProperToSpecZero…` (the algebra is finite type).
   `GeometricallyIrreducible` and `SmoothOfRelativeDimension 1` are project-side sub-builds
   (Mathlib does not ship these for `Proj`), left as scaffold `sorry`s for iter-166+.

2. `Ga` — the additive group object `𝔾_a` over `Spec k̄`, encoded as
   `(AffineSpace (Fin 1) (Spec (.of kbar))).asOver _`. `IsAffine` is FREE; `GrpObj` is
   installed via `GrpObj.ofRepresentableBy` with the additive-group functor
   `T ↦ AddGrpCat.of Γ(T.left, ⊤)`; `Smooth` is FREE from
   `smooth_of_grpObj_of_isAlgClosed`.

3. `Gm` — the multiplicative group object `𝔾_m` over `Spec k̄`, encoded as
   `(Spec (.of (Localization.Away (X : MvPolynomial Unit k̄)))).asOver _`
   (= `Spec k̄[t, t⁻¹]`, AFFINE — NOT the basic-open path). `IsAffine` is FREE; `GrpObj` is
   installed via `GrpObj.ofRepresentableBy` with the units functor
   `T ↦ GrpCat.of Γ(T.left, ⊤)ˣ`; `Smooth` is FREE from
   `smooth_of_grpObj_of_isAlgClosed`.

4. `gmScalingP1 : ProjectiveLineBar ⊗ Gm ⟶ ProjectiveLineBar` — the bare scaling
   morphism `(x, λ) ↦ λx`, with companion lemma `gmScalingP1_collapse_at_zero` exposing
   the load-bearing fixed-point property at `0 ∈ ℙ¹` that `hom_additive_decomp_of_rigidity`
   (Cor 1.5) needs.

The blueprint chapter `AbelianVarietyRigidity.tex` covers this file via
`% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean
AlgebraicJacobian/Genus0BaseObjects.lean`.
-/

set_option autoImplicit false
set_option linter.style.setOption false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

noncomputable section

namespace AlgebraicGeometry

/-! ### (A) The projective line `ℙ¹` over `Spec k̄` (the `Proj` realisation) -/

/-- The **standard ℕ-grading on `k̄[X₀, X₁]`** by total degree.

This is the homogeneous-component decomposition `MvPolynomial.homogeneousSubmodule`
specialised to two variables (`Fin 2`) over `k̄`. The `GradedRing` instance is
`MvPolynomial.gradedAlgebra` (free).

Used to define `ProjectiveLineBar = Proj` of this graded ring. -/
abbrev projectiveLineBarGrading (kbar : Type u) [Field kbar] :
    ℕ → Submodule kbar (MvPolynomial (Fin 2) kbar) :=
  MvPolynomial.homogeneousSubmodule (Fin 2) kbar

instance projectiveLineBarGrading_gradedRing (kbar : Type u) [Field kbar] :
    GradedRing (projectiveLineBarGrading kbar) :=
  MvPolynomial.gradedAlgebra

/-- **The projective line over `Spec k̄` as a scheme.** This is `Proj 𝒜` of the standard
ℕ-graded `k̄[X₀, X₁]`. Carries an `Over (Spec (.of kbar))` instance via
`Proj.toSpecZero` composed with the algebra-map identification of the degree-`0` piece
with `k̄` (Mathlib's `SetLike.GradeZero.instAlgebraSubtypeMemOfNat`).

`IsProper` is FREE — see the `instIsProper` instance below. `IsAlgClosed kbar` is *not*
required for the scheme itself but is needed for downstream `Smooth`/geometric
irreducibility instances. -/
def ProjectiveLineBarScheme (kbar : Type u) [Field kbar] : Scheme :=
  Proj (projectiveLineBarGrading kbar)

/-- The natural `Over (Spec (.of kbar))` structure on `ProjectiveLineBarScheme` via
`Proj.toSpecZero` and the identification `k̄ ≃ ↥(𝒜 0)`. -/
instance projectiveLineBarScheme_canOver (kbar : Type u) [Field kbar] :
    (ProjectiveLineBarScheme kbar).Over (Spec (.of kbar)) where
  hom := Proj.toSpecZero (projectiveLineBarGrading kbar) ≫
    Spec.map (CommRingCat.ofHom
      (algebraMap kbar ↥((projectiveLineBarGrading kbar) 0)))

/-- **The projective line `ℙ¹_{k̄}` as an object of `Over (Spec (.of kbar))`.** This is the
concrete scheme used by `morphism_P1_to_grpScheme_const` (iter-166) to formalise the
`𝔾_m`-scaling shortcut. -/
def ProjectiveLineBar (kbar : Type u) [Field kbar] : Over (Spec (.of kbar)) :=
  (ProjectiveLineBarScheme kbar).asOver (Spec (.of kbar))

/-- **`ℙ¹_{k̄}` is proper over `Spec k̄`.** FREE from
`AlgebraicGeometry.Proj.instIsProperToSpecZero…` — the algebra `k̄[X₀, X₁]` is finite type
over its degree-`0` piece `↥(𝒜 0) ≃ k̄` — chained via the standard properness-of-composition
lemma with the `Spec.map` of the algebra map `k̄ → ↥(𝒜 0)` (which is bijective hence
gives an iso of `Spec`s).

The chain:
* `Proj.toSpecZero 𝒜` is proper (Mathlib's
  `Proj.instIsProperToSpecZeroOfFiniteTypeSubtypeMemOfNatNat`, given
  `Algebra.FiniteType ↥(𝒜 0) (MvPolynomial (Fin 2) k̄)` — supplied by the
  `IsScalarTower kbar ↥(𝒜 0) (MvPolynomial _ _)` + `Algebra.FiniteType k̄ (MvPolynomial _ _)`
  chain via `Algebra.FiniteType.of_restrictScalars_finiteType`);
* `Spec.map (algebraMap k̄ ↥(𝒜 0))` is an iso because `algebraMap k̄ ↥(𝒜 0)` is bijective
  in this standard ℕ-grading case (`𝒜 0 = MvPolynomial.homogeneousSubmodule (Fin 2) k̄ 0`
  is the constants subalgebra, naturally ≅ k̄);
* composition of proper + iso is proper. -/
instance projectiveLineBar_isProper (kbar : Type u) [Field kbar] :
    IsProper (ProjectiveLineBar kbar).hom := by
  -- Unfold to expose the Proj.toSpecZero ≫ Spec.map chain.
  change IsProper (Proj.toSpecZero (projectiveLineBarGrading kbar) ≫
    Spec.map (CommRingCat.ofHom
      (algebraMap kbar ↥((projectiveLineBarGrading kbar) 0))))
  -- The IsScalarTower kbar ↥(𝒜 0) (MvPolynomial _ kbar) needed for the FiniteType derivation.
  haveI : IsScalarTower kbar
      ↥(MvPolynomial.homogeneousSubmodule (Fin 2) kbar 0)
      (MvPolynomial (Fin 2) kbar) :=
    IsScalarTower.of_algebraMap_eq fun _ => rfl
  -- MvPolynomial.{Fin 2} k̄ is finite type over ↥(𝒜 0) (chained from finite-type over k̄).
  haveI : Algebra.FiniteType
      ↥(MvPolynomial.homogeneousSubmodule (Fin 2) kbar 0)
      (MvPolynomial (Fin 2) kbar) :=
    Algebra.FiniteType.of_restrictScalars_finiteType kbar _ _
  -- The algebra map `k̄ → ↥(𝒜 0)` is bijective: the degree-`0` piece of the homogeneous
  -- decomposition is exactly the constants `C(k̄) ⊆ MvPolynomial (Fin 2) k̄`. Injectivity
  -- follows from `MvPolynomial.C_injective`. Surjectivity uses
  -- `MvPolynomial.homogeneousComponent_of_mem` (which says the degree-`0` component of a
  -- homogeneous-degree-`0` polynomial is itself) plus `homogeneousComponent_zero`
  -- (which expresses the degree-`0` component as `C` of the constant coefficient).
  have hbij : Function.Bijective (algebraMap kbar
      ↥(MvPolynomial.homogeneousSubmodule (Fin 2) kbar 0)) := by
    refine ⟨?_, ?_⟩
    · intro x y h
      apply MvPolynomial.C_injective (Fin 2) kbar
      exact congrArg Subtype.val h
    · intro ⟨v, hv⟩
      refine ⟨MvPolynomial.coeff 0 v, ?_⟩
      apply Subtype.ext
      rw [SetLike.GradeZero.coe_algebraMap]
      have key := MvPolynomial.homogeneousComponent_of_mem hv (m := 0)
      -- `key : (homogeneousComponent 0) v = if 0 = 0 then v else 0` which simp resolves
      -- and combines with `homogeneousComponent_zero` to give `C (coeff 0 v) = v`.
      simp only [MvPolynomial.homogeneousComponent_zero, if_true] at key
      exact key
  -- Therefore `Spec.map (algebraMap k̄ ↥(𝒜 0))` is iso, and composition of proper + iso is
  -- proper.
  haveI : IsIso (Spec.map (CommRingCat.ofHom
      (algebraMap kbar ↥(MvPolynomial.homogeneousSubmodule (Fin 2) kbar 0)))) := by
    rw [isIso_SpecMap_iff]
    exact hbij
  infer_instance

/-- **`ℙ¹_{k̄}` is geometrically irreducible over `Spec k̄`.** Project-side scaffold sorry
(Mathlib does not ship `GeometricallyIrreducible` for `Proj` of a polynomial ring;
plan-marked acceptable for iter-165). -/
instance projectiveLineBar_geomIrred (kbar : Type u) [Field kbar] :
    GeometricallyIrreducible (ProjectiveLineBar kbar).hom :=
  sorry

/-- **`ℙ¹_{k̄}` is smooth of relative dimension `1` over `Spec k̄`.** Project-side scaffold
sorry (Mathlib does not ship `SmoothOfRelativeDimension 1` for `Proj`; plan-marked
acceptable for iter-165). -/
instance projectiveLineBar_smoothOfRelDim (kbar : Type u) [Field kbar] :
    SmoothOfRelativeDimension 1 (ProjectiveLineBar kbar).hom :=
  sorry

/-! ### The 2-chart affine cover of `ℙ¹_{k̄}` -/

/-- **The 2-chart affine open cover of `ProjectiveLineBarScheme`** by `D₊(X 0)` and
`D₊(X 1)`. Specialises `Proj.affineOpenCoverOfIrrelevantLESpan` to the family
`![X 0, X 1] : Fin 2 → MvPolynomial (Fin 2) k̄` with `m := ![1, 1]`.

The non-trivial bit is `hf`: the irrelevant ideal `(X 0, X 1)` is contained in
`Ideal.span {X 0, X 1}` — proved by writing any irrelevant element as a sum of monomials
whose multi-index `d ≠ 0`, hence `d j > 0` for some `j ∈ Fin 2`, hence
`monomial d r ∈ Ideal.span {X 0, X 1}` via `MvPolynomial.X_dvd_monomial`. -/
noncomputable def projectiveLineBarAffineCover (kbar : Type u) [Field kbar] :
    (ProjectiveLineBarScheme kbar).AffineOpenCover :=
  let f : Fin 2 → MvPolynomial (Fin 2) kbar := ![MvPolynomial.X 0, MvPolynomial.X 1]
  let m : Fin 2 → ℕ := ![1, 1]
  Proj.affineOpenCoverOfIrrelevantLESpan (projectiveLineBarGrading kbar) (m := m) f
    (fun i ↦ by
      fin_cases i <;> simp [f, m, Matrix.cons_val_zero, Matrix.cons_val_one,
        MvPolynomial.isHomogeneous_X])
    (fun i ↦ by fin_cases i <;> simp [m])
    (by
      classical
      intro p hp
      rw [HomogeneousIdeal.mem_iff, HomogeneousIdeal.mem_irrelevant_iff,
        GradedRing.proj_apply] at hp
      have hp' : MvPolynomial.homogeneousComponent 0 p = 0 := by
        have := hp
        rw [show DirectSum.decompose (projectiveLineBarGrading kbar) p 0
            = ⟨MvPolynomial.homogeneousComponent 0 p,
                MvPolynomial.homogeneousComponent_mem 0 p⟩ from Subtype.ext
          (MvPolynomial.decomposition.decompose'_apply p 0)] at this
        exact this
      have h0 : MvPolynomial.coeff 0 p = 0 := by
        rw [MvPolynomial.homogeneousComponent_zero] at hp'
        exact MvPolynomial.C_injective _ _ (hp'.trans MvPolynomial.C_0.symm)
      rw [MvPolynomial.as_sum p]
      refine Ideal.sum_mem _ fun d hd ↦ ?_
      have hcoeff : MvPolynomial.coeff d p ≠ 0 := MvPolynomial.mem_support_iff.mp hd
      have hd_ne : d ≠ 0 := fun heq => hcoeff (heq ▸ h0)
      have hd_nonzero : d 0 ≠ 0 ∨ d 1 ≠ 0 := by
        by_contra h
        push Not at h
        apply hd_ne
        ext k
        fin_cases k
        · simpa using h.1
        · simpa using h.2
      rcases hd_nonzero with h0' | h1'
      · obtain ⟨q, hq⟩ : (MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar) ∣
            MvPolynomial.monomial d (MvPolynomial.coeff d p) :=
          MvPolynomial.X_dvd_monomial.mpr (Or.inr h0')
        rw [hq, mul_comm]
        exact Ideal.mul_mem_left _ _ (Ideal.subset_span ⟨0, rfl⟩)
      · obtain ⟨q, hq⟩ : (MvPolynomial.X 1 : MvPolynomial (Fin 2) kbar) ∣
            MvPolynomial.monomial d (MvPolynomial.coeff d p) :=
          MvPolynomial.X_dvd_monomial.mpr (Or.inr h1')
        rw [hq, mul_comm]
        exact Ideal.mul_mem_left _ _ (Ideal.subset_span ⟨1, rfl⟩))

/-! ### The chart-ring iso: `HomogeneousLocalization.Away 𝒜 (X i) ≃+* k̄[u]` -/

/-- **The "other" `Fin 2` index** used in the chart-`i` affine coordinate `X (other i) / X i`. -/
private def otherFin : Fin 2 → Fin 2
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
    simp only [RingHom.id_apply,
      mvPolyToHomogeneousLocalizationAway, MvPolynomial.eval₂Hom_C,
      kbarToAwayRingHom, RingHom.comp_apply,
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
    simp only [RingHom.id_apply,
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

/-- Round-trip on `Away 𝒜 (X i)`: `inverse ∘ forward = id`.

The proof strategy: surjectivity of `inverse` (the image equals `Algebra.adjoin (𝒜 0)
{isLocalizationElem}`, which is `⊤` by `Away.adjoin_mk_prod_pow_eq_top` applied with
`d = 1`, `v = ![X 0, X 1]`, `dv = ![1, 1]`); together with the already-proved
`forward.comp inverse = id`, gives `inverse.comp forward = id` by a "cancel surjective"
argument.

Full proof of surjectivity is involved (~30 LOC reducing through `Algebra.adjoin` and
`Away.adjoin_mk_prod_pow_eq_top`). Alternative direct approach via
`MvPolynomial.IsWeightedHomogeneous.induction_on` on `num` (~50 LOC). Deferred; see
analogist `gmscaling-deep.md` Q2 right_inv. -/
private lemma homogeneousLocalizationAwayIso_aux_left (kbar : Type u) [Field kbar] (i : Fin 2) :
    (mvPolyToHomogeneousLocalizationAway kbar i).comp
        (homogeneousLocalizationAwayToMvPoly kbar i) =
      RingHom.id _ := by
  sorry

/-- **The chart-ring iso `Away 𝒜 (X i) ≃+* k̄[u]`** — built from the forward map (via
`Localization.awayLift`) and the inverse map (via `MvPolynomial.eval₂Hom`). The two round-trips
are proved at the underlying-`Localization.Away` level by `HomogeneousLocalization.val_injective`. -/
noncomputable def homogeneousLocalizationAwayIso (kbar : Type u) [Field kbar] (i : Fin 2) :
    HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) ≃+*
      MvPolynomial Unit kbar :=
  RingEquiv.ofRingHom
    (homogeneousLocalizationAwayToMvPoly kbar i)
    (mvPolyToHomogeneousLocalizationAway kbar i)
    (homogeneousLocalizationAwayIso_aux_right kbar i)
    (homogeneousLocalizationAwayIso_aux_left kbar i)

/-! ### The standard `k̄`-points `0`, `1`, `∞` on `ℙ¹`

The three distinguished `k̄`-points of `ℙ¹_{k̄}` are `[0 : 1]` (the affine origin), `[1 : 1]`
(the affine unit), and `[1 : 0]` (the point at infinity). They are encoded as morphisms
`𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar`, i.e. sections of `ProjectiveLineBar.hom`.

The construction goes through `Proj.fromOfGlobalSections`: a `k̄`-point of `Proj 𝒜` is
specified by an evaluation ring map `MvPolynomial (Fin 2) kbar →+* k̄` (composed into
`Γ(Spec k̄, ⊤)` via `Scheme.ΓSpecIso`) whose image of the irrelevant ideal `(X₀, X₁)`
generates the unit ideal — automatic whenever the evaluation vector has a unit coordinate. -/

/-- **The underlying ring map of a `k̄`-point of `ℙ¹`.** Sends `X₀ ↦ v 0`, `X₁ ↦ v 1`,
then composes back into `Γ(Spec k̄, ⊤)` via the inverse of `Scheme.ΓSpecIso`. -/
private noncomputable def ProjectiveLineBar.evalIntoGlobal
    (kbar : Type u) [Field kbar] (v : Fin 2 → kbar) :
    MvPolynomial (Fin 2) kbar →+* Γ(Spec (.of kbar), ⊤) :=
  (Scheme.ΓSpecIso (.of kbar)).inv.hom.comp (MvPolynomial.eval v)

/-- **Irrelevant-ideal-maps-to-top condition** for `ProjectiveLineBar.evalIntoGlobal`: if one
of the coordinates `v 0` or `v 1` is a unit, then the image of `(X₀, X₁)` generates the
unit ideal in `Γ(Spec k̄, ⊤)`. -/
private lemma ProjectiveLineBar.irrelevant_map_eq_top
    (kbar : Type u) [Field kbar] (v : Fin 2 → kbar) (i : Fin 2) (hi : IsUnit (v i)) :
    Ideal.map (ProjectiveLineBar.evalIntoGlobal kbar v)
        (HomogeneousIdeal.irrelevant (projectiveLineBarGrading kbar)).toIdeal = ⊤ := by
  have hX_mem : (MvPolynomial.X i : MvPolynomial (Fin 2) kbar) ∈
      (HomogeneousIdeal.irrelevant (projectiveLineBarGrading kbar)).toIdeal :=
    HomogeneousIdeal.mem_irrelevant_of_mem _ Nat.zero_lt_one
      (MvPolynomial.isHomogeneous_X kbar i)
  have hImg_mem : ProjectiveLineBar.evalIntoGlobal kbar v (MvPolynomial.X i) ∈
      Ideal.map (ProjectiveLineBar.evalIntoGlobal kbar v)
        (HomogeneousIdeal.irrelevant (projectiveLineBarGrading kbar)).toIdeal :=
    Ideal.mem_map_of_mem _ hX_mem
  have hImg_unit : IsUnit (ProjectiveLineBar.evalIntoGlobal kbar v (MvPolynomial.X i)) := by
    unfold ProjectiveLineBar.evalIntoGlobal
    rw [RingHom.comp_apply, MvPolynomial.eval_X]
    exact hi.map _
  rw [Ideal.eq_top_iff_one]
  obtain ⟨u, hu⟩ := hImg_unit
  rw [show (1 : Γ(Spec (.of kbar), ⊤)) = ((u⁻¹ : Γ(Spec (.of kbar), ⊤)ˣ) : _) * u from
    (Units.inv_mul _).symm]
  exact Ideal.mul_mem_left _ _ (hu.symm ▸ hImg_mem)

/-- **Helper: construct a `k̄`-point of `ProjectiveLineBar kbar`** from an evaluation vector
`v : Fin 2 → kbar` with at least one unit coordinate. The underlying scheme map is
`Proj.fromOfGlobalSections` of the evaluation; the section condition chases through
`fromOfGlobalSections_toSpecZero` + `IsScalarTower kbar (𝒜 0) MvPoly` collapse to
`MvPolynomial.C` + `MvPolynomial.eval_C` + `toSpecΓ_SpecMap_ΓSpecIso_inv`. -/
private noncomputable def ProjectiveLineBar.pointOfVec
    (kbar : Type u) [Field kbar] (v : Fin 2 → kbar) (i : Fin 2) (hi : IsUnit (v i)) :
    𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar :=
  Over.homMk
    (Proj.fromOfGlobalSections (projectiveLineBarGrading kbar)
      (ProjectiveLineBar.evalIntoGlobal kbar v)
      (ProjectiveLineBar.irrelevant_map_eq_top kbar v i hi)) <| by
    -- Section condition: fromOfGlobalSections ≫ ProjectiveLineBar.hom = 𝟙.
    haveI : IsScalarTower kbar ↥(projectiveLineBarGrading kbar 0)
        (MvPolynomial (Fin 2) kbar) :=
      IsScalarTower.of_algebraMap_eq fun _ => rfl
    -- Expose the structure morphism's composition shape.
    change Proj.fromOfGlobalSections _ _ _ ≫ Proj.toSpecZero _ ≫ Spec.map _ = _
    -- Combine via `fromOfGlobalSections_toSpecZero`, then unify the two Spec.maps.
    rw [← Category.assoc, Proj.fromOfGlobalSections_toSpecZero, Category.assoc,
      ← Spec.map_comp, ← CommRingCat.ofHom_comp, RingHom.comp_assoc,
      ← IsScalarTower.algebraMap_eq kbar, MvPolynomial.algebraMap_eq]
    -- The inner composition `(evalIntoGlobal v) ∘ C` collapses to `(ΓSpecIso).inv.hom`.
    -- Build a CommRingCat-level equation, then apply `Spec.map` and finish.
    have hcc : CommRingCat.ofHom
        ((ProjectiveLineBar.evalIntoGlobal kbar v).comp MvPolynomial.C) =
        (Scheme.ΓSpecIso (CommRingCat.of kbar)).inv := by
      apply CommRingCat.hom_ext
      ext r
      change (Scheme.ΓSpecIso (CommRingCat.of kbar)).inv.hom
          ((MvPolynomial.eval v) (MvPolynomial.C r)) = _
      rw [MvPolynomial.eval_C]
    calc _ = (Spec (CommRingCat.of kbar)).toSpecΓ ≫
            Spec.map (Scheme.ΓSpecIso (CommRingCat.of kbar)).inv := by
            exact congrArg _ (congrArg Spec.map hcc)
      _ = _ := AlgebraicGeometry.toSpecΓ_SpecMap_ΓSpecIso_inv _

/-- The `k̄`-point `0 = [0 : 1] ∈ ℙ¹`, encoded as a section of `ProjectiveLineBar.hom` via
`Proj.fromOfGlobalSections` of the evaluation `X₀ ↦ 0`, `X₁ ↦ 1`. -/
noncomputable def ProjectiveLineBar.zeroPt (kbar : Type u) [Field kbar] :
    𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar :=
  ProjectiveLineBar.pointOfVec kbar (fun i => if i = 0 then 0 else 1) 1 (by simp)

/-- The `k̄`-point `1 = [1 : 1] ∈ ℙ¹`, encoded as a section via the evaluation
`X₀ ↦ 1`, `X₁ ↦ 1`. -/
noncomputable def ProjectiveLineBar.onePt (kbar : Type u) [Field kbar] :
    𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar :=
  ProjectiveLineBar.pointOfVec kbar (fun _ => 1) 0 (by simp)

/-- The `k̄`-point `∞ = [1 : 0] ∈ ℙ¹`, encoded as a section via the evaluation
`X₀ ↦ 1`, `X₁ ↦ 0`. -/
noncomputable def ProjectiveLineBar.inftyPt (kbar : Type u) [Field kbar] :
    𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar :=
  ProjectiveLineBar.pointOfVec kbar (fun i => if i = 0 then 1 else 0) 0 (by simp)

/-! ### (B) The additive group `𝔾_a` over `Spec k̄` -/

/-- **The additive group `𝔾_a = 𝔸¹` over `Spec k̄` as an underlying scheme.** This is the
affine line `AffineSpace (Fin 1) (Spec (.of kbar))`. It is affine, locally of finite
presentation, and reduced (its global sections are `MvPolynomial (Fin 1) k̄`, a domain). -/
def GaScheme (kbar : Type u) [Field kbar] : Scheme :=
  AffineSpace.{0, u} (Fin 1) (Spec (.of kbar))

/-- The natural `Over (Spec (.of kbar))` instance on `GaScheme` (via
`AlgebraicGeometry.AffineSpace.over`). -/
instance gaScheme_canOver (kbar : Type u) [Field kbar] :
    (GaScheme kbar).Over (Spec (.of kbar)) :=
  inferInstanceAs ((AffineSpace.{0, u} (Fin 1) (Spec (.of kbar))).Over (Spec (.of kbar)))

/-- **The additive group object `𝔾_a` over `Spec k̄` as an object of
`Over (Spec (.of kbar))`.** -/
abbrev Ga (kbar : Type u) [Field kbar] : Over (Spec (.of kbar)) :=
  (GaScheme kbar).asOver (Spec (.of kbar))

/-- **`𝔾_a` is an affine morphism over `Spec k̄`.** FREE from
`AlgebraicGeometry.AffineSpace.instIsAffineHomOverSchemeInferInstanceOverClass`. -/
instance ga_isAffineHom (kbar : Type u) [Field kbar] :
    IsAffineHom (Ga kbar).hom :=
  inferInstanceAs (IsAffineHom (AffineSpace.{0, u} (Fin 1) (Spec (.of kbar)) ↘
    (Spec (.of kbar))))

/-- **`𝔾_a` is locally of finite presentation over `Spec k̄`.** FREE from
`AffineSpace.instLocallyOfFinitePresentation…OfFinite` (the index `Fin 1` is finite). -/
instance ga_locallyOfFinitePresentation (kbar : Type u) [Field kbar] :
    LocallyOfFinitePresentation (Ga kbar).hom :=
  inferInstanceAs (LocallyOfFinitePresentation
    (AffineSpace.{0, u} (Fin 1) (Spec (.of kbar)) ↘ Spec (.of kbar)))

/-- **`𝔾_a`'s underlying scheme is reduced.** Since the global sections are
`MvPolynomial (Fin 1) k̄`, a domain over a field, the affine scheme is reduced. The proof
transfers `IsReduced (Spec (.of (MvPolynomial _ _)))` (free for any reduced ring) across
`AffineSpace.isoOfIsAffine`. -/
instance ga_isReduced (kbar : Type u) [Field kbar] : IsReduced (Ga kbar).left :=
  isReduced_of_isOpenImmersion (AffineSpace.isoOfIsAffine (Fin 1) _).hom

/-- **`GrpObj`-structure on `𝔾_a` via `ofRepresentableBy`.**

Installs the additive-group structure on `Ga` using the Yoneda installer
`GrpObj.ofRepresentableBy` (Mathlib's canonical mechanism) with the additive-group functor
`T ↦ AddGrpCat.of Γ(T.left, ⊤)` and the representable-by witness derived from
`AffineSpace.homOverEquiv`. Scaffold: full body is iter-166's lane (the homEquiv +
naturality glue is straightforward but needs careful unfolding).

Scaffold body for iter-166+; off-path for the genus-0 closure (the rigidity consumer
`hom_additive_decomp_of_rigidity` uses `W = Gm`, not `W = Ga` — `Ga` is on the demoted
additive route only). -/
instance ga_grpObj (kbar : Type u) [Field kbar] : GrpObj (Ga kbar) := sorry

/-- **`𝔾_a` is smooth over `Spec k̄`.** FREE from
`AlgebraicGeometry.smooth_of_grpObj_of_isAlgClosed` once `GrpObj`, `LocallyOfFinitePresentation`,
and `IsReduced` are installed. -/
instance ga_smooth (kbar : Type u) [Field kbar] [IsAlgClosed kbar] :
    Smooth (Ga kbar).hom :=
  have : GrpObj (Over.mk (Ga kbar).hom) := ga_grpObj kbar
  smooth_of_grpObj_of_isAlgClosed (Ga kbar).hom

/-! ### (C) The multiplicative group `𝔾_m` over `Spec k̄` -/

/-- **The ring `k̄[t, t⁻¹] = Localization.Away t`**, where `t = X () : MvPolynomial Unit k̄`.
This is the global-sections ring of `𝔾_m`. -/
abbrev GmRing (kbar : Type u) [Field kbar] : Type u :=
  Localization.Away (MvPolynomial.X () : MvPolynomial Unit kbar)

/-- **The multiplicative group `𝔾_m = Spec k̄[t, t⁻¹]` as an underlying scheme.** This is
the chosen affine encoding (the analogist `gm-scaling-p1` D2.b verdict: AFFINE `Spec`, NOT
the basic-open of `𝔸¹` — the latter loses `IsAffine`). -/
def GmScheme (kbar : Type u) [Field kbar] : Scheme :=
  Spec (CommRingCat.of (GmRing kbar))

/-- The natural `Over (Spec (.of kbar))` instance on `GmScheme`. -/
instance gmScheme_canOver (kbar : Type u) [Field kbar] :
    (GmScheme kbar).Over (Spec (.of kbar)) where
  hom := Spec.map (CommRingCat.ofHom (algebraMap kbar (GmRing kbar)))

/-- **The multiplicative group object `𝔾_m` over `Spec k̄` as an object of
`Over (Spec (.of kbar))`.** -/
abbrev Gm (kbar : Type u) [Field kbar] : Over (Spec (.of kbar)) :=
  (GmScheme kbar).asOver (Spec (.of kbar))

/-- **`𝔾_m` is affine.** -/
instance gm_isAffine (kbar : Type u) [Field kbar] : IsAffine (Gm kbar).left :=
  inferInstanceAs (IsAffine (Spec (CommRingCat.of (GmRing kbar))))

/-- **`𝔾_m` is locally of finite presentation over `Spec k̄`.** Follows from
`Algebra.FinitePresentation k̄ (k̄[t, t⁻¹])` (a localization of a polynomial ring at a single
element is finitely presented), bridged through
`AlgebraicGeometry.HasRingHomProperty.Spec_iff` for the `LocallyOfFinitePresentation` /
`RingHom.FinitePresentation` correspondence. -/
instance gm_locallyOfFinitePresentation (kbar : Type u) [Field kbar] :
    LocallyOfFinitePresentation (Gm kbar).hom :=
  (HasRingHomProperty.Spec_iff (P := @LocallyOfFinitePresentation)).mpr
    ((RingHom.finitePresentation_algebraMap (B := GmRing kbar)).mpr
      inferInstance)

/-- **`𝔾_m`'s underlying scheme is reduced.** `k̄[t, t⁻¹]` is a localization of a domain at
a non-zero-divisor, hence a domain, hence reduced. The `IsReduced (Spec _)` instance picks
up directly from `IsReduced (Localization.Away _)`. -/
instance gm_isReduced (kbar : Type u) [Field kbar] : IsReduced (Gm kbar).left :=
  inferInstanceAs (IsReduced (Spec (CommRingCat.of (GmRing kbar))))

/-- **`k̄[t, t⁻¹]` is an integral domain.** Localization of the integral polynomial ring
`MvPolynomial Unit k̄` at the powers of a nonzero element `X () ≠ 0` preserves the domain
property (`IsLocalization.isDomain_localization` applied to
`Submonoid.powers (X ()) ≤ nonZeroDivisors`, the latter from `MvPolynomial.X_ne_zero`).

Load-bearing for `gm_irreducibleSpace` and `gm_geomIrred`. -/
instance gmRing_isDomain (kbar : Type u) [Field kbar] : IsDomain (GmRing kbar) := by
  unfold GmRing
  exact IsLocalization.isDomain_localization
    (powers_le_nonZeroDivisors_of_noZeroDivisors (MvPolynomial.X_ne_zero _))

/-- **`𝔾_m`'s underlying scheme is irreducible.** Follows from the fact that the
global-sections ring `GmRing = k̄[t, t⁻¹]` is an integral domain (`gmRing_isDomain`)
together with Mathlib's `Spec` of a domain being irreducible
(`PrimeSpectrum.irreducibleSpace`). -/
instance gm_irreducibleSpace (kbar : Type u) [Field kbar] :
    IrreducibleSpace (Gm kbar).left := by
  change IrreducibleSpace (Spec (CommRingCat.of (GmRing kbar)))
  infer_instance

/-- **`GrpObj`-structure on `𝔾_m` via `ofRepresentableBy`.**

Installs the multiplicative-group structure on `Gm` using `GrpObj.ofRepresentableBy` with
the units functor `T ↦ GrpCat.of Γ(T.left, ⊤)ˣ`. The representable-by witness exploits the
fact that morphisms into `Spec (Localization.Away t)` correspond exactly to units in the
global sections (Mathlib's `IsLocalization.Away`-Spec bijection). Scaffold body — same
discipline as `ga_grpObj`.

This `GrpObj Gm` is the LIVE consumer of the iter-166 `morphism_P1_to_grpScheme_const`
proof body (the `𝔾_m`-scaling shortcut applies `hom_additive_decomp_of_rigidity` with
`W = Gm`). -/
instance gm_grpObj (kbar : Type u) [Field kbar] : GrpObj (Gm kbar) := sorry

/-- **`𝔾_m` is smooth over `Spec k̄`.** FREE from `smooth_of_grpObj_of_isAlgClosed` once
`GrpObj`, `LocallyOfFinitePresentation`, and `IsReduced` are installed. -/
instance gm_smooth (kbar : Type u) [Field kbar] [IsAlgClosed kbar] :
    Smooth (Gm kbar).hom :=
  have : GrpObj (Over.mk (Gm kbar).hom) := gm_grpObj kbar
  smooth_of_grpObj_of_isAlgClosed (Gm kbar).hom

/-- The `k̄`-point `1 ∈ 𝔾_m` (the multiplicative identity), encoded as the group-object
unit `η[Gm kbar] : 𝟙_ ⟶ Gm kbar`. -/
def Gm.onePt (kbar : Type u) [Field kbar] :
    𝟙_ (Over (Spec (.of kbar))) ⟶ Gm kbar :=
  η[Gm kbar]

/-! ### (D) The `𝔾_m`-scaling action `σ_× : ℙ¹ × 𝔾_m ⟶ ℙ¹`

`gmScalingP1` is a *bare* `Over (Spec (.of kbar))`-morphism (the analogist D3 verdict:
no `IsAction`/`MulAction`-style typeclass at scheme level — Mathlib has no such precedent;
the rigidity consumer needs only the bare morphism + the named fixed-point lemma).

Chartwise definition: on `𝔸¹ × 𝔾_m` (target chart `D₊(X₀)` of `ℙ¹`), the morphism is
the polynomial map `(x, λ) ↦ λx`; near `∞` (target chart `D₊(X₁)`, coordinate `u = 1/x`),
the target coordinate `1/(λx) = u/λ` is regular because `λ ∈ 𝔾_m` is invertible. The two
chart-restrictions agree on `(𝔸¹ ∖ {0}) × 𝔾_m`, so they glue via
`AlgebraicGeometry.Scheme.Cover.glueMorphisms`.

The companion lemma `gmScalingP1_collapse_at_zero` exposes the load-bearing fixed-point
property `σ_×(0, λ) = 0` for all `λ ∈ 𝔾_m`, packaged as the `W`-axis-collapse hypothesis
that `hom_additive_decomp_of_rigidity` (Cor 1.5) consumes. -/

/-- **The `𝔾_m`-scaling action `σ_× : ℙ¹ × 𝔾_m ⟶ ℙ¹`** in `Over (Spec (.of kbar))`.

Scaffold body — iter-165 lands the *type signature* (the concrete object the iter-166
proof refactor of `morphism_P1_to_grpScheme_const` consumes); the chartwise glue body
is iter-166's lane (or an even later sub-build if `Scheme.Cover.glueMorphisms` requires
further infrastructure). -/
def gmScalingP1 (kbar : Type u) [Field kbar] :
    ProjectiveLineBar kbar ⊗ Gm kbar ⟶ ProjectiveLineBar kbar :=
  sorry

/-- **The load-bearing fixed-point property of `σ_×`:** at the scaling fixed point
`0 ∈ ℙ¹`, the morphism `σ_×(0, ·) : 𝔾_m → ℙ¹` is the constant morphism at `0`. That is,
the composite `(0 ≫ toUnit) × 𝟙 : 𝔾_m ⟶ ℙ¹ ⊗ 𝔾_m ⟶ ℙ¹` equals `toUnit ≫ 0`.

This is precisely the `W`-axis-collapse hypothesis `_hf` that
`hom_additive_decomp_of_rigidity` (Cor 1.5) consumes when applied with `V = ℙ¹` proper,
`W = 𝔾_m`, base points `0 ∈ ℙ¹`, `1 ∈ 𝔾_m`.

Scaffold body — iter-165 lands the *statement* (matching the rigidity consumer's `_hf`
shape); the proof body is iter-166's lane (it reduces to a chart-level computation: on
`𝔸¹ × 𝔾_m`, `(0, λ) ↦ λ·0 = 0` is a defequal ring-map check). -/
lemma gmScalingP1_collapse_at_zero (kbar : Type u) [Field kbar] :
    lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) ≫
        gmScalingP1 kbar =
      toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar := by
  sorry

/-! ### (E) Product-stability instances on `ℙ¹ ⊗ 𝔾_m`

These four instances are exported for Lane B's consumer `morphism_P1_to_grpScheme_const_aux`
(in `AbelianVarietyRigidity.lean`), so its previously local `haveI ... := by sorry`
ad-hoc scaffolds collapse to `inferInstance`. Each instance is justified as follows:

* `(ℙ¹ ⊗ 𝔾_m).hom` is locally of finite type — by composition with `pullback.fst`
  (`LocallyOfFiniteType` is `IsStableUnderComposition` and `IsStableUnderBaseChange`,
  with both factors LOFT).
* `(ℙ¹ ⊗ 𝔾_m).hom` is geometrically irreducible — scaffold (Mathlib gap: `GeometricallyIrreducible`
  on `Gm.hom` needs the alg-closed-base reduction, currently not bridged).
* `(ℙ¹ ⊗ 𝔾_m).left` is reduced — scaffold (Mathlib gap: `Smooth → GeometricallyReduced`
  not shipped at scheme level).
* `ℙ¹` is reduced — scaffold (Mathlib gap: `IsReduced (Proj 𝒜)` for a domain graded ring
  is not shipped; would close via `IsReduced.of_openCover` over `Proj.affineOpenCover` once
  `HomogeneousLocalization.Away`'s domain property is bridged).
* `Gm.hom` is geometrically irreducible — scaffold (Mathlib gap: see above). -/

/-- **`(ℙ¹ ⊗ 𝔾_m).hom` is locally of finite type.** Decomposes as
`pullback.fst ≫ ProjectiveLineBar.hom`; `LocallyOfFiniteType` is stable under composition
and pullback (Mathlib's `locallyOfFiniteType_comp`,
`locallyOfFiniteType_isStableUnderBaseChange`). -/
instance projGm_locallyOfFiniteType (kbar : Type u) [Field kbar] :
    LocallyOfFiniteType ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom := by
  change LocallyOfFiniteType
    (pullback.fst (ProjectiveLineBar kbar).hom (Gm kbar).hom ≫ (ProjectiveLineBar kbar).hom)
  infer_instance

/-- **`ℙ¹` is reduced.** Project-side scaffold sorry (Mathlib does not ship `IsReduced (Proj 𝒜)`
for a domain graded ring; would close via `IsReduced.of_openCover` over `Proj.affineOpenCover`
once `HomogeneousLocalization.Away` is bridged to `IsDomain` for the standard ℕ-grading
on `MvPolynomial (Fin 2) k̄`). Exported here for Lane B (replaces its inline `haveI hP1red`).

The strategy:
1. `IsReduced.of_openCover` over `Proj.affineOpenCover (projectiveLineBarGrading kbar)`.
2. Each chart `Spec (HomogeneousLocalization.Away 𝒜 (X_i))` reduces to showing the ring is a
   domain.
3. `HomogeneousLocalization.Away 𝒜 X_i` for the standard ℕ-grading on `k̄[X_0, X_1]` is
   isomorphic to `k̄[X_{1-i}/X_i]` (polynomial ring in one variable over a field, a domain). -/
instance projectiveLineBar_isReduced (kbar : Type u) [Field kbar] :
    IsReduced (ProjectiveLineBar kbar).left := by
  change IsReduced (ProjectiveLineBarScheme kbar)
  -- Strategy: `IsReduced.of_openCover` over `projectiveLineBarAffineCover.openCover`.
  -- Each chart is `Spec(.of (Away 𝒜 (X i)))`; `IsReduced (Spec R)` if `R` is reduced.
  -- `Away 𝒜 (X i)` is a domain (and hence reduced) because it embeds via `val_injective`
  -- into `Localization.Away (X i)`, which is a localization of `MvPolynomial (Fin 2) kbar`
  -- (a domain) at a non-zero-divisor — hence a domain.
  haveI : ∀ i : Fin 2, IsReduced ((projectiveLineBarAffineCover kbar).openCover.X i) := by
    intro i
    -- (projectiveLineBarAffineCover kbar).openCover.X i = Spec (.of (Away 𝒜 (X i)))
    -- Need IsReduced of that Spec.
    change IsReduced (Spec (CommRingCat.of (HomogeneousLocalization.Away
        (projectiveLineBarGrading kbar) ((![MvPolynomial.X 0, MvPolynomial.X 1] :
          Fin 2 → MvPolynomial (Fin 2) kbar) i))))
    haveI : IsDomain (Localization.Away ((![(MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar),
        MvPolynomial.X 1] : Fin 2 → MvPolynomial (Fin 2) kbar) i)) := by
      fin_cases i <;>
        exact IsLocalization.isDomain_localization
          (powers_le_nonZeroDivisors_of_noZeroDivisors (MvPolynomial.X_ne_zero _))
    haveI : IsDomain (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        ((![(MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar), MvPolynomial.X 1] :
          Fin 2 → MvPolynomial (Fin 2) kbar) i)) := by
      refine Function.Injective.isDomain
        (algebraMap
          (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
            ((![(MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar), MvPolynomial.X 1] :
              Fin 2 → MvPolynomial (Fin 2) kbar) i))
          (Localization.Away
            ((![(MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar), MvPolynomial.X 1] :
              Fin 2 → MvPolynomial (Fin 2) kbar) i))) ?_
      intro x y h
      exact HomogeneousLocalization.val_injective _ h
    infer_instance
  exact IsReduced.of_openCover _ (projectiveLineBarAffineCover kbar).openCover

/-- **`𝔾_m` is geometrically irreducible over `Spec k̄`.** Scaffold (Mathlib gap: the
direct `GeometricallyIrreducible` consequence of `IrreducibleSpace + Spec(domain over alg
closed)` is not bridged; the analogist's recipe would require base-change reduction via
`IsAlgClosed`-fixed bridges that are absent at scheme level).

Exported here for Lane B and for the `projGm_geomIrred` derivation. -/
instance gm_geomIrred (kbar : Type u) [Field kbar] [IsAlgClosed kbar] :
    GeometricallyIrreducible (Gm kbar).hom := by
  sorry

/-- **`(ℙ¹ ⊗ 𝔾_m).hom` is geometrically irreducible.** Derives from the individual factors
via `GeometricallyIrreducible.comp` (with `UniversallyOpen` discharged for free by smoothness
of each factor). The `(X ⊗ Y).hom = pullback.fst ≫ X.hom` defeq unfolds, then
`GeometricallyIrreducible.comp` chains `pullback.fst`'s GI (by base-change stability of GI
from `gm_geomIrred`) with `projectiveLineBar_geomIrred`.

Exported here for Lane B (replaces its inline `haveI hProdGI`). Axiom-clean given the
individual GI scaffolds. -/
instance projGm_geomIrred (kbar : Type u) [Field kbar] [IsAlgClosed kbar] :
    GeometricallyIrreducible ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom := by
  change GeometricallyIrreducible
    (pullback.fst (ProjectiveLineBar kbar).hom (Gm kbar).hom ≫ (ProjectiveLineBar kbar).hom)
  exact GeometricallyIrreducible.comp _ _

/-- **`(ℙ¹ ⊗ 𝔾_m).left` is reduced.** Project-side scaffold sorry (Mathlib gap: the
`Smooth → GeometricallyReduced` bridge is missing at scheme level, so the standard
`isReduced_of_flat_of_isLocallyNoetherian` route is not directly applicable without
adding scheme-level infrastructure beyond an iter-167 lane's scope).

The chart-local alternative: cover `ProjectiveLineBar ⊗ Gm` by `Spec(k̄[t, λ, λ⁻¹])`
(a domain over k̄) using the product of `Proj.affineOpenCover` and the affine
`Gm = Spec k̄[t, t⁻¹]`. Each chart is a domain ⟹ reduced. Both rely on bridges currently
absent in Mathlib (`HomogeneousLocalization.Away`-is-domain plus
`tensor-of-domains-over-field-is-domain`).

Exported here for Lane B (replaces its inline `haveI hProdRed`). -/
instance projGm_isReduced (kbar : Type u) [Field kbar] :
    IsReduced ((ProjectiveLineBar kbar) ⊗ Gm kbar).left := by
  -- Strategy: chart-local IsReduced via Proj.affineOpenCover product, each chart a domain.
  -- Currently sorry: blocked by Mathlib gap on Smooth → GeometricallyReduced.
  sorry

end AlgebraicGeometry

end
