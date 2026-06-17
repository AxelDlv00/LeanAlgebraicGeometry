# Iter-172 Prover Objectives (detailed)

## Lane A — `AlgebraicJacobian/Genus0BaseObjects.lean`

**Status entering iter**: 10 sorries on file (L186, L193, L372, L624, L695, L705, L721, L762, L842, L872).

**iter-172 target**: close as many of `PRIMARY 1/2/3 + SECONDARY` as the prover budget supports.

### PRIMARY 1 — `mvPolyToHomogeneousLocalizationAway_surjective` (L372)

**Goal**: prove that the ring-hom `mvPolyToHomogeneousLocalizationAway kbar i` is surjective.

**Statement** (re-read the file for the exact signature):

```lean
private lemma mvPolyToHomogeneousLocalizationAway_surjective
    (kbar : Type u) [Field kbar] (i : Fin 2) :
    Function.Surjective (mvPolyToHomogeneousLocalizationAway kbar i) := by
  sorry
```

**Recipe**: image equals `Algebra.adjoin (𝒜 0) {isLocalizationElem (X i)}` which equals `⊤` by `Mathlib.RingTheory.GradedAlgebra.HomogeneousLocalization.Away.adjoin_mk_prod_pow_eq_top`. Specialise to `d = 1, v = ![X 0, X 1], dv = ![1, 1]`. Decompose any `Away.mk hf n a ha` along the monomial basis of `𝒜 n`; observe each `Away.mk hf n (X 0^k X 1^(n-k))` equals `α^k` on chart-1 / `α^(n-k)` on chart-0 where `α = isLocalizationElem (X i)`.

**Expected LOC**: ~60-80.

**Why important**: closes the iter-171 `aux_left` chain axiom-clean. Unblocks `homogeneousLocalizationAwayIso` propagating `sorryAx`-free; `projGm_isReduced` (L872) becomes attemptable; downstream `gmScalingP1_chart` (PRIMARY 3) becomes attemptable.

### PRIMARY 2 — `gmScalingP1_over_coherence` (L721)

**Goal**: each chart's composite to `Spec k̄` agrees with the structure morphism.

**Statement** (re-read the file for the exact signature):

```lean
noncomputable def gmScalingP1_over_coherence (kbar : Type u) [Field kbar] :
    ((gmScalingP1_cover kbar).glueMorphisms (gmScalingP1_chart kbar)
        (gmScalingP1_chart_agreement kbar)) ≫
      (ProjectiveLineBar kbar).hom =
      ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom := by
  sorry
```

(exact form may differ; check file)

**Recipe**: `Scheme.Cover.hom_ext` over `gmScalingP1_cover`, then for each chart `i` show the chart-morphism's composite to `Spec k̄` factors through `Spec.map (algebraMap kbar _)`. The chart morphism is built precisely to commute with the over-structure (the `Algebra.compHom kbar → 𝒜 0 → Away` chain). Should be mechanical.

**Expected LOC**: ~30-50.

**Why important**: mechanical; the most likely to close. Even if PRIMARY 1 doesn't close, PRIMARY 2 can land independently — the `gmScalingP1_chart` declaration is referenced but not unfolded inside the proof, so over-coherence can be proven generically over the cover.

### PRIMARY 3 — `gmScalingP1_chart kbar i` (L695)

**Goal**: define the chart-`i` scheme morphism.

**Recipe**: `pullbackSpecIso ≫ Spec.map gmScalingP1_chart_i_ringMap ≫ Spec.map homogeneousLocalizationAwayIso.symm ≫ Proj.awayι`.

Each chart: chart-1 sends `(x, λ) ↦ λx` (uses `gmScalingP1_chart1_ringMap` which sends `u ↦ u ⊗ λ` axiom-clean); chart-0 sends `(t, λ) ↦ t ⊗ λ⁻¹` similarly.

**Expected LOC**: ~30 per chart, ~60 total.

**Gating**: depends on `homogeneousLocalizationAwayIso` being axiom-clean (which requires `aux_left` axiom-clean — i.e. PRIMARY 1 must land). If PRIMARY 1 doesn't close, PRIMARY 3 cannot land axiom-clean.

### SECONDARY — `gmScalingP1_chart_agreement` (L705)

**Goal**: cocycle / agreement on overlap `D₊(X 0 · X 1)`.

**Recipe**: the substantive (0,1)/(1,0) cases reduce to the ring identity `λ · u = (1/t) · λ` in `Localization.Away t ⊗ GmRing`. See `analogies/gmscaling-deep.md` Q4 for the exact derivation. The (0,0) and (1,1) cases collapse by `pullback.lift_diag` / `pullback.diag_isPullback` self-overlap arguments.

**Expected LOC**: ~40.

**Gating**: requires PRIMARY 3 (chart morphisms) to be concrete. If PRIMARY 3 doesn't land, SECONDARY can't either.

### What NOT to attempt this iter

- `gm_grpObj` (L624) — iter-173 target via `GrpObj.ofRepresentableBy`.
- `projGm_isReduced` (L872) — gated on PRIMARY 1 landing axiom-clean (post that, attemptable iter-173).
- 3 genuine Mathlib gaps L186, L193, L842 — deferred indefinitely (confirmed real per lean-auditor `iter169`).
- `gmScalingP1_collapse_at_zero` (L762) — gated on PRIMARY 3.

### Lane A status targets

- **COMPLETE**: PRIMARY 1 + 2 + 3 + SECONDARY closed. 10 → 6 (-4).
- **PARTIAL-acceptable**: PRIMARY 1 + 2 OR PRIMARY 1 + 3 closed (any 2 of 3). 10 → 8 (-2).
- **PARTIAL-low**: PRIMARY 2 closed only. 10 → 9 (-1). Status fires iter-173 mathlib-analogist consult on `Away.adjoin_mk_prod_pow_eq_top` chain.
- **INCOMPLETE**: zero sorries closed. Reversal-trigger fires per progress-critic `route172`: iter-173 mathlib-analogist consult mandatory.

### Mathlib citations [verified]

- `Mathlib/RingTheory/GradedAlgebra/HomogeneousLocalization.lean:1064` (`Away.adjoin_mk_prod_pow_eq_top`) — for PRIMARY 1.
- `Mathlib/AlgebraicGeometry/Cover/Directed.lean` (`Scheme.OpenCover.glueMorphisms*`) — for PRIMARY 2/3.
- `Mathlib/AlgebraicGeometry/Pullbacks/Spec.lean` (`AlgebraicGeometry.pullbackSpecIso`) — for PRIMARY 3.
- `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean` (`Proj.awayι`) — for PRIMARY 3.

---

## Lane B — `AlgebraicJacobian/Picard/RelativeSpec.lean` (NEW file-skeleton)

**CONDITIONAL DISPATCH**: fires THIS iter only if `blueprint-writer route-a1-retry2` lands `Picard_RelativeSpec.tex` AND the iter-172 mandatory `blueprint-reviewer route172` clears HARD GATE for that chapter.

**Status entering iter**: file does not exist.

**Scope**:

1. Read `blueprint/src/chapters/Picard_RelativeSpec.tex` for the 6 declarations to scaffold:
   - `\lean{AlgebraicGeometry.Scheme.QcohAlgebra}` (Definition)
   - `\lean{AlgebraicGeometry.Scheme.RelativeSpec}` (Theorem)
   - `\lean{AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty}` (Theorem)
   - `\lean{AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff}` (Theorem)
   - `\lean{AlgebraicGeometry.Scheme.RelativeSpec.base_change}` (Theorem)
   - `\lean{AlgebraicGeometry.Scheme.RelativeSpec.functor}` (Theorem)

2. Create `AlgebraicJacobian/Picard/RelativeSpec.lean`:
   - Imports: `Mathlib.AlgebraicGeometry.AffineScheme`, `Mathlib.CategoryTheory.Sites.Sheaf`, and other Mathlib-side dependencies the declarations need.
   - `namespace AlgebraicGeometry.Scheme`.
   - For each declaration: write the signature exactly as the chapter pins; body `sorry`.
   - Each declaration carries a `/-- ... -/` docstring summarising its statement and citing the chapter label.

3. Update `AlgebraicJacobian.lean` umbrella to `import AlgebraicJacobian.Picard.RelativeSpec`.

4. `lake build AlgebraicJacobian.Picard.RelativeSpec` — must exit 0 (sorry warnings only).

**NOT in scope**: filling any body. The bodies are iter-173+ work.

**Expected LOC**: ~100-200.

---

## Lane C — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (NEW file-skeleton)

**Status entering iter**: file does not exist; chapter `RiemannRoch_WeilDivisor.tex` is on disk (445 LOC, 9 pins).

**Dispatch**: fires THIS iter assuming the mandatory `blueprint-reviewer route172` clears HARD GATE for the chapter.

**Scope**:

1. Read `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` for the 9 declarations to scaffold:
   - `\lean{AlgebraicGeometry.Scheme.WeilDivisor}` (Definition)
   - `\lean{AlgebraicGeometry.Scheme.RationalMap.order}` (Definition)
   - `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint}` (Definition)
   - `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree}` (Definition)
   - `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_hom}` (Theorem)
   - `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal}` (Definition)
   - `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_hom}` (Theorem)
   - `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_degree_zero}` (Theorem)
   - `\lean{AlgebraicGeometry.Scheme.WeilDivisor.LinearEquivalence}` (Definition)

2. Create `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`:
   - Imports: `Mathlib.AlgebraicGeometry.Scheme`, `Mathlib.RingTheory.Valuation.*`, `Mathlib.AlgebraicGeometry.Properties` and other Mathlib-side dependencies the declarations need.
   - `namespace AlgebraicGeometry.Scheme`.
   - For each declaration: write the signature exactly as the chapter pins; body `sorry`.
   - Each declaration carries a `/-- ... -/` docstring summarising its statement and citing the chapter label.

3. Update `AlgebraicJacobian.lean` umbrella to `import AlgebraicJacobian.RiemannRoch.WeilDivisor`.

4. `lake build AlgebraicJacobian.RiemannRoch.WeilDivisor` — must exit 0 (sorry warnings only).

**NOT in scope**: filling any body. The bodies are iter-173+ work (and RR.2 chapter must land first for the dimension-formula bodies).

**Expected LOC**: ~150-300.

---

## Constraints (all lanes)

- NO new axioms.
- NO protected signature touches (consult `archon-protected.yaml`).
- Build green for each touched file.
- Each sorry must be the body of a top-level named declaration; no buried sorries.
- All edits in your assigned file; no cross-file edits except updating `AlgebraicJacobian.lean` umbrella imports for Lane B / C.

## Cross-lane coordination

- Lane A edits `Genus0BaseObjects.lean`.
- Lane B edits `Picard/RelativeSpec.lean` (NEW).
- Lane C edits `RiemannRoch/WeilDivisor.lean` (NEW).
- All three lanes update `AlgebraicJacobian.lean` umbrella — coordinate with the parallel umbrella edits. (If Lane B + Lane C both touch the umbrella, the second one to commit will see the first one's edit; conflict resolution is mechanical line-add.)
- No file overlaps; lanes can run fully in parallel.
