# Iter-168 objectives detail

## Objective 1 — `AlgebraicJacobian/Genus0BaseObjects.lean`

**Lane A drill: `gmScalingP1` body via the 6-step `gmscaling-deep` recipe.**

### Authoritative references for the prover

- **Primary**: `analogies/gmscaling-deep.md` (iter-168 deep recipe, ~190-265
  LOC; Decision Q2 carries the transcription-ready
  `homogeneousLocalizationAwayIso` skeleton).
- **Baseline**: `analogies/gm-grpobj-and-friends.md` (iter-167 baseline; Q1
  PROCEED, Q3 PROCEED, Q4 individual verdicts).
- **Blueprint chapter**: `blueprint/src/chapters/AbelianVarietyRigidity.tex`,
  `def:genus0_base_objects` block (~L913), `def:gaTranslationP1` block (~L1052),
  `lem:gmScaling_fixes_zero` (~L1103).

### Attack order (sequential within the lane)

1. **`projectiveLineBarAffineCover`** — install
   `Scheme.AffineOpenCover` via `Proj.affineOpenCoverOfIrrelevantLESpan`
   specialised to `ι := Fin 2`, `f := ![X 0, X 1]`, `m := ![1, 1]`. The `hf`
   hypothesis (`irrelevant ⊆ Ideal.span {X 0, X 1}`) is the only non-trivial
   step (~10 LOC of `MvPolynomial` decomposition). **~15-20 LOC, axiom-clean.**
2. **`homogeneousLocalizationAwayIso`** — see `analogies/gmscaling-deep.md`
   Decision Q2 for the transcription-ready code skeleton. Built as a
   `RingEquiv` between `HomogeneousLocalization.Away (projectiveLineBarGrading
   kbar) (X i)` and `MvPolynomial Unit kbar`. Components:
   - `invFun` via `MvPolynomial.aeval` (~5 LOC)
   - `toFun` via `Quotient.lift` (~20-25 LOC, the hardest)
   - ring-hom axioms (~10 LOC)
   - `left_inv` via `val_injective` (~20-25 LOC)
   - `right_inv` via `induction_on` (~10 LOC)
   **~60-90 LOC, axiom-clean. 120-LOC drop-warning per analogist.**
3. **Close `projectiveLineBar_isReduced` (L522)** — `IsReduced.of_openCover`
   over the cover from step 1; each chart is `Spec (HomogeneousLocalization.Away
   𝒜 X_i)`, identified with `Spec (MvPolynomial Unit kbar)` via the iso from
   step 2; polynomial ring over a field is a domain, hence reduced. **~10-15
   LOC, axiom-clean once steps 1+2 land.**
4. **Chart-side morphism** — for `i ∈ Fin 2`, build the morphism
   `Spec(MvPolynomial Unit kbar) ⊗ GmRing kbar ⟶ Spec(MvPolynomial Unit kbar)`
   in `Over (Spec k̄)` via `pullbackSpecIso (kbar) (MvPolynomial Unit kbar)
   (GmRing kbar)` + `MvPolynomial.eval₂RingHom` (chart 0: `X () ↦ u ⊗ λ`;
   chart 1: `X () ↦ u ⊗ λ⁻¹` via `IsLocalization.Away.invSelf`) + `Spec.map`
   of the inverse step-2 iso + `Proj.awayι`. **WORK IN `Over (Spec k̄)` FROM
   THE START via `Over.homMk`** to avoid the bridge tax. ~30 LOC.
5. **Cross-chart agreement** — the equation `pullback.fst _ _ ≫ f₀ =
   pullback.snd _ _ ≫ f₁` after the convention `σ_×([X₀:X₁], λ) = [λ·X₀:X₁]`:
   chart 0 sends `t = X₁/X₀ ↦ t/λ`; chart 1 sends `u = X₀/X₁ ↦ λ·u`. On the
   intersection both reduce to `λ·u = 1/(t/λ) = λ/t`, which is true because
   `u·t = 1` in `Localization.Away t`. Closure: `pullbackSpecIso_inv_fst/_snd`
   + `Algebra.TensorProduct.tmul_mul_tmul` + `IsLocalization.Away.mul_invSelf`,
   discharged via `fin_cases`. ~40 LOC.
6. **`gmScalingP1` body** — glue via `Scheme.Cover.glueMorphisms` over
   `(projectiveLineBarAffineCover kbar).openCover` (using
   `AffineOpenCover.openCover`, `Mathlib.AlgebraicGeometry.Cover.Open.lean:128`).
   For the product cover, `OpenCover.pullback₁` (`Cover/MorphismProperty.lean:177`)
   applied to `pullback.fst ProjectiveLineBar.hom Gm.hom`. ~1-line bridging
   code. Total ~5 LOC.
7. **`gmScalingP1_collapse_at_zero` body** — chart-level direct computation:
   `zeroPt = pointOfVec (v 0 := 0, v 1 := 1) 1` lives in chart-1 (since
   `v 1 = 1` is the unit coord). After step 2's iso, `zeroPt` factors as
   `Spec.map (X () ↦ 0) ≫ awayι (X 1)`. Composed with `gmScalingP1`'s chart-1
   ring map `u ↦ u·λ`, we get `(X () ↦ 0) ≫ (u ↦ u·λ)` = `u ↦ 0·λ = 0`,
   constant at `zeroPt`. Requires a helper
   `zeroPt_left_factors_through_chart1` (~15 LOC) via
   `Proj.fromOfGlobalSections_morphismRestrict` (Mathlib
   `ProjectiveSpectrum/Basic.lean:493`). ~30-50 LOC.
8. **OPT-IN — `ga_grpObj`** — `GrpObj.ofRepresentableBy` with
   `T ↦ AddGrpCat.of Γ(T.left, ⊤)` and `AffineSpace.homOverEquiv`
   (`Mathlib.AlgebraicGeometry.AffineSpace.lean:155`) as the single Mathlib
   lemma discharging the bijection chain. Per iter-167 analogist
   `gm-grpobj-and-friends.md` Decision Q2 (bonus): FREE 2-3 LOC.

### Acceptance gate (per-target)

- **PRIMARY (steps 1+2 axiom-clean)**: COMPLETE if both land with `lean_verify`
  reporting `{propext, Classical.choice, Quot.sound}` (no sorryAx, no new
  axioms).
- **HIGH (steps 3-7 closing + `gmScalingP1` body)**: status proportional to
  how many sub-steps land axiom-clean. Each step's success/failure recorded
  individually.
- **OPT-IN (step 8 `ga_grpObj`)**: never gates the iter's status.

### Negative signals → escalate, NOT another helper round

- Step 2's `Quotient.lift` well-definedness exceeds 30 LOC → soft warning, push
  on.
- Step 2's `val_injective`/`induction_on` `left_inv`/`right_inv` exceed 50 LOC
  combined (i.e. Q2 total exceeds 120 LOC, the analogist's drop-warning) →
  pause, surface PARTIAL with the residual line count, do NOT bail; iter-169
  decides upstream-vs-continue.
- Step 1 (cover) itself fails → INCOMPLETE; iter-169 user-escalation (this
  would indicate the analogist's Mathlib API analysis is wrong, which would
  be surprising — Q1 was the simplest of the six).
- Any new `axiom` declaration → REJECT the result; the prover must revise.

### Notes for the prover

- The `homogeneousLocalizationAwayIso` helper is a Mathlib gap-fill. It is
  the project's NEW MATERIAL that the project owes upstream. The transcription-ready
  skeleton in `analogies/gmscaling-deep.md` Decision Q2 is your starting
  point — read it line-by-line.
- For step 4, the analogist warns: **work in `Over (Spec k̄)` via
  `Over.homMk` from the start** (do not try to live in the underlying
  category and convert at the end — every intermediate goal will pay the
  bridge tax in `simp`/`change`/`exact` overhead).
- The `gmScalingP1_collapse_at_zero` body (step 7) is independently
  closeable once `gmScalingP1` body is concrete; if you reach the end of the
  attempt budget after step 6, prioritize step 7 over step 8 (OPT-IN
  `ga_grpObj`).
- If `lake build AlgebraicJacobian.Genus0BaseObjects` goes red mid-attempt
  on a typeclass-synthesis issue, that's the bridge tax warning sign —
  re-route the goal into `Over` early.

### Off-limits this iter

- AVR.lean (all of it). The 2 AVR-side sorries (`iotaGm_isDominant`,
  `genusZero_curve_iso_P1`) are gated on Lane A (this iter's work)
  or upstream Mathlib (deferred). NOT a prover target.
- `Jacobian.lean` — gated on Route C closing first.
- `RigidityKbar.lean` — fallback artifact, off-path.
- `gm_grpObj` (L420), `projectiveLineBar_smoothOfRelDim` (L184),
  `projectiveLineBar_geomIrred` (L177), `projGm_isReduced` (L564),
  `gm_geomIrred` (L532). All NOT consumed by the rigidity critical path
  (re-verified this iter); deferred to a hygiene iter when Lane A has
  closed.
