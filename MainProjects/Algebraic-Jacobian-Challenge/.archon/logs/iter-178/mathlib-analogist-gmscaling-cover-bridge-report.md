# Mathlib Analogist Report

## Mode
api-alignment

## Slug
gmscaling-cover-bridge

## Iteration
178

## Question
What Mathlib idiom retires the two TEMPORARY axioms
`gmScalingP1_chart_data_temp` and `gmScalingP1_collapse_at_zero_temp` in
`AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (iter-177 HARD STOP
corrective)? Resolve the cover-vs-`Proj.awayι` syntactic mismatch via
`Scheme.AffineOpenCover.openCover_f` + `Matrix.cons_val` OR a structural
refactor of `gmScalingP1_cover_X_iso`; assess valuative-criterion
alternative as Open-Q fallback.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| (1) `openCover_f` + `Matrix.cons_val` recipe blocked by `match`-on-`i` decoration | ALIGN_WITH_MATHLIB | critical |
| (2) `Proj.affineOpenCoverOfIrrelevantLESpan` is the right cover; project already uses it | PROCEED | informational |
| (3) Uniform-in-`i` refactor of `gmScalingP1_cover_X_iso` (~85-130 LOC) | PROCEED | informational |
| (4) Valuative-criterion alternative: no savings, shifts the same blocker | DIVERGE_INTENTIONALLY | informational |

## Must-fix-this-iter

- **Decision (1) — `gmScalingP1_cover_X_iso` `match`-on-`i` decoration**:
  the project's `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:120-160`
  uses `match i with | ⟨0, _⟩ => … | ⟨1, _⟩ => …`. Lean's elaborator does NOT
  unfold `(![X 0, X 1]) ⟨0, _⟩` to `X 0` (the proof of `⟨0, h⟩.2` is a
  metavariable at elaboration time, so the `Matrix.cons` / `Fin.cons`
  computation rule never fires; verified empirically — see
  `analogies/gmscaling-cover-bridge.md`). This is the precise reason
  6 iters of helper-bridge attempts (iter-172 → iter-177) failed to
  penetrate. **Refactor**: make `gmScalingP1_cover_X_iso` uniform in `i`
  (eliminate the `match`; have the iso target use `((![X 0, X 1]) i)`
  generically), and hoist the inline `(fun i => by fin_cases i <;> simp […])`
  tactics in `BareScheme.lean:175-221`'s `projectiveLineBarAffineCover`
  to top-level named `noncomputable def projectiveLineBarAffineCover_fDeg`
  / `_hm` so the kernel doesn't `whnf` tactic-built proof closures during
  defeq. This unlocks `Scheme.AffineOpenCover.openCover_f` + the
  generic-`i` `rfl` (verified) so `pullbackSpecIso_hom_base` fires.

## Informational

- **Decision (2) — `Proj.affineOpenCoverOfIrrelevantLESpan`**: the project
  uses the canonical Mathlib idiom for Fin-indexed `Proj` chart covers
  (`Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic`). Alternatives
  (`Proj.affineOpenCover` — uses ALL elements; `Proj.openCoverOfMapIrrelevantEqTop`
  — wrong shape) don't apply. The structural issue is downstream
  decoration, not the cover choice. PROCEED.

- **Decision (4) — valuative-criterion alternative (STRATEGY.md Open Q
  pre-committed replacement candidate)**: Mathlib has
  `IsProper.of_valuativeCriterion`, `ValuativeCriterion.existence`,
  `ValuativeCriterion.uniqueness`, and `Scheme.RationalMap` / `PartialMap`
  with `dense_domain`. But Mathlib does NOT ship a "rational map from
  smooth curve to proper target extends to morphism" lemma — that's
  precisely Route A's A.4.a `Lemma 3.3 codim-1` lane (UNOWNED Mathlib gap,
  CRITICAL PATH risk). For the genus-0 sub-case, the same `Cover.glueMorphisms`
  blocker would surface (steps (i)/(iii) of the route) — NET no savings.
  DIVERGE_INTENTIONALLY from this fallback; stay on the chart-bridge route
  with the uniform-in-`i` refactor.

## Replacement plan (concrete; retires both TEMPORARY axioms)

### Step 1 — Hoist tactic-built proofs in `BareScheme.lean` (~12 LOC)

```lean
private noncomputable def projectiveLineBarAffineCover_fDeg
    (kbar : Type u) [Field kbar] :
    ∀ i, (![(MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar), MvPolynomial.X 1]) i ∈
      projectiveLineBarGrading kbar ((![1, 1] : Fin 2 → ℕ) i) :=
  fun i => by
    fin_cases i <;> simp [Matrix.cons_val_zero, Matrix.cons_val_one,
      MvPolynomial.isHomogeneous_X]

private lemma projectiveLineBarAffineCover_hm :
    ∀ i, 0 < (![1, 1] : Fin 2 → ℕ) i :=
  fun i => by fin_cases i <;> exact Nat.one_pos
```

Refactor `projectiveLineBarAffineCover` (`BareScheme.lean:175-221`) to
pass these by name instead of inline `by` tactics.

### Step 2 — Uniform-in-`i` `gmScalingP1_cover_X_iso` (net ~ -8 LOC)

```lean
private noncomputable def gmScalingP1_cover_X_iso (kbar : Type u) [Field kbar] (i : Fin 2) :
    (gmScalingP1_cover kbar).X i ≅
      Spec (CommRingCat.of
        (TensorProduct kbar
          (HomogeneousLocalization.Away (projectiveLineBarGrading kbar)
            ((![MvPolynomial.X 0, MvPolynomial.X 1] : Fin 2 → _) i))
          (GmRing kbar))) :=
  pullbackSymmetry _ _ ≪≫
    pullbackRightPullbackFstIso _ _ _ ≪≫
    pullback.congrHom
      (awayι_comp_PLB_hom kbar
        ((![MvPolynomial.X 0, MvPolynomial.X 1] : Fin 2 → _) i)
        (projectiveLineBarAffineCover_fDeg kbar i))
      (show (Gm kbar).hom =
          Spec.map (CommRingCat.ofHom (algebraMap kbar (GmRing kbar))) from rfl) ≪≫
    pullbackSpecIso kbar _ (GmRing kbar)
```

Target type now uses `((![X 0, X 1]) i)` ⟹ defeq with the cover's
generic `.f i` post-`pullback₁`-and-`openCover_f`. `pullback.congrHom`
applies generically; `pullbackSpecIso` lands at the canonical tensor-Spec.

### Step 3 — Retire the two TEMPORARY axioms (~80-125 LOC across 3 lemma bodies)

- **`gmScalingP1_chart_PLB_eq`** (~30-50 LOC): follow the 10-step recipe
  from `analogies/chart-bridge-shared-helper.md` Decision 3 verbatim.
  With Step 2's uniform iso, `pullbackSpecIso_hom_base` fires
  syntactically; the `homogeneousLocalizationAwayIso_algebraMap` lemma
  (axiom-clean since iter-174) supplies the kbar-algebra preservation
  pivot. After this body lands, **`gmScalingP1_chart_data_temp`'s first
  conjunct retires** as `(this lemma) ∧ (chart agreement)`.
- **`gmScalingP1_chart_agreement`** (~30-50 LOC): follow Sub-task B from
  `chart-bridge-shared-helper.md` — diagonal cases via
  `CategoryTheory.Limits.fst_eq_snd_of_mono_eq` (the cover's `.f i` is
  `IsOpenImmersion`, hence mono); cross cases `(0,1)/(1,0)` via the
  algebraic identity `λ·u = (1/t)·λ` in `Localization.Away t ⊗[kbar] GmRing`
  (per `analogies/gmscaling-deep.md` Q4). After this body lands,
  **`gmScalingP1_chart_data_temp`'s second conjunct retires**.
- **`gmScalingP1_collapse_at_zero`** (~15-25 LOC): chart-1's ring map
  sends `u ↦ u ⊗ λ`; `zeroPt` factors through chart-1 at `u = 0`; composite
  evaluates to `zeroPt` independently of `λ`. Apply `Cover.hom_ext` on
  `(ℙ¹ ⊗ Gm).left`, reduce on chart-1 to a ring-level identity in
  `MvPolynomial Unit kbar ⊗[kbar] GmRing` (constant-`0` collapse under
  `MvPolynomial.eval₂Hom`'s `X ()`-binding). After this body lands,
  **`gmScalingP1_collapse_at_zero_temp` retires**.

### Reversal trigger

If Step 2 cannot eliminate the syntactic mismatch even with the
uniform-in-`i` refactor (e.g., the chart-ring iso's kbar-algebra
preservation surfaces a fresh unification issue), iter-179 falls back to
the **partial `Fin.cases` refactor**: keep the case split in
`gmScalingP1_cover_X_iso` but use `Fin.cases` (canonical `(0 : Fin 2)`
index, not `⟨0, _⟩`) — empirically verified to trigger the right
`Matrix.cons_val` reduction at the kernel level.

## Persistent file
- `analogies/gmscaling-cover-bridge.md` — design-rationale + the four
  experimental probes that empirically isolated the
  `⟨0, _⟩`-vs-`(0 : Fin 2)` defeq blocker.

Overall verdict: refactor `gmScalingP1_cover_X_iso` uniform in `i` and
hoist the `projectiveLineBarAffineCover` proof-term tactics; this retires
both TEMPORARY axioms in ~85-130 LOC and STAYS on Route C (no valuative-criterion pivot).
