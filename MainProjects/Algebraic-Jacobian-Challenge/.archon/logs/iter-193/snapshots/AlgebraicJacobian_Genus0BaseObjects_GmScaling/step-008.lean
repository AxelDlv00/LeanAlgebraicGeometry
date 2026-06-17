/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Genus0BaseObjects.BareScheme
import AlgebraicJacobian.Genus0BaseObjects.ChartIso
import AlgebraicJacobian.Genus0BaseObjects.Cross01Substrate
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

/-! ### Recipe 1 helpers (iter-184 Lane B, `analogies/gmscaling-projection-idiom.md`):
project-side simp helpers for `pullback.map ≫ pullback.fst/snd`.

Mathlib's `pullback.lift_fst` / `pullback.lift_snd` are `@[reassoc]` ONLY, not
`@[simp]`, so the abbrev `pullback.map _ _ _ _ i₁ i₂ i₃ _ _ ≫ pullback.fst _ _`
is not collapsed by `simp` even though the equation holds definitionally. These
two local simp lemmas unblock projection-chain collapse for
`gmScalingP1_cover_intersection_X_iso` whose STEP 4 uses
`asIso (pullback.map …)`. Candidate for upstream Mathlib contribution. -/

@[reassoc (attr := simp)]
lemma pullback_map_fst_proj {C : Type*} [Category C] {W X Y Z S T : C}
    (f₁ : W ⟶ S) (f₂ : X ⟶ S) [Limits.HasPullback f₁ f₂] (g₁ : Y ⟶ T)
    (g₂ : Z ⟶ T) [Limits.HasPullback g₁ g₂] (i₁ : W ⟶ Y) (i₂ : X ⟶ Z) (i₃ : S ⟶ T)
    (eq₁ : f₁ ≫ i₃ = i₁ ≫ g₁) (eq₂ : f₂ ≫ i₃ = i₂ ≫ g₂) :
    Limits.pullback.map f₁ f₂ g₁ g₂ i₁ i₂ i₃ eq₁ eq₂ ≫
        Limits.pullback.fst g₁ g₂ =
      Limits.pullback.fst f₁ f₂ ≫ i₁ :=
  Limits.pullback.lift_fst _ _ _

@[reassoc (attr := simp)]
lemma pullback_map_snd_proj {C : Type*} [Category C] {W X Y Z S T : C}
    (f₁ : W ⟶ S) (f₂ : X ⟶ S) [Limits.HasPullback f₁ f₂] (g₁ : Y ⟶ T)
    (g₂ : Z ⟶ T) [Limits.HasPullback g₁ g₂] (i₁ : W ⟶ Y) (i₂ : X ⟶ Z) (i₃ : S ⟶ T)
    (eq₁ : f₁ ≫ i₃ = i₁ ≫ g₁) (eq₂ : f₂ ≫ i₃ = i₂ ≫ g₂) :
    Limits.pullback.map f₁ f₂ g₁ g₂ i₁ i₂ i₃ eq₁ eq₂ ≫
        Limits.pullback.snd g₁ g₂ =
      Limits.pullback.snd f₁ f₂ ≫ i₂ :=
  Limits.pullback.lift_snd _ _ _

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

set_option backward.isDefEq.respectTransparency false in
/-- **Shared per-chart helper for `gmScalingP1`** (iter-174 Sub-task A per
`analogies/chart-bridge-shared-helper.md` Decision 3). On the `i`-th chart of the
`gmScalingP1_cover`, the composition `gmScalingP1_chart kbar i ≫ PLB.hom` agrees with
`(gmScalingP1_cover kbar).f i ≫ ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom`.

This is the per-chart certificate used by `gmScalingP1_over_coherence` (via
`Scheme.Cover.hom_ext` + `Scheme.Cover.ι_glueMorphisms_assoc`).

**Status (iter-180):** body retired axiom-clean via the empirically-verified
`set_option backward.isDefEq.respectTransparency false` recipe of
`analogies/pullbackspeciso-bypass.md` (Decision 4). The option collapses the
`Algebra.compHom`-driven heartbeat sink on the `pullbackSpecIso_hom_base` rewrite
that blocked iter-175 through iter-179. -/
private lemma gmScalingP1_chart_PLB_eq (kbar : Type u) [Field kbar] (i : Fin 2) :
    gmScalingP1_chart kbar i ≫ (ProjectiveLineBar kbar).hom =
      (gmScalingP1_cover kbar).f i ≫ ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom := by
  -- Stage 1 (iter-179): unfold the chart map, apply `awayι_comp_PLB_hom` after a
  -- type-realigning `change`, and collapse the right-hand `Spec.map` chain into
  -- `Spec.map (algMap kbar (Away_i ⊗ GmRing))` via
  -- `homogeneousLocalizationAwayIso_algebraMap` + `MvPolynomial.eval₂Hom_comp_C`.
  unfold gmScalingP1_chart
  have h := awayι_comp_PLB_hom kbar (m := 1) Nat.one_pos
    (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)
    (MvPolynomial.isHomogeneous_X kbar i)
  change (gmScalingP1_cover_X_iso kbar i).hom ≫ _ ≫
      ((Proj.awayι (projectiveLineBarGrading kbar)
          (MvPolynomial.X i : MvPolynomial (Fin 2) kbar)
          (MvPolynomial.isHomogeneous_X kbar i) Nat.one_pos :
        Spec (CommRingCat.of (HomogeneousLocalization.Away
          (projectiveLineBarGrading kbar) (MvPolynomial.X i))) ⟶
          Proj (projectiveLineBarGrading kbar)) ≫
        (ProjectiveLineBar kbar).hom) = _
  rw [h, ← Spec.map_comp, ← CommRingCat.ofHom_comp, RingHom.comp_assoc,
    homogeneousLocalizationAwayIso_algebraMap, MvPolynomial.algebraMap_eq,
    MvPolynomial.eval₂Hom_comp_C]
  -- Stage 2 (iter-180 fix): the `respectTransparency` option lets the
  -- `pullbackSpecIso_hom_base` simp lemma fire on the buried iso chain;
  -- it produces `pullback.fst _ _ ≫ Spec.map (algMap kbar Away_i)` in place
  -- of `(pullbackSpecIso).hom ≫ Spec.map (algMap kbar (Away_i ⊗ GmRing))`.
  -- The follow-up simps collapse the `pullback.congrHom`-wrapped map into a
  -- bare `pullback.fst (cover.f i ≫ PLB.hom) Gm.hom`.
  unfold gmScalingP1_cover_X_iso
  simp only [Iso.trans_hom, Category.assoc, pullbackSpecIso_hom_base,
    pullback.congrHom_hom, pullback.lift_fst_assoc, Category.id_comp]
  -- Stage 3: re-align `Proj.awayι (![X 0, X 1] i) ⋯ ⋯` with `(cover.openCover.f i)`
  -- so `pullbackRightPullbackFstIso_hom_fst_assoc` can match its `f' ≫ f` pattern.
  change (pullbackSymmetry (pullback.fst (ProjectiveLineBar kbar).hom (Gm kbar).hom)
        ((projectiveLineBarAffineCover kbar).openCover.f i)).hom ≫
      (pullbackRightPullbackFstIso (ProjectiveLineBar kbar).hom (Gm kbar).hom
          ((projectiveLineBarAffineCover kbar).openCover.f i)).hom ≫
        pullback.fst
            ((projectiveLineBarAffineCover kbar).openCover.f i ≫
              (ProjectiveLineBar kbar).hom)
            (Gm kbar).hom ≫
          Spec.map (CommRingCat.ofHom (algebraMap kbar
            (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
              ((![(MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar), MvPolynomial.X 1] :
                Fin 2 → MvPolynomial (Fin 2) kbar) i)))) =
        (gmScalingP1_cover kbar).f i ≫ ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom
  simp only [pullbackRightPullbackFstIso_hom_fst_assoc,
    pullbackSymmetry_hom_comp_fst_assoc]
  -- Stage 4: reverse the chart bridge back to `cover.f i ≫ PLB.hom` so the residual
  -- matches `(PLB ⊗ Gm).hom`'s definitional form.
  rw [← awayι_comp_PLB_hom kbar (projectiveLineBarAffineCover_hm i)
    ((![(MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar), MvPolynomial.X 1] :
      Fin 2 → MvPolynomial (Fin 2) kbar) i)
    (projectiveLineBarAffineCover_fDeg kbar i)]
  -- Stage 5: expose `(PLB ⊗ Gm).hom = pullback.fst PLB.hom Gm.hom ≫ PLB.hom`
  -- and `(gmScalingP1_cover).f i = pullback.fst (pullback.fst PLB.hom Gm.hom)
  -- ((cover).openCover.f i)`, then close via `pullback.condition_assoc`.
  change pullback.snd (pullback.fst (ProjectiveLineBar kbar).hom (Gm kbar).hom)
        ((projectiveLineBarAffineCover kbar).openCover.f i) ≫
      (projectiveLineBarAffineCover kbar).openCover.f i ≫
        (ProjectiveLineBar kbar).hom =
    pullback.fst (pullback.fst (ProjectiveLineBar kbar).hom (Gm kbar).hom)
        ((projectiveLineBarAffineCover kbar).openCover.f i) ≫
      pullback.fst (ProjectiveLineBar kbar).hom (Gm kbar).hom ≫
        (ProjectiveLineBar kbar).hom
  rw [← pullback.condition_assoc]

/-- **Intersection-cover X iso** (iter-182 Lane B helper per
`analogies/intersection-ring-cross01.md` Decision 3 Recipe 1).

Identifies the pullback over the cross chart `(cover.f 0) ⨯ (cover.f 1)` with
`Spec ((Away 𝒜 (X 0 * X 1)) ⊗[kbar] GmRing)`, mirroring `gmScalingP1_cover_X_iso`
with the merged generator `X 0 * X 1` of degree 2.

The body is a chain of iso steps:
1. `pullbackRightPullbackFstIso q awayι_1 (cover.f 0)`: paste the outer pullback
   into a left-side composition `pullback (cover.f 0 ≫ q) awayι_1`.
2. `pullback.congrHom pullback.condition rfl`: rewrite `cover.f 0 ≫ q` as
   `pullback.snd q awayι_0 ≫ awayι_0`.
3. `(pullbackRightPullbackFstIso awayι_0 awayι_1 (pullback.snd q awayι_0)).symm`:
   bring the outer pullback into `pullback (pullback.snd q awayι_0) (pullback.fst awayι_0 awayι_1)`.
4. `pullback.map` with `i₂ = (Proj.pullbackAwayιIso ...).hom`: replace the inner
   pullback `pullback awayι_0 awayι_1 ≅ Spec (Away (X 0 * X 1))` (via
   `Proj.pullbackAwayιIso`), with the new "fst" being
   `Spec.map (awayMap (X 1 hom) rfl)` (via `pullbackAwayιIso_hom_SpecMap_awayMap_left`).
5. `pullbackLeftPullbackSndIso q awayι_0 (Spec.map (awayMap _ _))`: collapse the
   outer pullback to `pullback q (Spec.map (awayMap _ _) ≫ awayι_0)`.
6. `pullback.congrHom rfl (Proj.SpecMap_awayMap_awayι ...)`: identify
   `Spec.map (awayMap _ _) ≫ awayι_0 = awayι_(X_0 * X_1)`.
7. Apply the standard recipe (mirror of `gmScalingP1_cover_X_iso`) at the merged
   generator `X 0 * X 1` of degree 2: `pullbackSymmetry`, `pullbackRightPullbackFstIso`,
   `awayι_comp_PLB_hom` (m = 2), `pullbackSpecIso`. -/
private noncomputable def gmScalingP1_cover_intersection_X_iso
    (kbar : Type u) [Field kbar] :
    pullback ((gmScalingP1_cover kbar).f (0 : Fin 2))
        ((gmScalingP1_cover kbar).f (1 : Fin 2)) ≅
      Spec (CommRingCat.of
        (TensorProduct kbar
          (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
            ((MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar) * MvPolynomial.X 1))
          (GmRing kbar))) :=
  -- **iter-186 Lane B path (III.a): refactor to term-mode `Iso.trans`-spine**.
  -- This single-chain term-mode definition exposes the iso's `≪≫`-spine
  -- syntactically so the Mathlib `Iso.trans_inv`-based simp chain can unfold
  -- it link-by-link. Functionally equivalent to the prior tactic-mode form
  -- (`refine ≪≫ ?_; refine ≪≫ ?_; ...`); only the elaboration shape changes.
  pullbackRightPullbackFstIso _ _ _ ≪≫
    pullback.congrHom pullback.condition rfl ≪≫
    (pullbackRightPullbackFstIso _ _ _).symm ≪≫
    asIso (pullback.map _ _ _ _ (𝟙 _)
      (Proj.pullbackAwayιIso (projectiveLineBarGrading kbar)
        (projectiveLineBarAffineCover_fDeg kbar 0)
        (projectiveLineBarAffineCover_hm 0)
        (projectiveLineBarAffineCover_fDeg kbar 1)
        (projectiveLineBarAffineCover_hm 1)
        rfl).hom (𝟙 _)
      (by rw [Category.comp_id, Category.id_comp])
      (by
        rw [Category.comp_id]
        exact (Proj.pullbackAwayιIso_hom_SpecMap_awayMap_left
          (projectiveLineBarGrading kbar) _ _ _ _ _).symm)) ≪≫
    pullbackLeftPullbackSndIso _ _ _ ≪≫
    pullback.congrHom rfl
      (Proj.SpecMap_awayMap_awayι (projectiveLineBarGrading kbar)
        (projectiveLineBarAffineCover_fDeg kbar 0)
        (projectiveLineBarAffineCover_hm 0)
        (projectiveLineBarAffineCover_fDeg kbar 1) rfl) ≪≫
    pullbackSymmetry _ _ ≪≫
    pullbackRightPullbackFstIso _ _ _ ≪≫
    pullback.congrHom
      (awayι_comp_PLB_hom kbar (m := 2) (by norm_num)
        ((MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar) * MvPolynomial.X 1)
        ((MvPolynomial.isHomogeneous_X kbar 0).mul (MvPolynomial.isHomogeneous_X kbar 1)))
      (show (Gm kbar).hom =
        Spec.map (CommRingCat.ofHom (algebraMap kbar (GmRing kbar))) from rfl) ≪≫
    pullbackSpecIso kbar _ (GmRing kbar)

/-- **The substantive `(0, 1)` cross case of `gmScalingP1_chart_agreement`** (iter-181
Lane B helper).

This is the *single* non-trivial ring-level identity for the cocycle:

`pullback.fst ((cover).f 0) ((cover).f 1) ≫ chart 0 =
   pullback.snd ((cover).f 0) ((cover).f 1) ≫ chart 1`.

On the basic-open intersection `D₊(X 0 · X 1) ⊆ ProjectiveLineBarScheme` both chart
coordinates are units (chart-0 coord `t = X 1 / X 0`, chart-1 coord `u = X 0 / X 1`,
with `t · u = 1`). Under `σ_×([X 0 : X 1], λ) = [λ · X 0 : X 1]` the two chart maps
satisfy on the intersection:

* chart-0: `t ↦ t ⊗ λ⁻¹` (i.e. `t/λ`)
* chart-1: `u ↦ u ⊗ λ` (i.e. `λ · u`)

Substituting `u = 1/t` on the chart-1 side gives `λ · u = λ · (1/t) = λ/t`, and on the
chart-0 side `t/λ` corresponds to `u' = 1/(t/λ) = λ/t` under the `u ↔ 1/t` change of
coords. Hence the ring-level identity is `λ · u = (1/t) · λ` in
`Localization.Away t ⊗[kbar] GmRing kbar`, which after multiplying both sides by `t`
reduces to `λ · u · t = λ`, true because `u · t = 1`.

**Status (iter-182 Lane B):** **structural advance** — the intersection iso
`gmScalingP1_cover_intersection_X_iso` is now built axiom-clean using
Mathlib's `Proj.pullbackAwayιIso` (per `analogies/intersection-ring-cross01.md`
Decision 2). Both sides of the cocycle factor through `awayι_(X 0 * X 1)` once
we cancel-epi the iso's inverse; the residual is the ring-level identity above.

The `cancel_epi` step lifts the goal from `pullback ((cover).f 0) ((cover).f 1) ⟶ Proj 𝒜`
to `Spec ((Away X_0X_1) ⊗ GmRing) ⟶ Proj 𝒜`. The fully-unfolded form (after
`simp only [gmScalingP1_cover_intersection_X_iso, Iso.trans_inv, ...]`) is a chain
of 7 iso `.inv` compositions; reducing it to a `Spec.map` of a single ring map
into `awayι_(X 0 * X 1)` requires either (a) `@[simps]` annotation on the iso, or
(b) explicit projection lemmas for each stage. Both are out of iter-182 helper
budget (helper budget = 2 used on the intersection iso + this lemma).

iter-183 outcome: the cocycle proof was attempted via the iter-182 task_result
Recipe 2 (project both sides through the intersection iso
`iso = gmScalingP1_cover_intersection_X_iso` via `cancel_epi iso.inv`, then
collapse each projection through `Proj.pullbackAwayιIso_inv_fst/_snd` +
`Proj.SpecMap_awayMap_awayι` to a shared factorisation through
`Proj.awayι (X_0 · X_1)`). The empirical reality is that
the iso unfolds to an 800-line `Iso.trans_inv`-chained form whose component
`.inv` projections (`pullbackRightPullbackFstIso_inv_fst`, `pullback.congrHom_inv`
+ `pullback.map_fst`, `inv (pullback.map ... pullbackAwayιIso.hom ...)`, etc.)
do NOT fire via simp because of `Iso.trans` decoration and the `asIso`-wrapped
`pullback.map` step. Two failure modes recorded for iter-184+:

1. **No `pullback.map_fst` lemma in Mathlib**: the natural simp lemma name
   `CategoryTheory.Limits.pullback.map_fst` does not resolve. The closest
   `pullback.lift_fst` requires un-`asIso`ing the `pullback.map` first.
2. **`Iso.trans` opacity**: `Iso.trans_inv` rewrites to `(b ≪≫ a).inv = a.inv ≫ b.inv`,
   but each intermediate `b.inv` is itself a `≪≫`-chain whose `.inv` rewrites
   re-introduce `Iso.trans` opacity at the next stage.

The structural lift via `cancel_epi` is recorded; the substantive content
remains as a single direct sorry. iter-184 escalation per progress-critic
finding: the Mathlib-idiom consult should target `pullback.map_fst`'s
canonical name + the `asIso (pullback.map ...)`-unwrap idiom. -/
private lemma gmScalingP1_chart_agreement_cross01
    (kbar : Type u) [Field kbar] [IsAlgClosed kbar] :
    pullback.fst ((gmScalingP1_cover kbar).f (0 : Fin 2))
        ((gmScalingP1_cover kbar).f (1 : Fin 2)) ≫
      gmScalingP1_chart kbar (0 : Fin 2) =
    pullback.snd ((gmScalingP1_cover kbar).f (0 : Fin 2))
        ((gmScalingP1_cover kbar).f (1 : Fin 2)) ≫
      gmScalingP1_chart kbar (1 : Fin 2) := by
  -- ===================================================================
  -- iter-188 Lane B (III.c) **separated-locus structural setup** (HARD BAR)
  -- per chapters/AbelianVarietyRigidity.tex Section III.c MANDATORY PIVOT.
  --
  -- This proof replaces the iter-181→187 `cancel_epi (iso.inv)` + simp chain
  -- (paths III.a, III.b — permanently BLOCKED on Mathlib simp-coverage gaps
  -- around `Iso.trans_inv` of tactic-mode `≪≫`-spines) with the structural
  -- separated-locus setup from the blueprint's (III.c) recipe. The setup is
  -- axiom-clean through the closed-immersion identification of the diagonal;
  -- the substantive residual is the factorization of the pair-morphism
  -- through the diagonal, which the blueprint cites
  -- `IsClosedImmersion.lift_iff_range_subset` for — a Mathlib substrate
  -- that, on iter-188 verification (`lean_leansearch` 2026-05-25), is NOT
  -- shipped at commit b80f227.
  -- ===================================================================
  --
  -- Step 1: Both chart maps, post-composed with PLB.hom, agree on the
  -- intersection — via per-chart bridge `gmScalingP1_chart_PLB_eq` (axiom-clean
  -- iter-180) plus `pullback.condition` on the cover.
  have hPLB_agree :
      pullback.fst ((gmScalingP1_cover kbar).f (0 : Fin 2))
            ((gmScalingP1_cover kbar).f (1 : Fin 2)) ≫
          gmScalingP1_chart kbar (0 : Fin 2) ≫ (ProjectiveLineBar kbar).hom =
        pullback.snd ((gmScalingP1_cover kbar).f (0 : Fin 2))
            ((gmScalingP1_cover kbar).f (1 : Fin 2)) ≫
          gmScalingP1_chart kbar (1 : Fin 2) ≫ (ProjectiveLineBar kbar).hom := by
    rw [gmScalingP1_chart_PLB_eq kbar (0 : Fin 2),
      gmScalingP1_chart_PLB_eq kbar (1 : Fin 2),
      ← Category.assoc, ← Category.assoc, pullback.condition]
  -- Step 2: PLB.hom is separated (`ProjectiveLineBar` is proper hence separated).
  haveI hsep : IsSeparated (ProjectiveLineBar kbar).hom := inferInstance
  -- Step 3: The diagonal `Δ := pullback.diagonal PLB.hom : PLB → PLB ×_{Spec kbar} PLB`
  -- is a closed immersion (Mathlib `IsSeparated.isClosedImmersion_diagonal`,
  -- Stacks 01KU realisation for the Proj case).
  haveI hΔ : IsClosedImmersion (pullback.diagonal (ProjectiveLineBar kbar).hom) :=
    IsSeparated.isClosedImmersion_diagonal
  -- Step 4: Build the pair morphism `s_pair : intersection → PLB ×_{Spec kbar} PLB`
  -- via `pullback.lift`, using `hPLB_agree` as the universal-property compatibility
  -- witness. Axiom-clean: the body is the universal property of the codomain
  -- pullback.
  let s_pair :
      pullback ((gmScalingP1_cover kbar).f (0 : Fin 2))
          ((gmScalingP1_cover kbar).f (1 : Fin 2)) ⟶
        pullback (ProjectiveLineBar kbar).hom (ProjectiveLineBar kbar).hom :=
    pullback.lift
      (pullback.fst ((gmScalingP1_cover kbar).f (0 : Fin 2))
          ((gmScalingP1_cover kbar).f (1 : Fin 2)) ≫
        gmScalingP1_chart kbar (0 : Fin 2))
      (pullback.snd ((gmScalingP1_cover kbar).f (0 : Fin 2))
          ((gmScalingP1_cover kbar).f (1 : Fin 2)) ≫
        gmScalingP1_chart kbar (1 : Fin 2))
      (by rw [Category.assoc, Category.assoc]; exact hPLB_agree)
  -- Step 5: The pair morphism's defining projection identities are immediate
  -- from `pullback.lift_fst` / `pullback.lift_snd`. These are NOT used to close
  -- the goal — they document the structural content of `s_pair` for the
  -- iter-189+ pickup. (Names are private-`have` so they don't pollute the
  -- top-level namespace.)
  have hs_fst : s_pair ≫ pullback.fst (ProjectiveLineBar kbar).hom
        (ProjectiveLineBar kbar).hom =
      pullback.fst ((gmScalingP1_cover kbar).f (0 : Fin 2))
          ((gmScalingP1_cover kbar).f (1 : Fin 2)) ≫
        gmScalingP1_chart kbar (0 : Fin 2) :=
    pullback.lift_fst _ _ _
  have hs_snd : s_pair ≫ pullback.snd (ProjectiveLineBar kbar).hom
        (ProjectiveLineBar kbar).hom =
      pullback.snd ((gmScalingP1_cover kbar).f (0 : Fin 2))
          ((gmScalingP1_cover kbar).f (1 : Fin 2)) ≫
        gmScalingP1_chart kbar (1 : Fin 2) :=
    pullback.lift_snd _ _ _
  -- Step 6: The cocycle (= original goal) is equivalent to: `s_pair` factors
  -- through `Δ` as `s_pair = s ≫ Δ` for some `s : intersection → PLB`. Indeed,
  -- if `s_pair = s ≫ Δ`, then by `pullback.diagonal_fst`/`_snd` (both = 𝟙):
  --     pullback.fst ≫ chart 0 = s_pair ≫ pullback.fst PLB PLB
  --                            = s ≫ Δ ≫ pullback.fst PLB PLB = s ≫ 𝟙 = s
  --     pullback.snd ≫ chart 1 = s_pair ≫ pullback.snd PLB PLB
  --                            = s ≫ Δ ≫ pullback.snd PLB PLB = s ≫ 𝟙 = s
  -- so both equal `s`.
  --
  -- Step 7 (the SUBSTANTIVE GAP): To produce the section `s`, the blueprint
  -- cites `IsClosedImmersion.lift_iff_range_subset` (`AbelianVarietyRigidity.tex`
  -- III.c step 3): "a morphism factors through a closed immersion iff its
  -- set-theoretic image is contained in the image of the immersion".
  --
  -- **Empirical iter-188 verification (`lean_leansearch` 2026-05-25)**: this
  -- lemma is NOT in Mathlib at b80f227. The shipped `IsClosedImmersion.lift`
  -- (`Mathlib/AlgebraicGeometry/Morphisms/ClosedImmersion.lean:206`) requires
  -- the substantive ideal-sheaf condition `Δ.ker ≤ s_pair.ker`. Reducing this
  -- to the topological range-containment requires `IsReduced` on the
  -- intersection scheme — the same tensor-product-reducedness gap that blocks
  -- `gm_geomIrred` (L767) and `projGm_isReduced` (L799).
  --
  -- The intersection scheme is isomorphic to
  -- `Spec ((Away (X_0·X_1)) ⊗_kbar GmRing)` via
  -- `gmScalingP1_cover_intersection_X_iso`. Both factors are reduced (in fact
  -- domains: `Away (X_0·X_1)` via the iter-168 `projectiveLineBar_isReduced`
  -- chain; `GmRing` as a localisation of the polynomial ring). Over the
  -- algebraically-closed field `kbar` the tensor is reduced (and a domain),
  -- but Mathlib's `Algebra.IsGeometricallyReduced` bridge requires either
  -- `[IsAlgClosed kbar]` (not in this lemma's signature; would propagate to
  -- the whole `gmScalingP1_chart_agreement` chain) OR
  -- `Algebra.TensorProduct.isDomain_of_isAlgClosed_left`-style direct shim
  -- (not shipped at b80f227).
  --
  -- ===================================================================
  -- iter-188 outcome: structural setup landed; substantive content unchanged
  -- modulo Mathlib upstream of `IsClosedImmersion.lift_iff_range_subset`
  -- (+ tensor reducedness bridge) OR ~150-200 LOC project-side shim.
  --
  -- ESCALATION TO USER iter-189 per `iter/iter-188/objectives.md` Lane B
  -- HARD BAR ("Escalates to USER iter-189 if 0 sorry close"): the (III.c)
  -- substrate hooks claim in the blueprint (`IsClosedImmersion.lift_iff_range_subset`
  -- "present at b80f227") is FALSIFIED by the iter-188 verification. The
  -- mathematician must decide whether to (a) commit project-side substrate
  -- (~150-200 LOC: tensor reducedness + range-containment lift; estimated
  -- 3-5 iters), (b) wait for Mathlib upstream, or (c) accept (III.c) as the
  -- new permanent block alongside (III.a)+(III.b).
  -- ===================================================================
  -- The structural lift via `s_pair` + closed-immersion `Δ` is preserved so the
  -- iter-189+ pickup proceeds from a well-defined point — concretely, closing
  -- `chart_0_factors_through_Δ : ∃ s, s ≫ Δ = s_pair` would discharge cocycle
  -- via `cancel_mono Δ` on the post-composed forms.
  -- (`hs_fst`, `hs_snd`, `s_pair`, `hΔ`, `hsep`, `hPLB_agree` are silenced as
  -- `_` in the `have`-list so the lemma body uses them only as documentation;
  -- but Lean infers them as live, so they remain bound here.)
  -- ===================================================================
  -- iter-191 Lane B (III.c) **substrate plug-in** (HARD BAR progress):
  -- with Substrate 1 (`IsClosedImmersion.lift_iff_range_subset`) and Substrate 2
  -- (`gmRing_tensor_homogeneousAway_isDomain`) both landed in
  -- `Cross01Substrate.lean` (iter-189/-190), the cocycle proof can now be
  -- structured into 4 named pieces:
  --
  --   (i)   `IsReduced` of `intersection` — via Substrate 2 at degree-2
  --         generator `X_0 · X_1` + transport across
  --         `gmScalingP1_cover_intersection_X_iso` (axiom-clean below);
  --   (ii)  `QuasiCompact s_pair` — intersection is affine via the iso,
  --         so `CompactSpace intersection`; the codomain
  --         `pullback PLB.hom PLB.hom` is separated (PLB proper ⟹ separated
  --         ⟹ pullback inherits), so `QuasiSeparatedSpace`, and the
  --         `quasiCompact_of_compactSpace` instance applies;
  --   (iii) Topological range containment
  --         `Set.range s_pair.base ⊆ Set.range Δ.base` — closed-points
  --         + density (intersection is reduced + Jacobson over alg-closed kbar)
  --         + chart-coordinate ring-level check at `(x, λ)` kbar-rational
  --         points of `D₊(X_0 X_1) × Gm`; this is the **substantive residual**
  --         carried forward to iter-192+;
  --   (iv)  Extract `s : intersection → PLB` with `s ≫ Δ = s_pair` via
  --         Substrate 1; derive cocycle via `pullback.diagonal_fst/_snd`.
  -- ===================================================================
  --
  -- Step 7 (i): IsReduced of the intersection.
  -- Substrate 2 at degree-2 generator X_0 · X_1 gives IsDomain of the tensor.
  have hX01_ne : (MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar) * MvPolynomial.X 1 ≠ 0 :=
    mul_ne_zero (MvPolynomial.X_ne_zero _) (MvPolynomial.X_ne_zero _)
  have hX01_deg : ((MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar) * MvPolynomial.X 1) ∈
      projectiveLineBarGrading kbar 2 :=
    (MvPolynomial.isHomogeneous_X kbar 0).mul (MvPolynomial.isHomogeneous_X kbar 1)
  haveI hX01_dom : IsDomain (TensorProduct kbar
      (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        ((MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar) * MvPolynomial.X 1))
      (GmRing kbar)) :=
    AlgebraicGeometry.gmRing_tensor_homogeneousAway_isDomain kbar
      (by norm_num : (0 : ℕ) < 2) _ hX01_deg hX01_ne
  haveI hred_inter : IsReduced (pullback ((gmScalingP1_cover kbar).f (0 : Fin 2))
      ((gmScalingP1_cover kbar).f (1 : Fin 2))) := by
    exact isReduced_of_isOpenImmersion (gmScalingP1_cover_intersection_X_iso kbar).hom
  -- Step 7 (ii): QuasiCompact s_pair. The intersection is iso to an affine Spec
  -- via `gmScalingP1_cover_intersection_X_iso`, so `CompactSpace intersection` follows
  -- from the homeomorphism. The codomain `pullback PLB.hom PLB.hom` is separated
  -- (PLB proper ⟹ PLB.hom separated, base change ⟹ pullback fst separated, so the
  -- pullback scheme is separated, hence `QuasiSeparatedSpace`).
  haveI hSpec_compact : CompactSpace
      ↥(Spec (CommRingCat.of (TensorProduct kbar
        (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
          ((MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar) * MvPolynomial.X 1))
        (GmRing kbar)))) :=
    PrimeSpectrum.compactSpace
  haveI hcompact : CompactSpace
      (↥(Limits.pullback ((gmScalingP1_cover kbar).f (0 : Fin 2))
        ((gmScalingP1_cover kbar).f (1 : Fin 2)))) :=
    (gmScalingP1_cover_intersection_X_iso kbar).inv.homeomorph.compactSpace
  -- Step 7 (ii) cont'd: QuasiSeparatedSpace of the codomain
  -- `pullback PLB.hom PLB.hom`. From `IsSeparated PLB.hom` (PLB proper)
  -- we get `IsSeparated (pullback.fst PLB.hom PLB.hom)` (pullback of separated
  -- along itself is separated), hence `QuasiSeparated`. Since `PLB.left` is
  -- itself `QuasiSeparatedSpace` (PLB.hom is separated → quasi-separated, and
  -- `Spec kbar` is affine → quasi-separated space), we transport via
  -- `quasiSeparatedSpace_of_quasiSeparated` along the pullback.fst.
  haveI hPLB_QSS : QuasiSeparatedSpace (ProjectiveLineBar kbar).left := by
    haveI : QuasiSeparated (ProjectiveLineBar kbar).hom := inferInstance
    exact quasiSeparatedSpace_of_quasiSeparated (ProjectiveLineBar kbar).hom
  haveI hcodom_QSS : QuasiSeparatedSpace
      ↥(Limits.pullback (ProjectiveLineBar kbar).hom (ProjectiveLineBar kbar).hom) := by
    haveI : QuasiSeparated
        (pullback.fst (ProjectiveLineBar kbar).hom (ProjectiveLineBar kbar).hom) :=
      inferInstance
    exact quasiSeparatedSpace_of_quasiSeparated
      (pullback.fst (ProjectiveLineBar kbar).hom (ProjectiveLineBar kbar).hom)
  -- `QuasiCompact s_pair` now follows automatically: source CompactSpace +
  -- codomain QuasiSeparatedSpace ⟹ `quasiCompact_of_compactSpace`.
  haveI hs_pair_QC : QuasiCompact s_pair := quasiCompact_of_compactSpace s_pair
  -- Step 7 (iii) **residual**: topological range containment.
  -- The substantive residual is: at every point of the intersection scheme,
  -- the two chart maps land at the same point of PLB. Decomposed as a
  -- closed-points argument: the intersection is reduced (hred_inter), the
  -- diagonal's range is closed (closed immersion), and over the algebraically
  -- closed kbar the locally-of-finite-type intersection is Jacobson — so the
  -- closed points are dense. On a kbar-rational closed point (x, λ) ∈
  -- D₊(X_0·X_1) × 𝔾_m, both chart maps evaluate to the same kbar-point of
  -- ℙ¹: chart 0 sends (x, λ) ↦ [1 : λ⁻¹·t] = [1 : λ⁻¹·x⁻¹] (the chart-0
  -- representative of (λx) ∈ 𝔾_m ⊂ 𝔸¹), and chart 1 sends (x, λ) ↦ [λx : 1]
  -- = [λ·u⁻¹ : 1] (the chart-1 representative); both equal [λx : 1] in ℙ¹.
  -- The closed range `Set.range Δ.base` then swallows the dense closed-point
  -- subset of `Set.range s_pair.base`, and continuity + density yield full
  -- containment.
  have hrange : Set.range s_pair.base ⊆
      Set.range (pullback.diagonal (ProjectiveLineBar kbar).hom).base := by
    -- The substantive residual: closed-points computation + Jacobson density.
    -- Carried forward iter-194+ (~30-50 LOC chart-1 ring-map evaluation at
    -- kbar-rational points + ZariskiTopology Jacobson density argument).
    sorry
  -- Step 7 (iv): extract `s : intersection → PLB` with `s ≫ Δ = s_pair` via
  -- Substrate 1 (`IsClosedImmersion.lift_iff_range_subset` from
  -- `Cross01Substrate.lean`, iter-189 axiom-clean).
  haveI hPLB_red : IsReduced (ProjectiveLineBar kbar).left := inferInstance
  obtain ⟨s, hs⟩ :=
    (IsClosedImmersion.lift_iff_range_subset
      (pullback.diagonal (ProjectiveLineBar kbar).hom) s_pair).mpr hrange
  -- Step 7 (v): derive the cocycle from `s ≫ Δ = s_pair` via
  -- `pullback.diagonal_fst` / `pullback.diagonal_snd`. Both projections of `Δ`
  -- are 𝟙_{PLB}, so post-composition with the two pullback projections out of
  -- the codomain identifies `s` with both `pullback.fst (cover) ≫ chart 0`
  -- and `pullback.snd (cover) ≫ chart 1` — hence those are equal.
  have h_fst_eq :
      pullback.fst ((gmScalingP1_cover kbar).f (0 : Fin 2))
          ((gmScalingP1_cover kbar).f (1 : Fin 2)) ≫
        gmScalingP1_chart kbar (0 : Fin 2) = s := by
    have hcalc := congrArg
      (· ≫ pullback.fst (ProjectiveLineBar kbar).hom (ProjectiveLineBar kbar).hom) hs
    simp only at hcalc
    rw [Category.assoc, pullback.diagonal_fst, Category.comp_id] at hcalc
    rw [hcalc]; exact hs_fst.symm
  have h_snd_eq :
      pullback.snd ((gmScalingP1_cover kbar).f (0 : Fin 2))
          ((gmScalingP1_cover kbar).f (1 : Fin 2)) ≫
        gmScalingP1_chart kbar (1 : Fin 2) = s := by
    have hcalc := congrArg
      (· ≫ pullback.snd (ProjectiveLineBar kbar).hom (ProjectiveLineBar kbar).hom) hs
    simp only at hcalc
    rw [Category.assoc, pullback.diagonal_snd, Category.comp_id] at hcalc
    rw [hcalc]; exact hs_snd.symm
  rw [h_fst_eq, h_snd_eq]

/-- **Cocycle agreement for `gmScalingP1_chart`** on intersections of `(gmScalingP1_cover).f`.
The substantive `(0, 1)` / `(1, 0)` cross cases reduce on `D₊(X 0 · X 1)` to the ring-level
identity `λ·u = (1/t)·λ` in `Localization.Away t ⊗ GmRing` (where `t·u = 1`); the diagonal
`(0, 0)` / `(1, 1)` cases follow from `fst_eq_snd_of_mono_eq` (the cover's chart maps are
open immersions, hence monos).

**Status (iter-181):** diagonal cases `(0, 0)` and `(1, 1)` retired axiom-clean via
`fst_eq_snd_of_mono_eq`. The `(1, 0)` cross case derives axiom-clean from the
`(0, 1)` case via `pullbackSymmetry`. The substantive `(0, 1)` cross case
(`gmScalingP1_chart_agreement_cross01`, the iter-181 Lane B helper) remains a single
named honest sorry — the ring-level identity `λ · u = (1/t) · λ` in
`Localization.Away t ⊗[kbar] GmRing` requires the
`HomogeneousLocalization.Away.isLocalization_mul` bridge (iter-182+ work). -/
lemma gmScalingP1_chart_agreement (kbar : Type u) [Field kbar] [IsAlgClosed kbar] :
    ∀ x y : (gmScalingP1_cover kbar).I₀,
      pullback.fst ((gmScalingP1_cover kbar).f x) ((gmScalingP1_cover kbar).f y) ≫
          gmScalingP1_chart kbar x =
        pullback.snd ((gmScalingP1_cover kbar).f x) ((gmScalingP1_cover kbar).f y) ≫
          gmScalingP1_chart kbar y := by
  intro (x : Fin 2) (y : Fin 2)
  haveI : ∀ i, Mono ((gmScalingP1_cover kbar).f i) := by
    intro i
    change Mono (pullback.fst (pullback.fst (ProjectiveLineBar kbar).hom (Gm kbar).hom)
      ((projectiveLineBarAffineCover kbar).openCover.f i))
    haveI : Mono ((projectiveLineBarAffineCover kbar).openCover.f i) :=
      IsOpenImmersion.mono _
    infer_instance
  fin_cases x <;> fin_cases y
  · -- (0, 0) diagonal: `pullback.fst (f 0) (f 0) = pullback.snd (f 0) (f 0)`.
    rw [fst_eq_snd_of_mono_eq]
  · -- (0, 1) cross case: substantive ring-level identity
    -- `λ · u = (1/t) · λ` in `Localization.Away t ⊗[kbar] GmRing`.
    -- See `gmScalingP1_chart_agreement_cross01` for the iter-181+ honest sorry.
    exact gmScalingP1_chart_agreement_cross01 kbar
  · -- (1, 0) cross case: derives from `(0, 1)` via `pullbackSymmetry`. We pre-compose
    -- both sides with `(pullbackSymmetry _ _).hom` (an iso, hence epi) to land on the
    -- `(0, 1)` pullback, then rewrite via `pullbackSymmetry_hom_comp_{fst,snd}`.
    have h01 := gmScalingP1_chart_agreement_cross01 kbar
    -- Normalize the `fin_cases`-produced `⟨0, _⟩` / `⟨1, _⟩` to canonical `(0 : Fin 2)` /
    -- `(1 : Fin 2)` so the subsequent `pullbackSymmetry` lemmas match syntactically.
    simp only [Fin.isValue, Fin.zero_eta, Fin.mk_one]
    rw [← cancel_epi (pullbackSymmetry ((gmScalingP1_cover kbar).f (0 : Fin 2))
      ((gmScalingP1_cover kbar).f (1 : Fin 2))).hom,
      ← Category.assoc, ← Category.assoc,
      pullbackSymmetry_hom_comp_fst, pullbackSymmetry_hom_comp_snd, h01.symm]
  · -- (1, 1) diagonal: `pullback.fst (f 1) (f 1) = pullback.snd (f 1) (f 1)`.
    rw [fst_eq_snd_of_mono_eq]

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
lemma gmScalingP1_over_coherence (kbar : Type u) [Field kbar] [IsAlgClosed kbar] :
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
noncomputable def gmScalingP1 (kbar : Type u) [Field kbar] [IsAlgClosed kbar] :
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

**Status (iter-180):** axiom-laundering retired by deleting the temp axiom.
The substantive proof (Step 3 (3) of `analogies/gmscaling-cover-bridge.md`)
remains a single direct sorry: it requires unfolding `gmScalingP1` to its
`glueMorphisms` form, applying `Scheme.Cover.hom_ext` to reduce to a per-chart
identity, then computing the chart-1 ring map's action on `zeroPt`'s global
section. The chart-1 ring map is concrete (`gmScalingP1_chart1_ringMap`,
axiom-clean), but the bridge from `gmScalingP1`'s glued form to the chart-1
ring-map computation propagates a `pullback.lift _ _ _ ≫ glueMorphisms.f i`
chase against the `pointOfVec` factorization of `zeroPt`. -/
lemma gmScalingP1_collapse_at_zero (kbar : Type u) [Field kbar] [IsAlgClosed kbar] :
    lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) ≫
        gmScalingP1 kbar =
      toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar := by
  -- iter-185 Lane B (stretch): structural setup via `Over.OverMorphism.ext` lifts the
  -- equation to its `.left` form on `Scheme`. The next planned step is
  -- `Cover.hom_ext` on `gmScalingP1_cover` to reduce to a per-chart identity, then
  -- compute the chart-1 ring map's action on `zeroPt`'s factor through `Spec.map
  -- (eval-at-zero)`. Helper budget = 0 for iter-185 means the section-construction
  -- recipe (`pullback.lift (toUnit ≫ r_1) (𝟙 Gm.left) ...` from
  -- `analogies/intersection-ring-cross01.md` Decision 4) cannot be packaged into a
  -- private lemma; iter-186+ pickup either inlines that recipe here (~30-50 LOC)
  -- or packages it as a named helper.
  apply Over.OverMorphism.ext
  simp only [Over.comp_left, Over.lift_left]
  -- Goal: `pullback.lift ((toUnit Gm).left ≫ zeroPt.left) ((𝟙 Gm).left) _ ≫
  --        gmScalingP1.left = (toUnit Gm).left ≫ zeroPt.left`.
  -- Chart-1 of `gmScalingP1_cover` is the relevant one because `zeroPt = [0:1]` lies
  -- in `D₊(X 1)`. Both sides equal the chart-1 map composed with a section
  -- `s : Gm.left ⟶ (cover).X 1` built from `Spec.map (eval-at-0)` and `𝟙 Gm.left`.
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

-- `projectiveLineBar_isReduced` was moved upward to before the
-- `gmScalingP1_chart_agreement_cross01` cocycle proof (iter-193 Lane B refactor)
-- so that the cocycle's reduction to range-containment via
-- `IsClosedImmersion.lift_iff_range_subset` can resolve the
-- `IsReduced (ProjectiveLineBar kbar).left` typeclass requirement.

/-- **Helper:** `TensorProduct kbar (MvPolynomial Unit kbar) K` is a domain for any field
`K` over `kbar`. This is the "geometrically irreducible affine line" tensor identity,
established directly from `MvPolynomial.algebraTensorAlgEquiv` (no `IsLocalization`
machinery needed). -/
private lemma isDomain_mvPolyUnit_tensor (kbar : Type u) [Field kbar]
    (K : Type u) [Field K] [Algebra kbar K] :
    IsDomain (TensorProduct kbar (MvPolynomial Unit kbar) K) := by
  haveI : IsDomain (MvPolynomial Unit K) := inferInstance
  -- Iso chain: TensorProduct kbar (MvPoly Unit kbar) K
  --   ≃ₐ[kbar] TensorProduct kbar K (MvPoly Unit kbar) (by Algebra.TensorProduct.comm)
  --   ≃ₐ[K]    MvPoly Unit K                          (by MvPolynomial.algebraTensorAlgEquiv)
  let e1 : TensorProduct kbar K (MvPolynomial Unit kbar) ≃+* MvPolynomial Unit K :=
    (MvPolynomial.algebraTensorAlgEquiv (σ := Unit) kbar K).toRingEquiv
  let e2 : TensorProduct kbar (MvPolynomial Unit kbar) K ≃+* TensorProduct kbar K (MvPolynomial Unit kbar) :=
    (Algebra.TensorProduct.comm kbar (MvPolynomial Unit kbar) K).toRingEquiv
  refine Function.Injective.isDomain (e1.toRingHom.comp e2.toRingHom) ?_
  exact e1.injective.comp e2.injective

/-- **`(𝔸¹ = Spec k̄[t]).hom` is geometrically irreducible over `Spec k̄`** as a scheme
morphism `Spec (k̄[t]) ⟶ Spec k̄`. For any field `K` with `Algebra kbar K`, the pullback
is `Spec (k̄[t] ⊗_k̄ K) ≅ Spec (K[t])`, which is irreducible because `K[t]` is a domain. -/
private lemma affineLine_geomIrred (kbar : Type u) [Field kbar] :
    GeometricallyIrreducible
      (Spec.map (CommRingCat.ofHom (algebraMap kbar (MvPolynomial Unit kbar)))) := by
  refine ⟨?_⟩
  rw [geometrically_iff_of_commRing_of_isClosedUnderIsomorphisms]
  intro K _ _
  haveI hdom : IsDomain (TensorProduct kbar (MvPolynomial Unit kbar) K) :=
    isDomain_mvPolyUnit_tensor kbar K
  -- `Spec` of a domain is irreducible.
  haveI hirr : IrreducibleSpace
      (Spec (CommRingCat.of (TensorProduct kbar (MvPolynomial Unit kbar) K))) := by
    change IrreducibleSpace
      (PrimeSpectrum (TensorProduct kbar (MvPolynomial Unit kbar) K))
    infer_instance
  -- Transport via `pullbackSpecIso`.
  -- The Iso (pullbackSpecIso ...).symm : Spec(...) ≅ pullback ... gives a homeomorphism
  -- from which IrreducibleSpace transfers.
  exact (pullbackSpecIso kbar (MvPolynomial Unit kbar) K).symm.hom.homeomorph.irreducibleSpace_iff.mp
    hirr

/-- **`𝔾_m` is geometrically irreducible over `Spec k̄`.** Iter-191 closure via the
basic-open / open-immersion route:

* `(Gm).hom = Spec.map (algebraMap kbar (GmRing kbar))` factors as
  `Spec.map (algebraMap (MvPoly Unit kbar) (GmRing kbar)) ≫ Spec.map (algebraMap kbar (MvPoly Unit kbar))`
  via `IsScalarTower.algebraMap_apply`.
* The first arrow is an open immersion (Mathlib instance
  `isOpenImmersion_SpecMap_localizationAway`: `Gm = D₊(t) ⊂ 𝔸¹`).
* The second arrow is `GeometricallyIrreducible` (`affineLine_geomIrred`).
* `Surjective` of the composition is immediate because the target `Spec k̄` is a single
  point and the source is nonempty.
* Conclude via the Mathlib instance
  `[IsOpenImmersion f] [GeometricallyIrreducible g] [Surjective (f ≫ g)] →
  GeometricallyIrreducible (f ≫ g)`.

Exported here for Lane B and for the `projGm_geomIrred` derivation. -/
instance gm_geomIrred (kbar : Type u) [Field kbar] [IsAlgClosed kbar] :
    GeometricallyIrreducible (Gm kbar).hom := by
  -- Rewrite (Gm).hom as a composition Gm ↪ 𝔸¹ → Spec k̄.
  haveI hg_irr : GeometricallyIrreducible
      (Spec.map (CommRingCat.ofHom (algebraMap kbar (MvPolynomial Unit kbar)))) :=
    affineLine_geomIrred kbar
  have hcomp : (Gm kbar).hom =
      Spec.map (CommRingCat.ofHom (algebraMap (MvPolynomial Unit kbar) (GmRing kbar))) ≫
      Spec.map (CommRingCat.ofHom (algebraMap kbar (MvPolynomial Unit kbar))) := by
    show Spec.map (CommRingCat.ofHom (algebraMap kbar (GmRing kbar))) = _
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
    congr 1
  rw [hcomp]
  -- Surjective: target Spec k̄ is subsingleton, source is nonempty.
  haveI hsurj : Surjective (Spec.map (CommRingCat.ofHom
        (algebraMap (MvPolynomial Unit kbar) (GmRing kbar))) ≫
      Spec.map (CommRingCat.ofHom (algebraMap kbar (MvPolynomial Unit kbar)))) := by
    constructor
    intro p
    obtain ⟨x⟩ : Nonempty (Spec (CommRingCat.of (GmRing kbar))) := inferInstance
    refine ⟨x, ?_⟩
    exact Subsingleton.elim _ _
  haveI := hg_irr
  haveI := hsurj
  -- Mathlib's open-immersion + GeometricallyIrreducible composition instance
  -- (`AlgebraicGeometry.Geometrically.Irreducible`-:131).
  set_option backward.isDefEq.respectTransparency false in
    exact inferInstance

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

/-- **`(ℙ¹ ⊗ 𝔾_m).left` is reduced.** Iter-191 closure via the chart-local
recipe of `analogies/lane-b-substrate.md` §3 Application 2:

* Cover `(PLB ⊗ Gm).left` by the existing `gmScalingP1_cover`; the chart-`i`
  source is `Spec ((Away 𝒜 (X i)) ⊗_kbar GmRing kbar)` via
  `gmScalingP1_cover_X_iso`.
* `(Away 𝒜 (X i)) ⊗_kbar GmRing kbar` is a domain by Substrate 2
  (`gmRing_tensor_homogeneousAway_isDomain` at the degree-1 generator
  `(![X 0, X 1] i)`).
* `IsDomain → IsReduced` on the carrier ring; `Spec` of a reduced ring is
  reduced; transport reducedness along `gmScalingP1_cover_X_iso.hom` (an
  iso, hence `IsOpenImmersion`) via `isReduced_of_isOpenImmersion`.
* Conclude `IsReduced ((PLB ⊗ Gm).left)` via `IsReduced.of_openCover`. -/
instance projGm_isReduced (kbar : Type u) [Field kbar] :
    IsReduced ((ProjectiveLineBar kbar) ⊗ Gm kbar).left := by
  haveI hchart : ∀ i : (gmScalingP1_cover kbar).I₀,
      IsReduced ((gmScalingP1_cover kbar).X i) := by
    intro (i : Fin 2)
    have hf_deg : ((![MvPolynomial.X 0, MvPolynomial.X 1] :
                    Fin 2 → MvPolynomial (Fin 2) kbar) i) ∈
          projectiveLineBarGrading kbar ((![1, 1] : Fin 2 → ℕ) i) :=
      projectiveLineBarAffineCover_fDeg kbar i
    have hm : 0 < (![1, 1] : Fin 2 → ℕ) i := projectiveLineBarAffineCover_hm i
    have hne : ((![MvPolynomial.X 0, MvPolynomial.X 1] :
                  Fin 2 → MvPolynomial (Fin 2) kbar) i) ≠ 0 := by
      fin_cases i <;> simp
    haveI hdom : IsDomain (TensorProduct kbar
        (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
          ((![MvPolynomial.X 0, MvPolynomial.X 1] :
            Fin 2 → MvPolynomial (Fin 2) kbar) i))
        (GmRing kbar)) :=
      AlgebraicGeometry.gmRing_tensor_homogeneousAway_isDomain kbar hm _ hf_deg hne
    exact isReduced_of_isOpenImmersion (gmScalingP1_cover_X_iso kbar i).hom
  exact IsReduced.of_openCover _ (gmScalingP1_cover kbar)

end AlgebraicGeometry

end
