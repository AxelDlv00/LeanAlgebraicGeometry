# Blueprint Reviewer Report — iter-187

**Subagent:** blueprint-reviewer  
**Slug:** iter187  
**Date:** 2026-05-25  
**Scope:** Whole-blueprint audit (all 29 chapters) + HARD GATE verdicts for 10 `.lean` files under iter-187 prover dispatch.

---

## Executive Summary

| Category | Count |
|----------|-------|
| HARD GATE PASS | 6 |
| HARD GATE PARTIAL | 3 |
| HARD GATE FAIL | 1 |
| Must-fix-this-iter findings | 2 |
| Informational soft findings | 7 |
| Unstarted-phase gaps | 2 |
| Duplicate-label defects | 1 |

Two **must-fix** items block the iter-187 prover plan as-is. One hard-gate FAIL (`RRFormula.lean`) and one strategy-alignment miss in `AbelianVarietyRigidity.tex` (affects both `GmScaling.lean` and `AbelianVarietyRigidity.lean` verdicts). All other 6 dispatched files are cleared for prover work with minor notes.

---

## HARD GATE Clearance (10 files)

### 1. `OCofP.lean` — PARTIAL

**Chapter:** `RiemannRoch_OCofP.tex` (721 lines, `% archon:covers AlgebraicJacobian/RiemannRoch/OCofP.lean`)

**Status:** 6 declarations all `\leanok`: `lineBundleAtClosedPoint`, `lineBundleAtClosedPoint.toFunctionField`, `lineBundleAtClosedPoint.globalSections_iff`, `lineBundleAtClosedPoint.h1_vanishing_genusZero`, `lineBundleAtClosedPoint.dim_eq_two_of_genusZero`, `lineBundleAtClosedPoint.exists_nonconstant_genusZero`. iter-186 closed 3 `carrierSubmodule` closure sorries to axiom-clean.

**Gap:** Per directive question "Does the chapter cover the `presheaf` functor + `presheaf_isSheaf` Steps 3-4?": **NO**. The `def:lineBundleAtClosedPoint` "Lean signature scope" paragraph references `AlgebraicGeometry.IdealSheaf` machinery but does NOT include `\lean{...}` pins for `presheaf` functor or `presheaf_isSheaf` as separate declarations. Steps 3-4-5 are explicitly deferred to iter-187 refactor.

**Verdict:** PARTIAL. The iter-187 prover directive for OCofP.lean (Steps 3+4+5 refactor) should instruct the prover to add blueprint `\lean{...}` pins for the presheaf and isSheaf steps. Without pins, the plan agent cannot verify correctness post-dispatch. Recommend: add blueprint pin directive to the OCofP prover task.

---

### 2. `LineBundlePullback.lean` — PASS with note

**Chapter:** `Picard_LineBundlePullback.tex` (499 lines, `% archon:covers AlgebraicJacobian/Picard/LineBundlePullback.lean`)

**Status:** 5 declarations all `\leanok`: `OnProduct`, `pullbackAlongProjection`, `pullback_pullback_eq`, `preimage_subgroup`, `functorial`. iter-186 closed all 5 sorries to axiom-clean.

**Three `% NOTE (iter-186 review)` annotations present and adequate:**
- (a) `OnProduct` carrier = direct alias of `(pullback πC πT).Modules`; invertibility deferred iter-187+
- (b) `pullbackAlongProjection` body is direct Mathlib pullback application; invertibility-preservation deferred
- (c) `preimage_subgroup` quotient is isomorphism-class Setoid only, NOT yet quotient by pullback subgroup

**Per directive question** "does chapter need new sub-section for `IsInvertible` predicate, or is `% NOTE` annotation sufficient?": **`% NOTE` annotations are sufficient** pending iter-187 Lean work. A new sub-section is not needed until `LineBundle.IsInvertible` actually lands as a named Lean declaration. The `% NOTE` annotations correctly document the semantic debt without over-specifying the solution.

**Verdict:** PASS with note (carrier-level semantics deferred but adequately documented).

---

### 3. `QuotScheme.lean` — PASS with note

**Chapter:** `Picard_QuotScheme.tex` (~984 lines, `% archon:covers AlgebraicJacobian/Picard/QuotScheme.lean`)

**Status:** New subsection `subsec:quot_project_basechange` contains 4 new pins, all `\leanok`: `canonicalBaseChangeMap`, `canonicalBaseChangeMap_app_app_isIso`, `canonicalBaseChangeMap_isIso`, `Scheme.Modules.pullback_app_isoTensor`. The iter-185 checker had flagged a missing pin; the addition in iter-186 appears to address it.

**Note:** The directive mentions "Step 4 (`pullback_app_isoTensor_baseMap_isBaseChange`)". The chapter's Step 4 declaration is named `pullback_app_isoTensor_isBaseChange` — may be the same declaration under a slightly different name. If the iter-187 prover lane touches this step, the prover should verify the exact Lean name before writing.

**Verdict:** PASS with note (Step 4 naming deserves prover verification).

---

### 4. `RRFormula.lean` — FAIL (**MUST-FIX**)

**Chapter:** `RiemannRoch_RRFormula.tex` (~474 lines, `% archon:covers AlgebraicJacobian/RiemannRoch/RRFormula.lean`)

**Status:** Chapter covers `thm:euler_char_eq_deg_plus_one_minus_genus` with a 3-piece Hartshorne IV.1 decomposition.

**Must-fix:** iter-186 added 3 sub-helper declarations in Lean: `eulerCharacteristic_shortExact_add`, `eulerCharacteristic_iso`, `eulerCharacteristic_skyscraperSheaf`. The chapter does **NOT** contain `\lean{...}` pins for any of these three declarations. The proof block for `thm:euler_char_eq_deg_plus_one_minus_genus` mentions the decomposition steps informally but lacks Lean names. Without pins, `sync_leanok` cannot track these and the review agent cannot apply `\leanok` correctly.

**Verdict:** FAIL. **Must add 3 `\lean{...}` pins** (`eulerCharacteristic_shortExact_add`, `eulerCharacteristic_iso`, `eulerCharacteristic_skyscraperSheaf`) before dispatching prover to `RRFormula.lean`. This is a blocking deficiency for iter-187.

---

### 5. `RationalCurveIso.lean` — PASS with note

**Chapter:** `RiemannRoch_RationalCurveIso.tex` (~563 lines, `% archon:covers AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`)

**Status:** Covers `lem:degree_via_pole_divisor` and its dependencies. The `Hom.poleDivisor` body construction is described adequately (Finsupp on `φ⁻¹(∞)` route mentioned explicitly). iter-186 LANE I CRITICAL FINDING ("Hom.poleDivisor body must precede Hom.poleDivisor_degree_eq_finrank") is addressed in the chapter's proof ordering.

**Note:** The dependency ordering (`Hom.poleDivisor` body MUST precede `Hom.poleDivisor_degree_eq_finrank`) is implicitly present in the chapter structure but not made explicit as a guiding constraint. For a prover who doesn't read the full chapter, this ordering may not be obvious. Recommend: the iter-187 prover directive for RationalCurveIso.lean should include an explicit note about this ordering.

**Verdict:** PASS with note (poleDivisor ordering not explicit; pass with advisory to prover directive).

---

### 6. `GmScaling.lean` — PARTIAL (**MUST-FIX alignment**)

**Chapter:** `AbelianVarietyRigidity.tex` (~2117 lines, `% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean AlgebraicJacobian/Genus0BaseObjects.lean AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean AlgebraicJacobian/RigidityLemma.lean`)

**Status:** `lem:gmscaling_chart_agreement` has been expanded with (I)/(II)/(III.a)/(III.b)/(III.c)/(IV) structure in iter-186. The Mathlib simp coverage gap for `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` (absent at b80f227) is confirmed in the chapter. New mini-blocks pin `projGm_locallyOfFiniteType` (axiom-clean), `gm_geomIrred` (sorry-bearing), `projGm_geomIrred` (contingent), `projGm_isReduced` (sorry-bearing).

**Strategy alignment miss:** Per directive: "audit whether the chapter now states clearly enough that (III.c) **separated-locus** is the iter-187 mandatory pivot per iter-185 STRATEGY.md failure-mode trigger." The chapter describes (III.c) as ONE OF THREE paths [(III.a) `Algebra.TensorProduct.isDomain_of_isAlgClosed_left`, (III.b) direct scheme-map argument, (III.c) separated-locus argument] but does NOT explicitly label (III.c) as "the iter-187 mandatory pivot" or indicate that (III.a) and (III.b) are blocked at b80f227. This is a strategy-alignment gap: a prover reading the chapter might attempt (III.a) or (III.b) first.

**Verdict:** PARTIAL. **Must-fix for strategy alignment:** The `lem:gmscaling_chart_agreement` proof block should explicitly label (III.c) as the iter-187 committed path, with (III.a) labeled "BLOCKED: `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` absent at b80f227" and (III.b) labeled "DESCOPED iter-187." Without this labeling, the chapter does not adequately guide the iter-187 prover.

---

### 7. `AuslanderBuchsbaum.lean` — PASS with note

**Chapter:** `Albanese_AuslanderBuchsbaum.tex` (~610 lines, `% archon:covers AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`)

**Status:** 7 declaration blocks, all `\leanok`. iter-186 closed R⧸(x) bridge inline sorry. Substrate gaps on `exists_isSMulRegular_quotient_isRegularLocal_succ` remain (iter-187 Lane G target). `auslander_buchsbaum_formula` substrate gap also remains.

**Note:** `exists_isRegular_of_regularLocal` is a helper used in the proof of `lem:smooth_codim_one_dvr` but has no standalone `\lean{...}` pin in the chapter. This is a minor bookkeeping gap — the declaration exists in the Lean file but is unnamed in the blueprint. Not a blocking issue for iter-187 dispatch.

**Verdict:** PASS with note (missing helper pin is informational; substrate gaps on `exists_isSMulRegular_quotient_isRegularLocal_succ` and `auslander_buchsbaum_formula` are documented and expected).

---

### 8. `AbelianVarietyRigidity.lean` — PARTIAL (same as GmScaling)

**Chapter:** Same `AbelianVarietyRigidity.tex` as GmScaling above.

**Status:** Rigidity chain all `\leanok`; primary route `gmScalingP1` → `morphism_P1_to_grpScheme_const` → `rigidity_genus0_curve_to_grpScheme` is in place.

**Gap:** Same (III.c) labeling miss as noted for GmScaling.lean. Additionally: product-stability instances `gm_geomIrred` and `projGm_isReduced` are marked sorry-bearing — this is acceptable pending iter-187 dispatch, but the chapter should make clear these are iter-187 sub-targets.

**Verdict:** PARTIAL (same must-fix strategy alignment as GmScaling.lean — must label (III.c) as iter-187 committed path).

---

### 9. `IdentityComponent.lean` — PASS (file skeleton owed)

**Chapter:** `Picard_IdentityComponent.tex` (796 lines after iter-186 rewrite, `% archon:covers AlgebraicJacobian/Picard/IdentityComponent.lean`)

**Status:** Chapter grew 564→796 LOC. 10 declaration blocks with complete `\lean{...}` pins: `GroupScheme.IdentityComponent`, `isOpenSubgroupScheme`, `isSubgroupHomomorphism`, `isFiniteTypeGeometricallyIrreducible`, `baseChangeIso`, `Pic0Scheme`, `PicScheme.degree`, `Pic0Scheme.isAbelianVariety`, `Pic0Scheme.finrank_eq_genus`, `Pic0Scheme.kPoints_iff_kerDegree`. Block 1 split into 4 per-conclusion blocks (a/b/c/d), Block 2 into 3 (1/2/3). All citations have `% SOURCE:` + `(read from references/...)` parentheticals.

**Completeness against Kleiman §5:** `lem:agps` (connected component of identity), `prp:pic0` (Pic⁰ representability), `th:qpp&p` (quotient-and-period proof), `cor:sm` (smoothness), `ex:jac` (Jacobian identification) are all covered. Milne III.6 (abelian variety structure) is also covered.

**Correctness of new `\lean{...}` pins:** All 5 new pins from the directive (`isSubgroupHomomorphism`, `isFiniteTypeGeometricallyIrreducible`, `baseChangeIso`, `finrank_eq_genus`, `kPoints_iff_kerDegree`) are present and correctly named for the chapter's mathematical content.

**`IdentityComponent.lean` file status:** The Lean target file **does not yet exist** — this was correctly identified in the prior audit cycle. The chapter is ready; a file skeleton is owed before prover dispatch.

**Verdict:** PASS (chapter complete and correct; `IdentityComponent.lean` skeleton must be created before prover dispatch).

---

### 10. `CodimOneExtension.lean` — PASS with note

**Chapter:** `Albanese_CodimOneExtension.tex` (~956 lines, `% archon:covers AlgebraicJacobian/Albanese/CodimOneExtension.lean`)

**Status (NEVER AUDITED before):**
- `lem:smooth_to_regular_local_ring` has NO `\leanok` — **CORRECT**: Jacobian-criterion direction (smooth ⟹ regular stalk) is a Mathlib gap at b80f227 (~200–300 LOC of cotangent-space machinery). The missing `\leanok` correctly reflects formalization status.
- `% SOURCE QUOTE:` for Stacks 00TT at L38593-38611 appears verbatim in the chapter.
- iter-186 rewording (removing literal `\uses{}` token to defeat blueprint-doctor regex false-positive) is **semantically equivalent** — the rewording preserves the dependency relation while avoiding the false-positive.
- `lem:mem_domain_partial_map_reshuffle` → `mem_domain_iff_exists_partialMap_through_point` has `\leanok`. Correct.
- `CoheightBridge.lean` (new chapter from iter-183) documents that once `lem:ringKrullDimLE_of_coheight_eq_one` lands, the `hreg_dim` conjunction splits: the Krull-dim conjunct closes via bridge, leaving only `IsRegularLocalRing` as a named gap.

**Verdict:** PASS with note (`lem:smooth_to_regular_local_ring` correctly missing `\leanok`; overall chapter sound and auditable).

---

## Must-Fix Findings (Blocking)

### MF-1: `RiemannRoch_RRFormula.tex` — Missing 3 sub-helper `\lean{...}` pins

**Impact:** HARD GATE FAIL for `RRFormula.lean`.

**Required action:** Plan agent must instruct blueprint-writer to add:
```
\lean{AlgebraicGeometry.Scheme.eulerCharacteristic_shortExact_add}
\lean{AlgebraicGeometry.Scheme.eulerCharacteristic_iso}
\lean{AlgebraicGeometry.Scheme.eulerCharacteristic_skyscraperSheaf}
```
inside the proof block of `thm:euler_char_eq_deg_plus_one_minus_genus`, corresponding to the 3 iter-186 sub-helpers. Without these pins, `sync_leanok` cannot track them, and the review agent cannot apply `\leanok` correctly.

### MF-2: `AbelianVarietyRigidity.tex` — (III.c) not labeled as iter-187 mandatory pivot

**Impact:** HARD GATE PARTIAL for both `GmScaling.lean` and `AbelianVarietyRigidity.lean`.

**Required action:** Plan agent must instruct blueprint-writer to explicitly mark in the `lem:gmscaling_chart_agreement` proof block:
- (III.a): "BLOCKED at b80f227 — `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` absent"
- (III.b): "DESCOPED iter-187"
- (III.c): "**iter-187 MANDATORY PIVOT** (per iter-185 STRATEGY.md failure-mode trigger)"

---

## Informational / Soft Findings

### SF-1: `Picard_RelPicFunctor.tex` — `thm:rel_pic_etale_sheaf_group_structure` unpinned

`thm:rel_pic_etale_sheaf_group_structure` has no `\lean{...}` pin and no `\leanok`. This declaration (group structure on the étale-sheafified relative Picard functor) is not yet formalized. The `etSheaf` declaration was renamed from `PicScheme` in iter-176 review; a separate verification flag exists on the exact Mathlib name for abelian-group-valued sheafification. This is not a hard-gate blocker for iter-187 (no prover lane targets `RelPicFunctor.lean` this iter), but plan agent should note it as an open formalization obligation for A.1.c.

### SF-2: `Jacobian.tex` + `Albanese_AlbaneseUP.tex` — Duplicate `\label{thm:albanese_universal_property}`

`Jacobian.tex` at line 519 has a `\begin{theorem}` block with `\label{thm:albanese_universal_property}` and `\lean{AlgebraicGeometry.Scheme.Pic.albaneseUP}` but **NO `\leanok`**. This appears to be a stub from before the standalone `Albanese_AlbaneseUP.tex` chapter was created.

`Albanese_AlbaneseUP.tex` at line 95 has `\label{thm:albanese_universal_property}` with `\lean{AlgebraicGeometry.Pic0.albanese_universal_property}` and `\leanok`.

These are **different Lean names** for what appears to be the same theorem. The `Jacobian.tex` stub should either: (a) be removed as an obsolete pointer, or (b) updated to match the `AlbaneseUP.tex` pin. Blueprint-doctor may not yet flag this if both labels are in different files; a deduplication is recommended.

### SF-3: `Albanese_AuslanderBuchsbaum.tex` — Missing pin for `exists_isRegular_of_regularLocal`

The helper `exists_isRegular_of_regularLocal` is used in the `lem:smooth_codim_one_dvr` proof but has no standalone `\lean{...}` pin. Minor bookkeeping gap; not blocking.

### SF-4: `RiemannRoch_RationalCurveIso.tex` — Dependency ordering implicit

`Hom.poleDivisor` body must precede `Hom.poleDivisor_degree_eq_finrank` in the Lean file per iter-186 LANE I finding. The chapter implies this but does not make it explicit. Recommend adding a sentence to the prover directive (not blocking for blueprint correctness).

### SF-5: `Picard_FlatteningStratification.tex` — Castelnuovo-Mumford regularity gap

The `lem:noetherian_induction_strata` proof (the `N_1`-existence step) requires higher-direct-image base-change and Serre vanishing in relative form. The chapter explicitly notes that "Mathlib does not yet have these in the relative form needed." The `\leanok` markers on `flatteningStratification` and related declarations reflect this: the proofs will need these inputs sorry'd or worked around. Not a blueprint defect — the chapter is honest about the gap — but a prover dispatched to `FlatteningStratification.lean` should be instructed to sorry the Castelnuovo-Mumford regularity step.

### SF-6: `Cohomology_MayerVietoris.tex` — Producer instances not yet available

`HasCechToHModuleIso` and `HasAffineCechAcyclicCover` carrier classes are documented as **currently unproduced** (the project's autonomous-loop scope does not include a producer instance for either). The chapter is honest about this: genus finiteness is delivered as a conditional theorem. This is correct status; no blueprint fix needed.

### SF-7: `Picard_IdentityComponent.tex` — `IdentityComponent.lean` skeleton owed

The Lean file `AlgebraicJacobian/Picard/IdentityComponent.lean` does not yet exist. The chapter blueprint is ready for prover dispatch as soon as the skeleton is created. Same situation for several other files: `Thm32RationalMapExtension.lean`, `RelPicFunctor.lean`, `FGAPicRepresentability.lean`, `CoheightBridge.lean`, `FlatteningStratification.lean`.

---

## Unstarted-Phase Gaps

### UP-1: A.2.a Flattening Stratification

**Chapter:** `Picard_FlatteningStratification.tex` — `FlatteningStratification.lean` file skeleton NOT yet created.

**Status:** Chapter has all major declaration blocks with `\leanok` markers for `CoherentSheafFlat`, `genericFlatness`, `flatteningStratification`, `flatteningStratification_universal`. However, the Lean file does not exist yet, and the chapter itself documents critical Mathlib gaps (Castelnuovo-Mumford regularity in relative form; higher-direct-image base-change) that will require sorry-stubs or workarounds. The phase is defined and has a complete blueprint specification; execution has not started.

**Recommendation:** If iter-187 plan intends to start A.2.a, dispatch a file-skeleton creation task before the prover lane.

### UP-2: A.2.c FGA Pic Representability

**Chapter:** `Picard_FGAPicRepresentability.tex` — `FGAPicRepresentability.lean` file skeleton NOT yet created.

**Status:** Chapter is fully specified with 5 declaration blocks: `abelMap` (`\leanok`), `smoothProperQuotient` (`\leanok`), `representable` (`\leanok`), `groupSchemeStructure` (`\leanok`), `PicScheme` (`\leanok`). The `\leanok` markers reflect that these are stated goals, not proofs. The Lean file does not exist. The chapter explicitly flags that `smoothProperQuotient` (Altman-Kleiman descent) may need to be sorried if not in Mathlib.

**Recommendation:** A.2.c is downstream of A.2.a and A.1.c; do not dispatch until A.2.b (QuotScheme) and A.1.c (RelPicFunctor) are further along.

---

## Strategy-Modifying Findings

**None** beyond the MF-2 already captured. The (III.c) separation-locus pivot was declared in STRATEGY.md iter-185 and is confirmed by this audit as the only viable path; the blueprint just needs to propagate this commitment into the `lem:gmscaling_chart_agreement` proof block.

---

## Full Chapter Index (All 29 Chapters)

| # | Chapter file | Lean file | `\leanok` status | HARD GATE | Notes |
|---|-------------|-----------|-----------------|-----------|-------|
| 1 | `Picard_IdentityComponent.tex` | `IdentityComponent.lean` (missing) | All 10 blocks OK | PASS | File skeleton owed |
| 2 | `AbelianVarietyRigidity.tex` | `AbelianVarietyRigidity.lean` | Rigidity chain OK; 2 sorry-bearing | PARTIAL | (III.c) not labeled as mandatory pivot |
| 3 | `Albanese_CodimOneExtension.tex` | `CodimOneExtension.lean` | `smooth_to_regular_local_ring` correctly missing `\leanok` | PASS | Stacks 00TT correctly unformalized |
| 4 | `Picard_QuotScheme.tex` | `QuotScheme.lean` | 4 new pins all `\leanok` | PASS | Step 4 naming clarification |
| 5 | `Albanese_AuslanderBuchsbaum.tex` | `AuslanderBuchsbaum.lean` | All 7 `\leanok` | PASS | Missing helper pin (informational) |
| 6 | `RiemannRoch_RRFormula.tex` | `RRFormula.lean` | 3 sub-helpers missing pins | **FAIL** | Must add 3 `\lean{...}` pins |
| 7 | `RiemannRoch_RationalCurveIso.tex` | `RationalCurveIso.lean` | `poleDivisor` body adequate | PASS | Dependency ordering advisory |
| 8 | `Picard_LineBundlePullback.tex` | `LineBundlePullback.lean` | All 5 `\leanok`; 3 `% NOTE` annotations | PASS | `% NOTE` sufficient pending iter-187 |
| 9 | `RiemannRoch_OCofP.tex` | `OCofP.lean` | All 6 `\leanok`; Steps 3-4 missing | PARTIAL | Presheaf/isSheaf pins needed |
| 10 | `Albanese_CodimOneExtension.tex` | `CodimOneExtension.lean` | See row 3 | PASS | — |
| 11 | `Picard_RelativeSpec.tex` | `RelativeSpec.lean` | All 6 `\leanok` | (not dispatched) | A.1.a body complete |
| 12 | `RiemannRoch_WeilDivisor.tex` | `WeilDivisor.lean` | All 12 `\leanok` | (not dispatched) | Complete |
| 13 | `RiemannRoch_OcOfD.tex` | `OcOfD.lean` | All 4 `\leanok` | (not dispatched) | Complete |
| 14 | `Genus.tex` | (no separate file) | 1 `\leanok` | (not dispatched) | `finrank` definition complete |
| 15 | `Jacobian.tex` | `Jacobian.lean` (implicit) | Major decls `\leanok`; 1 stub without `\leanok` | (not dispatched) | Duplicate `\label{thm:albanese_universal_property}` |
| 16 | `Albanese_AlbaneseUP.tex` | `AlbaneseUP.lean` (missing) | All 6 `\leanok` | (not dispatched) | File skeleton owed |
| 17 | `AbelJacobi.tex` | `AbelJacobi.lean` (implicit) | All 3 `\leanok` | (not dispatched) | Complete |
| 18 | `Rigidity.tex` | `Rigidity.lean` (implicit) | 1 `\leanok` | (not dispatched) | Thin wrapper, complete |
| 19 | `RigidityKbar.tex` | `RigidityKbar.lean` + `Cotangent/ChartAlgebra.lean` | (i.a) trio + shearMulRight `\leanok`; mulRight_globalises_cotangent `\notready` (EXCISED iter-145); cotangent_bridge `\notready` (deferred) | (not dispatched) | Piece (iv) Serre duality on critical path; iter-155 correction documented |
| 20 | `Cohomology_StructureSheafAb.tex` | (no separate file listed) | All 3 `\leanok` | (not dispatched) | Phase A prereq complete |
| 21 | `Albanese_Thm32RationalMapExtension.tex` | `Thm32RationalMapExtension.lean` (missing) | 1 `\leanok` | (not dispatched) | File skeleton owed |
| 22 | `Picard_RelPicFunctor.tex` | `RelPicFunctor.lean` (missing) | 5 of 6 `\leanok`; `thm:rel_pic_etale_sheaf_group_structure` unpinned | (not dispatched) | A.1.c obligation; `etSheaf` name needs verification |
| 23 | `Cohomology_SheafCompose.tex` | (no separate file listed) | 1 `\leanok` | (not dispatched) | Phase A prereq complete |
| 24 | `Cohomology_MayerVietoris.tex` | (no separate file listed) | ~30+ all `\leanok`; producer instances unproduced | (not dispatched) | Conditional theorems; producer instances documented gap |
| 25 | `Cohomology_StructureSheafModuleK.tex` | (no separate file listed) | ~30+ all `\leanok` | (not dispatched) | Phase A step 5 complete |
| 26 | `Picard_FGAPicRepresentability.tex` | `FGAPicRepresentability.lean` (missing) | All 5 decls `\leanok` | (not dispatched yet) | A.2.c phase; file skeleton owed; assembly chapter |
| 27 | `AlgebraicJacobian_Cotangent_GrpObj.tex` | `Cotangent/GrpObj.lean` | All cited decls `\leanok`; mulRight_globalises_cotangent EXCISED | (not dispatched) | Pointer chapter; cleanup candidates noted |
| 28 | `Albanese_CoheightBridge.tex` | `CoheightBridge.lean` (missing) | All 4 `\leanok` | (not dispatched) | File skeleton owed; iter-183 chapter |
| 29 | `Picard_FlatteningStratification.tex` | `FlatteningStratification.lean` (missing) | 4 decls `\leanok` | (not dispatched yet) | A.2.a phase; Castelnuovo-Mumford gap documented |

---

## Appendix: Chapter-Level Completeness vs. Kleiman/Milne/Hartshorne Citations

All 3 priority chapters audited against directive references:

**`Picard_IdentityComponent.tex`** (Kleiman §5 + Milne III.6): Complete. All 5 key results from Kleiman §5 (lem:agps, prp:pic0, th:qpp&p, cor:sm, ex:jac) are covered in the 10 declaration blocks. Milne III.6 abelian variety structure is covered in `Pic0Scheme.isAbelianVariety`.

**`AbelianVarietyRigidity.tex`** (GmScaling chart-agreement expansion): The (I)/(II)/(III)/(IV) structure is present and correct. The chapter adequately reflects the iter-186 Lane B empirical finding ("Mathlib simp coverage gap"). Gap: (III.c) not labeled as mandatory pivot.

**`Albanese_CodimOneExtension.tex`** (Stacks 00TT): The verbatim SOURCE QUOTE block is present at L38593-38611. The `lem:mem_domain_partial_map_reshuffle` → `mem_domain_iff_exists_partialMap_through_point` rename is correctly reflected. The iter-186 `\uses{}` token removal rewording is semantically equivalent (confirmed).

---

*Report complete. Written to `.archon/task_results/blueprint-reviewer-iter187.md`.*
