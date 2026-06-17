# Lean Audit Report

## Slug
iter197

## Iteration
197

## Scope
- files audited: 43
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 flagged
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - Line 438: `sorry` in `kbarChart1Ring_specMap_fac`. The iter-197 comment says "steps 1+2 landed" — the `Proj.awayι_appIso_top_inv` substitution (step 2) is real structural progress, but the residual (the `onePt.left.app(D₊(X_1))` evaluation, step 4) is still open. No excuse-comment; progress notes are accurate.
  - Line 646: `sorry` in `iotaGm_chart1_appIso_eval`. Same substantive residual as line 438 per the iter-194 note ("SHARES SUBSTANTIVE CONTENT"). Also honest.
  - Line 1008: `genusZero_curve_iso_P1 := sorry`. Documented RR-bridge gap (iter-166+). Honest.
  - Lines 225–322: Three new iter-197 declarations (`Proj.basicOpenIsoSpec_inv_app_top`, `Proj.awayι_app_basicOpen`, `Proj.awayι_appIso_top_inv`) appear axiom-clean based on source inspection; no sorry.
  - Lines 119–125, 419, 572–576: Multiple `change`-tactic workarounds for private-name barriers (`gmScalingP1_cover_X_iso`) and type-class friction. Build-fragile pattern but structurally necessary with the current API.

### AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean *(iter-197 priority)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - The entire file appears axiom-clean: `homogeneousLocalizationAwayIso`, `homogeneousLocalizationAwayIso_algebraMap`, `mvPolyToHomogeneousLocalizationAway_surjective` all have substantive closed proofs. `projectiveLineBar_smoothOfRelDim` closes the smoothness instance via the 2-chart cover. No sorry in this file.

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean *(iter-197 priority)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 3 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `rationalMap_order_finite_support` (line ~249): `· sorry` for the nonzero branch. Documented as Mathlib-pending Stacks 02RV gap.
  - `principal_degree_zero` (line ~538): `sorry` for the non-constant branch. Documented as gated on the `φ : C → ℙ¹` construction and Hartshorne II.6.9.
  - `degree_positivePart_principal_eq_finrank` (line ~1108): `sorry` for the ramification-inertia bridge. Documented as Mathlib-pending `Scheme.Hom.ofFunctionFieldEmbedding`.
  - **New iter-197 advance**: `isRegularInCodimOneProjectiveLineBar` (formerly a sorry instance) now has a real proof closing the `hy_ne_bot` residual via the generic-point contradiction argument (lines 916–961). The proof uses `genericPoint_eq_bot_of_affine` + `genericPoint_eq_of_isOpenImmersion` + coheight argument; this closes the prior must-fix from iter-196.
  - `instIsLocallyNoetherianProjectiveLineBar` (line ~734) is axiom-clean.
  - The comment "**Demoted from `instance` per lean-auditor iter-196 must-fix**" on `isRegularInCodimOneProjectiveLineBar` is accurate: it's now a `theorem` (not an instance), so silent propagation through typeclass synthesis is blocked.

### AlgebraicJacobian/RiemannRoch/OCofP.lean *(iter-197 priority)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 3 flagged (per grep: 3 × `  sorry` occurrences in this file, in the bodies of `h1_vanishing_genusZero`, `dim_eq_two_of_genusZero`, `exists_nonconstant_genusZero`)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `lineBundleAtClosedPoint` (line ~806): substantive body via `carrierPresheaf` + `carrierPresheaf_isSheaf`. No sorry in this declaration.
  - `lineBundleAtClosedPoint.toFunctionField` (line ~848): substantive body via the `HModule_zero_linearEquiv` chain. No sorry.
  - `globalSections_iff_mp` (line ~923) and `globalSections_iff_mpr` (line ~1024): both have substantive bodies; the proofs look correct for extracting order conditions from the `carrierSubmodule` structure.
  - Pins 3–5 (`h1_vanishing_genusZero`, `dim_eq_two_of_genusZero`, `exists_nonconstant_genusZero`) retain sorry bodies as expected for iter-183+ targets.
  - The `add_mem'` proof in `carrierSubmodule` (lines ~253–291) uses `Ring.ordFrac_add` directly; the logic is sound for the non-archimedean inequality.

### AlgebraicJacobian/RiemannRoch/H1Vanishing.lean *(iter-197 priority)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.IsFlasque.constant_of_irreducible` (line ~138): `sorry` at line 178 for the non-empty branch. Documented as Mathlib-pending (no direct lemma for constant sheaf on irreducible via sheafification). Honest.
  - `Scheme.IsFlasque.injective_flasque` (line ~613): `sorry` at line 618. Documented as requiring the `j_!` extension-by-zero construction. Honest.
  - **New iter-197 advances (major real progress)**:
    - `alphaConstToSkyPUnit`, `betaSkyToConstPUnit`, `alphaConstToSkyPUnit_comp_betaSkyToConstPUnit_eq_toSheafify`: new presheaf-morphism helpers, all appear axiom-clean.
    - `Scheme.skyscraperSheaf_iso_constantSheaf_punit` (line ~907): new inner-iso declaration closing the iter-196 sorry gap in `skyscraperSheaf_eq_pushforward_const`. Proof is via `sheafifyLift` + `betaSkyToConstPUnit`; appears axiom-clean.
    - `Scheme.skyscraperSheaf_eq_pushforward_const` (line ~1015): previously had an inner-iso sorry; now consumes `skyscraperSheaf_iso_constantSheaf_punit`. Body is `sorry`-free.
  - The `Scheme.H1_skyscraperSheaf_finrank_eq_zero` (line ~1161) closes correctly from `HModule_flasque_eq_zero` + `skyscraperSheaf_isFlasque`.

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean *(carrier-soundness probe)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged (`smoothProperQuotient := sorry`)
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - Six `⟨sorry⟩` global instances: `instHasPicSharp`, `instHasDivFunctor`, `instHasPicScheme`, `instHasAbelMap`, `instPicSharpRepresentable`, `instPicSchemeGroupObject`. All are `noncomputable instance`-level global declarations. `lean_verify` on `representable` confirms `sorryAx` is present — **expected, not an unexpected route**.
  - The iter-196 probe correctly isolated sorrys into `Prop`-valued typeclasses; the `Classical.choice` extractions keep the data-level carriers `sorry`-free in their bodies (but `sorryAx` still propagates through the typeclass argument synthesis). This is the correct isolation pattern.
  - **No unexpected sorryAx route detected.** All six sorry sites are documented in the file header.
  - `smoothProperQuotient` body is `sorry` (line ~353). Documented as requiring Altman–Kleiman effective-quotient machinery.

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 5 flagged (5 × `  sorry` in grep)
- **bad practices**: none
- **excuse-comments**: 1 flagged
- **notes**:
  - Line 231: `-- TODO (A.1.b gate): close once ...` immediately preceding `exact sorry`. This is a `-- TODO` excuse-comment on a substantive proof obligation (`PicSharp.addCommGroup` instance body). **See Must-fix-this-iter below.**
  - The other four `sorry`-bodies in this file are for the pinned declarations of the `RelPicPresheaf` / `PicSharpFunctor` chain; all documented as A.1.b/A.1.c gate items.

### AlgebraicJacobian/Albanese/AlbaneseUP.lean
- **outdated comments**: none
- **suspect definitions**: 1 flagged
- **dead-end proofs**: 6 flagged (six `  sorry`-bodies for the 6 pinned declarations)
- **bad practices**: none
- **excuse-comments**: 1 flagged (in docstring)
- **notes**:
  - Line 183: `noncomputable def bundle : Bundle C := sorry`. The inline docstring says "File-internal **placeholder carrier**..." — word "placeholder" triggers excuse-comment rule. **See Must-fix-this-iter below.**
  - Lines 195–209: `jacobianScheme_grpObj`, `jacobianScheme_isProper`, etc. are correctly demoted from `instance` (per iter-196 lean-auditor must-fix note on line 191). The demotion is documented and accurate.
  - The 6 pinned declarations (abelJacobi, SymmetricPower, symmetricPowerAVMap, symmetricPowerToJacobian, descentThroughBirationalSigma, albanese_universal_property) all have `sorry` bodies as expected for the iter-177 file-skeleton.

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Line 155: `private theorem isReduced_of_smooth_over_field ... := sorry`. Documented as "Mathlib gap (Stacks `034V`/`02G4`)". The comment says "**Demoted from inline sorry per lean-auditor iter-196 must-fix**" — accurate demotion, not a new issue.
  - `av_isIntegral_of_smooth_geomIrred` and `extend_to_av` each have one `sorry` (the latter for the full 4-step Milne 3.2 body). Honest and documented.

### AlgebraicJacobian/Albanese/CodimOneExtension.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 3 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 6 pinned declarations all have `sorry` bodies; the 3 file-skeleton pins (`extend_of_codimOneFree_of_smooth`, `indeterminacy_pure_codim_one_into_grpScheme`, `mem_domain_iff_exists_partialMap_through_point`) map to 3 `sorry` sites.

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Line 1380: `-- broken into named steps` is a structural description ("broken into" = divided into), NOT an admission of incorrectness. Not an excuse-comment.
  - One `sorry` persists (per grep) in the `(≤)` direction of the Steinitz-exchange strategy (Steps 4–7 assembly).

### AlgebraicJacobian/Albanese/AlbaneseUP.lean *(see above)*

### AlgebraicJacobian/Albanese/CoheightBridge.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Contains 4 declarations (`coheight_eq_of_isOpenEmbedding`, `coheight_spec_eq_height_primeSpectrum`, `ringKrullDim_stalk_eq_coheight`, `ringKrullDimLE_of_coheight_eq_one`). Based on the header these are intended to be substantive. File-skeleton or substantive not confirmed (file not fully read) but grep found no `sorry` occurrences.

### AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 1 `sorry` occurrence (from grep). This is likely the geometric-irreducibility scaffold for `ProjectiveLineBar`. `projectiveLineBar_isProper` is fully closed (axiom-clean based on source inspection). The `SmoothOfRelativeDimension 1` instance is now closed in ChartIso.lean.

### AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean *(see above)*

### AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 1 `sorry` (from grep): likely the `gmScalingP1_collapse_at_zero` proof or the product-stability instance for `projGm_isReduced`. The header mentions "off-target sorries (`gm_geomIrred`, `projGm_isReduced`) in `Genus0BaseObjects/GmScaling.lean`" as part of Cross01Substrate.

### AlgebraicJacobian/Genus0BaseObjects/Points.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Grep found no sorry occurrences. File appears clean.

### AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Contains substrate lemmas (`IsClosedImmersion.lift_iff_range_subset` axiom-clean, `gmRing_tensor_homogeneousAway_isDomain` iter-190 closure). File not found in sorry counts; likely clean.

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure re-export shim (imports only, no declarations). Clean.

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: flagged (multiple; iter-179 file-skeleton bodies)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - iter-179 Block A advanced `RelativeSpec` and `structureMorphism` from weakened-wrong placeholders to proper `relativeGluingData` values. The three downstream theorems (`UniversalProperty`, `affine_base_iff`, `base_change`) have honest `sorry` bodies pending the Block B rewrites.

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: flagged (5 pinned declarations with sorry bodies)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All 5 pins have `sorry` bodies as expected for the iter-174 file-skeleton. Documented as gated on A.1.a settling.

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 8 flagged (per grep)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 4 occurrences of `exact sorry` (lines 596, 620, 676, 1065) and 4 occurrences of `  sorry` (per grep). All in the bodies of pinned declarations. Documented as iter-177+ work.

### AlgebraicJacobian/Picard/RelPicFunctor.lean *(see above)*

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean *(see above)*

### AlgebraicJacobian/Picard/IdentityComponent.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 8 flagged (per grep)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 5 blueprint-pinned declarations with `sorry` bodies. The additional 3 `sorry` occurrences are probably `haveI := sorry` or structural sorry sites within the scaffolded bodies. All as expected for iter-185 file-skeleton.

### AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 5 flagged (per grep)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 5 blueprint-pinned declarations with `sorry` bodies as expected for iter-193 file-skeleton.

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 7 flagged (per grep)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File-skeleton with 7 pinned declarations. All expected sorrys.

### AlgebraicJacobian/RiemannRoch/RRFormula.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `eulerCharacteristic` def is concrete (one-line subtraction). One `sorry` remains (per grep) in the body of `eulerCharacteristic_eq_degree_plus_one_minus_genus` or `l_eq_degree_plus_one_of_genus_zero`. The `sheafOf` placeholder is documented.

### AlgebraicJacobian/RiemannRoch/OcOfD.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.WeilDivisor.sheafOf` is a typed-sorry placeholder (documented). 2 `sorry` occurrences (per grep) in pin bodies.

### AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 3 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 3 pinned declarations with `sorry` bodies. The Pin 4 note says it re-exports `genusZero_curve_iso_P1` from AbelianVarietyRigidity; file is an iter-177 skeleton.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three declarations are mere projections from the `jacobianWitness` field; no sorry. File is clean.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `genusZeroWitness` and `nonempty_jacobianWitness` carry `sorry` bodies. Documented as Phase-C scaffolding; honest. 1 `sorry` per grep.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` is closed. File appears clean (no sorry in grep).

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `rigidity_over_kbar` has 1 `sorry` body. Documented as iter-126 scaffold pending cotangent-vanishing Mathlib pile. Route (a) fallback; route (c) via AbelianVarietyRigidity.lean is the current active path.

### AlgebraicJacobian/RigidityLemma.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Header says "PROVEN axiom-clean (iters 157–162)". No sorry in grep. File appears clean.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single honest `genus` definition. Axiom-clean. Clean.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - File builds relative Kähler differentials via Mathlib's `PresheafOfModules.DifferentialsConstruction`. No sorry in grep. Appears clean.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorry in grep. Appears clean.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorry in grep. Appears clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure re-export shim of three sub-files. Clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorry in grep. Contains categorical gap-fills and presheaf construction.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorry in grep.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorry in grep.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorry in grep. Appears clean.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorry in grep. Appears clean.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorry in grep. Appears clean.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - No sorry in grep. Appears clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean *(see above)*

### AlgebraicJacobian.lean *(top-level re-export, if present)*
- Top-level files (`AlgebraicJacobian.lean` not under the `AlgebraicJacobian/` subdirectory): not present as a standalone file; top-level imports live in the sub-files listed above.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:231-235` — `-- TODO (A.1.b gate): close once ...` followed immediately by `exact sorry`. This is a `-- TODO` excuse-comment on a substantive proof obligation (`PicSharp.addCommGroup` instance, the abelian-group structure on the quotient set). The comment claims the proof will be resolved when a sibling chapter lands, but it is currently wrong/incomplete. Why must-fix: `-- TODO` on a `sorry` body is an admission the code is wrong; per audit rules this must be flagged regardless of context. The instance is not `Prop`-valued (it produces an `AddCommGroup` data structure), so any downstream code synthesizing `AddCommGroup` from this instance silently propagates `sorryAx` through the data layer.

- `AlgebraicJacobian/Albanese/AlbaneseUP.lean:183` — `noncomputable def bundle : Bundle C := sorry`. The inline docstring says "File-internal **placeholder carrier**" and "Collapses to a re-export... once that materialises." The word "placeholder" in a docstring on a `def := sorry` is an excuse-comment per audit rules. Why must-fix: `bundle` feeds `jacobianScheme`, `jacobianScheme_grpObj`, `jacobianScheme_isProper`, `jacobianScheme_smooth`, `jacobianScheme_geomIrred` — all the load-bearing Pic⁰ structure for the positive-genus arm. The iter-196 lean-auditor already flagged instance propagation and the fix (demotion from `instance`) was applied, but the `def` itself remains a sorry-carrying load-bearing definition. The excuse-comment on it re-surfaces the must-fix.

---

## Major

- `AlgebraicJacobian/AbelianVarietyRigidity.lean:438` — `sorry` in `kbarChart1Ring_specMap_fac`. Iter-197 claimed partial progress (steps 1+2 of 4), but the substantive `Proj.appIso` evaluation residual (step 4) is still open. This blocks `iotaGm_r_1_eq_specMap`, `iotaGm_chart1_appIso_eval`, `iotaGm_chart1_composition_isOpenImmersion`, `iotaGm_isOpenImmersion`, `iotaGm_isDominant`, and ultimately `morphism_P1_to_grpScheme_const`.

- `AlgebraicJacobian/AbelianVarietyRigidity.lean:646` — `sorry` in `iotaGm_chart1_appIso_eval`. Per the iter-194 note at that line, this sorry shares substantive content with the line-438 sorry. Both must close together.

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:249,538,1108` — three persistent substantive sorrys: the nonzero branch of `rationalMap_order_finite_support` (Stacks 02RV gap), the non-constant branch of `principal_degree_zero` (Hartshorne II.6.10 / `φ : C → ℙ¹` construction), and the ramification-inertia bridge in `degree_positivePart_principal_eq_finrank` (Hartshorne II.6.9 / `Scheme.Hom.ofFunctionFieldEmbedding` gap). These block the full RR chain.

- `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean:178,618` — `Scheme.IsFlasque.constant_of_irreducible` (non-empty branch) and `Scheme.IsFlasque.injective_flasque` remain Tier-3 sorrys. They are in the critical path for `HModule_flasque_subsingleton_aux` and `HModule_flasque_eq_zero`.

- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean:149,176,236,294,409,465` — Six `⟨sorry⟩` global typeclass instances remain. No unexpected `sorryAx` propagation route found, but the instances are `noncomputable instance` declarations that silently synthesize in any file importing this one. The `PicSharp.addCommGroup` instance in RelPicFunctor.lean (must-fix above) compounds this.

---

## Minor

- `AlgebraicJacobian/AbelianVarietyRigidity.lean:119-125,419,572-576` — Multiple `change`-tactic workarounds for private-name barriers (`gmScalingP1_cover_X_iso` body is private in GmScaling.lean) and type-class friction. These are build-fragile: any refactor of the private definition or the type-class elaboration order could silently break these proofs.

- `AlgebraicJacobian/AbelianVarietyRigidity.lean:493-511` — Long historical doc block (`/- **Historical doc** (iter-183 — iter-191) for ...`) referencing an iter-sequence that spans multiple iters. Not outdated but verbose. Low impact.

- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — Many `show (... : X.PrimeDivisor →₀ ℤ) from principal ...` casting annotations in `one_le_degree_positivePart_principal_of_order_one` (lines ~653–682) and `degree_positivePart_principal_eq_finrank`. These are not wrong but indicate elaboration pressure; a `set D := (principal f hf : ...)` binding would clean this up.

- `AlgebraicJacobian/RigidityKbar.lean` — `rigidity_over_kbar` is the route (a) fallback, still sorry-carrying. Comments describe this as route (a); route (c) via AbelianVarietyRigidity is active. The file remains as non-dead-end scaffolding for the fallback route. Minor because it is not on the active path.

---

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Picard/RelPicFunctor.lean:231`: `"-- TODO (A.1.b gate): close once \`LineBundle.OnProduct\` is upgraded from a typed \`sorry\` to a concrete structure..."` (attached to `exact sorry` in `PicSharp.addCommGroup` instance body, which is a data-producing `AddCommGroup` instance). Severity: **critical** — `AddCommGroup` is load-bearing data; silent propagation through this instance taints the entire `PicSharpFunctor` chain.

- `AlgebraicJacobian/Albanese/AlbaneseUP.lean:183` docstring: `"File-internal **placeholder carrier** for \`Pic⁰_{C/k̄}\` — a typed \`sorry\` pending the A.3 row chapter."` (attached to `noncomputable def bundle : Bundle C := sorry`). Severity: **major** — `bundle` is explicitly a load-bearing placeholder. The iter-196 lean-auditor already addressed instance propagation (demotion), but the `def` itself is the root sorry source for the positive-genus arm.

---

## Severity summary

- **must-fix-this-iter**: 2
- **major**: 6
- **minor**: 4
- **excuse-comments**: 2 (both also counted above: 1 under must-fix, 1 under major)

Overall verdict: The iter-197 prover phase delivered three clean structural advances (ChartIso axiom-clean, WeilDivisor `hy_ne_bot` closed, H1Vanishing inner-iso gap filled) with no new excuse-comments introduced by the prover — but one pre-existing `-- TODO` excuse-comment in RelPicFunctor.lean and the `bundle` placeholder in AlbaneseUP.lean persist from earlier iters and hit the must-fix threshold; the carrier-soundness probe on FGAPicRepresentability found no unexpected sorryAx routes beyond the documented ones.
