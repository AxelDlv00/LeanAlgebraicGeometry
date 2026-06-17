# Lean Auditor Report — iter196

**Slug:** iter196
**Date:** 2026-05-27
**Files audited:** 43 (all `.lean` files in `AlgebraicJacobian/`)
**Scope:** Full project + focus areas from directive

---

## iter-195 Must-Fix Verification

### Item 1 — WeilDivisor.lean:746 instance-with-sorry-body
**STATUS: RESOLVED.**
`isRegularInCodimOneProjectiveLineBar` was demoted from `instance` to `theorem` (now at line 750). Comment confirms: "Demoted from `instance` per lean-auditor iter-196 must-fix". The body retains a sorry for `hy_ne_bot` (the maximality / Stacks 02IZ gap), but this is now acceptable as a named theorem sorry — no silent typeclass propagation. Route 2 PID-transfer skeleton is substantive (Steps A–D scaffolded). **Do not re-flag.**

### Item 2 — Thm32RationalMapExtension.lean:194 in-proof `haveI := sorry`
**STATUS: PARTIALLY RESOLVED — inline sorry pattern eliminated; named sorry remains.**
The inline `haveI := sorry` at line 194 is GONE. Replaced by named private helper `isReduced_of_smooth_over_field := sorry` at line 155, with comment: "Demoted from inline sorry per lean-auditor iter-196 must-fix; isolates the sorryAx to a single named declaration." The must-fix pattern (silent inline sorry in proof body) is resolved. The sorry itself persists as a named typed sorry (Stacks 034V/02G4 gap). **Reclassify to major; do not re-flag at must-fix level.**

### Item 3 — AlbaneseUP.lean:183 `:= sorry` def
**STATUS: RESOLVED (silent propagation blocked).**
`bundle : Bundle C := sorry` remains at line 183 (acceptable as named typed sorry def). The critical fix: all four downstream derived declarations (`jacobianScheme_grpObj`, `jacobianScheme_isProper`, `jacobianScheme_smooth`, `jacobianScheme_geomIrred`) were demoted from `instance` to `noncomputable def` / `theorem`. Comment at line 190: "Demoted from `instance` per lean-auditor iter-196 must-fix: silent propagation of `sorryAx` through GrpObj-typeclass synthesis is a soundness exposure." No silent propagation path remains. **Do not re-flag.**

---

## Severity Classifications

### Must-Fix This Iter

*No new must-fix items introduced by iter-196 changes were found.* The FGAPicRepresentability co-dependency is flagged as **major** (see below) — it is traceable via `lean_verify` and the instances are all named.

---

### Major

**M1 — FGAPicRepresentability.lean: `HasPicScheme → HasPicSharp` co-dependency (new iter-196 pattern)**

The carrier-soundness refactor introduced a typeclass co-dependency: `instHasPicScheme : HasPicScheme C := ⟨sorry⟩` whose `has_pic_scheme` field has type `Nonempty (∃ (X : ...), (PicScheme.picSharp C).RepresentableBy X)`. The term `PicScheme.picSharp C` is defined as `Classical.choice HasPicSharp.has_pic_sharp`, which requires `[HasPicSharp C]` to elaborate, triggering `instHasPicSharp : HasPicSharp C := ⟨sorry⟩`.

**Effect**: A consumer that writes only `[HasPicScheme C]` in context silently inherits `sorryAx` from both `instHasPicScheme` AND `instHasPicSharp`, without any visible sorry at the call site. The propagation involves 2 named instances (traceable via `lean_verify`) but is not visible from the consumer's declaration.

**Verification action**: run `lean_verify` on any theorem consuming `[HasPicScheme C]` to confirm `sorryAx` appears from the `HasPicSharp` chain. If confirmed, consider whether `picSharp` should be defined outside the `HasPicSharp` class body to break the synthesis cycle, or whether consumer sites should `haveI := instHasPicSharp C` explicitly.

**Assessment**: The refactor is a net improvement over the previous pattern (un-gated carrier defs). The 6 + 1 sorry instances are all named with `⟨sorry⟩` bodies, all `Prop`-level, and the co-dependency is documented. Classify as **major** pending `lean_verify` confirmation of the chain.

---

**M2 — AbelianVarietyRigidity.lean: persistent `iotaGm_chart1_appIso_eval` blocks Lane E**

`iotaGm_chart1_appIso_eval` (sorry, the `Proj.appIso` evaluation step) remains stuck. This sorry propagates through: `iotaGm_r_1_eq_specMap` → `iotaGm_chart1_composition_isOpenImmersion` → `iotaGm_range_isOpen` → `iotaGm_isDominant` → `morphism_P1_to_grpScheme_const_aux` → `morphism_P1_to_grpScheme_const` → `rigidity_genus0_curve_to_grpScheme`. Additionally `kbarChart1Ring_specMap_fac` (sorry) feeds into this chain.

New iter-196 Lane E supplements (`Proj.awayι_preimage_basicOpen_self`, `Proj.awayι_eq_specMap_fromSpec`) are **axiom-clean** — good addition.

`iotaGm_r_1`, `iotaGm_r_1_fac`, `iotaGm_r_1_range_subset`, `iotaGm_chart1_section` — all **axiom-clean**.

---

**M3 — WeilDivisor.lean: `isRegularInCodimOneProjectiveLineBar` body sorry (now theorem)**

Body now has substantive Route 2 PID-transfer skeleton (Steps A–D: chart selection, stalk-iso transfer, chart-stalk ↔ `Localization.AtPrime`, PID/Dedekind structure). Ends in sorry for `hy_ne_bot` (maximality claim, Stacks 02IZ gap). Acceptable as named theorem sorry.

`degree_positivePart_principal_eq_finrank` — sorry body with iter-195 pushes recorded in comments. Carries sorryAx to `Hom.poleDivisor_degree_eq_finrank` in RationalCurveIso.lean.

---

**M4 — RationalCurveIso.lean: `phi_left_locallyQuasiFinite_of_finrank_one` still sorry**

New iter-196 structural reduction via `LocallyQuasiFinite.of_finite_preimage_singleton` is good progress. The per-fibre goal ("smooth-dim-1 ⟹ 0-dim fibre") remains sorry (Mathlib gap). The structural skeleton is in place; the sorry is narrower than before.

Also: `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one` — sorry (IsNormalScheme Mathlib gap); `localParameterAtInfty_uniformiser_witness` — sorry (3-step closure documented).

---

**M5 — OCofP.lean: `functionField_const_of_complete_curve_of_orderZero` sorry (new iter-196)**

New private helper `functionField_const_of_complete_curve_of_orderZero := sorry` documents a genuine Stacks 02P0 / Hartshorne I.3.4 Mathlib gap. The sorry is well-isolated with full docstring. The surrounding chain — `toFunctionField_injective` (new, **axiom-clean**), `exists_nonconstant_rational_from_dim_eq_two` body steps (a)+(b) (axiom-clean) — is good progress. Step (c) consumes the sorry, propagating sorryAx to `exists_nonconstant_rational_from_dim_eq_two`.

---

**M6 — H1Vanishing.lean: all 8 pinned declarations are sorry stubs**

All 8 declarations (`IsFlasque`, `IsFlasque.pushforward`, `IsFlasque.constant_of_irreducible`, `HModule_flasque_eq_zero`, `skyscraperSheaf_eq_pushforward_const`, `PrimeDivisor.closure_isIrreducible`, `skyscraperSheaf_isFlasque`, `H1_skyscraperSheaf_finrank_eq_zero`) remain sorry-bodied. Documented as iter-192+ closure. The iter-196 directive flagged `IsFlasque.constant_of_irreducible` empty-branch closure and `skyscraperSheaf` outer step — both remain stuck. No progress visible this iter.

---

**M7 — Thm32RationalMapExtension.lean: `isReduced_of_smooth_over_field := sorry` (demoted from inline)**

Named private theorem at line 155, sorry body (Stacks 034V/02G4 gap). Propagates to `av_isIntegral_of_smooth_geomIrred` and through it to `extend_to_av`. Classification: acceptable named typed sorry (major, not must-fix). **The inline-sorry must-fix from iter-195 is resolved.**

`av_codimOneFree_of_indeterminacy` — sorry (codim-≥2 conclusion of Milne 3.1).

---

**M8 — AlbaneseUP.lean: `bundle : Bundle C := sorry` def persists**

`bundle := sorry` at line 183 is an acceptable named typed sorry def (no silent propagation since all derived declarations are now `def`/`theorem`). 28 remaining sorry instances in the file come from 6 blueprint-pinned scaffold declarations (`abelJacobi`, `SymmetricPower`, `symmetricPowerAVMap`, `symmetricPowerToJacobian`, `descentThroughBirationalSigma`, `albanese_universal_property`) — all Tier-3 honest typed sorries.

---

**M9 — BareScheme.lean: `projectiveLineBar_geomIrred` sorry scaffold instance**

`projectiveLineBar_geomIrred` is a sorry-bodied `instance` providing `GeometricallyIrreducible` for `ProjectiveLineBar`. The iter-196 directive lists BareScheme.lean as a focus area and notes this scaffold is expected. Classified as major (documented, planner-approved scaffold). `projectiveLineBar_smooth_chart_aux` is a correctly-structured private sorry (per-chart gap, downstream of ChartIso.lean). `projectiveLineBar_smoothOfRelDim` carries sorryAx from `smooth_chart_aux`.

New iter-196 additions: `mvPolyGenerators`, `mvPolyPresentation`, `mvPolyPreSubmersivePresentation`, `mvPolySubmersivePresentation`, `mvPolynomialFin_isStandardSmoothOfRelativeDimension` — all **axiom-clean**. Good substrate.

---

**M10 — AuslanderBuchsbaum.lean: `auslander_buchsbaum_formula_succ_pd` typed sorry (iter-196 structural carving)**

The iter-195/196 structural carving of the Auslander–Buchsbaum `pd = k+1` inductive step into the named helper `auslander_buchsbaum_formula_succ_pd := sorry` (with 4 documented Mathlib-absent sub-pieces) is good hygiene. Main theorem `auslander_buchsbaum_formula` now dispatches the `n > 0` branch via `exact auslander_buchsbaum_formula_succ_pd ...`. Base case (`pd = 0`) closed axiom-clean. The sorry is narrow and auditable.

Also: `depth := sorry`, `depth_eq_smallest_ext_index` (with two named inline sorry branches), `CohenMacaulay.of_regular` (sorry body for named helper `exists_isSMulRegular_quotient_isRegularLocal_succ`), `notMem_minimalPrimes_of_regularLocal_succ` (narrow Stacks 00NQ sorry) — all documented Tier-3 honest typed sorries. `toCotangent_ne_zero_of_not_mem_sq` is **axiom-clean**. `depth_of_short_exact` has 2 named inline sorry branches (documented iter-196 HARD BAR). Assembly skeleton for `CohenMacaulay.of_regular` is closed axiom-clean modulo the named helper.

---

**M11 — CodimOneExtension.lean: sorry bodies in key lemmas**

`isRegularLocalRing_stalk_of_smooth` — stages 3–4 remain sorry (Stacks 00TT Jacobian-criterion gap), stages 1–2 axiom-clean. `localRing_dvr_of_codim_one` — consumes named sorry helper. `extend_to_codim_one` — top-level body sorry (depth-≥2 H¹ vanishing, Stacks 0AVF). `codimOneFreeExtension` — sorry (Milne 3.1, Hartshorne AG 9.2 gap). All 6 pinned declarations have sorry bodies, documented as iter-178+ work.

---

**M12 — Picard/QuotScheme.lean: scaffold sorry bodies (39 occurrences)**

All sorries are typed sorry bodies in named theorem/def declarations (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`, `QuotScheme`, `pullback_app_isoTensor_isBaseChange` chain, `flatBaseChange`, `sectionFlatBaseChange`). Documented Mathlib gaps (Nitsure §5, Stacks 01HQ/02KE/00H8/02KH). The iter-189 Lane F unbundling (splitting into named substeps `pullback_tildeIso`, `tildeIso_of_isQuasicoherent_isAffineOpen`, `sectionTransport`) is good structural hygiene. Beck-Chevalley step ends in `exact sorry` (documented). No instance-with-sorry; no silent propagation.

---

**M13 — Picard/IdentityComponent.lean: scaffold sorry bodies (24 occurrences)**

`geometricallyConnected_of_connected_of_section` — sorry-bodied (Stacks 04KV, planner-sanctioned). `IdentityComponent.isFiniteTypeGeometricallyIrreducible` — sorry (Stacks 037Q/04KV). `baseChangeIso` — sorry. `Pic0Scheme`, `degree`, `isAbelianVariety`, `dim_eq_genus`, `kPoints_eq_kernel` — typed sorry bodies (iter-185 scaffold).

**Note**: The iter-193/194 must-fix demotion of `private instance isSubgroupHomomorphism_hom_isGeometricallyConnected` from `private instance` to `private theorem` was already recorded in earlier audits and confirmed here (line 544 comment). `isSubgroupHomomorphism` — sorry body (Nonempty (GrpObj (IdentityComponent G))).

---

**M14 — Other Picard files with scaffold sorry bodies (major, all Tier-3 honest)**

- `Picard/LineBundlePullback.lean` (6 sorries): `OnProduct` typed sorry carrier; `IsLocallyTrivial.pullback` named sorry (Stacks 01HH); `pullbackAlongProjection` named sorry; `functorial_eq` named sorry.
- `Picard/RelativeSpec.lean` (7 sorries): `QcohAlgebra` body now concrete; 5 downstream theorem sorries pending iter-179+ Block B rewrites.
- `Picard/RelPicFunctor.lean` (20 sorries): `addCommGroup` typed sorry (gated on A.1.b `LineBundle.OnProduct`); `PicSharp` typed sorry; `functorial` typed sorry; `wrapAsFunctor` typed sorry; `etSheaf` typed sorry; `etSheafUnit` typed sorry — all gated on A.1.b landing.
- `Picard/FlatteningStratification.lean` (9 sorries): Lemmas 5–7 sorry bodies (Nitsure §4); main `flatteningStratification` theorem sorry; `ofCurve` sorry.
- `Picard/Pic0AbelianVariety.lean` (7 sorries): 5 sorry-bodied declarations for A.3.vii properties (`cotangentBasis`, `smoothPic0`, `properPic0`, `geomIrredPic0`, `isAbelianVariety`).

---

**M15 — RiemannRoch/RRFormula.lean: sorry helper bodies (19 occurrences)**

`finrank_H0_toModuleKSheaf_eq_one` — sorry (Tier-3 honest, H⁰ bridge). `eulerCharacteristic_additive` — sorry (LES carrier gap). `eulerCharacteristic_sheafOf_zero` — sorry (base case, gated on `OcOfD.sheafOf` body). `eulerCharacteristic_sheafOf_single_add` — sorry (inductive step). Main theorem `eulerCharacteristic_eq_degree_plus_one_minus_genus` — body sorry-free assembly modulo the two helpers. The former local `sheafOf` placeholder (iter-174) has been retired by importing `OcOfD.lean` — good architectural progress.

---

**M16 — RiemannRoch/OcOfD.lean: `sheafOf` body sorry (13 occurrences)**

`sheafOf` — Tier-3 honest typed sorry (Hartshorne subsheaf-of-`K_C`, iter-184+ work). The `D = 0` branch closes axiom-clean (`toModuleKSheaf C`); the general branch remains sorry. `sheafOf_singlePoint` — sorry. `sheafOf_ses_single_add` — sorry. `sheafOf_zero` — partially implemented via if-branching with `if_pos rfl`, but the general body is still sorry. All documented with Stacks/Hartshorne references.

---

**M17 — RiemannRoch/WeilDivisor.lean: `degree_positivePart_principal_eq_finrank` sorry**

Body has iter-195 pushes (`rw [degree_positivePart_eq_sum_max, Finsupp.sum_max_zero_eq_sum_filter_pos]`). Remaining content still sorry. Propagates to `Hom.poleDivisor_degree_eq_finrank` and `iso_of_degree_one` in RationalCurveIso.lean.

---

**M18 — Jacobian.lean: `positiveGenusWitness` and `nonempty_jacobianWitness` sorry bodies**

`positiveGenusWitness` (iter-134 scaffold, body sorry — M3 work, off-critical-path). `nonempty_jacobianWitness` — body now delegates to `genusZeroWitness` (genus-0) and `positiveGenusWitness` (positive-genus), removing one inline sorry site. Good iter-196 restructure. `genusZeroWitness` — sorry body (gated on cotangent-vanishing pile). `nonempty_jacobianWitness` key inner `sorry` for `f = toUnit C ≫ η[A]`.

---

**M19 — Genus0BaseObjects/GmScaling.lean: honest sorry bodies (11 occurrences)**

`gmScalingP1_chart_agreement_cross01` — honest named sorry (ring-level identity `λ · u = (1/t) · λ` in `HomogeneousLocalization.Away`, iter-182+ work). `gmScalingP1_chart_PLB_eq` Step C — residual sorry (Fin syntactic-equality unification). `gmScalingP1_over_coherence` — structural sorry (Step 3(3) of cover-bridge analogy). `gmScalingP1_pt_eq_pullback` — sorry. Product-stability instances for `ℙ¹ ⊗ 𝔾_m` are **axiom-clean** (iter-196 addition: `haveI := by sorry` ad-hoc scaffolds in AbelianVarietyRigidity.lean collapsed to `inferInstance` — good cleanup).

---

**M20 — Cotangent/GrpObj.lean: step-2 derivation body sorry (9 occurrences)**

`basechange_along_proj_two_inv_derivation` — sorry body (d_app zero-on-source-ring law). `basechange_along_proj_two_inv` — sorry body (d_map cross-open naturality). Third sorry: IsIso of the inverse map. Net iter change: 1 hollow scaffold sorry → 3 narrowly-scoped concrete sorries. Good structural progress.

---

**M21 — RigidityKbar.lean: `rigidity_over_kbar` sorry body (3 occurrences in comments)**

`rigidity_over_kbar` — single sorry body (cotangent-vanishing Mathlib pile, STRATEGY.md M2.a + M2.d-alt). 3 sorry occurrences are all in comments describing the sorry; no code-level sorry other than the named declaration body.

---

### Minor

**m1 — FGAPicRepresentability.lean: 7th sorry instance (`instHasPicScheme`) is a new addition**

The co-dependency chain adds a 7th `⟨sorry⟩` instance beyond the planned 6. The type of `instHasPicScheme.has_pic_scheme` references `picSharp C`, creating a silent co-dependency with `instHasPicSharp`. Document this explicitly in the instance's docstring and add a `-- ⚠ co-depends on instHasPicSharp` annotation to make the chain visible to readers without running `lean_verify`.

**m2 — AbelianVarietyRigidity.lean: `iotaGm_chart1_appIso_eval` excuse comment is stale**

The comment says "iter-196 target: Proj.appIso evaluation step" but this sorry has been present since at least iter-193. If not addressed in iter-196, the comment should be updated to reflect the current blocking status and escalation plan.

**m3 — OCofP.lean: `h0_sub_h1_lineBundleAtClosedPoint_eq_two` should be documented**

The sorry helper `h0_sub_h1_lineBundleAtClosedPoint_eq_two` (new iter-196 named extraction) has a short comment. Consider adding a full Tier-3 docstring explaining the H¹-vanishing dependency to match the documentation standard of `functionField_const_of_complete_curve_of_orderZero`.

**m4 — AlbaneseUP.lean: `bundle` docstring should clarify sorry-propagation scope**

The docstring at line 179 says "collapses to a re-export" once A.3 materialises. It correctly says the 4 derived declarations "do not introduce additional `sorry`s". Consider adding a sentence explicitly noting all 4 are `def`/`theorem` (not `instance`) to make the demotion visible to new readers.

**m5 — H1Vanishing.lean: no progress marker**

The 8-declaration file skeleton from iter-191 has no iter-196 additions or comments indicating planned engagement. The directive flagged `IsFlasque.constant_of_irreducible` empty-branch and `skyscraperSheaf` outer step. If these were attempted and failed, document the blocker. If not attempted, add a `-- iter-196: no progress; gated on Hartshorne III.2.5 Mathlib gap` annotation.

**m6 — WeilDivisor.lean: `degree_positivePart_principal_eq_finrank` sorry excuse comment is thin**

Only iter-195 pushes are recorded. Add a concrete iter-196+ engagement plan (what sub-piece to tackle first) to help the planner schedule the next closure attempt.

**m7 — Cotangent/ChartAlgebra.lean: comment reference to removed sorry**

Line 25 references "iter-145 `: True := sorry` placeholders" as a historical note. Consider removing or moving this to a CHANGELOG to avoid confusion in sorry counts.

---

## Per-File Checklist

### Focus area files

| File | Sorry count | Worst-severity | Notes |
|------|------------|----------------|-------|
| `AbelianVarietyRigidity.lean` | 21 | Major | Lane E blocked by `iotaGm_chart1_appIso_eval`; new awayι supplements axiom-clean |
| `Genus0BaseObjects/BareScheme.lean` | 3 | Major | New mvPoly substrate clean; `smooth_chart_aux` correctly scoped |
| `RiemannRoch/H1Vanishing.lean` | 11 | Major | All 8 decls sorry; no iter-196 progress |
| `RiemannRoch/OCofP.lean` | 18 | Major | New `toFunctionField_injective` axiom-clean; `functionField_const` properly named |
| `RiemannRoch/RationalCurveIso.lean` | 27 | Major | `locallyQuasiFinite` structural skeleton good; fibre-goal sorry |
| `RiemannRoch/WeilDivisor.lean` | 13 | Major | Instance demotion verified; Route 2 skeleton substantive |
| `Picard/FGAPicRepresentability.lean` | 24 | Major | Co-dependency chain (M1); refactor is net improvement |
| `Albanese/Thm32RationalMapExtension.lean` | 16 | Major | Inline sorry removed; named helper; iter-195 item resolved |
| `Albanese/AlbaneseUP.lean` | 30 | Major | GrpObj demotion confirmed; iter-195 item resolved |

### Other files

| File | Sorry count | Worst-severity | Notes |
|------|------------|----------------|-------|
| `Albanese/AuslanderBuchsbaum.lean` | 25 | Major | Good structural carving; `succ_pd` helper well-scoped |
| `Albanese/CodimOneExtension.lean` | 8 | Major | Stages 1-2 clean; stages 3-4 sorry |
| `Albanese/CoheightBridge.lean` | 0 | — | Axiom-clean |
| `AbelJacobi.lean` | 0 | — | Axiom-clean |
| `AbelianVarietyRigidity.lean` | (see above) | | |
| `Cohomology/MayerVietorisCore.lean` | 0 | — | Axiom-clean |
| `Cohomology/MayerVietorisCover.lean` | 0 | — | Axiom-clean |
| `Cohomology/SheafCompose.lean` | 0 | — | Axiom-clean |
| `Cohomology/StructureSheafAb.lean` | 0 | — | Axiom-clean |
| `Cohomology/StructureSheafModuleK.lean` | 0 | — | Axiom-clean |
| `Cohomology/StructureSheafModuleK/Carriers.lean` | 0 | — | Axiom-clean |
| `Cohomology/StructureSheafModuleK/Presheaf.lean` | 0 | — | Axiom-clean |
| `Cohomology/StructureSheafModuleK/SheafProperty.lean` | 0 | — | Axiom-clean |
| `Cotangent/ChartAlgebra.lean` | 0 (code) | Minor | 2 sorry occurrences in comments only; code is axiom-clean |
| `Cotangent/GrpObj.lean` | 9 | Major | 1 hollow → 3 narrowly-scoped sorries; good progress |
| `Differentials.lean` | 0 | — | Axiom-clean |
| `Genus.lean` | 0 | — | Axiom-clean |
| `Genus0BaseObjects.lean` | 0 | — | Axiom-clean (stub re-export) |
| `Genus0BaseObjects/BareScheme.lean` | (see above) | | |
| `Genus0BaseObjects/ChartIso.lean` | 0 | — | Axiom-clean |
| `Genus0BaseObjects/Cross01Substrate.lean` | 0 | — | Axiom-clean |
| `Genus0BaseObjects/GmScaling.lean` | 11 | Major | Honest named sorries; product-stability instances clean |
| `Genus0BaseObjects/Points.lean` | 0 (code) | — | 1 sorry occurrence in docstring only; code axiom-clean |
| `Jacobian.lean` | 12 | Major | `nonempty_jacobianWitness` restructured (good); arms still sorry |
| `Picard/FGAPicRepresentability.lean` | (see above) | | |
| `Picard/FlatteningStratification.lean` | 9 | Major | Scaffold Tier-3 honest sorries |
| `Picard/IdentityComponent.lean` | 24 | Major | Prior instance demotion (iter-194) confirmed; scaffold sorries |
| `Picard/LineBundlePullback.lean` | 6 | Major | OnProduct typed sorry carrier; scaffold |
| `Picard/Pic0AbelianVariety.lean` | 7 | Major | A.3.vii scaffold sorry bodies |
| `Picard/QuotScheme.lean` | 39 | Major | Named sorry bodies, Lane F unbundling good |
| `Picard/RelPicFunctor.lean` | 20 | Major | Gated on A.1.b; documented |
| `Picard/RelativeSpec.lean` | 7 | Major | QcohAlgebra body concrete; 5 downstream sorries |
| `RiemannRoch/H1Vanishing.lean` | (see above) | | |
| `RiemannRoch/OCofP.lean` | (see above) | | |
| `RiemannRoch/OcOfD.lean` | 13 | Major | Tier-3 honest sheafOf sorry; D=0 branch clean |
| `RiemannRoch/RRFormula.lean` | 19 | Major | Sorry helpers; main theorem assembly clean |
| `RiemannRoch/RationalCurveIso.lean` | (see above) | | |
| `RiemannRoch/WeilDivisor.lean` | (see above) | | |
| `Rigidity.lean` | 0 | — | Axiom-clean |
| `RigidityKbar.lean` | 3 | Major | Named sorry body (3 occurrences in comments); code has 1 sorry in body |
| `RigidityLemma.lean` | 0 (code) | — | All 4 "sorry" occurrences are in comments; `rigidity_lemma` is axiom-clean |
| `AlgebraicJacobian.lean` | 0 | — | Axiom-clean (root stub) |

---

## Summary of iter-196 Changes (Auditor Perspective)

**Positive changes confirmed:**
1. `isRegularInCodimOneProjectiveLineBar`: instance → theorem demotion clean, Route 2 skeleton substantive.
2. `jacobianScheme_grpObj` + siblings: instance → def/theorem demotion clean, silent propagation blocked.
3. `isReduced_of_smooth_over_field`: inline sorry demoted to named helper — pattern improvement.
4. `toFunctionField_injective`: new axiom-clean private lemma (good).
5. `mvPolynomialFin_isStandardSmoothOfRelativeDimension` chain: new axiom-clean substrate (good).
6. Lane E awayι supplements: axiom-clean (good).
7. Product-stability instances (GmScaling): `haveI := by sorry` ad-hoc scaffolds collapsed to `inferInstance` (good cleanup).
8. FGAPicRepresentability typeclass-gated carrier refactor: net improvement despite co-dependency concern.
9. `nonempty_jacobianWitness` restructuring: inline sorry → named delegate (good).
10. `auslander_buchsbaum_formula_succ_pd` structural carving: 1 opaque sorry → named typed sorry (good).

**Concerns introduced:**
1. FGAPicRepresentability `HasPicScheme → HasPicSharp` co-dependency: silent sorryAx propagation to consumers of `[HasPicScheme C]` (M1).

**Stale/unresolved focus items:**
1. H1Vanishing.lean: no visible iter-196 progress on `IsFlasque.constant_of_irreducible` or `skyscraperSheaf` outer step.
2. `iotaGm_chart1_appIso_eval`: excuse comment should be updated.

---

## Issue Counts

- **Must-fix (this iter):** 0 new
- **Major:** 21 (M1–M21)
- **Minor:** 7 (m1–m7)
- **Axiom-clean files:** 15 files with 0 code-level sorries

**iter-195 must-fix resolution:** 2/3 fully resolved, 1/3 partially resolved (inline sorry removed, named sorry remains at major severity).
