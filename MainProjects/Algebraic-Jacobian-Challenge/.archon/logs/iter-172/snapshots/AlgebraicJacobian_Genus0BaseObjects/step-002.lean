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

/-- `kbar`-algebra structure on `HomogeneousLocalization.Away 𝒜 f` via the
composition `kbar →+* ↥(𝒜 0) →+* Away 𝒜 f`. Mathlib only ships
`Algebra (𝒜 0) (HomogeneousLocalization 𝒜 x)`; this instance bridges the
remaining `kbar →+* 𝒜 0` algebra map shipped via `SetLike.GradeZero.instAlgebra`.
Required for `TensorProduct kbar (Away _ _) _` to synthesize `CommRing`/`Algebra kbar`. -/
noncomputable instance algebraKbarAway (kbar : Type u) [Field kbar]
    (f : MvPolynomial (Fin 2) kbar) :
    Algebra kbar
      (HomogeneousLocalization.Away (projectiveLineBarGrading kbar) f) :=
  Algebra.compHom _ (algebraMap kbar ((projectiveLineBarGrading kbar) 0))

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
    have : ∀ q : MvPolynomial (Fin 2) kbar,
        q ∈ Algebra.adjoin ↥(projectiveLineBarGrading kbar 0) (Set.range v) := by
      intro q
      induction q using MvPolynomial.induction_on with
      | C r =>
        have h : (algebraMap ↥(projectiveLineBarGrading kbar 0)
            (MvPolynomial (Fin 2) kbar))
            ⟨MvPolynomial.C r, MvPolynomial.isHomogeneous_C _ _⟩ = MvPolynomial.C r :=
          SetLike.GradeZero.algebraMap_apply _ _
        rw [← h]
        exact Subalgebra.algebraMap_mem _ _
      | add p q hp hq => exact add_mem hp hq
      | mul_X p j hp =>
        refine mul_mem hp (Algebra.subset_adjoin ⟨j, ?_⟩)
        fin_cases j <;> simp [v]
    exact this p
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
      have := hai
      simp only [smul_eq_mul, dv, Matrix.cons_val_zero, Matrix.cons_val_one,
        Matrix.head_cons, mul_one] at this
      exact this
    -- Compute the right-hand-side `.val`.
    rw [HomogeneousLocalization.Away.val_mk, _root_.map_pow]
    show _ = (HomogeneousLocalization.val (HomogeneousLocalization.Away.mk _ hfi 1
        (MvPolynomial.X (otherFin i) ^ 1) _))^(ai (otherFin i))
    rw [HomogeneousLocalization.Away.val_mk, Localization.mk_pow, pow_one]
    -- Now both sides are `Localization.mk`. Reduce via `mk_eq_mk_iff` + `r_iff_exists`.
    rw [Localization.mk_eq_mk_iff, Localization.r_iff_exists]
    refine ⟨1, ?_⟩
    simp only [OneMemClass.coe_one, one_mul, Submonoid.coe_pow]
    -- Goal: (∏ j, v j ^ ai j) * X i^(ai (otherFin i)) = X (otherFin i)^(ai (otherFin i)) * X i^a
    fin_cases i
    · simp only [otherFin_zero, Fin.prod_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one,
        Matrix.head_cons, v]
      ring_nf
      rw [show ai 0 + ai 1 = a from ha_eq]
    · simp only [otherFin_one, Fin.prod_univ_two, Matrix.cons_val_zero, Matrix.cons_val_one,
        Matrix.head_cons, v]
      ring_nf
      rw [show ai 1 + ai 0 = a by omega]
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
      ?mem ?algMap ?add ?mul hy_in
  · -- mem case
    rintro x ⟨a, ai, hai, hai_le, rfl⟩
    have hgen :=
      gen_eq_pow a ai hai hai_le (hai ▸ SetLike.prod_pow_mem_graded _ _ _ _ fun i _ ↦ hxd i)
    refine ⟨MvPolynomial.X ()^(ai (otherFin i)), ?_⟩
    rw [hgen, _root_.map_pow]
    congr 1
    show MvPolynomial.eval₂Hom _ _ (MvPolynomial.X ()) = _
    rw [MvPolynomial.eval₂Hom_X']
  · -- algebraMap case
    intro r
    -- r : ↥(𝒜 0). Find `r₀ ∈ kbar` with `algebraMap kbar (𝒜 0) r₀ = r`.
    obtain ⟨r₀, hr₀⟩ := hkbar_sur r
    refine ⟨MvPolynomial.C r₀, ?_⟩
    -- Goal: mvPolyToHomogeneousLocalizationAway kbar i (C r₀) = algebraMap (𝒜 0) Away r
    show MvPolynomial.eval₂Hom _ _ (MvPolynomial.C r₀) = _
    rw [MvPolynomial.eval₂Hom_C]
    show kbarToAwayRingHom kbar i r₀ = _
    simp only [kbarToAwayRingHom, RingHom.comp_apply]
    rw [hr₀]
    rfl
  · -- add case
    rintro x z _ _ ⟨px, hpx⟩ ⟨pz, hpz⟩
    exact ⟨px + pz, by rw [map_add, hpx, hpz]⟩
  · -- mul case
    rintro x z _ _ ⟨px, hpx⟩ ⟨pz, hpz⟩
    exact ⟨px * pz, by rw [map_mul, hpx, hpz]⟩

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

/-- **Chart-1 ring map for `σ_×`** at the `MvPolynomial Unit kbar`-level: sends the affine
coord `u = X 0 / X 1 ↦ u ⊗ λ`, where `λ = X () ∈ GmRing kbar`. Uses
`MvPolynomial.eval₂Hom` with the algebra-map `kbar →+* MvPolynomial Unit kbar ⊗[kbar] GmRing`
(target carrier carries `Algebra kbar` because both factors do). Axiom-clean. -/
noncomputable def gmScalingP1_chart1_ringMap (kbar : Type u) [Field kbar] :
    MvPolynomial Unit kbar →+* TensorProduct kbar (MvPolynomial Unit kbar) (GmRing kbar) :=
  MvPolynomial.eval₂Hom (algebraMap kbar _)
    (fun _ => (MvPolynomial.X () : MvPolynomial Unit kbar) ⊗ₜ[kbar]
      (algebraMap (MvPolynomial Unit kbar) (GmRing kbar) (MvPolynomial.X ())))

/-- **Chart-0 ring map for `σ_×`** at the `MvPolynomial Unit kbar`-level: sends the affine
coord `t = X 1 / X 0 ↦ t ⊗ λ⁻¹`. The `λ⁻¹` is `IsLocalization.Away.invSelf (X ())` in
`GmRing kbar = Localization.Away (X () : MvPolynomial Unit kbar)`. Axiom-clean. -/
noncomputable def gmScalingP1_chart0_ringMap (kbar : Type u) [Field kbar] :
    MvPolynomial Unit kbar →+* TensorProduct kbar (MvPolynomial Unit kbar) (GmRing kbar) :=
  MvPolynomial.eval₂Hom (algebraMap kbar _)
    (fun _ => (MvPolynomial.X () : MvPolynomial Unit kbar) ⊗ₜ[kbar]
      (IsLocalization.Away.invSelf
        (MvPolynomial.X () : MvPolynomial Unit kbar) :
        GmRing kbar))

/-- **The pullback open cover of `(ℙ¹ ⊗ 𝔾_m).left`** along `pullback.fst`, indexed by
the 2-chart cover `projectiveLineBarAffineCover` of `ProjectiveLineBar.left`. The `i`-th
component is `pullback (pullback.fst PLB.hom Gm.hom) (Proj.awayι 𝒜 (X i) …)`. -/
noncomputable def gmScalingP1_cover (kbar : Type u) [Field kbar] :
    ((ProjectiveLineBar kbar) ⊗ Gm kbar).left.OpenCover :=
  (projectiveLineBarAffineCover kbar).openCover.pullback₁
    (pullback.fst (ProjectiveLineBar kbar).hom (Gm kbar).hom)

/-- **The chart-`i` scheme morphism** `(gmScalingP1_cover kbar).X i ⟶ ProjectiveLineBarScheme`
defining `σ_×` on the `i`-th chart. On chart-1 (target `D₊(X 1)`), the affine coord
`u = X 0 / X 1` is sent to `u ⊗ λ`; on chart-0 (target `D₊(X 0)`), `t = X 1 / X 0` is sent
to `t ⊗ λ⁻¹`. The scheme map is built from `gmScalingP1_chart{0,1}_ringMap` (the chart-side
ring maps) via `pullbackSpecIso` + (the chart-ring iso
`HomogeneousLocalization.Away ≃+* MvPolynomial Unit kbar`) + `Proj.awayι`.

**Status:** body remains a typed `sorry`. The construction requires the chart-ring iso
`homogeneousLocalizationAwayIso`, whose `aux_left` round-trip is still `sorry` in this
file (deferred infrastructure not on the genus-0 critical path). Internal to
`gmScalingP1` skeleton — each chart morphism is a top-level named declaration. -/
noncomputable def gmScalingP1_chart (kbar : Type u) [Field kbar] (i : Fin 2) :
    (gmScalingP1_cover kbar).X i ⟶ ProjectiveLineBarScheme kbar :=
  sorry

/-- **Cocycle agreement for `gmScalingP1_chart`** on intersections of `(gmScalingP1_cover).f`.
The substantive `(0, 1)` / `(1, 0)` cross cases reduce on `D₊(X 0 · X 1)` to the ring-level
identity `λ·u = (1/t)·λ` in `Localization.Away t ⊗ GmRing` (where `t·u = 1`); the diagonal
`(0, 0)` / `(1, 1)` cases are trivial via `pullback.condition`.

**Status:** typed `sorry`, gated on `gmScalingP1_chart` having a concrete construction. -/
lemma gmScalingP1_chart_agreement (kbar : Type u) [Field kbar] :
    ∀ x y : (gmScalingP1_cover kbar).I₀,
      pullback.fst ((gmScalingP1_cover kbar).f x) ((gmScalingP1_cover kbar).f y) ≫
          gmScalingP1_chart kbar x =
        pullback.snd ((gmScalingP1_cover kbar).f x) ((gmScalingP1_cover kbar).f y) ≫
          gmScalingP1_chart kbar y :=
  sorry

/-- **The over-structure coherence for the glued scheme map.** Asserts that the glued
morphism `(gmScalingP1_cover).glueMorphisms gmScalingP1_chart … : (ℙ¹ ⊗ 𝔾_m).left ⟶ ℙ¹.left`
intertwines the structure maps to `Spec k̄`. Reduces to checking on each chart of the cover
(via `Scheme.Cover.hom_ext`) — on chart-`i`, both compositions land in `Spec k̄`, where
agreement is automatic from the way `gmScalingP1_chart i` is built (factoring through
`Spec.map (algebraMap kbar (Away 𝒜 (X i) ⊗ GmRing))`).

**Status:** typed `sorry`, gated on `gmScalingP1_chart` having a concrete construction. -/
lemma gmScalingP1_over_coherence (kbar : Type u) [Field kbar] :
    (gmScalingP1_cover kbar).glueMorphisms
        (gmScalingP1_chart kbar)
        (gmScalingP1_chart_agreement kbar) ≫
      (ProjectiveLineBar kbar).hom =
    ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom :=
  sorry

/-- **The `𝔾_m`-scaling action `σ_× : ℙ¹ × 𝔾_m ⟶ ℙ¹`** in `Over (Spec (.of kbar))`.

The morphism is the bare scheme map `(x, λ) ↦ λ·x` (Möbius scaling fixing `0` and `∞`).
Built via `Scheme.Cover.glueMorphisms` over the 2-chart cover `gmScalingP1_cover` (the
pullback of `projectiveLineBarAffineCover` along `pullback.fst`). The chart-`i` scheme
morphism `gmScalingP1_chart kbar i`, the cocycle agreement
`gmScalingP1_chart_agreement kbar`, and the over-side coherence
`gmScalingP1_over_coherence kbar` are top-level named declarations — body skeleton with
three internal `sorry`s, each at a named declaration (no buried sorries).

Consumed by `morphism_P1_to_grpScheme_const` (the `𝔾_m`-scaling shortcut: Cor 1.5 +
density of `𝔾_m ⊆ ℙ¹` + `ext_of_eqOnOpen`). The load-bearing fixed-point property
`σ_×(0, λ) = 0` is exposed by the companion `gmScalingP1_collapse_at_zero`. -/
noncomputable def gmScalingP1 (kbar : Type u) [Field kbar] :
    ProjectiveLineBar kbar ⊗ Gm kbar ⟶ ProjectiveLineBar kbar :=
  Over.homMk
    ((gmScalingP1_cover kbar).glueMorphisms
      (gmScalingP1_chart kbar)
      (gmScalingP1_chart_agreement kbar))
    (gmScalingP1_over_coherence kbar)

/-- **The load-bearing fixed-point property of `σ_×`:** at the scaling fixed point
`0 ∈ ℙ¹`, the morphism `σ_×(0, ·) : 𝔾_m → ℙ¹` is the constant morphism at `0`. That is,
the composite `(0 ≫ toUnit) × 𝟙 : 𝔾_m ⟶ ℙ¹ ⊗ 𝔾_m ⟶ ℙ¹` equals `toUnit ≫ 0`.

This is precisely the `W`-axis-collapse hypothesis `_hf` that
`hom_additive_decomp_of_rigidity` (Cor 1.5) consumes when applied with `V = ℙ¹` proper,
`W = 𝔾_m`, base points `0 ∈ ℙ¹`, `1 ∈ 𝔾_m`.

**Status:** typed `sorry`. Reduces (once `gmScalingP1_chart` is concrete) to the chart-1
ring-map computation: chart-1's ring map sends `u ↦ u ⊗ λ` and `zeroPt` factors through
chart-1 at `u = 0`, so the composite at the `Proj.fromOfGlobalSections` level evaluates to
`zeroPt` independently of `λ`. -/
lemma gmScalingP1_collapse_at_zero (kbar : Type u) [Field kbar] :
    lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) ≫
        gmScalingP1 kbar =
      toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar := by
  sorry

/-! ### (E) Product-stability instances on `ℙ¹ ⊗ 𝔾_m`

These instances are exported for Lane B's consumer `morphism_P1_to_grpScheme_const_aux`
(in `AbelianVarietyRigidity.lean`), so its previously local `haveI ... := by sorry`
ad-hoc scaffolds collapse to `inferInstance`. Each instance is justified as follows:

* `(ℙ¹ ⊗ 𝔾_m).hom` is locally of finite type — by composition with `pullback.fst`
  (`LocallyOfFiniteType` is `IsStableUnderComposition` and `IsStableUnderBaseChange`,
  with both factors LOFT).
* `ℙ¹` is reduced — **closed axiom-clean iter-168** via the chart-cover + `val_injective`
  bridge (`projectiveLineBar_isReduced`).
* `(ℙ¹ ⊗ 𝔾_m).hom` is geometrically irreducible — scaffold (Mathlib gap: `GeometricallyIrreducible`
  on `Gm.hom` needs the alg-closed-base reduction, currently not bridged).
* `(ℙ¹ ⊗ 𝔾_m).left` is reduced — scaffold (Mathlib gap: `Smooth → GeometricallyReduced`
  not shipped at scheme level).
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

/-- **`ℙ¹` is reduced.** Closed axiom-clean iter-168 via `IsReduced.of_openCover` over
`projectiveLineBarAffineCover`; each chart `Spec (HomogeneousLocalization.Away 𝒜 (X_i))`
is a domain because the canonical `val`-injection into `Localization.Away (X_i)` (a
localization of `k̄[X_0, X_1]` at a non-zero-divisor, hence a domain) factors through
`Function.Injective.isDomain`. Exported here for Lane B (replaces its inline `haveI hP1red`). -/
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
