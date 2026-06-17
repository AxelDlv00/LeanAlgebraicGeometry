# Lean Audit Report

## Slug
iter206

## Iteration
206

## Scope
- files audited: 45 (every `.lean` file under `AlgebraicJacobian/`, plus top-level `AlgebraicJacobian.lean`)
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Import-only re-export shim. Clean.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Pure delegation to `(jacobianWitness C).isAlbaneseFor P`. 0 sorries in code. Clean.

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 3 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L438: `kbarChart1Ring_specMap_fac` — named typed sorry; residual is the `Proj.appIso` evaluation step, documented with precise missing infrastructure. Honest.
  - L646: `iotaGm_chart1_appIso_eval` — named typed sorry; same residual class. Honest, structurally separated from its consumer `iotaGm_chart1_composition_isOpenImmersion`.
  - L1008: `genusZero_curve_iso_P1 := sorry` — Hartshorne RR bridge (IV.1.3.5), gated on RR.1–RR.4 sub-build completion. Typed sorry with full documentation. Honest.
  - The file-internal helper infrastructure (Proj supplement lemmas, chart-bridge, `iotaGm_isDominant`, etc.) is axiom-clean per file's own status notes.

### AlgebraicJacobian/Albanese/AlbaneseUP.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 7 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `bundle` (~L183): typed `sorry` for the `Pic0.Bundle` placeholder. Collapses to a re-export once A.3 lands.
  - `abelJacobi` (~L250): typed `sorry`. Substantive type.
  - `SymmetricPower` (~L300): typed `sorry`. Substantive type.
  - `symmetricPowerAVMap` (~L334): typed `sorry`. Substantive type.
  - `symmetricPowerToJacobian` (~L372): typed `sorry`. Substantive type.
  - `descentThroughBirationalSigma` (~L417): typed `sorry`. Substantive type.
  - `albanese_eq_iff_symmetricPower_eq` (~L458): typed `sorry`. Substantive type.
  - `albanese_universal_property` body is sorry-free assembly from the above two. Well-structured.

### AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none (all 24 grep hits are in doc-comments)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `depth` body is concrete (if-else supremum). `depth_eq_smallest_ext_index` is fully proven (forward and backward directions both closed). `depth_of_short_exact` is fully proven. `depth_eq_of_linearEquiv`, `depth_of_pi_const`, `auslander_buchsbaum_formula`, `CohenMacaulay.of_regular` and all the Stacks-00OE substrate lemmas are axiom-clean in code. The file appears sorry-free in all proof bodies. **Notable: all sorry occurrences in grep are inside doc-comment text.**

### AlgebraicJacobian/Albanese/CodimOneExtension.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 3 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `isRegularLocalRing_stalk_of_smooth`: sorry for the smooth→regular-stalk bridge (Stacks 00TT); the Stacks-00SW Jacobian-regular-sequence witness is the residual documented gap. Honest.
  - `extend_of_codimOneFree_of_smooth` (Milne 3.1) and `indeterminacy_pure_codim_one_into_grpScheme` (Milne Lemma 3.3): both typed sorries with documented rationale.
  - Extensive axiom-clean infrastructure (Stages 1–6.B, MvPolynomial height lemmas, cotangent helpers) is present and clean.

### AlgebraicJacobian/Albanese/CoheightBridge.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: All four declarations axiom-clean. `coheight_eq_of_isOpenEmbedding`, `coheight_spec_eq_height_primeSpectrum`, `ringKrullDim_stalk_eq_coheight`, `ringKrullDimLE_of_coheight_eq_one` all have complete proofs.

### AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `isReduced_of_smooth_over_field` (~L155): typed sorry, Stacks `034V`/`02G4` Mathlib gap isolated to a named private declaration per iter-196 lean-auditor must-fix. Honest.
  - `av_codimOneFree_of_indeterminacy` (~L294): sorry in Branch 2 (project gap: codim-≥2 conclusion of Milne 3.1 not yet exposed as standalone lemma). Honest with detailed documentation.
  - `extend_to_av` body is sorry-free assembly from the two above helpers.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries in code. Clean.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries in code. Clean.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries in code. Clean.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries in code. Clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries in code. Clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Carriers.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries. Clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries. Clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK/SheafProperty.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries. Clean.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 actual sorry invocations in code (2 grep hits are in `--` comment text). `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`, `df_zero_factors_through_constant_on_chart`, `constants_integral_over_base_field`, `ext_of_diff_zero` all axiom-clean. Clean.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: none (iter-128/130/131/132 references are accurate historical notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 actual sorry invocations in code (9 grep hits are all inside `/- -/` doc-comment blocks). `cotangentSpaceAtIdentity` and `cotangentSpaceAtIdentity_finrank_eq` are axiom-clean. Clean.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries in code. Clean.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `genus` definition is concrete (`Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`). 0 sorries. Clean.

### AlgebraicJacobian/Genus0BaseObjects.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: Import-only re-export shim for the 4-stratum split. 0 sorries. Clean.

### AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged
- **bad practices**: none
- **excuse-comments**: 1 flagged
- **notes**:
  - L220: `instance projectiveLineBar_geomIrred ... := sorry`. Comment says "Project-side scaffold sorry (Mathlib does not ship `GeometricallyIrreducible` for `Proj` of a polynomial ring; plan-marked acceptable for iter-165)." The phrase "plan-marked acceptable" functions as a mitigating excuse-comment on a sorry `instance`. Since `GeometricallyIrreducible` propagates via `inferInstance`, this sorry propagates silently into downstream instances without explicit `sorry` markers at the call sites. **Severity: major.** The mitigation "plan-marked" limits it from critical.
  - `mvPolynomialFin_isStandardSmoothOfRelativeDimension` and related helpers are axiom-clean.

### AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries. `homogeneousLocalizationAwayToMvPoly`, `homogeneousLocalizationAwayIso` and related declarations axiom-clean. Clean.

### AlgebraicJacobian/Genus0BaseObjects/Cross01Substrate.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries. `IsClosedImmersion.lift_iff_range_subset` (Substrate 1) and `gmRing_tensor_homogeneousAway_isDomain` (Substrate 2) are axiom-clean. Clean.

### AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L771: `sorry` inside `hCP_check` in the proof of `gmScalingP1_chart_agreement_cross01` — the range-containment for the (III.c) cocycle closed points. Named and documented. Honest.
  - L944: `sorry` in `gmScalingP1_collapse_at_zero` — fixed-point property of σ_×. Named and documented. Honest.
  - The rest of the file (chart-bridge, chart-ring maps, cover construction, cocycle agreement for diagonal and symmetry cases) is axiom-clean.

### AlgebraicJacobian/Genus0BaseObjects/Points.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 actual sorry invocations in code (1 grep hit is in comment text). `ProjectiveLineBar.zeroPt`, `onePt`, `inftyPt`, `Ga`, `Gm`, `gmHomFunctor_representableBy`, `gm_grpObj`, `gm_smooth` are all axiom-clean. Clean.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `genusZeroWitness`: typed sorry (Phase-C scaffold, body gated on `rigidity_genus0_curve_to_grpScheme` in AbelianVarietyRigidity.lean). Honest.
  - `nonempty_jacobianWitness`: typed sorry (Phase-C OFF-LIMITS headline sorry, absorbing positive-genus Albanese existence + genus-0 rigidity). Explicitly documented. Honest.
  - `IsAlbanese`, `JacobianWitness`, `Jacobian` and the derived instances are all sorry-free.

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 9 flagged (file-skeleton scaffold)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: All declarations (`PicScheme`, `abelMap`, `smoothProperQuotient`, `representable`, `groupSchemeStructure`, plus internal placeholder helpers) carry typed sorry bodies with substantive types. File-skeleton scaffold per iter-196. Honest.

### AlgebraicJacobian/Picard/FlatteningStratification.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 8 flagged (file-skeleton scaffold)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: All declarations carry typed sorry bodies (Nitsure §4 content). Honest.

### AlgebraicJacobian/Picard/IdentityComponent.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 15 flagged (file-skeleton scaffold)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: All declarations carry typed sorry bodies with substantive types (iter-185 file-skeleton). Honest.

### AlgebraicJacobian/Picard/LineBundlePullback.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 actual sorry invocations in code (all 6 grep hits in comments). `IsLocallyTrivial`, `OnProduct`, `IsLocallyTrivial.pullback`, `pullbackAlongProjection`, `pullback_pullback_eq`, `preimage_subgroup`, `functorial` are all axiom-clean. **Notable improvement from prior iters.** Clean.

### AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 5 flagged (file-skeleton scaffold)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: All 5 pinned declarations (`tangentSpaceIso`, `smooth`, `proper`, `geometricallyIrreducible`, `isAbelianVariety`) carry typed sorry bodies. Honest.

### AlgebraicJacobian/Picard/QuotScheme.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 18 flagged (file-skeleton scaffold)
- **bad practices**: none
- **excuse-comments**: none
- **notes**: All declarations carry typed sorry bodies (Grothendieck–Altman–Kleiman content). Honest.

### AlgebraicJacobian/Picard/RelPicFunctor.lean
- **outdated comments**: none
- **suspect definitions**: 2 flagged (known, HELD)
- **dead-end proofs**: 1 flagged
- **bad practices**: none
- **excuse-comments**: 1 flagged
- **notes**:
  - **KNOWN HELD — re-confirmation**: `PicSharp := (CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))` at L330 still present. Placeholder pending `addCommGroup` closure.
  - **KNOWN HELD — re-confirmation**: `functorial := 0` (zero AddMonoidHom) at L377 still present. Placeholder pending `addCommGroup` closure.
  - L269: `addCommGroup` instance body is `exact sorry`. This is the only actual sorry in code.
  - L266: `-- TODO (Scheme.Modules monoidal-structure gate): close once Mathlib ships a monoidal-category instance on `Scheme.Modules` (or once the project-side `Scheme.Modules.tensorObj` lemma lands).` — this is an excuse-comment on the load-bearing `addCommGroup` sorry body. Per auditor rules, TODO comments on sorry bodies are red flags. **Severity: major** (mitigated from critical by the HELD-lane status and the fact this is a genuine external infrastructure gate, not an admission of mathematical wrongness).

### AlgebraicJacobian/Picard/RelativeSpec.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 actual sorry invocations in code (all 7 grep hits in doc-comments). `QcohAlgebra`, `RelativeSpec`, `RelativeSpec.structureMorphism`, `UniversalProperty`, `affine_base_iff`, `QcohAlgebra.pullback_fst_isAffineHom`, `QcohAlgebra.pullback_coequifibered`, `QcohAlgebra.pullback`, `pullback_cocone`, `pullback_cocone_desc_comp_fst`, `pullback_iso_desc_isIso`, `pullback_iso_construction`, `pullback_iso`, `base_change`, `functor` all axiom-clean. **Notable improvement.** Clean.

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean (focus file)
- **outdated comments**: 1 minor (iter-202 Lane TS scaffold references in docstrings, now in iter-206)
- **suspect definitions**: none
- **dead-end proofs**: 4 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Removed-declaration check (iter-206 pivot)**: The §2 comment at L135 explicitly documents the removal of `monoidalCategory`, `isMonoidal_W_of_whiskerLeft`, `monoidalCategoryOfIsMonoidalW`. No dangling references to these removed declarations found in the file. The removal is architecturally honest: §2 explains the full-monoidal-instance is off the critical path.
  - `tensorObj` (L113): concrete body (sheafification of `PresheafOfModules.Monoidal.tensorObj`). Axiom-clean.
  - `tensorObj_functoriality` (L129): concrete body. Axiom-clean.
  - `tensorObjIsoOfIso` (L164): concrete body. Axiom-clean.
  - `tensorObj_unit_iso` (L180): concrete body. Axiom-clean.
  - `restrictIsoUnitOfLE` (L198): concrete body. Axiom-clean.
  - `tensorObj_restrict_iso` (L244): proof body advanced to residual `sorry` at step 3 only. The advanced proof uses `restrictFunctorIsoPullback` (step 1) and `SheafOfModules.sheafificationCompPullback` (step 2) axiom-cleanly; the residual `sorry` is the presheaf base-change iso (`PresheafOfModules.pullback` monoidal instance). **This is the honest sorry documented in the memory file** — precisely `PresheafOfModules.pullback.Monoidal` is the missing ingredient. Honestly marked.
  - `tensorObj_isLocallyTrivial` (L294): proof body axiom-clean modulo the `tensorObj_restrict_iso` dependency.
  - `tensorObjOnProduct` (L332): concrete body, axiom-clean.
  - `exists_tensorObj_inverse` (L320): typed sorry. Honest.
  - `addCommGroup_via_tensorObj` (L360): typed sorry. Honest. Explicitly marked as non-instance to avoid diamond with RPF's `addCommGroup`.
  - The `@[implicit_reducible]` attribute on `addCommGroup_via_tensorObj` is unusual (implicitly reducible non-instance). Worth noting but not a correctness concern.

### AlgebraicJacobian/RiemannRoch/H1Vanishing.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 8-declaration file-skeleton scaffold. All typed sorries with substantive types. Honest.

### AlgebraicJacobian/RiemannRoch/OCofP.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 6 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**: All typed sorries (invertible sheaf `𝒪_C(P)` construction, global sections, H¹ vanishing, dimension formula, non-constant function). Honest.

### AlgebraicJacobian/RiemannRoch/OcOfD.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 3 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**: File-skeleton scaffold for 4 pinned declarations (`sheafOf`, `sheafOf_zero`, `sheafOf_singlePoint`, `sheafOf_ses_single_add`). All typed sorries. Honest.

### AlgebraicJacobian/RiemannRoch/RRFormula.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 3 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**: `eulerCharacteristic` definition is concrete. Remaining typed sorries for `WeilDivisor.l`, `eulerCharacteristic_eq_degree_plus_one_minus_genus`, `l_eq_degree_plus_one_of_genus_zero`. Honest.

### AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 5 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**: File-skeleton scaffold for 3 new declarations plus consuming the AbelianVarietyRigidity.lean pin. Typed sorries with substantive types. Honest.

### AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 4 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 9-declaration file-skeleton. `Scheme.PrimeDivisor` structure is concrete. All remaining declarations have typed sorry bodies. Honest.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 sorries in code. `ext_of_eqOnOpen`, `ext_of_isDominant_of_isSeparated'`, `rigidity_core`, `rigidity_lemma` are axiom-clean. Clean.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 1 sorry (iter-126 scaffold for `genusZeroWitness_kbar`). Typed sorry, Phase-C gated. Honest.

### AlgebraicJacobian/RigidityLemma.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**: 0 actual sorry invocations in code (4 grep hits are in doc-comment text). `rigidity_eqOn_dense_open`, `hom_additive_decomp_of_rigidity`, `av_regularMap_isHom_of_zero`, `rigidity_lemma` are axiom-clean. Clean. (Note: the file-level comment states "the whole Rigidity-Lemma chain is sorry-free".)

---

## Must-fix-this-iter

None new. All existing sorry bodies are honest typed sorries with documented justification. The two HELD-lane placeholders in RelPicFunctor.lean are re-confirmed below but are not new must-fix items.

---

## Major

- `Picard/RelPicFunctor.lean:266` — `-- TODO (Scheme.Modules monoidal-structure gate): close once Mathlib ships a monoidal-category instance on \`Scheme.Modules\` (or once the project-side \`Scheme.Modules.tensorObj\` lemma lands).` This TODO comment is attached to the `addCommGroup` sorry body (`exact sorry`). Per auditor rules, TODO comments on sorry bodies are excuse-comments (red flags). The mitigation is that it accurately describes a genuine external gate and the RPF is a HELD lane, which limits severity from critical; but the presence of an explicit `TODO` on a sorry warrants flagging.

- `Genus0BaseObjects/BareScheme.lean:220` — `instance projectiveLineBar_geomIrred ... := sorry`. The phrase "plan-marked acceptable for iter-165" in the comment is a mitigating-excuse on a sorry instance. A sorry `instance` is particularly risky because it propagates silently through `inferInstance` into downstream proofs without explicit sorry markers. Marked as major (not must-fix) because: the comment acknowledges the gap, it has been the status quo since iter-165, and the corresponding Mathlib gap is genuine (`GeometricallyIrreducible` for `Proj` of a polynomial ring is not shipped).

---

## Minor

- `Picard/TensorObjSubstrate.lean:37–86` — Module-level docstring references "iter-202 Lane TS scaffold" throughout. This is outdated; the file is in iter-206 and the scaffold has been partially filled. The docstring accurately describes iter-202 history, but the "iter-202" label may mislead future readers about current status. Cosmetic.

---

## Excuse-comments (always called out separately)

- `Picard/RelPicFunctor.lean:266`: `"TODO (Scheme.Modules monoidal-structure gate): close once Mathlib ships a monoidal-category instance on \`Scheme.Modules\`..."` (attached to `PicSharp.addCommGroup`, which is load-bearing for `PicSharp`, `PicSharp.functorial`, `PicSharp.presheaf`, `PicSharp.etSheaf`). Severity: major (HELD lane mitigates from critical).

- `Genus0BaseObjects/BareScheme.lean:215–220`: `"Project-side scaffold sorry (Mathlib does not ship \`GeometricallyIrreducible\` for \`Proj\` of a polynomial ring; plan-marked acceptable for iter-165)."` The phrase "plan-marked acceptable" mitigates but the comment admits the body is a sorry without further timeline. Severity: major (well-documented gap, long-standing).

---

## HELD-lane re-confirmation

As requested by directive, re-confirming the iter-203/205 flagged placeholders in `RelPicFunctor.lean` are still present:

- **L330**: `PicSharp := (CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))` — still present. Dishonest placeholder pending `addCommGroup` closure.
- **L377**: `functorial := 0` (zero AddMonoidHom) — still present. Dishonest placeholder pending `addCommGroup` closure.

Both are in the HELD-lane RPF and persist unchanged.

---

## Severity summary

- **must-fix-this-iter**: 0 — no new blocking issues found
- **major**: 2 — both excuse-comments (RelPicFunctor TODO + BareScheme "plan-marked acceptable")
- **minor**: 1 — stale iter-number in TensorObjSubstrate docstring
- **excuse-comments**: 2 (also counted under major above)

Overall verdict: The codebase is structurally sound for iter-206 — every sorry body carries honest documentation of the residual gap, no weakened-wrong definitions were introduced, and `TensorObjSubstrate.lean`'s iter-206 pivot (removal of unreachable monoidal instance + advancement of `tensorObj_restrict_iso` to a named residual) is correctly implemented with no dangling references. Two pre-existing excuse-comments (RelPicFunctor TODO and BareScheme scaffold) are flagged as major but are in known long-standing held lanes.
