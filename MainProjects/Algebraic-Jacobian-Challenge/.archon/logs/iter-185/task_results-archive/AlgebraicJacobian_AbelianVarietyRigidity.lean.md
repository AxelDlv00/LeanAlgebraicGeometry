# AlgebraicJacobian/AbelianVarietyRigidity.lean

## Lane E iter-185 outcome: PARTIAL on sub-task (f)

**Entering**: 2 sorries (L225 `iotaGm_chart1_composition_isOpenImmersion`; L565
`genusZero_curve_iso_P1`).
**Exiting**: 2 sorries (same locations; L238 + L659 in new numbering after
docstring update + body work). Sorry decrement gate **not** hit (would need 2 → 1).
Helper budget 0/1 (zero new helpers introduced).

## iotaGm_chart1_composition_isOpenImmersion (L238)

### Attempt 1
- **Approach:** Explicit canonical 3-step open-immersion factorisation
  `Spec(GmRing) → Spec(MvPoly Unit kbar) → Spec(Away 𝒜 X_1) → ℙ¹.left`, each
  factor an `IsOpenImmersion` instance:
  * **Step 1** — `Spec.map (CommRingCat.ofHom (algebraMap (MvPolynomial Unit kbar)
    (GmRing kbar)))`: `IsOpenImmersion.of_isLocalization (MvPolynomial.X () : ...)`
    (since `GmRing kbar = Localization.Away (X ())`).
  * **Step 2** — `Spec.map (CommRingCat.ofHom
    (homogeneousLocalizationAwayIso kbar 1).toRingHom)`: derived by lifting the
    `RingEquiv` to a `CommRingCat`-iso via
    `(homogeneousLocalizationAwayIso kbar 1).toCommRingCatIso.isIso_hom`, then
    `Spec.map`-functorial-on-iso (via `AlgebraicGeometry.instIsIsoSchemeMapOfCommRingCat`).
  * **Step 3** — `Proj.awayι (X 1) (isHomogeneous_X 1) Nat.one_pos`: Mathlib
    instance `AlgebraicGeometry.Proj.instIsOpenImmersionAwayι`.
- **Result:** **PARTIAL — substantive scaffold** (sorry count 2 → 2, helper
  budget 0/1). The canonical OI is explicitly constructed in the body; the
  conclusion reduces via `suffices` to a single Spec-map equation between
  affine schemes, which the body then progresses by two structural rewriting
  stages:
  * **Stage 1** (`← Spec.map_comp`, `← CommRingCat.ofHom_comp`): fuses the
    two trailing `Spec.map`s on the RHS into `Spec.map (CommRingCat.ofHom
    f_ring) ≫ Proj.awayι X_1` with `f_ring = (algMap (MvPoly Unit kbar)
    (GmRing kbar)).comp (homogeneousLocalizationAwayIso kbar 1).toRingHom`.
  * **Stage 2** (`unfold gmScalingP1_chart`, two `← Category.assoc`, `congr 1`):
    cancels the trailing `Proj.awayι X_1` factor on both sides (using `congr`
    structurally rather than `cancel_mono` — equivalent here since `Proj.awayι`
    is open immersion ⟹ mono).
  After these two stages, the residual goal is a clean Spec.map equation
  between affine schemes:
  ```
  (s ≫ (cover_X_iso 1).hom) ≫ Spec.map (chart-1 ring map) =
    Spec.map (CommRingCat.ofHom f_ring)
  ```
- **Key insight:** The underlying ring map of the LHS is the composite
  `(eval₂Hom ∘ iso) ∘ μ` where `μ : Away X_1 ⊗ GmRing → GmRing` is the ring
  map corresponding to `s ≫ (cover_X_iso 1).hom`. By the universal property
  of `pullbackSpecIso` + the section's `pullback.lift_fst/_snd` projections,
  `μ` satisfies:
  * `μ ∘ algMap (Away X_1) (Away ⊗ GmRing)` = `algMap kbar GmRing ∘ r_1_ring`
    (with `r_1_ring : Away X_1 → kbar` the ring map underlying `r_1`,
    sending `isLocalizationElem = X_0/X_1 ↦ 1 ∈ kbar`).
  * `μ ∘ includeRight (GmRing → Away ⊗ GmRing)` = `id_{GmRing}`.
  By multiplicativity `μ(a ⊗ b) = algMap kbar GmRing (r_1_ring(a)) · b`.
  Composed with the chart-1 ring map `eval₂Hom(X() ↦ isLocElem ⊗ algMap X())
  ∘ iso.toRingHom`, the underlying ring map collapses to
  `algMap MvPoly GmRing ∘ iso.toRingHom = f_ring` (case-by-case:
  `isLocalizationElem ↦ μ(isLocElem ⊗ algMap X()) = algMap kbar GmRing(1) · t
  = t = algMap MvPoly GmRing(X()) = f_ring(isLocElem)`; constants follow via
  `homogeneousLocalizationAwayIso_algebraMap`).
- **Dead end / blocker:** The chart-side chase requires unfolding
  `gmScalingP1_cover_X_iso` (private in `Genus0BaseObjects/GmScaling.lean`)
  to expose its `pullbackSymmetry ≫ pullbackRightPullbackFstIso ≫
  pullback.congrHom ≫ pullbackSpecIso` chain. From this prover file
  (`AbelianVarietyRigidity.lean`), the private name is inaccessible —
  `unfold gmScalingP1_cover_X_iso` rejects with `Unknown identifier`; the
  goal displays the iso as `AlgebraicGeometry.gmScalingP1_cover_X_iso✝`,
  blocking further structural rewriting.
- **Lemmas found / consulted:**
  * `AlgebraicGeometry.IsOpenImmersion.of_isLocalization` — verified, used.
  * `AlgebraicGeometry.IsOpenImmersion.comp` — verified instance, used.
  * `AlgebraicGeometry.Proj.instIsOpenImmersionAwayι` — verified instance, used.
  * `AlgebraicGeometry.instIsIsoSchemeMapOfCommRingCat` — verified instance, used.
  * `RingEquiv.toCommRingCatIso` + `.isIso_hom` — verified, used.
  * `AlgebraicGeometry.Spec.map_comp` — verified, used.
  * `AlgebraicGeometry.Spec.map_inj` / `Spec.map_injective` — verified, candidate
    for next-iter closure of the residual ring-map identity.
  * `pullbackSpecIso_hom_fst'` / `_hom_snd` / `_hom_base` — verified, candidate
    for next-iter `(cover_X_iso 1).hom ≫ Spec.map(_)` extraction.
  * `CategoryTheory.Limits.pullbackRightPullbackFstIso_hom_fst` / `_snd_assoc`
    — verified, candidate for next-iter cover-iso chain rewrites.
  * `pullback.congrHom_hom` — verified.
  * `MvPolynomial.isHomogeneous_X` — verified.
  * `homogeneousLocalizationAwayIso_algebraMap` (project lemma) — verified
    candidate for next-iter constant-side reduction.

### Next-iter recommendation

**Option A (lowest LOC, requires editing GmScaling.lean):** Drop `private` on
`gmScalingP1_cover_X_iso` in `Genus0BaseObjects/GmScaling.lean:154`. With the
iso exposed, the residual Spec.map equation closes via the chain:
1. `unfold gmScalingP1_cover_X_iso` to expose the 4-iso composition.
2. Decompose `s ≫ pullbackSymmetry ≫ pullbackRightPullbackFstIso ≫
   pullback.congrHom ≫ pullbackSpecIso` step-by-step via
   `pullbackSymmetry_hom_*`, `pullbackRightPullbackFstIso_hom_*`,
   `pullback.congrHom_hom`, `pullbackSpecIso_hom_fst'`/`_snd`.
3. Use the section's `pullback.lift_fst`/`_snd` (twice) to identify the
   `Gm.hom ≫ r_1` and `𝟙 Gm.left` components.
4. Identify the resulting Spec.map with `Spec.map (CommRingCat.ofHom f_ring)`
   by `Spec.map_inj` + ring-map identity (case analysis on `isLocElem` +
   constants, using `homogeneousLocalizationAwayIso_algebraMap`).
5. `Spec.map(f_ring)` closes the goal.
Estimated LOC: ~40-60 (matches the iter-183 task_result's docstring estimate).

**Option B (no edit to GmScaling.lean, more work):** Add public projection
lemmas to GmScaling.lean characterising `(cover_X_iso 1).hom ≫
Spec.map(algMap (Away X_1) (Away ⊗ GmRing))` and `(cover_X_iso 1).hom ≫
Spec.map(includeRight)`. These reduce to known forms by composing private
simp lemmas (`pullbackSpecIso_hom_fst'`/`_snd` in particular). Then iter-186
prover uses these lemmas at the residual goal. Estimated LOC: ~30 in
GmScaling.lean + ~20 here.

**Option C (alternative substrate):** Pivot to the `iotaGm_isOpenImmersion`
direct route via an explicit `gmScalingP1` chart-glue body (Lane B work).
This is essentially the genus-0 separated-locus alternative flagged in
STRATEGY.md Open Qs. Estimated LOC: ~150-200 across multiple iters.

## genusZero_curve_iso_P1 (L659) — unchanged this iter

Standing deferral: RR-bridge gated on RR.4 chain. Off-target for Lane E.

## Lemmas/instances discovered for next-iter use

- `RingEquiv.toCommRingCatIso.isIso_hom` packages `Spec.map(iso.toRingHom)`
  as a (proven) iso of schemes — useful idiom for "Spec of a chart-ring iso
  is iso" in any future chart-bridge proof.
- `IsOpenImmersion.comp` is an instance (`@[instance]`) but Lean's instance
  synthesis sometimes fails on multi-step compositions; the workaround used
  here is `@IsOpenImmersion.comp _ _ _ _ _ h_first h_rest` with explicit
  application.

## Sorry count

**Entering iter-185:** 2 (L225, L565)
**Exiting iter-185:** 2 (L238, L659)
Net: 0 (no decrement; substantive partial progress on L238).
