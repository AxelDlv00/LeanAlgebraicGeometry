# Strategy Critic Report

## Slug
iter034

## Iteration
034

## Routes audited

### Route: FBC-A — affine lemma, mate re-encoding

- **Goal-alignment**: PASS — produces `IsIso pushforwardBaseChangeMap` for the affine case, the i=0 base-change iso the goal names.
- **Mathematical soundness**: PASS — the affine flat-base-change comparison IS the mate of the base-change 2-square; organizing it via `mateEquiv`/`conjugateEquiv` for the composite adjunctions is the canonical categorical encoding, and `regroupEquiv` (DONE) supplies the module-level iso that makes β an iso.
- **Sunk-cost reasoning detected**: no — the pivot ABANDONS the ~15-iter direct route; that is anti-sunk-cost (correctly cutting losses), not sunk-cost. (The phrase "ABANDONED after ~15 iters" is per-iter narrative — a format issue, not a reasoning defect.)
- **Infrastructure-deferral detected**: no — this is a *valid re-leveling*, not a hollow pivot. The hardest prerequisite genuinely changes: before, the cross-layer mate coherence (F2/F3 cancellers) had "no term-mode form" under the `X.Modules` diamond; after, that same coherence is discharged by *proven Mathlib lemmas* (`mateEquiv_counit`, `unit_mateEquiv`, `mateEquiv_vcomp`, `conjugateEquiv_mateEquiv_vcomp`) at the functor layer where the diamond never forms. Moving a coherence from "prove by hand under a diamond" to "cite from the library" passes the pivot test.
- **Phantom prerequisites**: none. `CategoryTheory.mateEquiv`, `conjugateEquiv`, `conjugateEquiv_iso` (IsIso transport), and the composite-adjunction vcomp laws all VERIFIED in `Mathlib.CategoryTheory.Adjunction.Mates`. `gammaPushforwardNatIso` is project material (not a Mathlib claim).
- **Effort honesty**: reasonable-but-optimistic — 2–4 iters / ~120–280 LOC is in the ballpark of the comparable `RegroupHelper` categorical-transport unit (011·4, ~120 LOC), but the lower bound assumes Mathlib's mate API expresses the pasted *composite-adjunction* square with no project bridge — which is still Open-Q2. If a thin pasting bridge is needed, expect the upper end.
- **Parallelism under-exploited**: no.
- **Verdict**: SOUND — with one risk the planner must hold in view (below), already partly captured by Open-Q2.

**Residual risk to verify before committing prover budget.** The route only pays off if the identification `pushforwardBaseChangeMap ≅ mateEquiv adjL adjR β` (or its `.symm`) is either definitional or provable from the library mate lemmas. If `pushforwardBaseChangeMap` is defined concretely (unit/counit-built) rather than as a mate, proving that identification could re-import the abandoned term-mode diamond fight at the natural-transformation level. This is exactly Open-Q2 ("does the API express the pasted square directly, or must a thin bridge be built"); the iter-034 mathlib-analogist dispatch should confirm the *identification* is tractable, not just that `mateEquiv` exists.

### Route: FBC-B — globalization, H⁰-equalizer

- **Goal-alignment**: PASS — `H⁰(X,F)` as the sheaf-condition equalizer `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)` plus "flat preserves this finite equalizer" is the standard Čech-free globalization (Stacks 02KH part 2). Decomposition is correct.
- **Mathematical soundness**: PASS — the sheaf-condition equalizer of section-modules is the kernel of the difference of restriction maps; a flat `−⊗B` preserves that kernel. Sound.
- **Phantom prerequisites**: `tensorEqLocusEquiv` in `Mathlib.RingTheory.Flat.Equalizer` — **the module EXISTS, but no lemma is named `tensorEqLocusEquiv`.** The correct anchor in that module is `LinearMap.tensorKerEquiv` / `tensorKer` (flat preserves the kernel of a linear map). Caution: the *category-level* equalizer-preservation that loogle surfaces — `CommRingCat.Under.tensorProdMapEqualizerForkIsLimit` / `PreservesLimitsOfShape WalkingParallelPair (R.tensorProd S)` — lives in **CommRingCat-under-R (ring maps)**, NOT module/section land; the sheaf condition is an equalizer of *modules/abelian groups*, so the ring-level fork is the wrong hook. The right anchor is the module-level `tensorKerEquiv`.
- **Effort honesty**: reasonable — 2–5 iters / ~100–260 LOC; L1/L2 + finite-fork DONE.
- **Parallelism under-exploited**: no — the build-ahead `eqLocus` sub-lane (ModuleCat-over-A reformulation feeding `tensorKerEquiv`, independent of the affine sorry) is exactly correct parallelism; the downstream chain links are genuinely gated on FBC-A (you need the affine iso to globalize), so serializing those is correct.
- **Verdict**: SOUND — fix the anchor name (`tensorEqLocusEquiv` → `LinearMap.tensorKerEquiv`) so a prover doesn't chase a phantom and land on the wrong-category ring fork.

### Route: GF — generic flatness (geometric)

- **Goal-alignment**: PASS — wraps the DONE algebraic core to `genericFlatness` over the affine-patch cover.
- **Mathematical soundness**: PASS — base `[IsIntegral S]` + `[QuasiCompact p]` correctly identified as necessary (generic flatness is false over non-reduced/reducible base). Patch-cover + `D(∏fⱼ)` argument is standard.
- **Phantom prerequisites**: none — `Module.flat_of_isLocalized_maximal` VERIFIED (`Mathlib.RingTheory.Flat.Localization`); `AlgebraicGeometry.HasRingHomProperty.appLE` VERIFIED.
- **Effort honesty**: reasonable — G1 gated on gap1 is a legitimate dependency.
- **Parallelism under-exploited**: minor — G3 (flat-locality assembly: per-patch freeness on a finite cover ⟹ flatness over `Γ(S,U)`) does NOT depend on gap1, only G1 does. G3 could be a FBC-B-style build-ahead sub-lane rather than waiting on the whole "GF dispatch deferred until gap1 lands." Worth splitting the row if throughput matters.
- **Verdict**: SOUND.

### Route: QUOT — defs/predicates + gap1 spine

- **Goal-alignment**: PASS — produces the QUOT defs/predicates and feeds `grassmannian_representable`.
- **Mathematical soundness**: PASS, no circularity found. The C→P1→D→assembly spine reduces qcoh≃Mod on affine to: local f.g. presentation (P1, via Mathlib's global-`Presentation` case `isIso_fromTildeΓ_of_presentation`) + section-localization descent (D, from `IsLocalization.flat` + sheaf equalizer) glued by the in-file iff. D is proven from localization-flatness + the sheaf condition, NOT from gap1 itself, so there is no "D needs the equivalence we're proving" loop. The SNAP-S1 "chosen f.g. presentation" route correctly sidesteps the doubtful "Γ_*(F) f.g." lemma.
- **Phantom prerequisites**: `Scheme.Modules.restrictFunctor`/`pullback` are asserted to exist (strategy says verified; I did not re-confirm — flagged only as a watch-item, the strategy explicitly corrected the earlier "no restriction functor" error). **Stacks tag for D is unconfirmed**: STRATEGY cites "Stacks 01HA" for `section_localization_descent`, but `references/summary.md` corroborates only 01I9 (widetilde pullback), 01PB/01B5 (finite-type), 00K1 (Hilbert–Serre) — not 01HA. The *mathematical content* (Hartshorne II.5.3) is correct and well-known; the tag number is a citation-hygiene item to confirm with a reference-retriever, not a blocker.
- **Effort honesty**: borderline — the gap1 row is `infra-gated` and gap1's C-step-2 ("geometric ring-sheaf identification") is described as the "current obstacle" with **no per-step iter estimate**. C-step-2 is a single-point bottleneck: it gates GF-G1, the QUOT annihilator characterization, and (transitively via Q1's "defer until gap1 lands") the entire SNAP/Hilbert-polynomial lane. The strategy is *actively* prosecuting it (C decomposed into 4 steps, step 1 DONE), so this is an active keystone, not avoidance — but the estimates don't fully own that one node carries three downstream lanes.
- **Parallelism under-exploited**: no — QUOT defs/predicates run parallel to FBC/GF; predicate sub-builds (P1 done, P2 next) proceed independently of gap1.
- **Verdict**: SOUND — confirm the Stacks tag and keep an eye on the C-step-2 concentration (see effort note).

## Format compliance

- **Size**: 145 lines / ~11 KB — within budget.
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, exact canonical order.
- **Per-iter narrative detected**: **yes** — pervasive. Representative verbatim: "direct-on-sections ABANDONED after ~15 iters"; "the iter-033 HARD-COMMIT round did not close `_legs`"; "Refactor planned iter-035 once the shape is confirmed"; "Decision (iter-024): build it ONCE QUOT-side"; plus repeated `(analogist iter-030)` / `(strategy-critic iter-031)` / `(mathlib-analogist iter-034)` attributions in prose. This is exactly the momentum/history narrative the fresh-context skeleton is meant to keep out of STRATEGY.md; it belongs in `iter/iter-NNN/plan.md`. (The `## Completed` `Iters` cells like `022 · ~9` are fine — that is the allowed ledger.)
- **Accumulation detected**: no — no fully-completed phase left in the active table (GR-cells, SNAP-S2 properly migrated to `## Completed`); Completed table at 6 rows, within bound. NOTE: the FBC-A `Risks` cell has ballooned into a full paragraph carrying the pivot narrative — fold its history into the iter sidecar and keep the cell to one short line.
- **Table discipline**: PASS structurally (correct columns both tables), but several `Risks` cells (FBC-A especially) violate "one short line per cell."
- **Format verdict**: DRIFTED — structure is clean; the violation is concentrated in per-iter-narrative pollution + overlong Risks cells. Scrub iter references from prose this iter.

## Prerequisite verification

- `CategoryTheory.mateEquiv`: VERIFIED (`Mathlib.CategoryTheory.Adjunction.Mates`).
- `CategoryTheory.conjugateEquiv` (+ `conjugateEquiv_iso`, `conjugateEquiv_of_iso`): VERIFIED.
- `CategoryTheory.mateEquiv_vcomp` / `conjugateEquiv_mateEquiv_vcomp` (composite-adjunction pasting laws): VERIFIED.
- `tensorEqLocusEquiv`: MISSING (no such name). Real anchor in the named module `Mathlib.RingTheory.Flat.Equalizer` = `LinearMap.tensorKerEquiv` / `LinearMap.tensorKer`. The category-level `CommRingCat.Under.tensorProdMapEqualizerForkIsLimit` exists but is ring-level (wrong category for the section equalizer).
- `Module.flat_of_isLocalized_maximal`: VERIFIED (`Mathlib.RingTheory.Flat.Localization`).
- `AlgebraicGeometry.HasRingHomProperty.appLE`: VERIFIED (`Mathlib.AlgebraicGeometry.Morphisms.RingHomProperties`).

## Must-fix-this-iter

- Route FBC-B: phantom prerequisite — `tensorEqLocusEquiv` does not exist. Replace the anchor in STRATEGY with the module-level `LinearMap.tensorKerEquiv` (in the same `Mathlib.RingTheory.Flat.Equalizer` module), and note the ring-level `tensorProdMapEqualizerForkIsLimit` is the wrong category, so a prover isn't sent to it.
- Route FBC-A: before spending prover budget, the iter-034 mathlib-analogist must confirm the *identification* `pushforwardBaseChangeMap ≅ mateEquiv adjL adjR β` is tractable (not merely that `mateEquiv` exists) — otherwise the abandoned diamond fight re-enters at the nat-trans level. (Captured by Open-Q2; make it explicit.)
- Route QUOT: confirm the Stacks tag for `section_localization_descent` — "01HA" is uncorroborated by `references/summary.md`; cite Hartshorne II.5.3 and verify the tag via a reference-retriever before the D prover lane.
- Format: DRIFTED — scrub per-iter references from `## Phases & estimations` Risks cells, `## Routes`, and `## Open strategic questions` prose (move "ABANDONED after ~15 iters", "iter-033 HARD-COMMIT", "planned iter-035", "(analogist iter-NNN)" attributions to the iter sidecar); compress the FBC-A Risks cell to one line.

## Overall verdict

The strategy is SOUND and the FBC-A mate re-encoding is endorsed: it is a legitimate re-leveling, not a hollow pivot, because the hardest prerequisite genuinely changes — the cross-layer coherence that had no term-mode form under the `X.Modules` diamond becomes an invocation of proven Mathlib mate lemmas (`mateEquiv_counit`, `unit_mateEquiv`, the vcomp laws) at the functor layer where the diamond never forms, and all named categorical infra (`mateEquiv`, `conjugateEquiv`, `conjugateEquiv_iso`) is verified to exist. No simpler route survives scrutiny: there is no off-the-shelf Mathlib flat-base-change-of-H⁰ for schemes (that is what the project builds), and the "regroupEquiv + cleaner transport" alternative IS the abandoned direct-on-sections route that hit the diamond. The one real risk is the identification step (already Open-Q2), which the mathlib-analogist must confirm is tractable. FBC-B's H⁰-as-equalizer decomposition and its build-ahead `eqLocus` sub-lane are well-chosen and correctly parallelized, but its named anchor `tensorEqLocusEquiv` is phantom — the correct module-level hook is `LinearMap.tensorKerEquiv`. The gap1 spine has no circularity (D is proven from localization-flatness + the sheaf condition, not from gap1), though C-step-2 is an unestimated single-point bottleneck gating three downstream lanes (GF-G1, the QUOT annihilator, and SNAP via Q1) — the strategy is actively prosecuting it, so this is keystone concentration to watch, not deferral-by-avoidance. The strategy does NOT improperly defer any goal-required construction. Format is DRIFTED: pervasive per-iter narrative ("ABANDONED after ~15 iters", "iter-033 HARD-COMMIT round", "planned iter-035") and overlong Risks cells must be scrubbed into the iter sidecar this iter.
