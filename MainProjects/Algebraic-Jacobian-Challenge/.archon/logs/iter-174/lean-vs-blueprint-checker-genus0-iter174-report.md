# Lean ↔ Blueprint Check Report

## Slug
genus0-iter174

## Iteration
174

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

The chapter's `% archon:covers` line covers `AbelianVarietyRigidity.lean`,
`Genus0BaseObjects.lean`, and `RigidityLemma.lean`; this report audits only
the Genus0BaseObjects declarations.

## Per-declaration

For every `\lean{...}` block that targets a `Genus0BaseObjects.lean`
declaration, one entry.

### `\lean{AlgebraicGeometry.ProjectiveLineBar}` (chapter: `def:genus0_base_objects`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:119`, `def`).
- **Signature matches**: yes — `Over (Spec (.of kbar))` carrier of `Proj` of the
  standard ℕ-graded `MvPolynomial (Fin 2) kbar`. The blueprint prose says
  "smooth proper geometrically irreducible curve of genus 0"; smoothness and
  geometric-irreducibility are emitted as separate Lean instances (see notes).
- **Proof follows sketch**: N/A (definition).
- **notes**: Carries `IsProper` (axiom-clean, L138) and two `sorry`-bodied
  instances `projectiveLineBar_geomIrred` (L186) and
  `projectiveLineBar_smoothOfRelDim` (L193). Their docstrings flag them as
  Mathlib-gap scaffolds; the blueprint header prose mentions both properties
  but does not separately `\lean{...}`-pin them, so the gap is acknowledged
  on both sides.

### `\lean{AlgebraicGeometry.Ga}` (chapter: `def:ga`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:709`, `abbrev`).
- **Signature matches**: yes — `(GaScheme kbar).asOver (Spec (.of kbar))`.
- **Proof follows sketch**: N/A (definition).
- **notes**: Realised as `AffineSpace (Fin 1)` (not as `D₊(X₀)`). Companion
  instances `IsAffineHom`, `LocallyOfFinitePresentation`, `IsReduced` are
  axiom-clean.

### `\lean{AlgebraicGeometry.Gm}` (chapter: `def:gm`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:753`, `abbrev`).
- **Signature matches**: yes — `Spec (.of (Localization.Away (X ())))` wrapped
  in `asOver`, matching the blueprint's explicit encoding-choice note
  (`Spec(Localization.Away t)`, *not* `D(t) ⊂ 𝔸¹`).
- **Proof follows sketch**: N/A.
- **notes**: Affineness, LFP, reducedness, irreducibility all axiom-clean.

### `\lean{AlgebraicGeometry.ProjectiveLineBar.zeroPt}` (chapter: `def:p1bar_zero`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:677`, `def`).
- **Signature matches**: yes — `𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar`,
  via the private helper `pointOfVec` with evaluation `(0, 1)`. Matches the
  blueprint's "`[0 : 1]`" description and the `Proj.fromOfGlobalSections`
  recipe.
- **Proof follows sketch**: N/A (definition body matches the prose).

### `\lean{AlgebraicGeometry.ProjectiveLineBar.onePt}` (chapter: `def:p1bar_one`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:683`, `def`).
- **Signature matches**: yes — evaluation `(1, 1)`, matching "`[1 : 1]`".
- **Proof follows sketch**: N/A.

### `\lean{AlgebraicGeometry.ProjectiveLineBar.inftyPt}` (chapter: `def:p1bar_infty`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:689`, `def`).
- **Signature matches**: yes — evaluation `(1, 0)`, matching "`[1 : 0]`".
- **Proof follows sketch**: N/A.

### `\lean{AlgebraicGeometry.Gm.onePt}` (chapter: `def:gm_one`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:819`, `def`).
- **Signature matches**: yes — defined as `η[Gm kbar]`, matching the
  blueprint's "unit map η[𝔾ₘ] : Spec k̄ → 𝔾ₘ".
- **Proof follows sketch**: N/A.

### `\lean{AlgebraicGeometry.gm_grpObj}` (chapter: `def:gm_grpObj`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:808`, `instance`).
- **Signature matches**: yes.
- **Proof follows sketch**: body is `sorry`.
- **notes**: Explicitly OUT OF SCOPE per directive; not classified as a
  finding. The blueprint already acknowledges the scaffold state at
  `def:gm_grpObj`.

### `\lean{AlgebraicGeometry.projectiveLineBarAffineCover}` (chapter: `def:projlinebar_affine_cover`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:207`, `def`).
- **Signature matches**: yes — `Proj.affineOpenCoverOfIrrelevantLESpan` with
  family `(X 0, X 1)` and weights `(1, 1)`, matching the prose exactly.
- **Proof follows sketch**: yes — the non-trivial input (irrelevant ideal ⊆
  span `{X 0, X 1}`) is proved by the monomial-by-monomial route the
  blueprint describes. Axiom-clean.

### `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso}` (chapter: `def:proj_chart_ring_iso`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:545`, `def`).
- **Signature matches**: yes — `RingEquiv.ofRingHom` of forward
  (`homogeneousLocalizationAwayToMvPoly`) and inverse
  (`mvPolyToHomogeneousLocalizationAway`) maps with the two round-trip
  identities, exactly as the blueprint prose describes.
- **Proof follows sketch**: yes.
- **notes**: As of iter-174, axiom-clean conditional on
  `mvPolyToHomogeneousLocalizationAway_surjective` (which is itself
  axiom-clean per iter-172/173).

### `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_left}` (chapter: `lem:proj_chart_ring_iso_aux_left`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:528`, `lemma`).
- **Signature matches**: yes — `(inverse).comp (forward) = RingHom.id _`.
- **Proof follows sketch**: yes — "cancel surjective" via the surjective
  helper plus the forward round-trip, exactly as the blueprint prose says.

### `\lean{AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway_surjective}` (chapter: `lem:mvPoly_to_homogeneousLocalization_away_surjective`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:379`, `lemma`).
- **Signature matches**: yes.
- **Proof follows sketch**: yes — uses `Away.adjoin_mk_prod_pow_eq_top` with
  `d = 1`, `v = (X 0, X 1)`, `dv = (1, 1)`, then `Algebra.adjoin_induction`
  on the four cases (`mem`/`algebraMap`/`add`/`mul`), matching the blueprint
  recipe verbatim. Axiom-clean.

### `\lean{AlgebraicGeometry.projectiveLineBar_isReduced}` (chapter: `lem:projlinebar_isReduced`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:1240`, `instance`).
- **Signature matches**: yes.
- **Proof follows sketch**: yes — `IsReduced.of_openCover` + each chart a
  domain via `Function.Injective.isDomain` on the canonical `val`-injection
  into `Localization.Away`. Axiom-clean.

### `\lean{AlgebraicGeometry.gmScalingP1_cover}` (chapter: `def:gmscaling_cover`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:887`, `def`).
- **Signature matches**: yes — `(projectiveLineBarAffineCover).openCover.pullback₁ (pullback.fst _ _)`,
  matching the prose's pullback-of-chart-cover description. Axiom-clean.
- **Proof follows sketch**: N/A.

### `\lean{AlgebraicGeometry.gmScalingP1_chart}` (chapter: `def:gmscaling_chart`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:948`, `def`).
- **Signature matches**: yes.
- **Proof follows sketch**: yes — the body composes
  `gmScalingP1_cover_X_iso` (which uses `pullbackSymmetry ≪≫
  pullbackRightPullbackFstIso ≪≫ pullback.congrHom ≪≫ pullbackSpecIso`) with
  `Spec.map (chart_ring_map).comp (homogeneousLocalizationAwayIso).toRingHom`
  and `Proj.awayι`. Matches the blueprint's "construction recipe" prose.
- **notes**: Per directive, this body landed iter-173 and is already audited.
  Internal `match i` pattern matches blueprint's case-split between chart
  `0` (`λ⁻¹` via `IsLocalization.Away.invSelf`) and chart `1` (`λ` via
  the unit-of-localisation algebra map).

### `\lean{AlgebraicGeometry.gmScalingP1_chart_agreement}` (chapter: `lem:gmscaling_chart_agreement`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:1120`, `lemma`).
- **Signature matches**: yes.
- **Proof follows sketch**: partial — diagonal cases `(0,0)` and `(1,1)`
  close via `fst_eq_snd_of_mono_eq` (axiom-clean per directive's known-issues
  list); cross cases `(0,1)` and `(1,0)` are `sorry` (acknowledged-scaffold
  per directive Decision 2).
- **notes**: The cross-case sorries are flagged in both the docstring
  ("Status (iter-173)…iter-174 lane will land…") and the blueprint
  (`lem:gmscaling_chart_agreement` "the substantive cases are the cross
  cases" prose). Both sides agree on the deferred-scaffold status.

### `\lean{AlgebraicGeometry.gmScalingP1_over_coherence}` (chapter: `lem:gmscaling_over_coherence`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:1158`, `lemma`).
- **Signature matches**: yes — exactly the equation between
  `(gmScalingP1_cover).glueMorphisms … ≫ PLB.hom` and `(ℙ¹ ⊗ 𝔾ₘ).hom`.
- **Proof follows sketch**: yes — body is `Scheme.Cover.hom_ext` +
  `Scheme.Cover.ι_glueMorphisms_assoc` + the per-chart certificate
  `gmScalingP1_chart_PLB_eq`. Matches the blueprint's "by
  Scheme.Cover.hom_ext, equivalent to its chart-wise restrictions; agreement
  there is automatic" prose.
- **notes**: Body itself contains no `sorry`; sorryAx propagates through
  `gmScalingP1_chart_PLB_eq`. Directive confirms this lemma is closed
  modulo the helper.

### `\lean{AlgebraicGeometry.gmScalingP1}` (chapter: `def:gaTranslationP1`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:1182`, `def`).
- **Signature matches**: yes — `ProjectiveLineBar ⊗ Gm ⟶ ProjectiveLineBar`,
  via `Over.homMk ((cover).glueMorphisms … …) (over_coherence …)`. Matches
  the blueprint's "primary action `σ_×`" pin.
- **Proof follows sketch**: yes (body of this definition is structural).
- **notes**: A `% NOTE` in the blueprint at this block names the three
  internal scaffold helpers (`gmScalingP1_chart`,
  `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence`). All three
  are now top-level named `\lean{...}`-pinned declarations, consistent
  with the blueprint's reduction diary.

### `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` (chapter: `lem:gmScaling_fixes_zero`)
- **Lean target exists**: yes (`Genus0BaseObjects.lean:1202`, `lemma`).
- **Signature matches**: yes.
- **Proof follows sketch**: body is `sorry`.
- **notes**: Both Lean docstring ("Reduces (once `gmScalingP1_chart` is
  concrete) to the chart-1 ring-map computation") and blueprint NOTE at
  `lem:gmScaling_fixes_zero` ("gated `sorry`…residual gate is on the three
  internal scaffold helpers") acknowledge this is an acknowledged-scaffold
  pending downstream concrete chart bodies. Not a fresh finding.

## Red flags

(No fresh red flags — all sorries in the file are either explicitly
acknowledged scaffolds, the directive-excluded `gm_grpObj`, or
deferred-per-analogist cross-cases acknowledged on both sides.)

## Unreferenced declarations (informational)

The Lean file has many helper declarations that intentionally lack
`\lean{...}` pins (private helpers, structural instances, etc.). The
substantive ones worth surfacing:

- **`AlgebraicGeometry.homogeneousLocalizationAwayIso_algebraMap`**
  (`Genus0BaseObjects.lean:564`, `private lemma`) — **NEW iter-174 helper.**
  Asserts that the chart-ring iso preserves `algebraMap kbar`. Load-bearing
  for `gmScalingP1_chart_PLB_eq` Step B. Axiom-clean per directive. The
  blueprint has no `\lean{...}` block pinning it — see "Blueprint adequacy"
  for the writer-side action.
- **`AlgebraicGeometry.gmScalingP1_chart_PLB_eq`**
  (`Genus0BaseObjects.lean:991`, `private lemma`) — **NEW iter-174 helper.**
  The per-chart certificate consumed by `gmScalingP1_over_coherence`.
  Steps A + B axiom-clean; Step C has 2 `sorry`s (`i = 0` and `i = 1`)
  deferred per analogist Decision (Fin syntactic-equality unification gap).
  The blueprint has no `\lean{...}` block pinning it — writer-side gap.
- **`AlgebraicGeometry.homogeneousLocalizationAwayToMvPoly`**
  (`Genus0BaseObjects.lean:291`, `noncomputable def`) — public helper, the
  forward direction of the chart-ring iso. Mentioned in prose at
  `def:proj_chart_ring_iso` ("the forward direction…via Localization.awayLift")
  but no separate `\lean{...}` block. Could be promoted; not load-bearing
  enough to flag as a fresh gap (the iso itself is pinned).
- **`AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway`**
  (`Genus0BaseObjects.lean:314`, `noncomputable def`) — public helper, the
  inverse direction. Same status as above. The surjectivity lemma over it
  (`mvPolyToHomogeneousLocalizationAway_surjective`) IS pinned, which
  effectively anchors the inverse map indirectly.
- **`AlgebraicGeometry.gmScalingP1_chart0_ringMap` / `..._chart1_ringMap`**
  (`Genus0BaseObjects.lean:867, 876`) — public helpers; the
  per-chart ring maps. Mentioned in `def:gmscaling_chart` prose by name
  but not pinned. Acceptable as helpers; the chart morphism that consumes
  them IS pinned.
- **`AlgebraicGeometry.algebraKbarAway`**
  (`Genus0BaseObjects.lean:91`, `noncomputable instance`) — bridge
  instance giving `Algebra kbar (HomogeneousLocalization.Away _ _)` via
  `Algebra.compHom`. Load-bearing for tensor-product instance synthesis;
  not pinned in the blueprint. Acceptable as a typeclass-resolution
  bridge.
- Several structural instances on `ProjectiveLineBar`, `Ga`, `Gm`
  (`isProper`, `isAffineHom`, LFP, `isReduced`, …): the blueprint mentions
  the corresponding properties in `def:genus0_base_objects` prose ("smooth
  proper geometrically irreducible curve of genus 0", "affine", "reduced",
  etc.) but does not pin them as separate `\lean{...}` blocks. Reasonable
  for typeclass instances; the bundled definition's `\lean{...}` covers
  them implicitly.

## Blueprint adequacy for this file

- **Coverage**: 18/18 substantive Lean targets that *should* be in the
  blueprint are `\lean{...}`-pinned, with **two iter-174-new exceptions**:
  `homogeneousLocalizationAwayIso_algebraMap` (L564) and
  `gmScalingP1_chart_PLB_eq` (L991). Both are private but
  load-bearing for the iter-174 closure of `gmScalingP1_over_coherence`
  (which itself IS pinned and whose 3-line body delegates entirely to
  these two helpers + `Cover.hom_ext`). Per the directive
  ("Pay particular attention to whether the chapter has `\lean{...}`
  pins for the new helpers…if not, that is a writer-side gap to
  surface"), this is a deliberate flag.

  Beyond those two, ~20 helper definitions/instances (private helpers,
  structural instances, ring maps) are reasonably left unpinned — they
  are infrastructure that the pinned targets transparently consume.

- **Proof-sketch depth**: adequate for every pinned declaration this
  iter touched (`gmScalingP1_chart`, `gmScalingP1_chart_agreement`,
  `gmScalingP1_over_coherence`, `gmScalingP1`). The blueprint
  `def:gmscaling_chart` "Construction recipe" paragraph, the
  `lem:gmscaling_chart_agreement` "Content of the equation" cross-case
  description, and the `lem:gmscaling_over_coherence` "Reduction"
  paragraph each preview the actual Lean strategy faithfully. The
  iter-174-new Step-B chart-algebra preservation step is, however,
  *not* explicitly previewed (because the helper that does that step
  is unpinned).

- **Hint precision**: precise. Each pinned `\lean{...}` block names the
  exact Lean declaration name; no loose Mathlib-predicate ambiguity. The
  `Gm` encoding clarification (affine `Spec(Localization.Away t)` vs the
  basic open `D(t)`) is well-handled by both a header `% NOTE` and an
  in-statement clarification.

- **Generality**: matches need. The pinned signatures align with what
  the consumer `morphism_P1_to_grpScheme_const` (in `AbelianVarietyRigidity.lean`)
  actually wants.

- **Recommended chapter-side actions** (writer-side, blocking nothing
  this iter — these are MAJOR, not must-fix-this-iter):
  1. Add a `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_algebraMap}`
     block under the chart-ring-iso section (e.g. between
     `lem:proj_chart_ring_iso_aux_left` at L1117 and
     `lem:mvPoly_to_homogeneousLocalization_away_surjective` at L1140),
     stating "the chart-ring iso preserves `algebraMap kbar`". This
     anchors the iter-174 Step-B identity that the over-coherence proof
     depends on.
  2. Add a `\lean{AlgebraicGeometry.gmScalingP1_chart_PLB_eq}` block in
     the iter-171 chart-glue scaffold subsection (near
     `def:gmscaling_chart` / `lem:gmscaling_over_coherence`), explaining
     the per-chart `awayι ≫ PLB.hom` ↔ `(cover).f i ≫ (PLB ⊗ Gm).hom`
     bridge identity, and noting the Fin syntactic-equality residual on
     Step C as a deferred scaffold. This brings the over-coherence
     reduction diary up to iter-174.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: two missing `\lean{...}` pins for iter-174-new
  load-bearing helpers (`homogeneousLocalizationAwayIso_algebraMap`,
  `gmScalingP1_chart_PLB_eq`) — these are blueprint-writer follow-ups,
  not Lean-side errors. They do not block prover work this iter
  (the helpers exist and compile; only the static blueprint↔Lean graph
  is incomplete).
- **minor**: the iter-174 closure of `gmScalingP1_over_coherence` is
  not yet noted in the `lem:gmscaling_over_coherence` block's NOTE diary
  (still says "Reduction…chart-wise restrictions" in the abstract; the
  iter-174 NOTE that the closure went through `Cover.hom_ext +
  chart_PLB_eq` would refresh that block). Trivially addressable.

Overall verdict: Lean side faithfully follows the blueprint with no
fresh red flags or laundered hypotheses; the only adequacy gaps are
two missing `\lean{...}` pins for the iter-174-new helpers
(`homogeneousLocalizationAwayIso_algebraMap` and
`gmScalingP1_chart_PLB_eq`), which are blueprint-writer follow-ups
that do not block downstream work.
