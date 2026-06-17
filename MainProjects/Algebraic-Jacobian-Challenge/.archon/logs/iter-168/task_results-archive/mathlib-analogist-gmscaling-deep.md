# Mathlib Analogist Report

## Mode
api-alignment

## Slug
gmscaling-deep

## Iteration
168

## Question

Six concrete, transcription-ready sub-questions for `gmScalingP1` and
`gmScalingP1_collapse_at_zero` at `AlgebraicJacobian/Genus0BaseObjects.lean:457`
and `:472`:

- **Q1** — exact API of `Proj.affineOpenCoverOfIrrelevantLESpan` specialised
  to `f := ![X 0, X 1]`.
- **Q2** — canonical Mathlib path to build
  `HomogeneousLocalization.Away (projectiveLineBarGrading kbar) (X i) ≃+*
  MvPolynomial Unit kbar` (the helper the iter-167 prover identified after
  `gm-grpobj-and-friends.md` was written).
- **Q3** — chart-side morphism via `pullbackSpecIso`.
- **Q4** — cross-chart agreement equation.
- **Q5** — `Scheme.Cover.glueMorphisms` signature + bridging from
  `AffineOpenCover`.
- **Q6** — proof body for `gmScalingP1_collapse_at_zero`.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1: 2-chart cover via `affineOpenCoverOfIrrelevantLESpan` | PROCEED | informational |
| Q2: `homogeneousLocalizationAwayIso` build path | NEEDS_MATHLIB_GAP_FILL | high-stakes |
| Q3: chart-side morphism via `pullbackSpecIso` | PROCEED | informational |
| Q4: cross-chart agreement on `Localization.Away t ⊗ GmRing` | PROCEED | informational |
| Q5: `glueMorphisms` signature + `AffineOpenCover.openCover` bridge | PROCEED | informational |
| Q6: `gmScalingP1_collapse_at_zero` body via chart-1 factor | PROCEED | informational |

## Informational

- **Q1 — `projectiveLineBarAffineCover`**: directly apply
  `Proj.affineOpenCoverOfIrrelevantLESpan`
  (`Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic:324`) with
  `ι := Fin 2`, `f := ![X 0, X 1]`, `m := ![1, 1]`. Only non-trivial step
  is the `hf` proof (`irrelevant ⊆ Ideal.span {X 0, X 1}`), ~10 LOC of
  MvPolynomial decomposition. **~15-20 LOC total.**

- **Q2 — `homogeneousLocalizationAwayIso`**: **NEEDS_MATHLIB_GAP_FILL**.
  Mathlib ships NO iso between `HomogeneousLocalization.Away` and a polynomial
  ring (verified via `lean_loogle "HomogeneousLocalization.Away ≃+*"` and
  `lean_loogle "HomogeneousLocalization _ _ →+* MvPolynomial"`, both no results).
  The project owes a `~60-90 LOC` helper (NOT 30 LOC as iter-167's
  `gm-grpobj-and-friends.md` estimated — the `Quotient.lift` well-definedness +
  `val_injective` round-trip is what consumes the LOC). **Sub-task breakdown**:
  `invFun` via `MvPolynomial.aeval` (~5 LOC) + `toFun` via `Quotient.lift`
  (~20-25 LOC, the hardest) + ring-hom axioms (~10 LOC) + `left_inv` via
  `val_injective` (~20-25 LOC) + `right_inv` via `induction_on` (~10 LOC).
  See `analogies/gmscaling-deep.md` Decision Q2 for the verbatim code skeleton.

  **Alternative considered + rejected**: build through
  `Away.adjoin_mk_prod_pow_eq_top` + `Algebra.adjoin_eq_top_iff_isIso_aeval`.
  Rejected because it still requires showing aeval is injective (the harder
  half), and is no shorter.

  This single helper unlocks Q3, Q4, Q6 — all four downstream uses gate on it.

- **Q3 — chart-side morphism**: use `pullbackSpecIso (kbar) (MvPolynomial Unit kbar)
  (GmRing kbar)` to identify the chart-i pullback with `Spec((k̄[u] ⊗ k̄[λ,λ⁻¹]))`,
  then a ring map `k̄[u] →+* k̄[u] ⊗ k̄[λ,λ⁻¹]` built via
  `MvPolynomial.eval₂RingHom` (sending `X () ↦ u ⊗ λ` on chart-1, `X () ↦ u ⊗ λ⁻¹`
  on chart-0 via `IsLocalization.Away.invSelf`), then `Spec.map` of the inverse
  Q2 iso to land back in `Away 𝒜 (X i)`, then `Proj.awayι`.
  **WARNING**: the prover must work in `Over (Spec k̄)` from the start (via
  `Over.homMk`) or pay a bridge tax at every `simp`. **~30 LOC** for both charts.

- **Q4 — cross-chart agreement**: by the chosen scaling convention
  `σ_×([X 0:X 1], λ) = [λ X 0 : X 1]`, chart-0 sends `t = X 1/X 0 ↦ t/λ`
  and chart-1 sends `u = X 0/X 1 ↦ λ·u`. On the intersection
  `D₊(X 0)∩D₊(X 1)` with localisation ring `Localization.Away t ⊗ GmRing
  = k̄[t,t⁻¹,λ,λ⁻¹]`, both restrict to the identification `λ·u = 1/(t/λ) = λ/t`,
  which is true because `u·t = 1` in `Localization.Away t`. Closure tactic:
  `pullbackSpecIso_inv_fst/_snd` to expose ring maps, then
  `Algebra.TensorProduct.tmul_mul_tmul` + `IsLocalization.Away.mul_invSelf`.
  **~40 LOC** for both cross cases via `fin_cases`.

- **Q5 — `glueMorphisms` bridge**: `Scheme.Cover.glueMorphisms`
  (`Mathlib.AlgebraicGeometry.Gluing:436`) takes `OpenCover.{v} X`, not
  `AffineOpenCover`. Bridge: `(projectiveLineBarAffineCover kbar).openCover`
  (the `AffineCover.cover` field via `AffineOpenCover.openCover`,
  `Cover/Open.lean:128`). For the product, use `OpenCover.pullback₁`
  (`Cover/MorphismProperty.lean:177`) applied to `pullback.fst ProjectiveLineBar.hom
  Gm.hom`. Index type stays `Fin 2`. **~1 line of bridging code.**

- **Q6 — `gmScalingP1_collapse_at_zero`**: chart-level direct computation.
  `zeroPt = pointOfVec (v 0 := 0, v 1 := 1) 1` lives in chart-1 (since `v 1 = 1`
  is the unit coord). After Q2's iso, `zeroPt` factors as `Spec.map (X () ↦ 0)
  ≫ awayι (X 1)`. Composed with `gmScalingP1`'s chart-1 ring map
  `u ↦ u·λ`, we get `(X () ↦ 0) ≫ (u ↦ u·λ)` = `u ↦ 0·λ = 0` = constant at
  `zeroPt`. **~30-50 LOC**, requires a helper
  `zeroPt_left_factors_through_chart1` (~15 LOC) via
  `Proj.fromOfGlobalSections_morphismRestrict` (`Basic.lean:493`).

**Total LOC estimate for the iter-168 prover lane**: **~190-265 LOC** for the
six steps. The previous iter-167 estimate was off because it under-counted Q2
by 2-3x.

**Critical drop-warning for the prover**: if step 2 (Q2) exceeds ~120 LOC,
pause and reconsider upstreaming `homogeneousLocalizationAwayIso` as a focused
Mathlib PR. The in-project version is what closes iter-168's lane though, so
do NOT bail on the recipe before hitting 120 LOC.

## Persistent file
- `analogies/gmscaling-deep.md` — deep recipe for `gmScalingP1` build (an
  extension of `analogies/gm-grpobj-and-friends.md`, with the Q2
  `homogeneousLocalizationAwayIso` helper's transcription-ready skeleton and
  realistic LOC budget).

Overall verdict: `gmScalingP1` is **transcribable in iter-168** via a 6-step
lane totalling ~190-265 LOC; the long pole is the
`homogeneousLocalizationAwayIso` Mathlib-gap helper (~60-90 LOC), which iter-167
under-budgeted at 30 LOC.
