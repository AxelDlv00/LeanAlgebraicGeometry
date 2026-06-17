# Blueprint Audit Report — iter-066

**Date:** 2026-06-11  
**Auditor:** blueprint-reviewer subagent  
**Scope:** Full audit, all chapters (no scope limit)  
**Tools run:** `leandag build --json`, `leandag stats`, `leandag show isolated`, `leandag show gaps`, `archon blueprint-doctor --json`, per-chapter Python analysis  

---

## Global Summary

| Metric | Value |
|---|---|
| Total blueprint nodes (ex. lean_aux) | 590 |
| Proved (`\leanok`) | 487 |
| Sorry (Lean `sorry` in proof) | 10 |
| Unproved + no Lean source | see per-chapter |
| Unknown `\uses{}` edges | **0** |
| DAG gaps (`\lean{}` target missing from Lean) | **0** |
| Isolated blueprint nodes | **5** |
| Broken refs | **0** |
| Orphan chapters | **0** |
| blueprint-doctor axiom_decls | **0** |

All `\uses{}` edges are intact; all `\lean{}` targets resolve in the local build.

---

## Per-Chapter Verdicts

### 1. Cohomology_RegroupHelper.tex
**complete: true | correct: true**

Single node (`lem:base_change_regroup_linearEquiv`) with `\leanok`, no sorry, source cited (Stacks coherent). No issues.

---

### 2. Cohomology_FlatBaseChange.tex ← FBC-A2 active lane
**complete: false | correct: false**

**Covers:** `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (14 sorrys), `FlatBaseChangeGlobal.lean` (0 sorrys)

| Status | Count | IDs |
|---|---|---|
| `\leanok` proved | 82 | — |
| `\mathlibok` (leandag quirk, not counted) | 18 | — |
| **Sorry nodes** | **4** | see below |
| Truly unproved + no Lean source | **4** live + 1 abandoned | see below |

**Sorry nodes (FBC-A keystone chain still open):**
- `lem:base_change_mate_fstar_reindex_legs_conj` → `base_change_mate_fstar_reindex_legs_conj`
- `lem:base_change_mate_gstar_transpose` → `base_change_mate_gstar_transpose`
- `lem:affine_base_change_pushforward` → `affineBaseChange_pushforward_iso`
- `thm:flat_base_change_pushforward` → `flatBaseChange_pushforward_isIso`

**Live unproved targets (FBC-A2 chain):**
- `lem:base_changed_equalizer_diagram` → `baseChange_sheafConditionFork_tensorIso`
- `lem:flat_base_change_separated` → `flatBaseChange_pushforward_isIso_of_isSeparated`
- `lem:flat_base_change_mayer_vietoris` → `flatBaseChange_pushforward_mayerVietoris`
- `lem:flat_base_change_reduce_global_sections` → `flatBaseChange_isIso_iff_gammaTensorComparison`

**Abandoned route (do NOT dispatch):**
- `lem:pushforward_base_change_mate_sections_direct` — NOTE at line 3330 states explicitly: "abandoned route record, NOT a live critical path; do NOT dispatch a prover at it." Lean target `pushforward_base_change_mate_sections_direct` was intentionally never added.

**HARD GATE: BLOCKED.** Chapter has 4 sorry nodes and 4 live unproved targets. The FBC-A2 chain (equalizer → separated → Mayer-Vietoris → reduction) has complete blueprint proofs but no Lean implementations yet. The FBC-A keystone (`_legs_conj`) remains sorry. Prover should address keystone sorry first, then implement FBC-A2 chain. STRATEGY.md estimates 3–6 iters for FBC-A2.

---

### 3. Picard_FlatteningStratification.tex
**complete: true (effective) | correct: true**

**Covers:** `AlgebraicJacobian/Picard/FlatteningStratification.lean`

All local Lean targets proved, including:
- `thm:generic_flatness_algebraic` (`\leanok`) ✓
- `thm:generic_flatness` (`\leanok`) ✓ — geometric form, the chapter's main result

**27 `\mathlibok` entries** appear as `proved: false` in leandag (leandag does not count Mathlib-backed entries unless they have a local Lean source). This is a leandag counting quirk; it is not a blueprint correctness problem.

**Hygiene issue (non-blocking):**  
`lem:gf_finite_gen_iff_free_epi` (line 1507) has a complete Lean proof (no sorry) but is missing its `\leanok` marker in the blueprint. No downstream impact; 1 rdep (`lem:gf_finiteType_affine_finite_cover_generated`) is separately proved.

**Isolated nodes in this chapter:** `lem:isLocalizedModule_powers_restrictScalars` (proved, 0 impact). The 3 isolated `\mathlibok` nodes (`lem:mathlib_flat_localization_preserves`, `lem:mathlib_flat_of_localized_maximal`, `lem:mathlib_free_of_isLocalizedModule`) have zero downstream uses and are harmless.

---

### 4. Picard_GrassmannianCells.tex
**complete: true | correct: true**

**Covers:** `AlgebraicJacobian/Picard/GrassmannianCells.lean`

All 97 environments either `\leanok` or `\mathlibok`. No sorry, no truly unproved local targets. Includes:
- `lem:gr_proper` / `lem:gr_isProper_of_valuativeExistence` — `Gr(d,r)` proper over `ℤ`
- `lem:gr_separated` — `Gr(d,r)` separated
- All existence-lift / valuative criteria lemmas (`\leanok`)

8 `\mathlibok` entries (`lem:mathlib_away_algebraMap_isUnit`, etc.) show as `proved: false` in leandag — same counting quirk as above, not a real issue.

---

### 5. Picard_GrassmannianQuot.tex ← GR-QUOT LANE GATE (primary)
**complete: false | correct: false**

**Covers:** `AlgebraicJacobian/Picard/GrassmannianQuot.lean` (2 sorrys remaining)

| Status | Count | IDs |
|---|---|---|
| `\leanok` proved, no sorry | 44 | — |
| **Sorry nodes** | **2** | see below |
| Unrealized forward decls | **3** | see below |
| Missing `\leanok` but Lean proved | 2 | hygiene only |

**Sorry nodes:**
- `def:tautological_quotient` → `tautologicalQuotient`: The overlap compatibility step inside `glueLift`. Comment (line 1952) says: "the remaining `sorry` is the equalizing condition — chart compatibility `g_{IJ} ∘ f_{IJ}^* u^I = (t_{IJ} ≫ f_{JI})^* u^J`, whose matrix content is `X^J = (X^I_J)⁻¹ X^I` (`universalMatrix_map_transitionPreMap`/`imageMatrix`) transported through the adjunction." This is the "rectangular analogue of `matrixEnd_pullback`/`matrixEnd_comp` for the `r → d` chart quotient."
- `thm:grassmannian_universal_property` → `represents`: Fully sorry. Comment says: "rides on `tautologicalQuotient` (hence on the bundle cocycle, the only remaining upstream gap)."

**Unrealized forward declarations (planned work, no Lean source yet):**
- `def:gr_modules_glueRestrictionIso` — NOTE: "forward declaration (planned work)"
- `lem:gr_modules_glue_unique` — NOTE: "forward declaration (planned work)"
- `def:gr_modules_glueHom` — NOTE: "forward declaration (planned work)"

These are `\uses{}`-referenced by `def:tautological_quotient` and/or `def:gr_modules_glue`. They are planned refinements; the current Lean proof bypasses them directly.

**Hygiene (non-blocking):**
- `lem:gr_glueData_bridges` (line 152): Lean proof exists (no sorry), missing `\leanok`
- `def:gr_rankQuotient` (line ~2100+): Lean proof exists (no sorry), missing `\leanok`

**Isolated node:** `lem:gr_homEquiv_conjugateEquiv_app` — proved, 0 downstream impact; this was the `functor` keystone dropped iter-055 and is now unused in the blueprint DAG.

**Concurrent edit check:** No half-written or freshly-appended block detected under `def:tautological_quotient`. The overlap-compatibility sorry is the only open item in `tautologicalQuotient`.

**HARD GATE: BLOCKED.** The chapter's primary deliverables (`tautologicalQuotient`, `represents`) both carry sorry. The tautologicalQuotient sorry is the load-bearing gate: it requires the rectangular `matrixEnd_pullback`-style transport for the `r → d` quotient, plus adjunction bookkeeping for two equalizer legs. Closing that sorry unlocks `represents` which is then a global construction.

**Prover routing:** The `task_results/effort-breaker-tq-rect2.md` file (present in task_results) appears to be the current effort-breaker target for this sorry. Check that file for the specific infra gap before dispatching.

---

### 6. Picard_QuotScheme.tex
**complete: false | correct: false**

**Covers:** `AlgebraicJacobian/Picard/QuotScheme.lean`

| Status | Count | IDs |
|---|---|---|
| `\leanok` proved | 146 | — |
| `\mathlibok` (leandag quirk) | 40 | — |
| **Sorry nodes** | **4** | see below |
| Truly unproved + no Lean source | **4** | see below |
| Intentional narrative record (no `\leanok`) | 1 | `lem:composite_immersion_flocus_basicOpen` |

**Sorry nodes:**
- `def:hilbert_polynomial` → `hilbertPolynomial`
- `def:quot_functor` → `QuotFunctor`
- `def:grassmannian_scheme` → `Grassmannian`
- `thm:grassmannian_representable` → `Grassmannian.representable`

These are the QUOT-repr infrastructure. They are downstream of the GR-quot lane (GrassmannianQuot.tex); `Grassmannian.representable` will close once `represents` in GrassmannianQuot.lean closes.

**Truly unproved + no Lean source (SNAP-blocked):**
- `def:sectionGradedRing` → `sectionGradedRing` — NOTE: "blocked on the absence of tensor products for sheaves of modules in Mathlib." Uses `lem:sectionGradedRing_gcommSemiring` (unproved in SectionGradedRing lane).
- `def:sectionGradedModule` → `sectionGradedModule` — depends on `def:sectionGradedRing`
- `lem:sectionGradedModule_fg` → `sectionGradedModule_fg` — depends on both above
- `thm:hilbertPoly_of_sectionModule` → `hilbertPolynomialOfSectionModule` — depends on `lem:sectionGradedModule_fg`

All four are blocked on SNAP. Complete blueprint proofs exist; Lean implementations await SNAP infrastructure.

**Intentional narrative record:**  
`lem:composite_immersion_flocus_basicOpen` (line 4820): deliberately lacks `\leanok`; NOTE states its content is "absorbed inline into `section_localization_hfr_basicOpen`." The iter-027 duplicate-pin pattern. Not a correctness failure.

---

### 7. Picard_RelativeSpec.tex
**complete: true | correct: partial (known weaker Lean types)**

**Covers:** `AlgebraicJacobian/Picard/RelativeSpec.lean`

All 5 declarations have `\leanok`, no sorry:
- `def:qc_sheaf_of_algebras` ✓
- `thm:relative_spec_exists` ✓
- `def:relspec_structure_morphism` ✓
- `thm:relative_spec_univ` ✓
- `thm:relative_spec_affine_base` ✓

**Known Lean/prose mismatch (documented in blueprint):**  
`thm:relative_spec_univ` prose claims Yoneda representability bijection; the Lean type is the strictly weaker `IsAffineHom (structureMorphism 𝒜)`. The NOTE (line 186) says "iter-174+ must upgrade the Lean type to a `RepresentableBy` witness." Similarly `thm:relative_spec_affine_base` proves the weaker `IsAffine` rather than the canonical iso. Both are flagged; this chapter is stable and not on an active prover lane.

---

### 8. Picard_SectionGradedRing.tex ← SNAP LANE GATE (primary)
**complete: false | correct: false**

**Covers:** `AlgebraicJacobian/Picard/SectionGradedRing.lean`

| Status | Count | IDs |
|---|---|---|
| `\leanok` proved | 30 | — |
| `\mathlibok` (leandag quirk) | 8 | — |
| Truly unproved + no Lean source | **7** | see below |
| Sorry nodes | 0 | — |

**Truly unproved (the SNAP open chain):**
1. `lem:snap_ztensor_whisker_localIso` — local-iso step for ℤ-tensor whisker
2. **`lem:isIso_sheafification_whiskerRight_unit`** — **CRUX**: the key sheafification unit iso; all downstream declarations depend on this
3. `cor:sheafTensorObjAssoc` — associativity of sheaf tensor (depends on crux)
4. `lem:sheafTensorPow_add` — tensor power addition (depends on associativity)
5. `lem:sectionMul_coherent` — coherence of section multiplication
6. `lem:sectionGradedRing_gcommSemiring` — graded commutative semiring structure
7. `lem:sectionGradedModule_gmodule` — graded module structure

All infrastructure proved axiom-clean through iter-060/063: `relTensorActL/R/Proj`, `relativeTensorCoequalizerIso`, `objRestrict`. The SNAP crux `lem:isIso_sheafification_whiskerRight_unit` is the gate for the entire chain above.

**HARD GATE: BLOCKED.** SNAP crux must be resolved first. STRATEGY.md estimates 2–6 iters for SNAP. The crux is a sheafification unit iso — a genuinely hard step requiring new sheafification infrastructure.

---

## Isolated Blueprint Nodes (5 total)

| ID | Chapter | Proved | Impact | Notes |
|---|---|---|---|---|
| `lem:mathlib_flat_localization_preserves` | FlatteningStratification | ✗* | 0 | `\mathlibok`; leandag quirk |
| `lem:mathlib_flat_of_localized_maximal` | FlatteningStratification | ✗* | 0 | `\mathlibok`; leandag quirk |
| `lem:mathlib_free_of_isLocalizedModule` | FlatteningStratification | ✗* | 0 | `\mathlibok`; leandag quirk |
| `lem:isLocalizedModule_powers_restrictScalars` | FlatteningStratification | ✓ | 0 | Proved; no downstream uses in DAG |
| `lem:gr_homEquiv_conjugateEquiv_app` | GrassmannianQuot | ✓ | 0 | Proved; `functor` keystone dropped iter-055 |

*`\mathlibok` entries; leandag does not count them as proved because they lack local Lean source. Not a real correctness issue.

**Action:** No action required. All 5 have zero impact; none blocks any active proof chain.

---

## Blueprint Hygiene Issues (non-blocking)

Three declarations have complete Lean proofs (no sorry) but are missing their `\leanok` markers:

| ID | Chapter | Status | Notes |
|---|---|---|---|
| `lem:gf_finite_gen_iff_free_epi` | FlatteningStratification | Lean proved, no sorry | Should add `\leanok` to statement and proof |
| `lem:gr_glueData_bridges` | GrassmannianQuot | Lean proved, no sorry | Should add `\leanok` |
| `def:gr_rankQuotient` | GrassmannianQuot | Lean proved, no sorry | Should add `\leanok` |

Adding these would close the gap between blueprint rendering and actual Lean state. Low-priority hygiene fix; no proof impact.

---

## Active Lane Status

### GR-quot Lane (gate: `Picard_GrassmannianQuot.tex`)
**Status: OPEN, 1–3 iters remaining**

The tautologicalQuotient overlap-compatibility sorry is the critical path. The sorry requires:
- A rectangular analogue of `matrixEnd_pullback`/`matrixEnd_comp` for the `r → d` quotient morphism
- Adjunction bookkeeping for the two `glueLift` equalizer legs
- `universalMatrix_map_transitionPreMap` / `imageMatrix` identity transport

Once this closes, `represents` (fully sorry) can be dispatched. The 3 forward decls are **not blocking** the sorry closure — they are planned refinements for a cleaner glue-data presentation.

Check `task_results/effort-breaker-tq-rect2.md` (present in task_results) for the current infra gap analysis before dispatching.

### SNAP Lane (gate: `Picard_SectionGradedRing.tex`)
**Status: BLOCKED on crux, 2–6 iters remaining**

The crux `lem:isIso_sheafification_whiskerRight_unit` is the single gate. Once it closes, the chain `cor:sheafTensorObjAssoc → lem:sheafTensorPow_add → sectionMul_coherent → sectionGradedRing_gcommSemiring → sectionGradedModule_gmodule` unblocks in sequence, then the 4 SNAP-blocked nodes in QuotScheme (sectionGradedRing, sectionGradedModule, sectionGradedModule_fg, hilbertPoly_of_sectionModule) open.

### FBC-A2 Lane (gate: `Cohomology_FlatBaseChange.tex`)
**Status: OPEN for blueprint work (FBC-A2 chain blueprinted), but HARD GATE on FBC-A keystone sorry**

FBC-A2 targets have complete blueprint proof sketches. However, the FBC-A affine base case (`affineBaseChange_pushforward_iso`) is still sorry and is the upstream gate. The FBC-A keystone `_legs_conj` (`base_change_mate_fstar_reindex_legs_conj`) remains the root sorry; dispatching FBC-A2 Lean work now is possible if treating `affineBaseChange_pushforward_iso` as given, but full closure requires keystone resolution. STRATEGY.md estimates 3–6 iters.

---

## Summary Table

| Chapter | complete | correct | Sorry | Unproved local | Gate status |
|---|---|---|---|---|---|
| Cohomology_RegroupHelper | ✓ | ✓ | 0 | 0 | N/A (complete) |
| Cohomology_FlatBaseChange | ✗ | ✗ | 4 | 4 live + 1 abandoned | BLOCKED (keystone sorry) |
| Picard_FlatteningStratification | ✓* | ✓ | 0 | 0 | N/A (complete) |
| Picard_GrassmannianCells | ✓ | ✓ | 0 | 0 | N/A (complete) |
| Picard_GrassmannianQuot | ✗ | ✗ | 2 | 3 fwd decls | **GATE: tautologicalQuotient sorry** |
| Picard_QuotScheme | ✗ | ✗ | 4 | 4 SNAP-blocked | Downstream of GR-quot + SNAP |
| Picard_RelativeSpec | ✓ | ~✓ | 0 | 0 | Stable (weaker Lean types, documented) |
| Picard_SectionGradedRing | ✗ | ✗ | 0 | 7 | **GATE: sheafification crux** |

*`lem:gf_finite_gen_iff_free_epi` has Lean proof but missing `\leanok`; not a material gap.
