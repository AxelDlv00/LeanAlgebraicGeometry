# Lean Audit Report

## Slug
iter184

## Iteration
184

## Scope
- files audited: 4 (per directive — narrow audit of the iter-184 prover edits)
- files skipped (per directive): 6 — QuotScheme, RelativeSpec, OCofP, OcOfD, RRFormula, RationalCurveIso (their prover sessions hit the weekly API limit at first turn and committed no edits)

## Tier-1 axiom-clean verification

All four declarations named in the directive verify axiom-clean (`{propext, Classical.choice, Quot.sound}` only, no `sorryAx`):

- `AlgebraicGeometry.iotaGm_onePt_chart1_factor` — ✓ clean
- `RingTheory.Module.depth_eq_smallest_ext_index` — ✓ clean
- `AlgebraicGeometry.pullback_map_fst_proj` — ✓ clean
- `AlgebraicGeometry.pullback_map_snd_proj` — ✓ clean

(Verified via `lean_verify` against the four target files.)

## Per-file checklist

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: 4 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: none
- **notes**:
  - L29-30 (header): `morphism_P1_to_grpScheme_const` is described as "(Still a scaffold `sorry` pending the concrete ℙ¹/𝔾ₘ/σ_× infra.)". The declaration itself (L523) has no inline sorry — it propagates via `iotaGm_chart1_composition_isOpenImmersion` (L225, sub-task f) and via `gmScalingP1`'s chartwise sorries. The phrasing reads as if the parent body is still a scaffold; it isn't.
  - L520-522 (`morphism_P1_to_grpScheme_const` Status iter-166): claims propagated `sorryAx` "via the helper's residuals (three product-instance Mathlib bridges + dominance of the canonical `Gm → ℙ¹` map)". Stale — those four product-instance bridges shipped from Lane A, and `iotaGm_isDominant` is the only file-local sorry chain (which now bottoms out at sub-task f's `iotaGm_chart1_composition_isOpenImmersion`).
  - L586-589 (`rigidity_genus0_curve_to_grpScheme` Status iter-166): same staleness — references "helper's product-instance + dominance sorries", but iter-184 has consolidated these.
  - L342-345 (`iotaGm_isDominant` Status iter-181): "Lane B gating" wording predates iter-184 sub-task closures; sub-task (b) is now axiom-clean per `iotaGm_onePt_chart1_factor`.
  - Two compile-warned sorries:
    - L225 `iotaGm_chart1_composition_isOpenImmersion` — Tier-3 typed sorry, downstream-consumed by `iotaGm_isOpenImmersion` (L309). Has substantive docstring; honestly named.
    - L565 `genusZero_curve_iso_P1` — RR bridge, bare sorry, honestly named.

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
- **outdated comments**: 4 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 2 (underscore-prefix convention misused — see below)
- **excuse-comments**: none
- **notes**:
  - L29-43 (header §"Status iter-178"): lists "remaining five typed `sorry` bodies (`depth`, `depth_eq_smallest_ext_index`, `depth_of_short_exact`, `auslander_buchsbaum_formula`, `CohenMacaulay.of_regular`)". STALE: `depth` body landed (the supremum-with-`IM=M` clause is present, L146-151); `depth_eq_smallest_ext_index` closed iter-184 (Tier-1 verified); `depth_of_short_exact` closed via Helpers A+B; `CohenMacaulay.of_regular` reduces to the named helper `exists_isRegular_of_regularLocal`. Only 2 of the 5 carry a residual sorry (`auslander_buchsbaum_formula` L835, `exists_isRegular_of_regularLocal` L944).
  - L131-138 (`depth` docstring): "iter-176+: the body is the supremum ..." — describes the body as forthcoming. It is now actually that body — the description should reflect closed state.
  - L139-145 (`depth` iter-179 audit note): "the body stays a typed `sorry` until an iter-180+ body lane fills the supremum-with-`IM=M` clause directly". STALE — the body now IS that supremum.
  - L256-294 (`depth_eq_smallest_ext_index` docstring): the iter-183 status block lists "Residual `sorry`s (2 named inline branches)". STALE — the verify above confirms axiom-clean closure of both directions.
  - L857-864 (`CohenMacaulay` class doc): "the carrier definition is a typed `sorry` at the `Prop` level — substantively, the predicate is the named equality, but we package it as a `class` so use sites are uniform". Misleading — the class has a real field (`depth_eq_krullDim`), no sorry.
  - L146-147 `depth` def: parameters `(_I : Ideal R) (_M : Type v)` use the `_`-prefix convention for *unused* binders, yet the body uses both `_I` and `_M`. Should be `I` and `M`. Bad practice.
  - L186-188 `projectiveDimension`: same — `(_M : Type u) [AddCommGroup _M] [Module R _M]` is used in the body but underscore-prefixed. Bad practice.
  - Two compile-warned sorries:
    - L835 `auslander_buchsbaum_formula` — bare sorry, honestly named (multi-iter content).
    - L944 `exists_isRegular_of_regularLocal` — bare sorry for Stacks 00OD lower bound; docstring honestly documents the Mathlib gap (`IsRegularLocalRing ⟹ IsDomain`).

### AlgebraicJacobian/Albanese/CodimOneExtension.lean
- **outdated comments**: 3 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: none
- **notes**:
  - L39-49 (header §"Status iter-177 Lane 6 file-skeleton"): "Each of the six blueprint-pinned declarations carries the *intended* substantive type signature... with a `sorry` body. Bodies are iter-178+ work." STALE: `indeterminacyLocus` (L146), `isClosed_indeterminacyLocus` (L151), `CodimOneFree` (L180), `localRing_dvr_of_codim_one` (L302), `mem_domain_iff_exists_partialMap_through_point` (L492) all have substantive bodies. Only 3 of 6 pins still carry sorries (`smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`, `extend_of_codimOneFree_of_smooth`, `indeterminacy_pure_codim_one_into_grpScheme`).
  - L203-219 (`smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` Status iter-179): "We package both as a single internal `sorry` (the `hreg_dim` hypothesis below)". STALE after iter-184 — the iter-184 Lane M refactor split this conjunction into a `refine ⟨?_, ?_⟩`. The iter-184 status note is correctly added at L246-249, but the iter-179 narrative immediately above no longer matches the body shape.
  - L219-222: "The previous body was a bare `sorry`; this Lane-D refactor preserves the warning count at 1". Refers to iter-179 in past tense; iter-184 further refactored. Tense/narrative drift — minor.
  - Body of `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` L250-258 (the structured `refine ⟨?_, ?_⟩`): Krull-dim half closes axiom-clean via `Scheme.ringKrullDim_stalk_eq_coheight` from the new `CoheightBridge` import — verified honest. `IsRegularLocalRing` half is a typed sorry with the Stacks 00TT gap honestly documented.
  - Three compile-warned sorries:
    - L223 → typed sorry inside `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` (L254 — `IsRegularLocalRing` half).
    - L371 `extend_of_codimOneFree_of_smooth` — bare scaffold sorry, honestly named (Milne Theorem 3.1).
    - L412 `indeterminacy_pure_codim_one_into_grpScheme` — bare scaffold sorry, honestly named (Milne Lemma 3.3).

### AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean
- **outdated comments**: 1 flagged
- **suspect definitions**: 2 (dead helpers — see below)
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: none
- **notes**:
  - L51-69: the two new iter-184 helpers `pullback_map_fst_proj` / `pullback_map_snd_proj`. Both verify Tier-1 axiom-clean. They carry `@[reassoc (attr := simp)]` — i.e. they are globally active simp lemmas. NOT orphan dead-code: even though no in-tree declaration invokes them by name, the `@[simp]` attribute makes them fire automatically during any `simp` call across the project, and their intended call sites (Recipe 2/3 closure of `gmScalingP1_chart_agreement_cross01`) are documented in the docstring at L42-49. Acceptable as next-iter setup.
  - L116 `gmScalingP1_chart1_ringMap` (and L125 `gmScalingP1_chart0_ringMap`): both defined as `noncomputable def`s with substantive bodies (axiom-clean). Grep shows NO consumer in the codebase — `gmScalingP1_chart` at L186 inlines `MvPolynomial.eval₂Hom` directly rather than going through these helpers. The status comment at L535 references `gmScalingP1_chart1_ringMap` only descriptively. **Effectively dead-code stubs**: these were the iter-173 chart-bridge-recipe scratch helpers; the actual chart map was built differently. They should either be consumed by `gmScalingP1_chart` (so the body unfolds cleanly to them) or removed.
  - L271-278 (`gmScalingP1_chart_agreement_cross01` Status iter-182): "reducing it to a `Spec.map` of a single ring map ... requires either (a) `@[simps]` annotation on the iso, or (b) explicit projection lemmas for each stage. Both are out of iter-182 helper budget". STALE in iter-184: the two new `pullback_map_*_proj` helpers ARE option (b) for the `asIso (pullback.map _)` step. Comment should be updated to mark the helpers as landed but the consuming cocycle body as still iter-185+ work (lane terminated mid-flight per directive).
  - Four compile-warned sorries:
    - L412 `gmScalingP1_chart_agreement_cross01` — substantive cross-case sorry, honestly named (the iter-185+ target).
    - L539 `gmScalingP1_collapse_at_zero` — load-bearing fixed-point property, honestly named.
    - L621 `gm_geomIrred` — scaffold sorry, Mathlib gap honestly noted.
    - L651 `projGm_isReduced` — scaffold sorry, Mathlib gap honestly noted.

## Must-fix-this-iter

None. All sorries are honestly named typed-sorries or bare scaffold sorries with substantive documentation of the underlying Mathlib gap. No excuse-comments (no `TODO: replace`, `placeholder`, `temporary`, `wrong but works`, `will fix later`). No weakened-wrong definitions, no parallel-API copies of Mathlib, no `:= True` / `:= rfl` on non-trivial claims, no unauthorized axioms.

## Major

- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:116, 125` — `gmScalingP1_chart1_ringMap` / `gmScalingP1_chart0_ringMap`: defined-but-unused helpers from the iter-173 recipe. The actual `gmScalingP1_chart` body bypasses them. Either wire them in (so `gmScalingP1_chart` is built compositionally on top) or delete. Letting unused defs accumulate makes future audits noisier and signals "we explored multiple chart-bridge recipes and never cleaned up the loser".
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:146, 186` — `depth` and `projectiveDimension` parameters use the `_`-prefix convention (`_I`, `_M`) on binders that ARE used in the body. Lean's convention is `_x` = "deliberately unused"; using it on used binders is misleading and will trip up readers / automated tooling. Rename to `I`, `M`.

## Minor

- `AlgebraicJacobian/AbelianVarietyRigidity.lean:29-30, 520-522, 586-589, 342-345` — stale Status/header narrative that overclaims residual sorry locations. Pre-dates iter-184 Lane E sub-task closures. Doesn't actively mislead about correctness, but the docstrings on top-level results lie about *where* the propagated sorry lives.
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:29-43, 131-145, 256-294, 857-864` — header and per-declaration Status comments describe closed bodies as "iter-176+ work" or "typed `sorry`". The body content has caught up; the prose hasn't.
- `AlgebraicJacobian/Albanese/CodimOneExtension.lean:39-49, 203-222` — header Status and the helper's iter-179 narrative pre-date the iter-184 structured `refine ⟨?_, ?_⟩` refactor. Iter-184 leaves a fresh status note (L246-249) but doesn't reconcile the older narrative.
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:271-278` — `gmScalingP1_chart_agreement_cross01` Status names "explicit projection lemmas for each stage" as out-of-budget. With iter-184's new `pullback_map_*_proj` helpers landed, the narrative should note the helpers are now available; the actual cocycle body (use site) is what didn't land.

## Excuse-comments

None flagged. All `sorry`-bearing declarations carry substantive docstrings naming the Mathlib gap or the geometric content. No `-- TODO replace`, `-- placeholder`, `-- temporary`, `-- wrong but works`, `-- will fix later` style comments.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 — unused-helper cleanup (GmScaling.lean L116/125) + underscore-binder misuse on used params (AuslanderBuchsbaum.lean L146/186).
- **minor**: 12 — distributed stale status/narrative comments across all four files; characteristic of multi-iter prover incrementing without a docstring sweep.
- **excuse-comments**: 0

Overall verdict: **SOUND.** The iter-184 substantive code lands cleanly — four targeted Tier-1 axiom-clean claims all verify, the CodimOneExtension `refine ⟨?_, ?_⟩` refactor is honest (Krull-dim half closes via the new CoheightBridge import; `IsRegularLocalRing` half is a typed sorry with documented Stacks 00TT gap), and the two new GmScaling projection helpers compile axiom-clean with global `@[simp]` reach despite their intended use sites being deferred. The chief debt is documentation hygiene: per-declaration Status/iter-NNN narratives have drifted across the four files because each iter appends rather than reconciles. A targeted docstring sweep is not blocking but would clarify which residuals are now landed vs. still open. Two leftover GmScaling chart-ring-map defs (`gmScalingP1_chart{0,1}_ringMap`) appear to be unused scratch from the iter-173 recipe and should be either wired or deleted.
