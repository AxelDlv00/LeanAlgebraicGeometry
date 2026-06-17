# Lean ↔ Blueprint Check Report

## Slug
g0bo171

## Iteration
171

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`
  (covers G0BO via the `% archon:covers` declaration at L3)

## Per-declaration

For every `\lean{...}` block in the chapter that targets a `Genus0BaseObjects.lean`
declaration. (Blocks that target `AbelianVarietyRigidity.lean` / `RigidityLemma.lean`
are out of scope for this directive.)

### `\lean{AlgebraicGeometry.ProjectiveLineBar}` (chapter: `def:genus0_base_objects`, L913)
- **Lean target exists**: yes — `def ProjectiveLineBar (kbar : Type u) [Field kbar] : Over (Spec (.of kbar))` at L119.
- **Signature matches**: yes. The blueprint pins ``$\mathbb P^1 = \mathbb P^1_{\bar k}$ as an object of $\mathrm{Over}\,(\Spec \bar k)$''; Lean returns `Over (Spec (.of kbar))`.
- **Proof follows sketch**: N/A (definition).
- **notes**: Built on `Proj` of the standard ℕ-graded `MvPolynomial (Fin 2) kbar`, exactly as the chapter's bullet states (``Mathlib: projective space, or $\mathrm{Proj}$ of the graded polynomial ring'').

### `\lean{AlgebraicGeometry.Ga}` (chapter: `def:ga`, L949)
- **Lean target exists**: yes — `abbrev Ga` at L525.
- **Signature matches**: yes (`Over (Spec (.of kbar))`-valued).
- **Proof follows sketch**: N/A.
- **notes**: Encodes `AffineSpace (Fin 1) (Spec (.of kbar))` as the blueprint's bullet says.

### `\lean{AlgebraicGeometry.Gm}` (chapter: `def:gm`, L960)
- **Lean target exists**: yes — `abbrev Gm` at L569.
- **Signature matches**: yes.
- **Proof follows sketch**: N/A.
- **notes**: The Lean encoding is the AFFINE `Spec (Localization.Away t)` route; the chapter's prose says ``$\mathbb G_m = \mathbb A^1 \setminus \{0\}$'' — the affine encoding realises the same scheme but as a `Spec` rather than as a basic open of `𝔸¹`. The Lean header docstring (L41–46) explicitly flags this choice; chapter prose does not say which encoding (would be a clarity nit only).

### `\lean{AlgebraicGeometry.ProjectiveLineBar.zeroPt}` (chapter: `def:p1bar_zero`, L971)
- **Lean target exists**: yes — `def` at L493.
- **Signature matches**: yes. Both name a section `𝟙_ ⟶ ProjectiveLineBar kbar`; blueprint pins it as ``the morphism $\Spec \bar k \to \mathbb P^1$ in $\mathrm{Over}\,(\Spec \bar k)$ defined via $\mathrm{Proj.fromOfGlobalSections}$''. Lean uses `pointOfVec` which in turn uses `Proj.fromOfGlobalSections`. ✓
- **Proof follows sketch**: N/A.

### `\lean{AlgebraicGeometry.ProjectiveLineBar.onePt}` (chapter: `def:p1bar_one`, L985)
- **Lean target exists**: yes — `def` at L499. Signature matches. ✓

### `\lean{AlgebraicGeometry.ProjectiveLineBar.inftyPt}` (chapter: `def:p1bar_infty`, L997)
- **Lean target exists**: yes — `def` at L505. Signature matches. ✓

### `\lean{AlgebraicGeometry.Gm.onePt}` (chapter: `def:gm_one`, L1010)
- **Lean target exists**: yes — `def Gm.onePt` at L635.
- **Signature matches**: yes. Blueprint pins it as ``the unit map $\eta[\mathbb G_m] \colon \Spec \bar k \to \mathbb G_m$''; Lean body is exactly `η[Gm kbar]`. ✓

### `\lean{AlgebraicGeometry.gm_grpObj}` (chapter: `def:gm_grpObj`, L1023)
- **Lean target exists**: yes — `instance gm_grpObj` at L624.
- **Signature matches**: yes (`GrpObj (Gm kbar)`).
- **Proof follows sketch**: N/A (instance body is `sorry`, tracked in directive — NOT re-flagged).
- **notes**: Blueprint prose claims this is the live multiplicative-group structure and the lemma is consumed only as a carrier for `σ_×`. Lean docstring marks it as scaffold pending `GrpObj.ofRepresentableBy` with the units functor. Per directive, this is a known tracked sorry.

### `\lean{AlgebraicGeometry.projectiveLineBarAffineCover}` (chapter: `def:projlinebar_affine_cover`, L1050)
- **Lean target exists**: yes — `noncomputable def` at L207.
- **Signature matches**: yes (`.AffineOpenCover`). The blueprint's recipe (specialise `Proj.affineOpenCoverOfIrrelevantLESpan` to `f = (X 0, X 1)`, `m = (1, 1)`, and prove the irrelevant-ideal ⊆ span condition by monomial-degree argument) is realised verbatim in the Lean body.
- **Proof follows sketch**: yes — the body matches the blueprint's argument step-by-step (write a homogeneous element as a sum of monomials, each monomial has multi-index `d ≠ 0`, so divisible by `X 0` or `X 1`). ✓

### `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso}` (chapter: `def:proj_chart_ring_iso`, L1073)
- **Lean target exists**: yes — `noncomputable def` at L401.
- **Signature matches**: yes — `Away 𝒜 (X i) ≃+* MvPolynomial Unit kbar`.
- **Proof follows sketch**: yes — built via `RingEquiv.ofRingHom` from the forward (via `Localization.awayLift`) and inverse (via `MvPolynomial.eval₂Hom` with `isLocalizationElem`) directions, with the two round-trip identities supplied. Matches the chapter prose.
- **notes**: Chapter `% NOTE (iter-169)` at L1091-94 says ``the reverse round-trip … is currently a scaffold `sorry` … the iso therefore ships sorry-tainted''. As of iter-171 this NOTE is mildly stale: the reverse round-trip's body (`homogeneousLocalizationAwayIso_aux_left`) was rewritten this iter to a real cancel-surjective proof; the `sorryAx` taint now flows through the newly factored helper `mvPolyToHomogeneousLocalizationAway_surjective` instead. Iso is still sorry-tainted, but the residual has moved one node downstream. (Minor staleness.)

### `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_left}` (chapter: `lem:proj_chart_ring_iso_aux_left`, L1100)
- **Lean target exists**: yes — `private lemma` at L384.
- **Signature matches**: yes (`(mvPolyToHomogeneousLocalizationAway kbar i).comp (homogeneousLocalizationAwayToMvPoly kbar i) = RingHom.id _`).
- **Proof follows sketch**: **YES, the iter-171 rewrite now matches the blueprint's recommended ``cancel surjective'' route precisely.** The Lean body: `ext x; obtain ⟨p, rfl⟩ := mvPolyToHomogeneousLocalizationAway_surjective kbar i x; …` — combines surjectivity of inverse with the already-proven forward round-trip `aux_right`. This is exactly the path the chapter pre-described at L1110-1117.
- **notes**: `private` modifier on a `\lean{...}`-pinned declaration — leanblueprint typically resolves these fine since the fully-qualified name still exists in the namespace, but worth noting for the sync_leanok step.

### `\lean{AlgebraicGeometry.projectiveLineBar_isReduced}` (chapter: `lem:projlinebar_isReduced`, L1123)
- **Lean target exists**: yes — `instance` at L800.
- **Signature matches**: yes (`IsReduced (ProjectiveLineBar kbar).left`).
- **Proof follows sketch**: yes — chapter prose says ``two-chart affine cover + each chart-ring embeds via `val_injective` into the localized polynomial ring (a domain)''. The Lean body uses exactly `IsReduced.of_openCover` over `projectiveLineBarAffineCover`, with each chart's `IsDomain` produced by `Function.Injective.isDomain` on the `algebraMap → Localization.Away`. The chapter's `% NOTE` at L1554-1558 confirms this was closed axiom-clean iter-168. ✓

### `\lean{AlgebraicGeometry.gmScalingP1}` (chapter: `def:gaTranslationP1`, L1145)
- **Lean target exists**: yes — `noncomputable def` at L742.
- **Signature matches**: yes (`ProjectiveLineBar kbar ⊗ Gm kbar ⟶ ProjectiveLineBar kbar` in `Over (Spec (.of kbar))`).
- **Proof follows sketch**: PARTIAL — body is concrete `Over.homMk ((cover).glueMorphisms gmScalingP1_chart gmScalingP1_chart_agreement) gmScalingP1_over_coherence` with three named internal `sorry`s factored out (per directive, this is the planner's expected shape). The chapter prose's chartwise construction (chart-`x` `(x, λ) ↦ λx`, chart-`u = 1/x` `u/λ`) matches the intent of the chart-side ring maps `gmScalingP1_chart{0,1}_ringMap` (axiom-clean). Three tracked sorries remain at the chart-glue / agreement / over-coherence stage — directive-acknowledged, NOT re-flagged.
- **notes**: Chapter `% NOTE (iter-170 decision)` at L1147-1156 is **stale**: ``the Lean body of `gmScalingP1` still ships as a typed `sorry` THIS iter'' — this iter (171) the body is concrete; the sorry now lives at the three internal helpers (`gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence`) plus `gmScalingP1_chart_i_ringMap` (which iter-170 expected as the Step A target) is now actually axiom-clean as `gmScalingP1_chart0_ringMap`/`gmScalingP1_chart1_ringMap`. NOTE should be refreshed to reflect iter-171 state.

### `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` (chapter: `lem:gmScaling_fixes_zero`, L1206)
- **Lean target exists**: yes — `lemma` at L762.
- **Signature matches**: yes. Both sides express ``$\sigma_\times(0, \lambda) = 0$'' as the morphism equation `lift (toUnit _ ≫ zeroPt) (𝟙 _) ≫ gmScalingP1 = toUnit _ ≫ zeroPt`. ✓
- **Proof follows sketch**: N/A (body is `sorry`, gated on `gmScalingP1_chart` per directive — tracked, NOT re-flagged).
- **notes**: Chapter `% NOTE` at L1208-1213 honestly acknowledges the sorry is gated and reduces to a chart-1 computation; matches the Lean docstring's claim. No staleness here.

## Red flags

### Placeholder / suspect bodies

NONE beyond the 10 tracked sorries listed in the directive. Each tracked sorry is `:= sorry` (an explicit placeholder), not a fake-but-wrong body (`:= True`, `:= rfl` on a non-trivial claim, `:= Classical.choice _` masquerading as a proof, etc.). All are accompanied by honest status docstrings.

### Excuse-comments

NONE. The Lean file's status notes (e.g. ``Project-side scaffold sorry'', ``**Status:** typed sorry, gated on …'', ``Scaffold body — same discipline as `ga_grpObj`'') describe explicit `sorry` placeholders, not workarounds masquerading as real definitions. No ``-- TODO replace with real def'', no ``-- temporary'', no ``-- wrong but works for now'' patterns. The single comment that comes close — ``Currently sorry: blocked by Mathlib gap on Smooth → GeometricallyReduced'' on `projGm_isReduced` — is an honest tracking note on an explicit `sorry`, paired with a concrete chart-local alternative outline in the docstring.

### Axioms / Classical.choice on non-trivial claims

NONE. No `axiom` declarations. Standard `Classical.choice` propagation from `noncomputable` / `Function.Injective.isDomain` is invisible-to-kernel only.

## Unreferenced declarations (informational)

Declarations in `Genus0BaseObjects.lean` without a `\lean{...}` block in the chapter:

**Scheme-level infrastructure (helpers — acceptable to leave unreferenced):**
- `projectiveLineBarGrading`, `projectiveLineBarGrading_gradedRing`, `algebraKbarAway`
- `ProjectiveLineBarScheme`, `projectiveLineBarScheme_canOver`
- `otherFin`, `otherFin_zero/_one/_ne`, `chartEvalRingHom`, `chartEvalRingHom_X_self/_other/_C`, `kbarToAwayRingHom`
- `homogeneousLocalizationAwayToMvPoly`, `mvPolyToHomogeneousLocalizationAway`, `homogeneousLocalizationAwayIso_aux_right`
- `ProjectiveLineBar.evalIntoGlobal`, `ProjectiveLineBar.irrelevant_map_eq_top`, `ProjectiveLineBar.pointOfVec`
- `GaScheme`, `gaScheme_canOver`, `GmRing`, `GmScheme`, `gmScheme_canOver`

**Type-class instances (substantive but routine — most carry axiom-clean proofs):**
- `projectiveLineBar_isProper` (axiom-clean, real `IsProper` proof) — chapter prose at `def:genus0_base_objects` says ``$\mathbb P^1$ is proper'' but does not pin this specific instance. Minor.
- `projectiveLineBar_geomIrred`, `projectiveLineBar_smoothOfRelDim` (sorry, tracked)
- `ga_isAffineHom`, `ga_locallyOfFinitePresentation`, `ga_isReduced`
- `gm_isAffine`, `gm_locallyOfFinitePresentation`, `gm_isReduced`, `gmRing_isDomain`, `gm_irreducibleSpace`, `gm_smooth`
- `projGm_locallyOfFiniteType` (axiom-clean), `projGm_geomIrred` (axiom-clean conditional on `gm_geomIrred`), `gm_geomIrred` (sorry, tracked), `projGm_isReduced` (sorry, tracked)

These ``Lane A export'' instances are referenced by name in the chapter's `% NOTE (iter-167 review)` at L1542-L1552 and `% NOTE (iter-168 review)` at L1553-L1567 as the AVR.lean consumers' bridges. They are not, however, pinned via `\lean{...}` blocks. Per directive question 3, this is acceptable for routine instance-level scaffold but `projectiveLineBar_isProper` (a substantive axiom-clean proof, the chain that turns ``finite-type algebra over `𝒜₀`'' + ```algebraMap kbar 𝒜₀` bijective'' into `IsProper ℙ¹`) is the kind of milestone the chapter could pin. Minor.

**Substantive `sorry`-residual SUB-LEMMA, NOT pinned in blueprint:**
- `mvPolyToHomogeneousLocalizationAway_surjective` (L372, `private lemma`, body `sorry`, **substantive infrastructure**). The blueprint sketches the closure path at `lem:proj_chart_ring_iso_aux_left` ``prove that the inverse map $\bar k[u] \to \mathrm{Away}\,\mathcal A\,X_i$ is surjective … combine with the already-proven forward round-trip to cancel'' — and as of iter-171 the Lean has factored this into its own named lemma. **MAJOR finding** — the blueprint should add a sub-lemma block pinning this declaration now that it is the iso's true residual `sorry`. See ``Blueprint adequacy'' below.

**Three internal scaffolding helpers for `gmScalingP1`, NOT pinned in blueprint:**
- `gmScalingP1_chart` (L695, `sorry`, tracked)
- `gmScalingP1_chart_agreement` (L705, `sorry`, tracked)
- `gmScalingP1_over_coherence` (L721, `sorry`, tracked)
- (plus axiom-clean `gmScalingP1_chart0_ringMap`, `gmScalingP1_chart1_ringMap`, `gmScalingP1_cover`)

Per directive question 2 these may legitimately be unreferenced internal scaffold. The blueprint NOTE at `def:gaTranslationP1` L1147-1156 already calls out the chart-side ring maps `gmScalingP1_chart_i_ringMap` by name (anticipating Step A landing), so the chapter is aware of this scaffolding tier. Now that the three internal helpers are concrete named declarations carrying the three tracked sorries, blueprint coverage would benefit from `\lean{...}` blocks for each (so the sorry-status can be tracked per-declaration in `sync_leanok`). Minor-to-major.

## Blueprint adequacy for this file

A bidirectional check: does the chapter give a prover enough detail to formalize `Genus0BaseObjects.lean` correctly?

- **Coverage**: 13/~50 Lean declarations have `\lean{...}` blocks (covering ProjectiveLineBar, Ga, Gm, the three ℙ¹-points, Gm.onePt, gm_grpObj, projectiveLineBarAffineCover, homogeneousLocalizationAwayIso, homogeneousLocalizationAwayIso_aux_left, projectiveLineBar_isReduced, gmScalingP1, gmScalingP1_collapse_at_zero). Of the unreferenced declarations: ~30 are clean helpers/infrastructure (acceptable); 5 are substantive (`projectiveLineBar_isProper`, `mvPolyToHomogeneousLocalizationAway_surjective`, and the three internal `gmScalingP1_*` helpers). `mvPolyToHomogeneousLocalizationAway_surjective` is the one that meaningfully should be pinned now.
- **Proof-sketch depth**: ADEQUATE for the pinned blocks. The `def:projlinebar_affine_cover` body matches the Lean step-by-step (irrelevant-ideal ⊆ span via monomial degree); `lem:projlinebar_isReduced` correctly anticipates the `val_injective` + `Function.Injective.isDomain` chain; `lem:proj_chart_ring_iso_aux_left` precisely pre-described the iter-171 ``cancel surjective'' route that landed. The blueprint did a strong job of pre-specifying the proofs.
- **Hint precision**: PRECISE for the 13 pinned blocks (all signatures match). One UNDER-SPECIFICATION: the chapter prose for `def:gm` doesn't say which concrete encoding the Lean uses (affine `Spec` of `Localization.Away t` vs the basic-open of `𝔸¹`); the choice is load-bearing (the iter-167 analogist's D2.b verdict) but only documented in the Lean header docstring. Minor clarity gap.
- **Generality**: MATCHES NEED. No parallel API surfaced because the blueprint was too narrow.
- **Recommended chapter-side actions** (for the blueprint-writing subagent, NOT blocking):
  1. Add a sub-lemma block under `lem:proj_chart_ring_iso_aux_left` pinning `\lean{AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway_surjective}` — the substantive residual that the iter-171 ``cancel surjective'' rewrite now depends on. The closure path that the chapter sketches (``image equals `Algebra.adjoin 𝒜₀` of the localised generator, which is `⊤` by `Away.adjoin_mk_prod_pow_eq_top` specialised to `d = 1`'') is the actual Lean obligation and should pin a target.
  2. Refresh the `% NOTE (iter-170 decision)` on `def:gaTranslationP1` (L1147-1156) to reflect iter-171: the body of `gmScalingP1` is now a concrete `Over.homMk + Scheme.Cover.glueMorphisms`, with the three named internal sorries `gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence` factored out. The chart-side ring maps `gmScalingP1_chart{0,1}_ringMap` and the cover `gmScalingP1_cover` are axiom-clean.
  3. (Optional) Add `\lean{...}` blocks for the three internal `gmScalingP1_*` helpers so `sync_leanok` can track each sorry separately. They are sufficiently substantive (each carries a tracked sorry of distinct mathematical content — chart construction, cocycle, over-coherence) that per-declaration tracking would improve the dashboard signal.
  4. (Optional) Pin `\lean{AlgebraicGeometry.projectiveLineBar_isProper}` as a sub-lemma block — it is an axiom-clean substantive result (the `Algebra.FiniteType` chain + `algebraMap kbar 𝒜₀` bijection + properness of `Proj.toSpecZero`) that is currently only referenced in passing as ``$\mathbb P^1$ is proper'' in `def:genus0_base_objects` prose.
  5. (Optional) Refresh the `% NOTE (iter-169)` on `def:proj_chart_ring_iso` (L1091-94): the reverse round-trip body is no longer `sorry` itself but propagates `sorryAx` through the new `mvPolyToHomogeneousLocalizationAway_surjective` helper.

## Severity summary

Applied verbatim per spec:

- **must-fix-this-iter**: NONE.
  - The 10 known sorries listed in the directive are not re-flagged.
  - No fake bodies (`:= True`, `:= rfl` on non-trivial claims), no excuse-comments, no unauthorised axioms.
  - The pinned `gm_grpObj`'s placeholder body is directive-tracked.
  - All 13 pinned signatures match.
- **major**:
  - (one) `mvPolyToHomogeneousLocalizationAway_surjective` (Lean L372, substantive `sorry` that the iter-171 iso rewrite depends on) is NOT `\lean{...}`-pinned in the blueprint. The chapter sketches its closure path at `lem:proj_chart_ring_iso_aux_left` but no pinned sub-lemma exists. The blueprint-writer should add one so sorry-status can be tracked per-declaration.
- **minor**:
  - Blueprint `% NOTE (iter-170 decision)` on `def:gaTranslationP1` (L1147-1156) is stale (claims `gmScalingP1` body is `sorry`; iter-171 made it concrete).
  - Blueprint `% NOTE (iter-169)` on `def:proj_chart_ring_iso` (L1091-94) is mildly stale (the reverse round-trip's body is real now; residual has moved to the new surjectivity helper).
  - `def:gm` prose doesn't pin the affine-Spec vs basic-open encoding choice — load-bearing in the Lean, documented only in the Lean header docstring.
  - Three internal `gmScalingP1_*` helpers (chart, chart_agreement, over_coherence) lack `\lean{...}` blocks. The blueprint NOTE on `def:gaTranslationP1` already anticipates the chartwise scaffolding, so per-declaration pins would round out the bidirectional coverage but are not strictly required for soundness.
  - `projectiveLineBar_isProper` (axiom-clean) and `gm_irreducibleSpace` (axiom-clean) are substantive results not pinned individually.

Overall verdict: **PASS** — Genus0BaseObjects.lean faithfully realises the chapter's `def:genus0_base_objects` / `def:projlinebar_affine_cover` / `def:proj_chart_ring_iso` / `def:gaTranslationP1` (and companions); all 13 pinned signatures match, no excuse-comments, no fake bodies, no unauthorised axioms; the 10 known sorries are directive-tracked and the iter-171 ``cancel surjective'' iso rewrite landed exactly as the blueprint prose pre-described — but the blueprint should add one missing `\lean{...}` block for the new substantive `mvPolyToHomogeneousLocalizationAway_surjective` helper and refresh two stale iter-170/iter-169 NOTE comments.
