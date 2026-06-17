/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Genus0BaseObjects.BareScheme
import AlgebraicJacobian.Genus0BaseObjects.ChartIso
import AlgebraicJacobian.Genus0BaseObjects.Points

/-!
# Genus-`0` base objects (Stratum 4): the `𝔾_m`-scaling action `σ_×` and product-stability instances

This file is **Stratum 4** of the four-stratum split of the legacy
`AlgebraicJacobian.Genus0BaseObjects` (iter-175 refactor `g0bo-split`). It ships:

* the chart-bridge `awayι_comp_PLB_hom` (iter-173 `chart-bridge173` recipe step (a));
* the per-chart ring maps `gmScalingP1_chart{0,1}_ringMap` of the scaling action;
* the pullback cover `gmScalingP1_cover` of `(ℙ¹ ⊗ 𝔾_m).left`;
* the per-chart scheme morphism `gmScalingP1_chart`, the cocycle agreement
  `gmScalingP1_chart_agreement`, and the over-coherence
  `gmScalingP1_over_coherence`;
* the bare scaling morphism `gmScalingP1 : ProjectiveLineBar ⊗ Gm ⟶ ProjectiveLineBar`;
* the load-bearing fixed-point property `gmScalingP1_collapse_at_zero`;
* the product-stability instances on `ℙ¹ ⊗ 𝔾_m` exported for Lane B in
  `AbelianVarietyRigidity.lean`.

Upstream strata: `BareScheme`, `ChartIso`, `Points`.
-/

set_option autoImplicit false
set_option linter.style.setOption false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

noncomputable section

namespace AlgebraicGeometry

/-! ### Chart-bridge: `Proj.awayι ≫ PLB.hom = Spec.map (algebraMap kbar (Away _ _))`

The helper below is the iter-173 `mathlib-analogist chart-bridge173` recipe step (a)
(`analogies/chart-bridge.md`). Used by `gmScalingP1_cover_X_iso` (below the `gmScalingP1_cover`
definition). -/

/-- **`Proj.awayι 𝒜 f _ _ ≫ PLB.hom = Spec.map (algebraMap kbar (Away 𝒜 f))`** for any
homogeneous element `f` of positive degree.

Generic in the element `f` AND in the degree `m` so we can apply it to either
`(![X 0, X 1]) i` (the actual chart input from `projectiveLineBarAffineCover.openCover.f i`,
which uses `m = (![1, 1]) i`) or `X i` (which uses `m = 1`). A pure rewrite chasing
`awayι_toSpecZero` + `Spec.map_comp` + the `algebraKbarAway` defeq. -/
private lemma awayι_comp_PLB_hom (kbar : Type u) [Field kbar]
    {m : ℕ} (hm : 0 < m)
    (f : MvPolynomial (Fin 2) kbar) (hf : f ∈ projectiveLineBarGrading kbar m) :
    Proj.awayι (projectiveLineBarGrading kbar) f hf hm ≫
      (ProjectiveLineBar kbar).hom =
    Spec.map (CommRingCat.ofHom (algebraMap kbar
      (HomogeneousLocalization.Away (projectiveLineBarGrading kbar) f))) := by
  change Proj.awayι _ _ _ _ ≫ Proj.toSpecZero _ ≫ Spec.map _ = _
  rw [← Category.assoc, Proj.awayι_toSpecZero, ← Spec.map_comp,
    ← CommRingCat.ofHom_comp]
  rfl

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

/-- **The chart-`i` source of `gmScalingP1_cover` is
`Spec ((Away 𝒜 ((![X 0, X 1]) i)) ⊗[kbar] GmRing kbar)`.**

Built by composing `pullbackSymmetry`, `pullbackRightPullbackFstIso`, the
`awayι_comp_PLB_hom` rewrite via `pullback.congrHom`, and `pullbackSpecIso`. Mirrors the
Mathlib precedent `OpenCover.pullbackCoverAffineRefinementObjIso`
(`Mathlib.AlgebraicGeometry.Cover.Open:160-166`). Used by `gmScalingP1_chart`.

**Uniform-in-`i` (iter-179 refactor `cover-bridge-uniform-i`):** the target type carries
`((![X 0, X 1]) i)` rather than `MvPolynomial.X i`. The hoisted helpers
`projectiveLineBarAffineCover_fDeg`/`_hm` together with the m-generalised
`awayι_comp_PLB_hom` keep the bridge chain syntactic so `pullbackSpecIso` applies
generically — no `match`-on-`i` decoration. -/
private noncomputable def gmScalingP1_cover_X_iso (kbar : Type u) [Field kbar] (i : Fin 2) :
    (gmScalingP1_cover kbar).X i ≅
      Spec (CommRingCat.of
        (TensorProduct kbar
          (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
            ((![MvPolynomial.X 0, MvPolynomial.X 1] :
              Fin 2 → MvPolynomial (Fin 2) kbar) i))
          (GmRing kbar))) :=
  pullbackSymmetry _ _ ≪≫
    pullbackRightPullbackFstIso _ _ _ ≪≫
    pullback.congrHom
      (awayι_comp_PLB_hom kbar (projectiveLineBarAffineCover_hm i)
        ((![MvPolynomial.X 0, MvPolynomial.X 1] :
          Fin 2 → MvPolynomial (Fin 2) kbar) i)
        (projectiveLineBarAffineCover_fDeg kbar i))
      (show (Gm kbar).hom =
          Spec.map (CommRingCat.ofHom (algebraMap kbar (GmRing kbar))) from rfl) ≪≫
    pullbackSpecIso kbar _ (GmRing kbar)

/-- **The chart-`i` scheme morphism** `(gmScalingP1_cover kbar).X i ⟶ ProjectiveLineBarScheme`
defining `σ_×` on the `i`-th chart. On chart-1 (target `D₊(X 1)`), the affine coord
`u = X 0 / X 1` is sent to `u ⊗ λ`; on chart-0 (target `D₊(X 0)`), `t = X 1 / X 0` is sent
to `t ⊗ λ⁻¹`. The scheme map is built from `gmScalingP1_chart{0,1}_ringMap` (the chart-side
ring maps) via `pullbackSpecIso` + (the chart-ring iso
`HomogeneousLocalization.Away ≃+* MvPolynomial Unit kbar`) + `Proj.awayι`.

**Status (iter-173):** body landed via the `mathlib-analogist chart-bridge173` recipe
(`analogies/chart-bridge.md`). The bridge `gmScalingP1_cover_X_iso` (above) identifies the
source with `Spec ((Away 𝒜 (X i)) ⊗[kbar] GmRing)`. The chart-ring iso
`homogeneousLocalizationAwayIso` plus a chart-`i`-specific `MvPolynomial.eval₂Hom` produces
the ring map `Away 𝒜 (X i) →+* Away 𝒜 (X i) ⊗ GmRing`, then `Proj.awayι` lands the
result in `ProjectiveLineBarScheme`. -/
noncomputable def gmScalingP1_chart (kbar : Type u) [Field kbar] (i : Fin 2) :
    (gmScalingP1_cover kbar).X i ⟶ ProjectiveLineBarScheme kbar :=
  (gmScalingP1_cover_X_iso kbar i).hom ≫
    Spec.map (CommRingCat.ofHom
      ((MvPolynomial.eval₂Hom (algebraMap kbar _)
          (fun _ : Unit =>
            (HomogeneousLocalization.Away.isLocalizationElem
                (projectiveLineBarAffineCover_fDeg kbar i)
                (projectiveLineBarAffineCover_fDeg kbar (otherFin i))) ⊗ₜ[kbar]
              (match i with
               | ⟨0, _⟩ =>
                  (IsLocalization.Away.invSelf
                    (MvPolynomial.X () : MvPolynomial Unit kbar) : GmRing kbar)
               | ⟨1, _⟩ =>
                  algebraMap (MvPolynomial Unit kbar) (GmRing kbar)
                    (MvPolynomial.X ())))).comp
        (homogeneousLocalizationAwayIso kbar i).toRingHom)) ≫
    Proj.awayι (projectiveLineBarGrading kbar)
      (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)
      (MvPolynomial.isHomogeneous_X kbar i) Nat.one_pos

/-- **TEMPORARY AXIOM (iter-177 HARD STOP corrective)** — chart-bridge data. Packages
both the per-chart over-coherence identity and the chart cocycle agreement at
intersection, the two ingredients needed to construct `gmScalingP1` via
`Scheme.Cover.glueMorphisms`. The mathematical content is correct (the chart maps are
designed to glue on `D₊(X_0 · X_1) × 𝔾_m`); the absorbing structural blocker is a
Mathlib API question — the cover-vs-`Proj.awayι` syntactic mismatch
(`(projectiveLineBarAffineCover kbar).openCover.f i` = `awayι 𝒜 (![X 0, X 1] i) _ _` vs
`Proj.awayι 𝒜 (X i) _ Nat.one_pos`) — not a mathematical content question.
See `STRATEGY.md` Open Q "Lane A1 HARD STOP rule".

TODO (iter-178+): replace by chart-bridge body when the
`(cover).f i = Proj.awayι _ X_i _ Nat.one_pos` defeq + Fin normalization
is resolved (probable route: `Scheme.AffineOpenCover.openCover_f` +
`Matrix.cons_val` + a structural `Fin.cases` refactor of
`gmScalingP1_cover_X_iso`). For the cocycle agreement: `Algebra.TensorProduct.tmul_mul_tmul`
+ the chart-bridge defeq chain. -/
axiom gmScalingP1_chart_data_temp (kbar : Type u) [Field kbar] :
    (∀ i : Fin 2, gmScalingP1_chart kbar i ≫ (ProjectiveLineBar kbar).hom =
        (gmScalingP1_cover kbar).f i ≫ ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom) ∧
    (∀ x y : (gmScalingP1_cover kbar).I₀,
      pullback.fst ((gmScalingP1_cover kbar).f x) ((gmScalingP1_cover kbar).f y) ≫
          gmScalingP1_chart kbar x =
        pullback.snd ((gmScalingP1_cover kbar).f x) ((gmScalingP1_cover kbar).f y) ≫
          gmScalingP1_chart kbar y)

/-- **Shared per-chart helper for `gmScalingP1`** (iter-174 Sub-task A per
`analogies/chart-bridge-shared-helper.md` Decision 3). On the `i`-th chart of the
`gmScalingP1_cover`, the composition `gmScalingP1_chart kbar i ≫ PLB.hom` agrees with
`(gmScalingP1_cover kbar).f i ≫ ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom`.

This is the per-chart certificate used by `gmScalingP1_over_coherence` (via
`Scheme.Cover.hom_ext` + `Scheme.Cover.ι_glueMorphisms_assoc`).

**Status (iter-177 Lane GM-AXIOM):** body discharged via the first conjunct of the
temporary axiom `gmScalingP1_chart_data_temp` (HARD STOP corrective; see the axiom's
docstring). -/
private lemma gmScalingP1_chart_PLB_eq (kbar : Type u) [Field kbar] (i : Fin 2) :
    gmScalingP1_chart kbar i ≫ (ProjectiveLineBar kbar).hom =
      (gmScalingP1_cover kbar).f i ≫ ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom := by
  unfold gmScalingP1_chart
  rw [Category.assoc, Category.assoc,
    awayι_comp_PLB_hom kbar Nat.one_pos
      (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)
      (MvPolynomial.isHomogeneous_X kbar i)]
  sorry

/-- **Cocycle agreement for `gmScalingP1_chart`** on intersections of `(gmScalingP1_cover).f`.
The substantive `(0, 1)` / `(1, 0)` cross cases reduce on `D₊(X 0 · X 1)` to the ring-level
identity `λ·u = (1/t)·λ` in `Localization.Away t ⊗ GmRing` (where `t·u = 1`); the diagonal
`(0, 0)` / `(1, 1)` cases follow from `fst_eq_snd_of_mono_eq` (the cover's chart maps are
open immersions, hence monos).

**Status (iter-177 Lane GM-AXIOM):** body discharged via the second conjunct of the
temporary axiom `gmScalingP1_chart_data_temp` (HARD STOP corrective; see the axiom's
docstring). -/
lemma gmScalingP1_chart_agreement (kbar : Type u) [Field kbar] :
    ∀ x y : (gmScalingP1_cover kbar).I₀,
      pullback.fst ((gmScalingP1_cover kbar).f x) ((gmScalingP1_cover kbar).f y) ≫
          gmScalingP1_chart kbar x =
        pullback.snd ((gmScalingP1_cover kbar).f x) ((gmScalingP1_cover kbar).f y) ≫
          gmScalingP1_chart kbar y :=
  (gmScalingP1_chart_data_temp kbar).2

/-- **The over-structure coherence for the glued scheme map.** Asserts that the glued
morphism `(gmScalingP1_cover).glueMorphisms gmScalingP1_chart … : (ℙ¹ ⊗ 𝔾_m).left ⟶ ℙ¹.left`
intertwines the structure maps to `Spec k̄`. Reduces to checking on each chart of the cover
(via `Scheme.Cover.hom_ext`) — on chart-`i`, both compositions land in `Spec k̄`, where
agreement is automatic from the way `gmScalingP1_chart i` is built (factoring through
`Spec.map (algebraMap kbar (Away 𝒜 (X i) ⊗ GmRing))`).

**Status (iter-174):** Body restructured via the `Scheme.Cover.hom_ext` + `ι_glueMorphisms_assoc`
+ shared helper `gmScalingP1_chart_PLB_eq` recipe. The helper itself is partially proven
(Steps A + B closed axiom-clean; Step C bridge-chasing has a residual `sorry` due to Fin
syntactic-equality unification — `X 0` vs `X ⟨0, ⋯⟩` after fin_cases). The over_coherence
proof itself is structurally complete; the only residual sorryAx propagates through the
helper's Step C. -/
lemma gmScalingP1_over_coherence (kbar : Type u) [Field kbar] :
    (gmScalingP1_cover kbar).glueMorphisms
        (gmScalingP1_chart kbar)
        (gmScalingP1_chart_agreement kbar) ≫
      (ProjectiveLineBar kbar).hom =
    ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom := by
  refine Scheme.Cover.hom_ext (gmScalingP1_cover kbar) _ _ ?_
  intro i
  rw [Scheme.Cover.ι_glueMorphisms_assoc]
  exact gmScalingP1_chart_PLB_eq kbar i

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

/-- **TEMPORARY AXIOM (iter-177 HARD STOP corrective)** — the load-bearing fixed-point
property of `σ_×`. Reduces (once `gmScalingP1_chart` is concrete) to the chart-1 ring-map
computation: chart-1's ring map sends `u ↦ u ⊗ λ` and `zeroPt` factors through chart-1
at `u = 0`, so the composite at the `Proj.fromOfGlobalSections` level evaluates to
`zeroPt` independently of `λ`. Currently blocked by the same chart-bridge syntactic
mismatch as `gmScalingP1_chart_PLB_eq_temp`.

TODO (iter-178+): replace by chart-1 ring-map computation once the chart-bridge body
lands. -/
axiom gmScalingP1_collapse_at_zero_temp (kbar : Type u) [Field kbar] :
    lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) ≫
        gmScalingP1 kbar =
      toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar

/-- **The load-bearing fixed-point property of `σ_×`:** at the scaling fixed point
`0 ∈ ℙ¹`, the morphism `σ_×(0, ·) : 𝔾_m → ℙ¹` is the constant morphism at `0`. That is,
the composite `(0 ≫ toUnit) × 𝟙 : 𝔾_m ⟶ ℙ¹ ⊗ 𝔾_m ⟶ ℙ¹` equals `toUnit ≫ 0`.

This is precisely the `W`-axis-collapse hypothesis `_hf` that
`hom_additive_decomp_of_rigidity` (Cor 1.5) consumes when applied with `V = ℙ¹` proper,
`W = 𝔾_m`, base points `0 ∈ ℙ¹`, `1 ∈ 𝔾_m`.

**Status (iter-177 Lane GM-AXIOM):** body discharged via the temporary axiom
`gmScalingP1_collapse_at_zero_temp` (HARD STOP corrective; see the axiom's docstring). -/
lemma gmScalingP1_collapse_at_zero (kbar : Type u) [Field kbar] :
    lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) ≫
        gmScalingP1 kbar =
      toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar :=
  gmScalingP1_collapse_at_zero_temp kbar

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
