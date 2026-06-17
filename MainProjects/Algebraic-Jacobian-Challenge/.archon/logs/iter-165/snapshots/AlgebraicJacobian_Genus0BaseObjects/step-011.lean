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
over its degree-`0` piece `↥(𝒜 0) ≃ k̄`. -/
instance projectiveLineBar_isProper (kbar : Type u) [Field kbar] :
    IsProper (ProjectiveLineBar kbar).hom := by
  -- `(ProjectiveLineBar kbar).hom = Proj.toSpecZero 𝒜 ≫ Spec.map (algebraMap …)`.
  -- `Proj.toSpecZero` is proper (Mathlib); composition with a Spec.map of a ring map of
  -- finite type rings remains proper since the algebra-map identifying ↥(𝒜 0) with k̄ is
  -- finite (it is an iso in the standard ℕ-grading case). Scaffold-allowed: needs
  -- `IsProper.comp` + finite-iso step; deferred to iter-166+.
  sorry

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

/-! ### The standard `k̄`-points `0`, `1`, `∞` on `ℙ¹`

The three distinguished `k̄`-points of `ℙ¹_{k̄}` are `[0 : 1]` (the affine origin), `[1 : 1]`
(the affine unit), and `[1 : 0]` (the point at infinity). They are encoded as morphisms
`𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar`. The construction follows
`Proj.awayι` (the affine charts) composed with the appropriate `Spec.map` of a ring
homomorphism corresponding to "evaluate at the chosen point".

These are scaffold definitions for iter-165; their use sites (in particular the proof of
`morphism_P1_to_grpScheme_const`) are iter-166's lane. -/

/-- The `k̄`-point `0 = [0 : 1] ∈ ℙ¹`. Scaffold: body is `sorry` pending the explicit
`Proj.awayι ≫ Spec.map` construction (iter-166+). -/
def ProjectiveLineBar.zeroPt (kbar : Type u) [Field kbar] :
    𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar :=
  sorry

/-- The `k̄`-point `1 = [1 : 1] ∈ ℙ¹`. Scaffold: body is `sorry` (iter-166+). -/
def ProjectiveLineBar.onePt (kbar : Type u) [Field kbar] :
    𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar :=
  sorry

/-- The `k̄`-point `∞ = [1 : 0] ∈ ℙ¹`. Scaffold: body is `sorry` (iter-166+). -/
def ProjectiveLineBar.inftyPt (kbar : Type u) [Field kbar] :
    𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar :=
  sorry

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

PARTIAL placeholder: the type signature is correct and the projects' downstream consumer
(`hom_additive_decomp_of_rigidity` with `W = Gm`, NOT `W = Ga` — `Ga` is on the demoted
route only) does not exercise this. -/
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

end AlgebraicGeometry

end
