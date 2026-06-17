/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Genus
import AlgebraicJacobian.Genus0BaseObjects
import AlgebraicJacobian.RigidityLemma

/-!
# Abelian-variety rigidity: genus-`0` final assembly

This file is the **genus-`0` final layer** of the project's committed characteristic-free
route (route (c)) to abelian-variety rigidity. It assembles the headline
`rigidity_genus0_curve_to_grpScheme` — the char-free replacement (no `[CharZero kbar]`) for
`AlgebraicGeometry.rigidity_over_kbar` of `AlgebraicJacobian.RigidityKbar` (which remains in
tree as the fallback route (a) artifact and still carries `[CharZero]`).

The abstract Mumford Rigidity Lemma chain (`rigidity_lemma`) and the two Milne §I.1 corollaries
(`hom_additive_decomp_of_rigidity` = Cor 1.5, `av_regularMap_isHom_of_zero` = Cor 1.2) it
implies live **upstream** in `AlgebraicJacobian.RigidityLemma`, which is imported here. That
chain is PROVEN axiom-clean (iters 157–162); this file consumes it.

The final assembly has three links specific to the genus-`0` route:

1. `morphism_P1_to_grpScheme_const` — every morphism `ℙ¹ → A` into an abelian variety is
   constant. Proved (route resolved iter-164) by the **𝔾ₘ-scaling shortcut**: the total scaling
   action `σ_× : ℙ¹ × 𝔾ₘ → ℙ¹`, `(x, λ) ↦ λx`, feeds the proven Cor 1.5
   (`hom_additive_decomp_of_rigidity`) — NO theorem of the cube, NO Milne Thm 3.2, NO
   `Hom(𝔾ₐ, A) = 0`, char-general. (Still a scaffold `sorry` pending the concrete ℙ¹/𝔾ₘ/σ_× infra.)
2. `genusZero_curve_iso_P1` — a smooth proper geom-irred genus-`0` curve over `k̄` is
   isomorphic to `ℙ¹` (blocked on Riemann–Roch).
3. `rigidity_genus0_curve_to_grpScheme` — THE HEADLINE consumed by `genusZeroWitness`.

The file also exposes the project-local bridge `iotaGm_isDominant` — the dominance of the
canonical `Gm ↪ ℙ¹` inclusion — which becomes provable once Lane A
(`AlgebraicJacobian.Genus0BaseObjects`) ships the concrete chartwise body of `gmScalingP1`.

See `blueprint/src/chapters/AbelianVarietyRigidity.tex` for the informal sketches and sources
(Mumford, *Abelian Varieties*, Ch. II §6; Milne, *Abelian Varieties*, Prop. 3.10;
Hartshorne, *Algebraic Geometry*, Example IV.1.3.5).

## Encoding notes

Mathlib `b80f227` packages no `ℙ¹` as a `Scheme`, so the projective line is encoded by its
abstract characterisation: a smooth proper geometrically irreducible `Over (Spec (.of kbar))` of
relative dimension `1` with `genus = 0` (see
`AlgebraicJacobian.Genus0BaseObjects.ProjectiveLineBar`).
The signatures of declarations 1–3 are **provisional** (`SCAFFOLD` comments mark them); the prover
may refine the encoding when the bodies are filled. Declaration 3 is pinned verbatim to
`rigidity_over_kbar`'s signature minus `[CharZero kbar]`, because it is the exact signature the
consumer (`genusZeroWitness.key`) needs.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace AlgebraicGeometry

variable {kbar : Type u} [Field kbar]

/-! ### Iter-167 dominance bridge for the canonical `Gm ↪ ℙ¹` map

The four product / Proj instances `morphism_P1_to_grpScheme_const_aux` needs
(`GeometricallyIrreducible`, `LocallyOfFiniteType`, `IsReduced` of the product, and
`IsReduced (ProjectiveLineBar kbar).left`) all ship from Lane A
(`AlgebraicJacobian.Genus0BaseObjects`) as the instances `projGm_geomIrred`,
`projGm_locallyOfFiniteType`, `projGm_isReduced`, and `projectiveLineBar_isReduced`. The
helper resolves them all by `infer_instance`.

The one remaining bridge — dominance of the canonical inclusion `ι : Gm ⟶ ℙ¹` — is
file-local because its proof depends on the concrete chartwise body of `gmScalingP1` (still
a Lane A scaffold sorry through iter-167). It is exposed here as a named top-level lemma
`iotaGm_isDominant` so the helper carries no inline `sorry`. -/

/-- **Sub-task (b) range containment (iter-190 Lane E refactor):** the topological image of
the `k̄`-point `onePt = [1:1] ∈ ℙ¹` lies inside the open image of the chart-1 affine open
`Proj.awayι (X 1) : Spec(Away 𝒜 (X 1)) ⟶ Proj 𝒜`.

**Mathematical content.** `onePt.left = Proj.fromOfGlobalSections 𝒜 (evalIntoGlobal v) _`
with `v 0 = v 1 = 1`. Since `evalIntoGlobal v (X 1) = (ΓSpecIso k̄).inv 1 = 1` is a unit in
`Γ(Spec k̄, ⊤)`, the preimage of `D₊(X 1) ⊆ Proj 𝒜` under `onePt.left` is
`(Spec k̄).basicOpen 1 = ⊤`, so the image of `onePt.left` lies entirely in
`Set.range (Proj.awayι (X 1)) = D₊(X 1)`.

The range chain (iter-184 closure):
(i) `Scheme.Hom.coe_opensRange` + `Proj.opensRange_awayι` rewrite the RHS into
`↑(Proj.basicOpen 𝒜 (X 1))`; (ii) pointwise destructure to `onePt.left x ∈ basicOpen`;
(iii) `Scheme.Hom.mem_preimage` + `change` expose `onePt.left = fromOfGlobalSections 𝒜 φ hφ`
(`pointOfVec` unfolds through `Over.homMk` even though `evalIntoGlobal`/`pointOfVec` are
private — defeq is unaffected by name visibility); (iv) `fromOfGlobalSections_preimage_basicOpen`
reduces to `(Spec k̄).basicOpen ((ΓSpecIso k̄).inv.hom (eval (·=1) (X 1)))`;
(v) `Scheme.basicOpen_of_isUnit` + `simp` closes via `eval_X` + `map_one` + `isUnit_one`.
Axiom-clean: `#print axioms` = `{propext, Classical.choice, Quot.sound}`.

Iter-190: extracted from the previous `∃`-packed `iotaGm_onePt_chart1_factor` (verdict A of
the iter-189 mathlib-analogist Lane E `projappiso` analysis) so the chart-1 lift
`iotaGm_r_1` is exposed as a named `noncomputable def`. Downstream
`iotaGm_chart1_composition_isOpenImmersion` can then apply `IsOpenImmersion.lift_app`
directly to `iotaGm_r_1` without re-deriving the range witness via `cancel_mono`. -/
private lemma iotaGm_r_1_range_subset (kbar : Type u) [Field kbar] :
    Set.range ⇑(ProjectiveLineBar.onePt kbar).left ⊆
      Set.range ⇑(Proj.awayι (projectiveLineBarGrading kbar)
        ((![MvPolynomial.X 0, MvPolynomial.X 1] :
          Fin 2 → MvPolynomial (Fin 2) kbar) 1)
        (projectiveLineBarAffineCover_fDeg kbar 1)
        (projectiveLineBarAffineCover_hm 1)) := by
  -- Iter-190 prover closure (point-witness reshape). The iter-184 closed body relied on
  -- `rw [← Scheme.Hom.coe_opensRange]` to expose the RHS `Set.range` as a `(...).opensRange`
  -- coercion; in the standalone signature here, elaboration types the LHS at
  -- `Set ↥(ProjectiveLineBar kbar).left` whereas `Proj.awayι _ _ _ _` is typed at
  -- `Set ↥(Proj 𝒜)`, so the rewrite pattern does not match. We sidestep this by
  -- destructuring point-wise FIRST, then `change`-ing the membership goal into
  -- `(...).opensRange.1` (a defeq reshape that works because the underlying carriers
  -- `↥(ProjectiveLineBar kbar).left` and `↥(Proj 𝒜)` are defeq through
  -- `Scheme.asOver` / `OverClass.asOver`). The remainder of the chain is identical to
  -- the iter-184 body.
  rintro _ ⟨x, rfl⟩
  change (ProjectiveLineBar.onePt kbar).left.base x ∈ (Proj.awayι _ _ _ _).opensRange.1
  rw [Proj.opensRange_awayι]
  change x ∈ (ProjectiveLineBar.onePt kbar).left ⁻¹ᵁ Proj.basicOpen _ _
  change x ∈ Proj.fromOfGlobalSections (projectiveLineBarGrading kbar) _ _ ⁻¹ᵁ _
  rw [Proj.fromOfGlobalSections_preimage_basicOpen _ _ _
      (projectiveLineBarAffineCover_hm 1)
      (projectiveLineBarAffineCover_fDeg kbar 1)]
  refine (Scheme.basicOpen_of_isUnit _ ?_).symm ▸ TopologicalSpace.Opens.mem_top x
  change IsUnit ((Scheme.ΓSpecIso (CommRingCat.of kbar)).inv.hom
    ((MvPolynomial.eval (fun _ : Fin 2 => (1 : kbar)))
      ((![MvPolynomial.X 0, MvPolynomial.X 1] :
        Fin 2 → MvPolynomial (Fin 2) kbar) 1)))
  simp

/-- **Sub-task (b) lift (iter-190 Lane E refactor):** the chart-1 factor
`r_1 : Spec k̄ ⟶ Spec(Away 𝒜 (X 1))` of the `k̄`-point `onePt = [1:1] ∈ ℙ¹` through
the chart-1 open immersion `Proj.awayι (X 1)`. Provided by the universal property
`IsOpenImmersion.lift` of the open immersion `Proj.awayι (X 1)` together with the
range-containment witness `iotaGm_r_1_range_subset`.

Iter-190 refactor: replaces the existential `∃ r_1, ...` of the previous
`iotaGm_onePt_chart1_factor` (verdict A of the iter-189 mathlib-analogist Lane E
`projappiso` analysis) with a named `noncomputable def`, so that the consumer
`iotaGm_chart1_composition_isOpenImmersion` can apply `IsOpenImmersion.lift_app`
directly to `iotaGm_r_1` instead of re-deriving the lift identity via `cancel_mono`. -/
private noncomputable def iotaGm_r_1 (kbar : Type u) [Field kbar] :
    Spec (CommRingCat.of kbar) ⟶
      Spec (CommRingCat.of (HomogeneousLocalization.Away
        (projectiveLineBarGrading kbar)
        ((![MvPolynomial.X 0, MvPolynomial.X 1] :
          Fin 2 → MvPolynomial (Fin 2) kbar) 1))) :=
  IsOpenImmersion.lift
    (Proj.awayι (projectiveLineBarGrading kbar)
      ((![MvPolynomial.X 0, MvPolynomial.X 1] :
        Fin 2 → MvPolynomial (Fin 2) kbar) 1)
      (projectiveLineBarAffineCover_fDeg kbar 1)
      (projectiveLineBarAffineCover_hm 1))
    (ProjectiveLineBar.onePt kbar).left
    (iotaGm_r_1_range_subset kbar)

/-- **Sub-task (b) factorisation (iter-190 Lane E refactor):** the chart-1 factor
`iotaGm_r_1` factors `onePt.left` through `Proj.awayι (X 1)`. Discharges via
`IsOpenImmersion.lift_fac`. -/
private lemma iotaGm_r_1_fac (kbar : Type u) [Field kbar] :
    iotaGm_r_1 kbar ≫ Proj.awayι (projectiveLineBarGrading kbar)
        ((![MvPolynomial.X 0, MvPolynomial.X 1] :
          Fin 2 → MvPolynomial (Fin 2) kbar) 1)
        (projectiveLineBarAffineCover_fDeg kbar 1)
        (projectiveLineBarAffineCover_hm 1) =
      (ProjectiveLineBar.onePt kbar).left :=
  IsOpenImmersion.lift_fac _ _ _

/-! ### Iter-193 Lane E refactor — `IsOpenImmersion.lift_uniq` route

The substantive content of `iotaGm_chart1_appIso_eval` (the chart-1 `Proj.appIso`
evaluation `isLocElem ↦ 1`) repeatedly STUCK across iter-188/189/190/191 on the
`Proj.appIso` evaluation step. Iter-193 reroutes via `IsOpenImmersion.lift_uniq`:
since `iotaGm_r_1 = IsOpenImmersion.lift (Proj.awayι X_1) onePt.left h_range` by
definition, *any* `Spec.map(F)` satisfying the same lift identity must equal
`iotaGm_r_1`. So if we can build an explicit ring map
`kbarChart1Ring : Away 𝒜 X_1 →+* kbar`
sending `isLocElem ↦ 1` and prove `Spec.map kbarChart1Ring ≫ Proj.awayι X_1 =
onePt.left`, then `iotaGm_r_1 = Spec.map kbarChart1Ring` (by `lift_uniq`), and
the whole chart-1 evaluation reduces to a ring-map identity on `MvPolynomial Unit kbar`. -/

/-- **Iter-193 Lane E (helper).** The chart-`1` evaluation ring map at the `k̄`-point
`[1:1]`: `Away 𝒜 X_1 →+* k̄` sending the chart-`1` affine coordinate
`isLocElem = [X_0/X_1]` to `1 ∈ k̄`.

Defined as the composition
`Away 𝒜 X_1 →+* MvPolynomial Unit k̄ →+* k̄`
where the first map is the chart-`1` ring iso forward direction
(`homogeneousLocalizationAwayToMvPoly kbar 1`, sending `isLocElem ↦ X () = u`)
and the second is `MvPolynomial.eval (fun _ ↦ 1)` (evaluation of the chart-`1`
affine coordinate `u` at `λ = 1`). -/
private noncomputable def kbarChart1Ring (kbar : Type u) [Field kbar] :
    HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
        ((![MvPolynomial.X 0, MvPolynomial.X 1] :
          Fin 2 → MvPolynomial (Fin 2) kbar) 1) →+*
      kbar :=
  (MvPolynomial.eval (fun _ : Unit => (1 : kbar))).comp
    (homogeneousLocalizationAwayToMvPoly kbar 1)

/-- **Iter-193 Lane E (key helper, structural sorry).** The Spec-map factorisation
of `onePt.left` through `Proj.awayι X_1`: in concrete terms, the `k̄`-point `[1:1]`
of `D₊(X_1) ⊂ Proj 𝒜` is the Spec of the `k̄`-algebra evaluation map
`Away 𝒜 X_1 →+* k̄` sending `isLocElem ↦ 1`.

**Mathematical content.** Both sides are morphisms `Spec k̄ ⟶ Proj 𝒜`. They agree
on their image lying in `D₊(X_1)`, where the canonical iso
`basicOpenIsoSpec 𝒜 X_1 _ _ : D₊(X_1) ≅ Spec(Away 𝒜 X_1)` identifies the lift
with the algebra map. Since `onePt.left = Proj.fromOfGlobalSections 𝒜 evalIntoGlobal _`
restricts to `D₊(X_1)` via `Proj.fromOfGlobalSections_morphismRestrict`, both
land at the same Spec point.

**Status (iter-193).** Typed sorry replacing the previous `Proj.appIso` evaluation
sorry. The substantive content here is the chart-`1` ring-map identification via
`basicOpenIsoSpec_inv_ι` + `Proj.fromOfGlobalSections_morphismRestrict`. Cleaner
target than the previous `Proj.appIso` chain because it factors entirely through
named Mathlib lemmas (no inaccessible `appIso` evaluation). -/
private lemma kbarChart1Ring_specMap_fac (kbar : Type u) [Field kbar] :
    Spec.map (CommRingCat.ofHom (kbarChart1Ring kbar)) ≫
        Proj.awayι (projectiveLineBarGrading kbar)
          ((![MvPolynomial.X 0, MvPolynomial.X 1] :
            Fin 2 → MvPolynomial (Fin 2) kbar) 1)
          (projectiveLineBarAffineCover_fDeg kbar 1)
          (projectiveLineBarAffineCover_hm 1) =
      (ProjectiveLineBar.onePt kbar).left := by
  -- Iter-194 prover refactor (Lane E target 1): the substantive
  -- `IsOpenImmersion.lift_uniq` factorisation claim. The iter-193 reroute via
  -- `lift_uniq` exposes a clean ring-map target. Iter-194 structural step:
  -- factor the proof through the already-named `iotaGm_r_1_fac` lift identity
  -- (`iotaGm_r_1 ≫ awayι X_1 = onePt.left`, axiom-clean from
  -- `IsOpenImmersion.lift_fac`), reducing to a focused affine-Spec ring-map
  -- identity `Spec.map(kbarChart1Ring) = iotaGm_r_1`.
  --
  -- After the reduction, both sides are morphisms `Spec k̄ ⟶ Spec(Away 𝒜 X_1)`,
  -- with affine codomain; `ext_of_isAffine` reduces to a ring-map equality
  -- `Away 𝒜 X_1 →+* Γ(Spec k̄, ⊤)`.
  --
  -- The ring-map identity captured below as the residual is the chart-`1`
  -- evaluation identity: under `((awayι X_1).appIso ⊤).inv` (the Mathlib
  -- `Proj.appIso` evaluation step) plus `homogeneousLocalizationAwayIso`,
  -- the canonical generator `isLocElem ∈ Away 𝒜 X_1` lifts to `[X_0/X_1]`,
  -- then to the polynomial generator `u ∈ MvPolynomial Unit kbar`, then evals
  -- to `1 ∈ k̄` at `v = (1,1)`. The substantive content matches
  -- `iotaGm_chart1_appIso_eval`'s residual (line 439 below).
  rw [← iotaGm_r_1_fac kbar]
  -- Goal: Spec.map(kbarChart1Ring) ≫ awayι X_1 = iotaGm_r_1 kbar ≫ awayι X_1.
  -- The two `awayι X_1` factors are identical; `congr 1` reduces to head
  -- equality on `Spec k̄ ⟶ Spec(Away 𝒜 X_1)`.
  congr 1
  -- Goal: Spec.map(CommRingCat.ofHom (kbarChart1Ring kbar)) = iotaGm_r_1 kbar.
  -- Both sides have codomain `Spec(Away 𝒜 X_1)`, which is affine.
  -- Use `ext_of_isAffine` to reduce to ring-map equality on global sections.
  refine ext_of_isAffine ?_
  -- Goal: appTop equality as ring map `Away 𝒜 X_1 →+* Γ(Spec k̄, ⊤)`.
  --
  -- LHS appTop = `kbarChart1Ring kbar` (via `Spec.map_appTop` chain).
  -- RHS appTop = `((awayι X_1).appIso ⊤).inv ≫ onePt.left.app(D₊(X_1)) ≫ ...`
  --             (via `IsOpenImmersion.lift_app` applied to `iotaGm_r_1`).
  --
  -- The substantive content is the iter-188/189/190/191 STUCK `Proj.appIso`
  -- evaluation. Pending iter-195+ mathlib-analogist verdict on a Mathlib API
  -- for evaluating `(Proj.awayι X_1).appIso ⊤ .inv` on `isLocElem`.
  --
  -- Status (iter-194): structural skeleton landed; the focused residual is the
  -- single named ring-map equality `appTop(Spec.map kbarChart1Ring) = appTop
  -- (iotaGm_r_1)`. This is strictly smaller in surface than the original
  -- `_ ≫ awayι X_1 = onePt.left` goal — the `awayι` factor and the morphism-
  -- level reasoning are eliminated.
  sorry

/-- **Iter-193 Lane E (identification via `lift_uniq`).** The chart-`1` lift
`iotaGm_r_1 : Spec k̄ ⟶ Spec(Away 𝒜 X_1)` is, in concrete form, `Spec.map` of the
chart-`1` evaluation ring map `kbarChart1Ring`.

Proof via `IsOpenImmersion.lift_uniq` of `Proj.awayι X_1`: both `iotaGm_r_1` and
`Spec.map kbarChart1Ring` satisfy the same `lift_fac` identity (`_ ≫ Proj.awayι X_1
= onePt.left`), so they coincide by uniqueness. -/
private lemma iotaGm_r_1_eq_specMap (kbar : Type u) [Field kbar] :
    iotaGm_r_1 kbar =
      Spec.map (CommRingCat.ofHom (kbarChart1Ring kbar)) := by
  refine (IsOpenImmersion.lift_uniq
    (Proj.awayι (projectiveLineBarGrading kbar)
      ((![MvPolynomial.X 0, MvPolynomial.X 1] :
        Fin 2 → MvPolynomial (Fin 2) kbar) 1)
      (projectiveLineBarAffineCover_fDeg kbar 1)
      (projectiveLineBarAffineCover_hm 1))
    (ProjectiveLineBar.onePt kbar).left
    (iotaGm_r_1_range_subset kbar)
    _ (kbarChart1Ring_specMap_fac kbar)).symm

/-- **Sub-task f reusable compatibility helper (iter-183 Lane E):** the compatibility
hypothesis for the inner `pullback.lift` of the section `s`, namely
`((Gm).hom ≫ onePt.left) ≫ PLB.hom = 𝟙 Gm.left ≫ Gm.hom`. Reduces to `Over.w onePt`
plus `(𝟙_).hom = 𝟙 _` on the codomain. -/
private lemma iotaGm_inner_lift_compat (kbar : Type u) [Field kbar] :
    ((Gm kbar).hom ≫ (ProjectiveLineBar.onePt kbar).left) ≫
        (ProjectiveLineBar kbar).hom =
      𝟙 (Gm kbar).left ≫ (Gm kbar).hom :=
  (Category.assoc _ _ _).trans <|
    ((congrArg ((Gm kbar).hom ≫ ·)
      (Over.w (ProjectiveLineBar.onePt kbar))).trans (by simp))

/-- **Sub-task f section (iter-183 Lane E; iter-191 refactored to specialise on `iotaGm_r_1`):**
the chart-1 section `s : Gm.left ⟶ (gmScalingP1_cover).X 1`, built as the `pullback.lift` over
`pullback q (awayι (![X 0, X 1] 1))` with the iotaGm-prefix as `q`-component and
`Gm.hom ≫ iotaGm_r_1` as `awayι`-component.

**Iter-191 refactor** (per iter-190 review §7 + progress-critic STUCK-corrective scope):
Previously parametrised over abstract `(r_1, h_r_1)`. Now specialised on the named
`iotaGm_r_1` / `iotaGm_r_1_fac` directly, so the downstream consumer
`iotaGm_chart1_composition_isOpenImmersion` can apply `IsOpenImmersion.lift_app` to
`iotaGm_r_1` via `unfold` without re-deriving the lift identity through `cancel_mono`. -/
private noncomputable def iotaGm_chart1_section (kbar : Type u) [Field kbar] :
    (Gm kbar).left ⟶ (gmScalingP1_cover kbar).X (1 : Fin 2) :=
  pullback.lift
    (pullback.lift
      ((Gm kbar).hom ≫ (ProjectiveLineBar.onePt kbar).left)
      (𝟙 (Gm kbar).left)
      (iotaGm_inner_lift_compat kbar))
    ((Gm kbar).hom ≫ iotaGm_r_1 kbar)
    (by
      simp [pullback.lift_fst, ← iotaGm_r_1_fac kbar, Category.assoc]
      rfl)

/- **Historical doc** (iter-183 — iter-191) for `iotaGm_chart1_composition_isOpenImmersion`.
Now consumes the iter-192 blueprint-named helper `iotaGm_chart1_appIso_eval` below;
that helper holds the substantive proof skeleton (chart-1 composition equation +
Proj.appIso evaluation residual). The composition realises the canonical inclusion
`Gm = Spec k̄[t, t⁻¹] ↪ ℙ¹` sending `λ ↦ [λ : 1]`, decomposing as

```
Gm.left = Spec k̄[t, t⁻¹]
   ↪ Spec k̄[u]               (localization at `t`, via `IsOpenImmersion.of_isLocalization`)
   ≅ Spec (Away 𝒜 (X 1))     (via `homogeneousLocalizationAwayIso.symm`, an iso)
   ↪ ℙ¹.left                  (via `Proj.awayι (X 1)`).
```

Each factor is an open immersion; the composition therefore is. The substantive
chart-1 composition equation (`iotaGm_chart1_section ≫ gmScalingP1_chart 1 =
Spec.map(algMap) ≫ Spec.map(iso) ≫ Proj.awayι X_1`) is now extracted as
`iotaGm_chart1_appIso_eval` (iter-192), per the blueprint sub-lemma
`lem:iotaGm_chart1_appIso_eval` at lines 1146-1219 of the AVR chapter. -/
/-- **Blueprint sub-lemma `lem:iotaGm_chart1_appIso_eval` (iter-192 Lane E
extraction):** the chart-`1` Proj.appIso evaluation that bridges
`isLocElem → [X_0/X_1] → u → 1`.

This is the substantive morphism-level equation identifying the chart-`1`
composition `iotaGm_chart1_section ≫ gmScalingP1_chart 1 : Gm.left ⟶ ℙ¹.left`
with the canonical 3-step open-immersion factorisation
`Spec.map(algMap MvPoly→GmRing) ≫ Spec.map(iso.toRingHom) ≫ Proj.awayι X_1`.

**Mathematical content** (per blueprint `lem:iotaGm_chart1_appIso_eval`).
The chart-`1` ring map of `gmScalingP1_chart 1` sends `isLocElem ∈ Away 𝒜 X_1`
(the chart-`1` affine coordinate `X_0/X_1`) to `isLocElem ⊗ algMap(X())` in the
tensor product `Away 𝒜 X_1 ⊗ GmRing`. The section `iotaGm_chart1_section`'s
chart-`1` factor is `Gm.hom ≫ iotaGm_r_1`, where `iotaGm_r_1` is the chart-`1`
lift of the `k̄`-point `onePt = [1:1]`. Composing the section with the chart map
collapses the tensor through `Algebra.TensorProduct.lid` (the trivial `Gm`-twist
at `λ = 1`), yielding the canonical inclusion via the chart-`1` ring iso.

The key evaluation chain: `isLocElem ∈ Away 𝒜 X_1` lifts via
`(Proj.awayι X_1).appIso ⊤ .inv` to `[X_0/X_1] ∈ HomogeneousLocalization.Away 𝒜 X_1`
(the ratio in `Γ(Proj 𝒜, D₊(X_1))`); the chart-`1` ring iso forward sends
`[X_0/X_1] ↦ u`; finally, evaluation at the identity section `λ = 1` lands at
`1 ∈ kbar` after `Algebra.TensorProduct.lid` collapse.

**Status (iter-192).** Extracted as the blueprint-named hook. Body holds the
substantive proof skeleton; residual `Proj.appIso` evaluation step pending —
this is the same residual that has been STUCK across iter-188/189/190/191. The
extraction provides a focused target for future closure attempts and ensures
the consumer `iotaGm_chart1_composition_isOpenImmersion` is structurally clean
(no sorry in its body, just a `rw` of this helper). -/
private lemma iotaGm_chart1_appIso_eval (kbar : Type u) [Field kbar] [IsAlgClosed kbar] :
    iotaGm_chart1_section kbar ≫ gmScalingP1_chart kbar (1 : Fin 2) =
      Spec.map (CommRingCat.ofHom
          (algebraMap (MvPolynomial Unit kbar) (GmRing kbar))) ≫
        Spec.map (CommRingCat.ofHom
          (homogeneousLocalizationAwayIso kbar 1).toRingHom) ≫
          Proj.awayι (projectiveLineBarGrading kbar)
            (MvPolynomial.X 1 : MvPolynomial (Fin 2) kbar)
            (MvPolynomial.isHomogeneous_X kbar 1) Nat.one_pos := by
  -- Prove the equation `s ≫ chart 1 = canonical 3-step OI`.
  -- Stage 1: Fuse the two trailing `Spec.map`s on the RHS into a single `Spec.map`
  --   via `Spec.map_comp` + `CommRingCat.ofHom_comp`, so both sides end with
  --   `Spec.map (CommRingCat.ofHom f_ring) ≫ Proj.awayι (X 1)` where
  --   `f_ring = (algMap (MvPoly Unit kbar) (GmRing kbar)).comp
  --             (homogeneousLocalizationAwayIso kbar 1).toRingHom`.
  rw [← Category.assoc, ← Spec.map_comp, ← CommRingCat.ofHom_comp]
  -- Stage 2: Unfold `gmScalingP1_chart` on the LHS and re-associate so both
  --   sides end with `Proj.awayι (X 1)`. Apply `congr 1` to cancel the
  --   trailing `Proj.awayι (X 1)` factor (open immersion ⟹ mono, but `congr 1`
  --   is structural and avoids needing the mono instance directly).
  unfold gmScalingP1_chart
  rw [← Category.assoc, ← Category.assoc]
  congr 1
  -- Stage 3 (iter-185 attack): the `(gmScalingP1_cover_X_iso kbar 1).hom` in the LHS is
  -- inaccessible to `unfold` (the def is `private` in `Genus0BaseObjects/GmScaling.lean`),
  -- but its body is a 4-step iso chain `pullbackSymmetry ≪≫ pullbackRightPullbackFstIso ≪≫
  -- pullback.congrHom _ _ ≪≫ pullbackSpecIso`, with the two `pullback.congrHom`-equality
  -- proofs `Prop`-typed (hence proof-irrelevant). A `change` with `_, _` placeholders for
  -- those two proofs forces Lean to reconstruct them by unification and lets the kernel
  -- discharge the defEq via proof irrelevance — sidestepping the private-name barrier.
  change (iotaGm_chart1_section kbar ≫
      (pullbackSymmetry _ _ ≪≫
        pullbackRightPullbackFstIso _ _ _ ≪≫
        pullback.congrHom _ _ ≪≫
        pullbackSpecIso kbar _ (GmRing kbar)).hom) ≫ _ = _
  -- Stage 4: spread the iso (4 components) and unfold the section's `pullback.lift`
  -- skeleton so the LHS becomes a fully concrete chain
  --   `pullback.lift _ _ _ ≫ pullbackSymmetry.hom ≫ pullbackRightPullbackFstIso.hom ≫
  --    pullback.congrHom.hom ≫ pullbackSpecIso.hom ≫ Spec.map (eval₂Hom_comp_iso)`.
  simp only [Iso.trans_hom, Category.assoc, iotaGm_chart1_section]
  -- Iter-193 Lane E rerouting: identify `iotaGm_r_1` with `Spec.map kbarChart1Ring` via
  -- `IsOpenImmersion.lift_uniq` (helper `iotaGm_r_1_eq_specMap`). The `rw` motive fails
  -- because the `pullback.lift` cocycle compatibility's TYPE depends on `iotaGm_r_1`, but
  -- `simp only` handles proof-irrelevant dependencies and rewrites cleanly through the
  -- auto-param.
  simp only [iotaGm_r_1_eq_specMap]
  -- Stage 5: pull the trailing iso `Spec.map (iso.toRingHom)` out via `Spec.map_comp` on
  -- both sides so both end with the SAME morphism `Spec.map(iso.toRingHom)`. With the
  -- iso instance `h_iso_isIso` (= `IsIso (CommRingCat.ofHom iso.toRingHom)`),
  -- `Spec.map(iso.toRingHom)` is itself iso; `cancel_iso_hom_right_assoc` cancels it.
  rw [CommRingCat.ofHom_comp, Spec.map_comp, CommRingCat.ofHom_comp, Spec.map_comp]
  haveI h_iso_isIso : IsIso (CommRingCat.ofHom
      (homogeneousLocalizationAwayIso kbar 1).toRingHom) := by
    rw [show CommRingCat.ofHom (homogeneousLocalizationAwayIso kbar 1).toRingHom
          = (homogeneousLocalizationAwayIso kbar 1).toCommRingCatIso.hom from rfl]
    exact (homogeneousLocalizationAwayIso kbar 1).toCommRingCatIso.isIso_hom
  haveI : IsIso (Spec.map (CommRingCat.ofHom
      (homogeneousLocalizationAwayIso kbar 1).toRingHom)) := inferInstance
  -- Stage 6: fully left-associate `≫`s so both sides syntactically end with the iso
  -- `Spec.map (homogeneousLocalizationAwayIso kbar 1).toRingHom`; then `cancel_mono`
  -- on the iso (`IsIso → Mono`) discards the trailing factor.
  simp only [← Category.assoc]
  apply (CategoryTheory.cancel_mono (f := Spec.map (CommRingCat.ofHom
      (homogeneousLocalizationAwayIso kbar 1).toRingHom))).mpr
  -- Stage 7: both sides now target the affine `Spec (MvPolynomial Unit kbar)`. Use
  -- `ext_of_isAffine` to reduce to ring-map equality on global sections.
  refine ext_of_isAffine ?_
  -- Stage 8: telescope `appTop` of the composition through `Scheme.Hom.comp_appTop`.
  -- This reduces the goal to an explicit ring-map equation
  --   `appTop(LHS chain) = appTop(Spec.map(algMap MvPoly→GmRing))`
  -- viewed as `CommRingCat` morphisms `Γ(Spec(MvPoly Unit kbar)) ⟶ Γ(Spec(GmRing))`.
  simp only [Scheme.Hom.comp_appTop, Scheme.Hom.appTop]
  -- **Residual (iter-192 PARTIAL — Proj.appIso evaluation step).** The substantive
  -- closure requires evaluating `iotaGm_r_1.appTop(isLocElem) = 1 ∈ kbar` via:
  --   (i) `iotaGm_r_1 = IsOpenImmersion.lift (Proj.awayι X_1) onePt.left h_range`
  --       (by definition), so `IsOpenImmersion.lift_app` gives
  --       `iotaGm_r_1.app ⊤ = (Proj.awayι X_1).appIso ⊤ .inv ≫ onePt.left.app(D₊(X_1)) ≫ ...`;
  --   (ii) `(Proj.awayι X_1).appIso ⊤ .inv` sends `isLocElem ∈ Γ(Spec(Away X_1), ⊤)`
  --       to `[X_0/X_1] ∈ Γ(Proj 𝒜, D₊(X_1)) = HomogeneousLocalization.Away 𝒜 X_1`
  --       (the ratio of the two degree-1 generators);
  --   (iii) `onePt.left.app(D₊(X_1))` applied to `[X_0/X_1]` evaluates the
  --       degree-zero homogeneous fraction at the `k̄`-point `v = (1, 1)`,
  --       sending `X_0/X_1 ↦ 1/1 = 1 ∈ Γ(Spec k̄, D₊(X_1)) = k̄`;
  --   (iv) the chart-1 ring iso forward direction
  --       `homogeneousLocalizationAwayIso kbar 1 : Away 𝒜 X_1 ≃+* MvPoly Unit kbar`
  --       sends `isLocElem ↦ X () = u`;
  --   (v) `Algebra.TensorProduct.lid` collapses the trivial Gm-twist `1 ⊗ b ↦ b`,
  --       lifting `u ↦ algMap kbar→GmRing(1) · t = t = algMap MvPoly→GmRing(X ())`.
  -- Combined, the LHS ring map sends `X () ∈ MvPoly Unit kbar` to
  -- `algMap MvPoly→GmRing(X ()) = t`, matching the RHS ring map. By
  -- `MvPolynomial.algHom_ext`, the two ring maps are equal.
  --
  -- The substantive residual is the Mathlib-side `Proj.appIso` evaluation
  -- (step (ii)). Pending Mathlib API or a focused lemma extraction.
  sorry

/-- **Iter-182 Lane E primary helper (refactored iter-183):** the composed morphism
`(lift (toUnit Gm ≫ onePt) (𝟙 Gm)).left ≫ gmScalingP1.left : Gm.left ⟶ ℙ¹.left` is an
open immersion. -- See `iotaGm_isOpenImmersion` below for the consumer; the chart-1
substantive content is now packaged in `iotaGm_chart1_appIso_eval`. -/
private lemma iotaGm_chart1_composition_isOpenImmersion [IsAlgClosed kbar] :
    IsOpenImmersion (iotaGm_chart1_section kbar
      ≫ gmScalingP1_chart kbar (1 : Fin 2)) := by
  -- The composition equals the canonical inclusion `Gm = Spec k̄[t, t⁻¹] → ℙ¹` sending
  -- `λ ↦ [λ : 1]`, which factors as three open immersions:
  --   Spec(GmRing) → Spec(MvPoly Unit kbar) → Spec(Away 𝒜 (X 1)) → ℙ¹.
  -- The first is `Spec.map (algebraMap (MvPoly Unit kbar) (GmRing kbar))`, an open
  -- immersion via `IsOpenImmersion.of_isLocalization` (Mathlib).
  -- The second is `Spec.map homogeneousLocalizationAwayIso.toRingHom`, an iso (hence
  -- open immersion).
  -- The third is `Proj.awayι (X 1)`, an open immersion (Mathlib instance).
  haveI h_loc : IsOpenImmersion
      (Spec.map (CommRingCat.ofHom
        (algebraMap (MvPolynomial Unit kbar) (GmRing kbar)))) :=
    IsOpenImmersion.of_isLocalization
      (MvPolynomial.X () : MvPolynomial Unit kbar)
  haveI h_iso_isIso : IsIso (CommRingCat.ofHom
      (homogeneousLocalizationAwayIso kbar 1).toRingHom) := by
    rw [show CommRingCat.ofHom (homogeneousLocalizationAwayIso kbar 1).toRingHom
          = (homogeneousLocalizationAwayIso kbar 1).toCommRingCatIso.hom from rfl]
    exact (homogeneousLocalizationAwayIso kbar 1).toCommRingCatIso.isIso_hom
  haveI h_iso : IsOpenImmersion (Spec.map (CommRingCat.ofHom
      (homogeneousLocalizationAwayIso kbar 1).toRingHom)) :=
    inferInstance
  haveI h_proj : IsOpenImmersion (Proj.awayι (projectiveLineBarGrading kbar)
      (MvPolynomial.X 1 : MvPolynomial (Fin 2) kbar)
      (MvPolynomial.isHomogeneous_X kbar 1) Nat.one_pos) :=
    inferInstance
  -- Apply the blueprint sub-lemma: the chart-1 composition equals the canonical
  -- 3-step OI chain `Spec.map(algMap) ≫ Spec.map(iso) ≫ Proj.awayι X_1`. The
  -- conclusion follows from `IsOpenImmersion.comp` applied three times.
  rw [iotaGm_chart1_appIso_eval kbar]
  exact @IsOpenImmersion.comp _ _ _ _ _ h_loc
    (@IsOpenImmersion.comp _ _ _ _ _ h_iso h_proj)

/-- **Iter-182 Lane E primary helper (refactored iter-183):** the composed morphism
`(lift (toUnit Gm ≫ onePt) (𝟙 Gm)).left ≫ gmScalingP1.left : Gm.left ⟶ ℙ¹.left` is an
open immersion.

**Mathematical content.** Per `analogies/intersection-ring-cross01.md` Decision 4: the
composition realises the canonical inclusion `λ ↦ [λ : 1]` of `Gm = Spec k̄[t, t⁻¹]` into
`ℙ¹` as the chart-1 of the `gmScalingP1_cover`. The factorisation chain is

```
Gm.left = Spec k̄[t, t⁻¹]
   ↪ Spec k̄[u]               (`Spec.map (algebraMap k̄[u] k̄[u, u⁻¹])`, an open immersion
                                via `IsOpenImmersion.of_isLocalization`)
   ≅ Spec (Away 𝒜 (X 1))     (via `homogeneousLocalizationAwayIso.symm`, an iso)
   ↪ ℙ¹.left                  (via `Proj.awayι 𝒜 (X 1)`, an open immersion).
```

Composing the three open immersions gives an open immersion `Gm.left ⟶ ℙ¹.left`.

**Status (iter-183 structural assembly).** Body refactored to pure structural assembly
of two named sub-task helpers (helper budget = 2):
* `iotaGm_onePt_chart1_factor` (sub-task b) — typed sorry, ~30-50 LOC iter-184+.
* `iotaGm_chart1_composition_isOpenImmersion` (sub-task f) — typed sorry, ~30-60 LOC
  iter-184+.

This parent body itself is sorry-free assembly. iter-184+ closure of both helpers will
elevate the parent to Tier-1 (axiom-clean). -/
private lemma iotaGm_isOpenImmersion [IsAlgClosed kbar] :
    IsOpenImmersion ((lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar)
        (𝟙 (Gm kbar))).left ≫ (gmScalingP1 kbar).left) := by
  -- Step (a): unfold `(lift _ _).left` to `pullback.lift _ _ _` via `Over.lift_left`,
  -- and expose `gmScalingP1.left` as its `glueMorphisms` form.
  rw [Over.lift_left]
  simp only [Over.comp_left, Over.id_left, Over.toUnit_left]
  change IsOpenImmersion (pullback.lift _ _ _ ≫
    (gmScalingP1_cover kbar).glueMorphisms (gmScalingP1_chart kbar)
      (gmScalingP1_chart_agreement kbar))
  -- Step (b): the chart-1 factorisation of `onePt.left` is now packaged as
  -- the named `iotaGm_r_1` (def) + `iotaGm_r_1_fac` (lemma), with the iter-191
  -- refactor specialising `iotaGm_chart1_section` and
  -- `iotaGm_chart1_composition_isOpenImmersion` directly on `iotaGm_r_1`.
  -- Step (c)+(d)+(e): the section `s` (named `iotaGm_chart1_section`) satisfies
  -- `s ≫ (cover).f 1 = inner pullback.lift` by `pullback.lift_fst`. Combined with
  -- `Cover.ι_glueMorphisms` for chart `1 : Fin 2`, this identifies the prefix
  -- composed with `glueMorphisms` to `s ≫ gmScalingP1_chart 1`.
  have hfact : pullback.lift
        ((Gm kbar).hom ≫ (ProjectiveLineBar.onePt kbar).left)
        (𝟙 (Gm kbar).left)
        (iotaGm_inner_lift_compat kbar)
      ≫ (gmScalingP1_cover kbar).glueMorphisms (gmScalingP1_chart kbar)
          (gmScalingP1_chart_agreement kbar) =
      iotaGm_chart1_section kbar ≫
        gmScalingP1_chart kbar (1 : Fin 2) := by
    rw [← Scheme.Cover.ι_glueMorphisms (gmScalingP1_cover kbar)
          (gmScalingP1_chart kbar) (gmScalingP1_chart_agreement kbar) (1 : Fin 2),
      ← Category.assoc]
    congr 1
    -- `s ≫ (cover).f 1 = inner pullback.lift` by `pullback.lift_fst` of the outer pullback.
    exact (pullback.lift_fst _ _ _).symm
  -- Step (f): the composed section ≫ chart-1 map is an open immersion (sub-task f helper).
  have := iotaGm_chart1_composition_isOpenImmersion (kbar := kbar)
  rwa [← hfact] at this

/-- **Helper for `iotaGm_isDominant`:** the underlying topological range of the canonical
`Gm ↪ ℙ¹` morphism is open in `(ProjectiveLineBar kbar).left`.

**Mathematical content.** The composition `lift (toUnit Gm ≫ onePt) (𝟙 Gm) ≫ gmScalingP1` is
the morphism `Gm ⟶ ProjectiveLineBar kbar` sending `λ` to the projective point `[λ : 1]`. Its
underlying set-theoretic image is the basic principal open `D₊(X 0 · X 1) ⊂ ℙ¹` — i.e.
`ℙ¹ \ {[1:0], [0:1]}`. This image is open: the morphism factors through chart-1 of
`gmScalingP1_cover` (the `D₊(X 1)` chart of `ℙ¹`) as the composition
`Gm = Spec k̄[t, t⁻¹] ↪ Spec k̄[u] = D₊(X 1) ↪ ℙ¹`
where the first map is the open immersion `D(t) ⊂ 𝔸¹` (localization at `t`) and the second
is `Proj.awayι` (open immersion onto the basic open `D₊(X 1)`).

**Status (iter-182 PARTIAL — kernel-clean modulo `iotaGm_isOpenImmersion`).** The
open-range claim is reduced to the strictly-stronger `IsOpenImmersion` claim
(`iotaGm_isOpenImmersion`) via `IsOpenImmersion.isOpen_range`; the substantive content
(the chart-1 factorisation chain) is now packaged in that helper's body. -/
private lemma iotaGm_range_isOpen [IsAlgClosed kbar] :
    IsOpen (Set.range ⇑((lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar)
        (𝟙 (Gm kbar))).left ≫ (gmScalingP1 kbar).left)) := by
  -- Reduce the open-range claim to the strictly-stronger open-immersion claim,
  -- packaged as the named helper `iotaGm_isOpenImmersion`.
  haveI := iotaGm_isOpenImmersion (kbar := kbar)
  exact IsOpenImmersion.isOpen_range _

/-- **The canonical `Gm ↪ ℙ¹` inclusion `ι : Gm ⟶ ℙ¹` is dominant.** Here `ι` is the
"specialise the scaling action at `x = 1`" map `lift (toUnit Gm ≫ onePt) (𝟙 Gm) ≫ gmScalingP1`.
Once Lane A ships the concrete `gmScalingP1` body (chartwise glue), this becomes the standard
open immersion `Gm = Spec k̄[t, t⁻¹] ↪ ℙ¹` (sending `λ` to `[λ : 1]`), which is dense in the
irreducible `ℙ¹`.

**Status (iter-181).** kernel-clean (this body) MODULO upstream `iotaGm_range_isOpen` (the
substantive chart-1 open-immersion identification, gated on Lane B). The structural derivation
of `DenseRange` from `IsOpen (range f) + Nonempty (range f) + IrreducibleSpace target` is
closed in-body via `IsOpen.dense` on the `IrreducibleSpace`-from-`GeometricallyIrreducible`
deduction. -/
private lemma iotaGm_isDominant [IsAlgClosed kbar] :
    IsDominant (lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
      ≫ gmScalingP1 kbar).left := by
  -- Reduce `IsDominant` to `DenseRange` on the composed underlying continuous map.
  rw [Over.comp_left]
  refine ⟨?_⟩
  -- `IrreducibleSpace ℙ¹.left` from `GeometricallyIrreducible PLB.hom` + `Subsingleton Spec k̄`.
  haveI : Subsingleton ↥(Spec (CommRingCat.of kbar)) := inferInstance
  haveI hirr : IrreducibleSpace (ProjectiveLineBar kbar).left :=
    GeometricallyIrreducible.irreducibleSpace_of_subsingleton
      (f := (ProjectiveLineBar kbar).hom)
  -- `Nonempty Gm.left` from `PrimeSpectrum`-of-nontrivial-ring.
  haveI : Nonempty (Gm kbar).left := inferInstance
  -- Closes via `IsOpen.dense`: in a preirreducible space, any non-empty open is dense.
  -- `Set.range_nonempty` gives non-emptiness from the source `Gm.left` being non-empty;
  -- `iotaGm_range_isOpen` packages the substantive chart-1 open-immersion identification
  -- (single named honest sorry, gated on Lane B's `gmScalingP1` chart-1 body).
  exact (iotaGm_range_isOpen.dense (Set.range_nonempty _))

/-- **Helper (pointed case): a morphism `f : ℙ¹ → A` killing `0 ∈ ℙ¹` is the constant `1`.**
Over an algebraically closed field `k̄`, if `f : ProjectiveLineBar kbar ⟶ A` satisfies
`ProjectiveLineBar.zeroPt kbar ≫ f = η[A]`, then `f = (1 : ProjectiveLineBar kbar ⟶ A)`
(equivalently `f = toUnit ProjectiveLineBar ≫ η[A]`).

This is the pointed core of the `𝔾ₘ`-scaling shortcut: form `h := gmScalingP1 ≫ f`, feed it
to Cor 1.5 (`hom_additive_decomp_of_rigidity`) with `V = ProjectiveLineBar`, `W = Gm`, base
points `zeroPt`, `onePt`. The `W`-axis collapses by `gmScalingP1_collapse_at_zero`, leaving
`h = fst ≫ fV` (the relation `f(λx) = fV(x)`). Specialising at `x = 1` (via the canonical
inclusion `Gm ↪ ℙ¹` given by `λ ↦ σ×(1, λ) = λ`) and using density of `Gm ⊆ ℙ¹` plus
separatedness of `A` (via `ext_of_isDominant_of_isSeparated'`, the same Mathlib bridge
`rigidity_core` uses inline), we conclude `f = toUnit ℙ¹ ≫ (onePt ≫ fV)`. The basepoint
hypothesis then pins `onePt ≫ fV = η[A]`.

**Status (iter-167):** body fully refactored — all five in-line product/Proj `sorry`s have
been eliminated. Four of them (`GeometricallyIrreducible`, `LocallyOfFiniteType`, `IsReduced`
of the product, and `IsReduced (ProjectiveLineBar kbar).left`) ship from Lane A
(`AlgebraicJacobian.Genus0BaseObjects` instances `projGm_geomIrred`,
`projGm_locallyOfFiniteType`, `projGm_isReduced`, `projectiveLineBar_isReduced`) and resolve
by `infer_instance` in scope. The fifth — dominance of the canonical `Gm ↪ ℙ¹` map — is
exposed as the named top-level bridge `iotaGm_isDominant` above (a single `sorry` pending
Lane A's `gmScalingP1` body). The helper itself contains no `sorry`. -/
private theorem morphism_P1_to_grpScheme_const_aux
    [IsAlgClosed kbar]
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : ProjectiveLineBar kbar ⟶ A)
    (hf0 : ProjectiveLineBar.zeroPt kbar ≫ f = η[A]) :
    f = (1 : ProjectiveLineBar kbar ⟶ A) := by
  -- W-axis collapse via `gmScalingP1_collapse_at_zero`, precomposed with `onePt`:
  -- `lift zeroPt onePt ≫ gmScalingP1 = zeroPt`.
  have hcollapse :
      lift (ProjectiveLineBar.zeroPt kbar) (Gm.onePt kbar) ≫ gmScalingP1 kbar
        = ProjectiveLineBar.zeroPt kbar := by
    have hbase := gmScalingP1_collapse_at_zero kbar
    -- Rewrite `lift zeroPt onePt = onePt ≫ lift (toUnit Gm ≫ zeroPt) (𝟙 Gm)`.
    have hreshape :
        lift (ProjectiveLineBar.zeroPt kbar) (Gm.onePt kbar)
          = Gm.onePt kbar ≫
            lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) := by
      rw [comp_lift, Category.comp_id]
      congr 1
      rw [← Category.assoc,
        toUnit_unique (Gm.onePt kbar ≫ toUnit (Gm kbar)) (𝟙 _), Category.id_comp]
    rw [hreshape, Category.assoc, hbase, ← Category.assoc,
      toUnit_unique (Gm.onePt kbar ≫ toUnit (Gm kbar)) (𝟙 _), Category.id_comp]
  -- The Cor 1.5 basepoint hypothesis `lift v₀ w₀ ≫ (σ ≫ f) = η[A]`.
  have hcorhyp :
      lift (ProjectiveLineBar.zeroPt kbar) (Gm.onePt kbar)
        ≫ (gmScalingP1 kbar ≫ f) = η[A] := by
    rw [← Category.assoc, hcollapse]; exact hf0
  -- Apply Cor 1.5.
  have key := hom_additive_decomp_of_rigidity
    (V := ProjectiveLineBar kbar) (W := Gm kbar)
    (ProjectiveLineBar.zeroPt kbar) (Gm.onePt kbar)
    (gmScalingP1 kbar ≫ f) hcorhyp
  -- W-axis restriction: `lift (toUnit Gm ≫ zeroPt) (𝟙 Gm) ≫ σ ≫ f = (1 : Gm ⟶ A)`.
  have hfW :
      lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar))
        ≫ (gmScalingP1 kbar ≫ f) = (1 : Gm kbar ⟶ A) := by
    rw [← Category.assoc, gmScalingP1_collapse_at_zero, Category.assoc, hf0]
    exact Hom.one_def.symm
  -- `snd ≫ fW = snd ≫ 1 = 1` (using `toUnit` uniqueness).
  have hSndFW :
      snd (ProjectiveLineBar kbar) (Gm kbar)
        ≫ (lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar))
          ≫ (gmScalingP1 kbar ≫ f))
        = (1 : ProjectiveLineBar kbar ⊗ Gm kbar ⟶ A) := by
    rw [hfW, Hom.one_def, ← Category.assoc]
    congr 1
    exact toUnit_unique _ _
  -- `key` now reads `σ ≫ f = fst ≫ fV` (after collapsing the W-axis to 1).
  rw [hSndFW, _root_.mul_one] at key
  -- Name the V-axis restriction `fV`.
  set fV : ProjectiveLineBar kbar ⟶ A :=
    lift (𝟙 (ProjectiveLineBar kbar)) (toUnit (ProjectiveLineBar kbar) ≫ Gm.onePt kbar)
      ≫ (gmScalingP1 kbar ≫ f) with hfVdef
  -- Precompose `key` with `gmInP1 := lift (toUnit Gm ≫ onePt) (𝟙 Gm) : Gm → ℙ¹ ⊗ Gm`
  -- ("λ ↦ (1, λ)"). The resulting morphism `ι := gmInP1 ≫ σ : Gm → ℙ¹` is the canonical
  -- inclusion `Gm ↪ ℙ¹` ("λ ↦ σ×(1, λ) = λ"); on its image, `f` is constant at `onePt ≫ fV`.
  set iotaGm : Gm kbar ⟶ ProjectiveLineBar kbar :=
    lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
      ≫ gmScalingP1 kbar with hιdef
  have hιf :
      iotaGm ≫ f = toUnit (Gm kbar) ≫ (ProjectiveLineBar.onePt kbar ≫ fV) := by
    calc iotaGm ≫ f
        = lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
            ≫ (gmScalingP1 kbar ≫ f) := by rw [hιdef, Category.assoc]
      _ = lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
            ≫ (fst (ProjectiveLineBar kbar) (Gm kbar) ≫ fV) := by rw [key]
      _ = (lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) (𝟙 (Gm kbar))
            ≫ fst (ProjectiveLineBar kbar) (Gm kbar)) ≫ fV := by
          rw [Category.assoc]
      _ = (toUnit (Gm kbar) ≫ ProjectiveLineBar.onePt kbar) ≫ fV := by rw [lift_fst]
      _ = toUnit (Gm kbar) ≫ (ProjectiveLineBar.onePt kbar ≫ fV) := by
          rw [Category.assoc]
  -- Separatedness of the target `A` over `Spec k̄` in `OverClass.fromOver` form.
  haveI hAsep : IsSeparated A.hom := IsProper.toIsSeparated
  haveI : IsSeparated (A.left ↘ Spec (CommRingCat.of kbar)) := hAsep
  -- `IsReduced (ProjectiveLineBar kbar).left` and the product geom-irred / LOFT / IsReduced
  -- instances are all auto-resolved via Lane A's exports in `Genus0BaseObjects`
  -- (`projectiveLineBar_isReduced`, `projGm_geomIrred`, `projGm_locallyOfFiniteType`,
  -- `projGm_isReduced`). Dominance of `ι.left` is the only file-local bridge, cited
  -- explicitly via `iotaGm_isDominant` (the `set`-binding `hιdef` exposes `iotaGm.left`
  -- definitionally as `(lift _ _ ≫ gmScalingP1 kbar).left`).
  haveI hιDom : IsDominant iotaGm.left := iotaGm_isDominant
  -- Globalise: `ι ≫ f = ι ≫ (toUnit ℙ¹ ≫ (onePt ≫ fV))` gives, by dominance, `f = toUnit ℙ¹ ≫ c`.
  have hf_eq :
      f = toUnit (ProjectiveLineBar kbar) ≫ (ProjectiveLineBar.onePt kbar ≫ fV) := by
    -- Promote the Over morphism equality from the underlying scheme equality.
    have hgoal :
        iotaGm ≫ f
          = iotaGm ≫ (toUnit (ProjectiveLineBar kbar) ≫
              (ProjectiveLineBar.onePt kbar ≫ fV)) := by
      have hreshape :
          iotaGm ≫ (toUnit (ProjectiveLineBar kbar) ≫
              (ProjectiveLineBar.onePt kbar ≫ fV))
            = toUnit (Gm kbar) ≫ (ProjectiveLineBar.onePt kbar ≫ fV) := by
        rw [← Category.assoc,
          toUnit_unique (iotaGm ≫ toUnit (ProjectiveLineBar kbar)) (toUnit (Gm kbar))]
      rw [hreshape, hιf]
    refine Over.OverMorphism.ext ?_
    refine ext_of_isDominant_of_isSeparated' (S := Spec (.of kbar))
      (X := (ProjectiveLineBar kbar).left) (Y := A.left)
      (f := f.left)
      (g := (toUnit (ProjectiveLineBar kbar) ≫
        (ProjectiveLineBar.onePt kbar ≫ fV)).left) iotaGm.left ?_
    rw [← Over.comp_left, ← Over.comp_left]
    exact congrArg Over.Hom.left hgoal
  -- Pin `onePt ≫ fV = η[A]` via the basepoint hypothesis `hf0`.
  have hc : ProjectiveLineBar.onePt kbar ≫ fV = η[A] := by
    have hcomp := hf0
    rw [hf_eq] at hcomp
    rw [← Category.assoc,
      toUnit_unique (ProjectiveLineBar.zeroPt kbar ≫ toUnit (ProjectiveLineBar kbar))
        (𝟙 _),
      Category.id_comp] at hcomp
    exact hcomp
  rw [hf_eq, hc, ← Hom.one_def]

/-- **A morphism `ℙ¹ → A` is constant.** Over an algebraically closed field `k̄`, every
morphism `f : ProjectiveLineBar kbar ⟶ A` from the projective line into an abelian variety
`A` (a smooth proper geometrically irreducible group scheme) is constant: it factors through
a single `k̄`-point `a₀ : 𝟙_ ⟶ A`, i.e. `f = toUnit ℙ¹ ≫ a₀`.

The single-curve base case of Milne's Proposition 3.10. **Route resolved iter-164: the
𝔾ₘ-scaling shortcut** — NO theorem of the cube, NO Milne Thm 3.2, NO `Hom(𝔾ₐ, A) = 0`,
char-general. The proof body proceeds by translating in the group `A` to reduce to the
basepoint case `zeroPt ≫ f = η[A]` (handled by the helper
`morphism_P1_to_grpScheme_const_aux`), then un-translating.

See blueprint `prop:morphism_P1_to_AV_constant`
(Milne, *Abelian Varieties*, Prop. 3.10).

**Status (iter-166):** body landed. Carries propagated `sorryAx` via the helper's residuals
(three product-instance Mathlib bridges + dominance of the canonical `Gm → ℙ¹` map). Lifts
to axiom-clean once those are discharged. -/
theorem morphism_P1_to_grpScheme_const
    [IsAlgClosed kbar]
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : ProjectiveLineBar kbar ⟶ A) :
    ∃ a₀ : 𝟙_ (Over (Spec (.of kbar))) ⟶ A,
      f = toUnit (ProjectiveLineBar kbar) ≫ a₀ := by
  -- Witness: `a₀ := zeroPt ≫ f` (the value of `f` at the scaling fixed point `0 ∈ ℙ¹`).
  refine ⟨ProjectiveLineBar.zeroPt kbar ≫ f, ?_⟩
  -- Translate: form `f' := f / (toUnit ℙ¹ ≫ a₀)` and apply the helper to `f'`.
  have hf' :
      (f / (toUnit (ProjectiveLineBar kbar) ≫ ProjectiveLineBar.zeroPt kbar ≫ f))
        = (1 : ProjectiveLineBar kbar ⟶ A) := by
    apply morphism_P1_to_grpScheme_const_aux
    -- Show `zeroPt ≫ (f / (toUnit ℙ¹ ≫ a₀)) = η[A]`.
    rw [GrpObj.comp_div]
    have hv :
        ProjectiveLineBar.zeroPt kbar ≫
            toUnit (ProjectiveLineBar kbar) ≫
              (ProjectiveLineBar.zeroPt kbar ≫ f)
          = ProjectiveLineBar.zeroPt kbar ≫ f := by
      rw [← Category.assoc,
        toUnit_unique (ProjectiveLineBar.zeroPt kbar ≫ toUnit (ProjectiveLineBar kbar))
          (𝟙 _),
        Category.id_comp]
    rw [hv, div_self', Hom.one_def, toUnit_unique (toUnit _) (𝟙 _), Category.id_comp]
  -- Untranslate: `f / (toUnit ℙ¹ ≫ a₀) = 1` ⟺ `f = toUnit ℙ¹ ≫ a₀`.
  exact div_eq_one.mp hf'

/-- **A genus-`0` curve over `k̄` is isomorphic to `ℙ¹`.** Over an algebraically closed field
`k̄`, a smooth proper geometrically irreducible curve `C` with `genus C = 0` is isomorphic — in
`Over (Spec (.of kbar))` — to the concrete projective line `ProjectiveLineBar kbar`.

Hartshorne's Example IV.1.3.5 (Riemann–Roch). Its formalisation is a genuine sub-build:
Mathlib has no Riemann–Roch for curves; this is the dominant long pole flagged by the
iter-164 progress-critic.

See blueprint `prop:genusZero_curve_iso_P1`
(Hartshorne, *Algebraic Geometry*, Example IV.1.3.5).

**Status (iter-166):** signature refactored to the concrete `ProjectiveLineBar kbar`; body
remains `sorry` (RR bridge — iter-167+). -/
theorem genusZero_curve_iso_P1
    [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (_hgenus : genus C = 0) :
    Nonempty (C ≅ ProjectiveLineBar kbar) :=
  sorry

/-- **Headline: rigidity for a pointed genus-`0` curve.** Over an algebraically closed field
`k̄` (arbitrary characteristic — no `[CharZero kbar]`), let `C` be a smooth proper geometrically
irreducible curve with `genus C = 0` and `A` an abelian variety (smooth proper geom-irred group
scheme). Then every morphism `f : C ⟶ A` killing a `k̄`-point `p` (`p ≫ f = η[A]`) equals the
constant morphism at the identity, `f = toUnit C ≫ η[A]`.

This is the project's committed characteristic-free statement that `genusZeroWitness` consumes
(via the `k̄ → k` descent step hosted in `AlgebraicJacobian.Jacobian`). Its signature mirrors
`AlgebraicGeometry.rigidity_over_kbar` of `AlgebraicJacobian.RigidityKbar` **verbatim except**
the `[CharZero kbar]` instance is dropped. Combine `genusZero_curve_iso_P1` (`C ≅ ℙ¹`) with
`morphism_P1_to_grpScheme_const` (`ℙ¹ → A` constant) and pin the constant value to `η[A]` via
the pointed hypothesis. No `df = 0`, no Serre duality, no Picard representability.

**Status (iter-166):** body landed. Carries propagated `sorryAx` via `genusZero_curve_iso_P1`
(RR bridge, iter-167+) and `morphism_P1_to_grpScheme_const`'s helper residuals. Once the RR
bridge closes and the helper's product-instance + dominance sorries discharge, lifts to
axiom-clean. -/
theorem rigidity_genus0_curve_to_grpScheme
    [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [SmoothOfRelativeDimension 1 C.hom]
    [IsProper C.hom]
    [GeometricallyIrreducible C.hom]
    (_hgenus : genus C = 0)
    {A : Over (Spec (.of kbar))}
    [GrpObj A] [IsProper A.hom] [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : C ⟶ A)
    (p : 𝟙_ (Over (Spec (.of kbar))) ⟶ C)
    (_hf : p ≫ f = η[A]) :
    f = (toUnit C ≫ η[A]) := by
  -- Transport `f` along `C ≅ ProjectiveLineBar kbar` to a morphism `g : ℙ¹ ⟶ A`.
  obtain ⟨φ⟩ := genusZero_curve_iso_P1 _hgenus
  set g : ProjectiveLineBar kbar ⟶ A := φ.inv ≫ f with hgdef
  -- `morphism_P1_to_grpScheme_const` gives `g = toUnit ℙ¹ ≫ a₀` for some `a₀`.
  obtain ⟨a₀, hga₀⟩ := morphism_P1_to_grpScheme_const g
  -- Pin `a₀ = η[A]` via the pointed hypothesis on `f`.
  have hpoint : (p ≫ φ.hom) ≫ g = η[A] := by
    rw [hgdef, Category.assoc, ← Category.assoc φ.hom, φ.hom_inv_id, Category.id_comp]
    exact _hf
  have hcst : a₀ = η[A] := by
    rw [hga₀, ← Category.assoc,
      toUnit_unique ((p ≫ φ.hom) ≫ toUnit (ProjectiveLineBar kbar)) (𝟙 _),
      Category.id_comp] at hpoint
    exact hpoint
  rw [hcst] at hga₀
  -- Back-transport: `f = φ.hom ≫ g = φ.hom ≫ toUnit ℙ¹ ≫ η[A] = toUnit C ≫ η[A]`.
  calc f
      = φ.hom ≫ φ.inv ≫ f := by
        rw [← Category.assoc, φ.hom_inv_id, Category.id_comp]
    _ = φ.hom ≫ g := by rw [hgdef]
    _ = φ.hom ≫ toUnit (ProjectiveLineBar kbar) ≫ η[A] := by rw [hga₀]
    _ = toUnit C ≫ η[A] := by
        rw [← Category.assoc,
          toUnit_unique (φ.hom ≫ toUnit (ProjectiveLineBar kbar)) (toUnit C)]


end AlgebraicGeometry
