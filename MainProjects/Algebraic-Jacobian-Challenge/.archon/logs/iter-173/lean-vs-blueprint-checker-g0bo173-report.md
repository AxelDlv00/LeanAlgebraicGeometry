# Lean ↔ Blueprint Check Report

## Slug
g0bo173

## Iteration
173

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`
  (`% archon:covers` at L3 lists this file alongside `AbelianVarietyRigidity.lean` and `RigidityLemma.lean`.)

Build state at audit: `lean_diagnostic_messages` reports **0 errors** and **8 `declaration uses 'sorry'`** warnings — matching the directive's expected breakdown (3 iter-173-focus + 5 carry-over).

## Per-declaration

Only the iter-173-relevant `\lean{...}` blocks are expanded in full; carry-over blocks are touched at the end (Coverage section).

### `\lean{AlgebraicGeometry.gmScalingP1_chart}` (chapter: `def:gmscaling_chart`, L1304–L1343)
- **Lean target exists**: yes — `noncomputable def gmScalingP1_chart` at L908.
- **Signature matches**: yes. Chapter L1311–L1314 prescribes
  `gmScalingP1_chart : (kbar) → (i : Fin 2) → (gmScalingP1_cover kbar).X i ⟶ ProjectiveLineBarScheme kbar`;
  Lean writes exactly that, with the same `kbar : Type u, [Field kbar], i : Fin 2` argument shape.
- **Proof / definition body follows sketch**: yes. The chapter's "Construction recipe" (L1327–L1342) names four chained pieces:
  (i) `pullbackSpecIso` identifying the cover chart with `Spec(Away ⊗ GmRing)`,
  (ii) `Spec.map` of the chart-side ring map,
  (iii) the chart-ring iso `homogeneousLocalizationAwayIso`,
  (iv) `Proj.awayι` landing back in `ProjectiveLineBarScheme`.
  The Lean body L910–L927 assembles exactly this chain: `gmScalingP1_cover_X_iso ≫ Spec.map (eval₂Hom ... ∘ homogeneousLocalizationAwayIso) ≫ Proj.awayι`. The two-case `match i with | ⟨0,_⟩ | ⟨1,_⟩` branch is the documented `Matrix.cons_val_zero/one` non-defeq workaround (cf. the comment at L869–L872), not a divergence from the sketch.
- **notes**: blueprint mentions `analogies/chart-bridge.md` (iter-173) is "in flight" — the recipe Lean used; consistent with chapter intent.

### `\lean{AlgebraicGeometry.gmScalingP1_chart_agreement}` (chapter: `lem:gmscaling_chart_agreement`, L1345–L1379)
- **Lean target exists**: yes — `lemma gmScalingP1_chart_agreement` at L944.
- **Signature matches**: yes. Chapter prescribes `∀ x y : (gmScalingP1_cover kbar).I₀, pullback.fst ((cover).f x) ((cover).f y) ≫ chart x = pullback.snd … ≫ chart y` — the Lean signature L944–L949 is verbatim that.
- **Proof follows sketch**: N/A — body is `sorry` (top-level scaffold). The chapter's "Content of the equation" section (L1364–L1378) gives a faithful and detailed sketch (diagonal cases via `pullback.condition`, cross cases via the ring identity `λ·u = (1/t)·λ` in `Localization.Away t ⊗ GmRing`, gated on `gmScalingP1_chart` having a concrete body). The Lean docstring L935–L943 explicitly cross-references the same recipe ("via `fst_eq_snd_of_mono_eq` and the same in-proof `gmScalingP1_chart_PLB_eq` infrastructure used for `gmScalingP1_over_coherence`"). Iter-174 closure path is well-pinned.
- **notes**: top-level scaffold sorry per directive — NOT a placeholder masking a substantive claim. The Lean doc-comment explicitly cites the helper-budget=0 directive guidance ("If you can only land it with `sorryAx`-propagation through a new buried sorry, leave it as a top-level scaffold sorry instead"), consistent with the iter-173 prover lane discipline.

### `\lean{AlgebraicGeometry.gmScalingP1_over_coherence}` (chapter: `lem:gmscaling_over_coherence`, L1381–L1417)
- **Lean target exists**: yes — `lemma gmScalingP1_over_coherence` at L961.
- **Signature matches**: yes. Chapter L1392–L1397 prescribes `(cover).glueMorphisms chart agreement ≫ ProjectiveLineBar.hom = (ProjectiveLineBar ⊗ Gm).hom`; the Lean signature L961–L966 matches verbatim.
- **Proof follows sketch**: N/A — body is `sorry` (top-level scaffold). The chapter's "Reduction" paragraph (L1404–L1416) prescribes the `Scheme.Cover.hom_ext` ⇒ chart-wise reduction ⇒ `Spec.map (algebraMap kbar (Away ⊗ GmRing))` factoring argument. The Lean body L967–L989 spells out an EIGHT-STEP paper-proof outline (incl. `awayι_comp_PLB_hom` reuse + the two named sub-lemmas (a) kbar-linearity and (b) bridge-structure) that mirrors the chapter's recipe at finer grain. The Lean's iter-174 closure plan (~30 LOC in a follow-up `gmScalingP1_chart_PLB_eq` definition) is consistent with the chapter's "argument is therefore mechanical given that `def:gmscaling_chart` has a concrete body" claim.
- **notes**: scaffold sorry under the same `helper-budget = 0` discipline. iter-174-actionable.

### `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` (chapter: `lem:gmScaling_fixes_zero`, L1419–end of fragment)
- **Lean target exists**: yes — `lemma gmScalingP1_collapse_at_zero` at L1025.
- **Signature matches**: yes. Chapter prescribes the composite `(toUnit Gm ≫ zeroPt, 𝟙 Gm) ≫ σ_× = toUnit Gm ≫ zeroPt`; Lean signature L1025–L1028 matches (using `lift ... (𝟙 (Gm kbar))` for the pair).
- **Proof follows sketch**: N/A — body is `sorry`. Chapter `% NOTE` (L1424–L1432) and chapter proof body (L1441 onward) describe the chart-1 ring-map reduction "`X 0 ↦ 0 ⊗ λ = 0` in `Localization.Away t ⊗ GmRing`". Lean docstring L1021–L1024 cites exactly that reduction. Gate is on `gmScalingP1_chart` having a concrete body (just landed iter-173), so the closure is genuinely unlocked for iter-174.
- **notes**: same scaffold-sorry discipline.

## Red flags

None for the iter-173 prover edits. The three remaining sorries (`gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence`, `gmScalingP1_collapse_at_zero`) are explicitly top-level scaffold sorries authorized by the iter-173 directive's helper-budget=0 strict policy, with iter-174 closure plans fully documented both in Lean doc-comments and the chapter pins.

### Carry-over sorries (informational, NOT iter-173 must-fix)
For completeness, the 5 non-iter-173 sorries in this file (preserved from earlier iters):
- L188 `projectiveLineBar_geomIrred` — pinned only via `def:genus0_base_objects` instance enumeration (L913 vicinity), explicitly flagged as scaffold "Mathlib does not ship `GeometricallyIrreducible` for `Proj`".
- L195 `projectiveLineBar_smoothOfRelDim` — same instance block, same scaffold rationale.
- L768 `gm_grpObj` — pinned by `def:gm_grpObj` (L1034–L1037); known multi-iter deferral on the `GrpObj.ofRepresentableBy` units-functor build.
- L1107 `gm_geomIrred` — Mathlib base-change gap, documented in Lean docstring.
- L1135 `projGm_isReduced` — Mathlib `Smooth → GeometricallyReduced` gap, documented.

These are NOT flagged as iter-173 must-fix per the directive ("The other 5 sorries are carry-over from earlier iters and are not the focus of this round").

## Unreferenced declarations (informational)

The two new iter-173 helpers — `awayι_comp_PLB_hom` (L796) and `gmScalingP1_cover_X_iso` (L862) — are **`private`** declarations with no `\lean{...}` block in the chapter. **Acceptable** per the directive's Q3: they are internal lemmas of the body of `gmScalingP1_chart`, and the `private` modifier signals exactly this intent. Both have substantial docstrings explaining their role (`awayι_comp_PLB_hom` is generic in `f` to handle the `Matrix.cons_val` reduction; `gmScalingP1_cover_X_iso` mirrors `OpenCover.pullbackCoverAffineRefinementObjIso` and is required because `(Matrix.cons_val) i` is not definitionally `X i` for generic `i`). Neither is a "substantive" declaration whose absence from the chapter would constitute coverage failure.

Other unreferenced declarations in this file are all longstanding helpers (e.g. `projectiveLineBarGrading`, `chartEvalRingHom`, `kbarToAwayRingHom`, `gmScalingP1_chart{0,1}_ringMap`, the `Ga*` and `Gm*` lower-level instances, `ProjectiveLineBar.pointOfVec`/`evalIntoGlobal`/`irrelevant_map_eq_top`, the various FREE-from-Mathlib instances). All are acceptable as helper/instance scaffolding — none claims to be the "real" definition the chapter pins.

## Blueprint adequacy for this file

- **Coverage**: 16 of the file's substantive top-level declarations are pinned via `\lean{...}` blocks in this chapter (`ProjectiveLineBar`, `Ga`, `Gm`, `ProjectiveLineBar.{zeroPt,onePt,inftyPt}`, `Gm.onePt`, `gm_grpObj`, `projectiveLineBarAffineCover`, `homogeneousLocalizationAwayIso`, `homogeneousLocalizationAwayIso_aux_left`, `mvPolyToHomogeneousLocalizationAway_surjective`, `projectiveLineBar_isReduced`, `gmScalingP1`, `gmScalingP1_cover`, `gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence`, `gmScalingP1_collapse_at_zero`). The remaining unpinned declarations are recognisable as private helpers / FREE-from-Mathlib instances / supporting algebra ring maps and require no chapter pin.
- **Proof-sketch depth**: adequate. The three iter-173-focus scaffold sorries each have detailed reduction sketches in the chapter (chart-bridge recipe for `gmscaling_chart`; diagonal+cross case decomposition for `gmscaling_chart_agreement`; `Cover.hom_ext` + algebraMap factoring for `gmscaling_over_coherence`; chart-1 ring-map reduction for `gmScaling_fixes_zero`). The Lean prover's iter-174 closure plans cleanly cross-reference these sketches.
- **Hint precision**: precise. Every `\lean{...}` block lands on exactly the named Archon declaration in this file. The `def:gmscaling_chart` pin correctly captures the per-chart shape (per-`i` scheme morphism); the `lem:gmscaling_*` pins each land on top-level named lemmas with matching signatures.
- **Generality**: matches need. The chapter's chart-bridge framework (via `pullbackSpecIso` + `Proj.awayι` + the chart-ring iso) maps exactly to what the Lean body produces.
- **Recommended chapter-side actions**: none for the iter-173 prover edits. (The chapter is already well-aligned with the iter-174 closure plan.) The two iter-173 new private helpers (`awayι_comp_PLB_hom`, `gmScalingP1_cover_X_iso`) need no pin since they are sub-proof scaffolding for `def:gmscaling_chart`, which is itself pinned and gives the right level of detail.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**: none. (The two new private helpers being chapter-unpinned is acceptable per directive Q3 and standard helper-vs-pinned-declaration discipline; not classified as minor.)

**Overall verdict**: iter-173 prover edits to `Genus0BaseObjects.lean` (concrete `gmScalingP1_chart` body via `awayι_comp_PLB_hom` + `gmScalingP1_cover_X_iso`) faithfully realise the blueprint's `def:gmscaling_chart` construction recipe; the three remaining top-level scaffold sorries (`gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence`, `gmScalingP1_collapse_at_zero`) are blueprint-pinned with detailed iter-174 closure plans both in chapter prose and Lean doc-comments; HARD GATE consequence is **chapter remains `complete + correct` for next iter's Lane A**.
