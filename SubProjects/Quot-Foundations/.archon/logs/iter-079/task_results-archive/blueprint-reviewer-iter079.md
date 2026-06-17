# Blueprint Review — iter-079

**Auditor:** blueprint-reviewer subagent  
**Scope:** Full per-chapter completeness + correctness audit of `blueprint/src/chapters/*.tex`  
**Focus chapters:** Picard_GlueDescent.tex, Picard_GrassmannianQuot.tex, Picard_SectionGradedRing.tex  
**DAG snapshot:** blueprint_nodes=630, lean_aux_nodes=122, proved=484, mathlib_ok=103, with_sorry=13, edges=1441, isolated=126  
**Blueprint-doctor:** CLEAN (zero orphan_chapters, broken_refs, malformed_refs, axiom_decls, covers_problems)  
**DAG integrity:** `unknown_uses: []` — zero broken `\uses{}` edges; `unmatched_lean`: 55 entries (all expected: Mathlib anchors + 2 deliberate forward declarations)

---

## Severity index

| Sev | Count | Summary |
|-----|-------|---------|
| BLOCK | 0 | — |
| WARN | 5 | proof-prose divergence; 15-helper coverage debt; 3 missing `\mathlibok`; 2 missing proof `\uses{}` in GlueDescent; 2 missing proof `\uses{}` in SectionGradedRing |
| INFO | 4 | spurious statement `\uses{}` edge; 1 proved-isolated orphan; SNAP-S1/S3 unstarted; `thm:grassmannian_universal_property` proof not yet closed |

---

## Per-chapter checklist

### 1. Cohomology_FlatBaseChange.tex  (archon:covers FlatBaseChange.lean + FlatBaseChangeGlobal.lean)

| Field | Status |
|-------|--------|
| complete | partial — FBC-A phases done; FBC-B is a future follow-on |
| correct | true |
| `\uses{}` accurate | true — no unknown_uses |
| Lean targets | some unmatched_lean (expected: all Mathlib anchors) |

**Notes:** `def:pushforward_base_change_map` has `\leanok`. FBC-A1/A2 complete per STRATEGY.md. FBC-B (global version in `FlatBaseChangeGlobal.lean`) is already covered by the `archon:covers` directive; no new chapter needed.

---

### 2. Cohomology_RegroupHelper.tex

| Field | Status |
|-------|--------|
| complete | true (single lemma `lem:base_change_regroup_linearEquiv` has `\leanok`) |
| correct | true |
| `\uses{}` accurate | true |
| Lean targets | well-formed; `lem:isPushout_cancelBaseChange_mathlib` in unmatched_lean is expected |

---

### 3. Picard_FlatteningStratification.tex

| Field | Status |
|-------|--------|
| complete | partial — see isolated-node triage below |
| correct | true |
| `\uses{}` accurate | true for non-isolated content |
| Lean targets | well-formed |

**WARN — 3 isolated `lem:mathlib_*` nodes missing `\mathlibok`:**  
Three `lem:mathlib_*` nodes in this chapter appear in `leandag show isolated` with `proved: false` and 0 edges. They are Mathlib-provided lemmas that lack `\mathlibok` markers. The missing markers cause them to show as unproved in the DAG and orphan them from the dependency graph.  
Disposition: **add `\mathlibok`** to each.  
(Full IDs truncated by leandag display as `lem:mathl…`; exact labels in the `lem:mathlib_flat_*` / `lem:mathlib_free_*` family near lines 1848–1952.)

**INFO — 1 proved-isolated node `lem:isLoc*`:**  
One lemma (`lem:isLocalization_away_mul_of_associated` or `lem:isLocalizedModule_powers_restrictScalars`, line ~1095 or ~2149) is proved but has no downstream consumers.  
Disposition: **wire-up** (identify dependents and add `\uses{}` edges) or **remove** if genuinely unused.

---

### 4. Picard_GrassmannianCells.tex

| Field | Status |
|-------|--------|
| complete | true (GR-cells phase done per STRATEGY.md) |
| correct | true |
| `\uses{}` accurate | true |
| Lean targets | well-formed |

No findings.

---

### 5. Picard_GrassmannianQuot.tex  ← ACTIVE prover lane

| Field | Status |
|-------|--------|
| complete | **partial** — see coverage debt below |
| correct | **partial** — see `lem:chartLocus_isOpenCover` ruling below |
| `\uses{}` accurate | minor issue (see below) |
| Lean targets | well-formed for all `\leanok` blocks |

**Universal property section (lines 1844–2190) — summary of `\leanok` blocks found:**

| Block | `\leanok` |
|-------|-----------|
| `lem:tautologicalQuotient_epi` | ✓ statement |
| `def:isoLocus` | ✓ statement |
| `lem:isIso_of_stalkFunctor_map_iso_mathlib` | `\mathlibok` |
| `lem:isIso_pullback_isoLocus_map` | ✓ statement + proof |
| `def:chartLocus` | ✓ statement |
| `lem:chartLocus_isOpenCover` | ✓ statement |
| `def:grPointOfRankQuotient` | ✓ statement |
| `thm:grassmannian_universal_property` | ✓ statement only |

**INFO — `thm:grassmannian_universal_property` proof not yet closed:** The theorem statement has `\leanok` (line 2075) but the proof block does not. Proof block is detailed and complete — this is a prover task.

---

#### WARN — `lem:chartLocus_isOpenCover` proof-prose/formalization divergence

**Ruling: `correct: partial`** (not `correct: false`).

The block at line 1982 has `\leanok` — the Lean declaration `AlgebraicGeometry.Grassmannian.chartLocus_isOpenCover` IS formalized. The statement is mathematically correct.

However, the proof prose (lines 2015–2035) describes the **Nakayama route**: work locally over a trivialising open V, reduce q at the fibre to a surjection of vector spaces, extract an invertible d-column minor, invoke Nakayama to propagate invertibility to a neighbourhood. This is a valid proof strategy.

The `% NOTE (review iter-078)` at lines 2006–2014 documents that the **formalized proof uses a different route** — affine-projective splitting:
1. `exists_section_of_epi_free_spec` / `exists_rightInverse_of_epi_matrixEndRect` — split the epi of free sheaves globally over an affine W via projectivity  
2. `exists_isUnit_submatrix` — a right-invertible matrix over a field has an invertible d-column minor  
3. Cut out the basic open from the minor determinant

Both routes reach the same conclusion (minor invertible on a basic open implies `t ∈ T_I`), but the mechanism is different. A prover following the prose would attempt the Nakayama route and not match the existing Lean proof.

**Required action:** Blueprint-writer should rewrite the proof block to describe the affine-splitting route, per the existing NOTE. This is a documentation correctness issue, not a mathematical error. The active prover can consult the Lean source directly.

**Gate decision for active prover lane (`grPointOfRankQuotient` overlap): PROCEED.** All upstream blocks have `\leanok`. The proof-prose divergence is advisory; it does not block a prover reading the Lean source.

---

#### `\uses{}` accuracy issue — `lem:chartLocus_isOpenCover`

**INFO — spurious statement edge:** The statement `\uses` at line 1986 includes `lem:isIso_pullback_isoLocus_map`. The statement of `lem:chartLocus_isOpenCover` ("the chart loci cover T") does not logically depend on `lem:isIso_pullback_isoLocus_map`; that lemma is needed in `def:grPointOfRankQuotient` (which consumes the cover), not in the covering itself. Recommend removing this edge from the statement `\uses{}`.

**The proof `\uses{def:chartLocus, def:gr_rankQuotient}`** is too sparse for the prose; it should reference `def:isoLocus` explicitly since the proof says "Each T_I is open, being an iso-locus."

---

#### WARN — 15 matrix-calculus helpers with no blueprint block (coverage debt)

These Lean declarations proved in iter-078 exist only as `lean_aux` nodes in the DAG — no blueprint block, no statement, no proof sketch, no `\uses{}` edges. They are the key building blocks of the affine-splitting route used in `lem:chartLocus_isOpenCover` (and several other GR-quot proofs).

| Lean declaration | Role |
|---|---|
| `matrixEndRect_comp_rect` | composition law for rectangular matrix homs |
| `matrixEndRect_injective` | injectivity of the rectangular hom |
| `freeMap_matrixEndRect` | free module map expressed as matrixEndRect |
| `presentedMatrix` | matrix of a presented morphism |
| `presentedMatrix_changeOfBasis` | change-of-basis for the presented matrix |
| `matrixEndRect_presentedMatrix` | round-trip identity |
| `matrixEndRect_presentedMatrix_minor` | minor of the round-trip |
| `isUnit_of_isIso_matrixEndRect` | iso ↔ unit condition |
| `exists_section_of_epi_free_spec` | affine splitting: epi of free sheaves has a section |
| `exists_rightInverse_of_epi_matrixEndRect` | right inverse of an epi matrixEndRect |
| `exists_rightInverse_of_epi_matrixEndRect_spec` | spec version of the above |
| `exists_isUnit_submatrix` | right-invertible matrix over a field has invertible d-minor |
| `pullbackFreeIso_inv_freeMap` | inverse of the free pullback iso expressed as freeMap |
| `matrixEnd_eq_matrixEndRect` | square = rectangular specialisation |
| `matrixEndRect_one` | identity matrix is matrixEndRect of id |

**Required action:** Blueprint-writer should add a blueprint block for each helper in `Picard_GrassmannianQuot.tex` (as an appendix subsection or inline in the relevant infrastructure section). Priority: `exists_section_of_epi_free_spec`, `exists_isUnit_submatrix`, `exists_rightInverse_of_epi_matrixEndRect` (the three used directly in `lem:chartLocus_isOpenCover`).

---

### 6. Picard_GlueDescent.tex  ← ACTIVE prover lane

| Field | Status |
|-------|--------|
| complete | **partial** — 2 active sorries (`lem:gr_glueOverlapFactor_transpose`, `lem:gr_glueChartFamily_equalizes`) |
| correct | true — all 23+ helper blocks present; proof sketches are mathematically sound |
| `\uses{}` accurate | **2 missing proof-block edges** (see below) |
| Lean targets | well-formed; `def:modules_pullbackComp` is `\mathlibok` (expected in unmatched_lean) |

**All 23+ helper blocks confirmed present** (full list below includes: `def:gr_glue_equalizer`, `lem:glueOverlapBaseChangeIso`, `lem:glueRestrictionHom`, `thm:isIso_glueRestrictionHom`, `lem:gr_appLE_congr_mor`, `lem:gr_overlap_appIso_compat`, `lem:gr_overlapBaseChange_{inv,hom}_app`, `lem:gr_restrictAdjunction_unit_iso`, `lem:gr_restrictIsoPullback_{counit,congr}`, `lem:gr_pullbackCongr_hom_eqToHom`, `lem:gr_restrictFunctorCongr_rfl`, `def:gr_glueOverlapFactorIso`, `def:gr_glueChartComponent`, `def:gr_glueChartFamily`, `lem:gr_glueChartFamily_equalizes`, `def:gr_glueRestrictionInv`, `lem:gr_glueRestrict_{proj_compat,hom_ext}`, `lem:gr_glueRestrictionInv_proj`, `lem:gr_glueChartComponent_self_counit`, `lem:gr_glueOverlapFactor_{transpose,mate}`, `lem:gr_glueRestriction_{overlap_compat,Hom_glueChartComponent}`, `lem:gr_pullback_jointly_faithful`, `def:glueRestrictionIso`).

Both sorry targets have detailed, step-by-step proof blocks:
- `lem:gr_glueOverlapFactor_transpose` (lines 656–693): 8-step adjoint-transpose expansion
- `lem:gr_glueChartFamily_equalizes` (lines 497–549): 3-case reduction using triple-overlap cocycle (C2)

---

#### WARN — missing `\uses{}` edges in sorry-target proof blocks

**Finding 1 — `lem:gr_glueOverlapFactor_transpose` proof:**  
Proof `\uses{}` (lines 679–680): `{def:gr_glueOverlapFactorIso, lem:glueOverlapBaseChangeIso, lem:gr_overlapBaseChange_hom_app, def:scheme_modules_glue}`  
Proof prose at line 682 explicitly says: "the left-adjoint comparison isomorphisms (`\cref{lem:modules_restrictFunctorIsoPullback_mathlib}`) conjugating the chart factor cancel..."  
**Missing edge:** `lem:modules_restrictFunctorIsoPullback_mathlib`

**Finding 2 — `lem:gr_glueChartFamily_equalizes` proof:**  
Proof `\uses{}` (lines 509–511): `{def:gr_glueChartFamily, def:scheme_modules_glue, lem:gr_glueData_bridges, lem:modules_pullback_basechange_transport, lem:gr_overlap_appIso_compat, lem:gr_glueChartComponent_self_counit}`  
Proof prose at line 525 explicitly says: "exactly as the pair-level transpose of `\cref{lem:gr_glueOverlapFactor_mate}`"  
**Missing edge:** `lem:gr_glueOverlapFactor_mate`

These are DAG traceability gaps, not mathematical errors. Neither blocks the prover — the proof sketches are complete and the missing lemmas ARE present in the chapter.

**Cross-chapter note (INFO):** `def:gr_modules_glueRestrictionIso` in GrassmannianQuot.tex is a consumer cross-reference node with no `\lean{}` pin (the canonical pin is `def:glueRestrictionIso` here). The NOTE at line 799–803 of this chapter already documents the reconciliation needed; no further action from this review.

**Forward declarations** without `\lean{}` pins: `lem:gr_modules_glue_unique` and `def:gr_modules_glueHom` — both correctly marked as planned work; their presence in unmatched_lean is expected.

**Gate decision for active prover lane: PROCEED.** Both sorry targets have complete, detailed proof blocks; all 23+ helper blocks are present and correct; `\uses{}` gaps are advisory only.

---

### 7. Picard_QuotScheme.tex  (archon:covers QuotScheme.lean + GradedHilbertSerre.lean)

| Field | Status |
|-------|--------|
| complete | true for covered phases |
| correct | true |
| `\uses{}` accurate | true |
| Lean targets | well-formed |

Extensive chapter covering multiple completed phases. No findings from this review.

---

### 8. Picard_RelativeSpec.tex

| Field | Status |
|-------|--------|
| complete | true for covered phase |
| correct | true |
| `\uses{}` accurate | true |
| Lean targets | well-formed |

**INFO (strategic, from STRATEGY.md):** Open Q4 — RelativeSpec Stacks-tag pin — is a fence before any QUOT-repr prover. The blueprint chapter exists; the open question is about wiring the Lean declaration to the correct Mathlib/Stacks tag. Not a blueprint gap; a strategy tracking note.

---

### 9. Picard_SectionGradedRing.tex  ← SNAP phase

| Field | Status |
|-------|--------|
| complete | **partial** — `lem:sectionMul_coherent` and 2 graded-assembly lemmas not yet `\leanok` |
| correct | true — all proof sketches are mathematically sound |
| `\uses{}` accurate | minor (see below) |
| Lean targets | well-formed |

**Infrastructure blocks confirmed `\leanok`:** `def:sheafTensorObj`, `def:sheafTensorPow`, `lem:isIso_sheafification_whiskerRight_unit`, `cor:sheafTensorObjAssoc`, `lem:sheafTensorPow_add`, `def:sectionMul`.

**`lem:sectionMul_coherent` (SNAP target) adequacy assessment:**  
Statement (lines 1291–1310): `\lean{AlgebraicGeometry.Scheme.Modules.sectionsMul_assoc_unit}`, no `\leanok` (correct — target not yet scaffolded).  
Proof sketch (lines 1311–1326): 2-step route — (1) reduce to the tensor-product presheaf level using `lem:presheafModule_sheafification_mathlib` + `lem:presheafModule_monoidal_mathlib` where evaluation at the top open is strictly monoidal; (2) transport via naturality of the sheafification unit η.  
**Verdict: adequate for scaffolder + prover.** The two-step reduction is clearly described. The Lean path (apply η-naturality, close by presheaf strict-monoidal evaluation) is unambiguous. The sketch could be more specific about the exact whisker/unitor diagram, but at the SNAP level of "reduce to presheaf identities" this is sufficient.

**WARN — missing `\uses{}` edges in `lem:sectionMul_coherent` proof block:**  
Proof `\uses{def:sectionMul, lem:presheafModule_monoidal_mathlib, lem:presheafModule_sheafification_mathlib}` — missing:
- `lem:sheafTensorPow_add` (the μ_{m,m'} comparison is used in the proof reduction)
- `cor:sheafTensorObjAssoc` (the underlying associator identity the proof transports)

**`lem:sectionGradedRing_gcommSemiring` and `lem:sectionGradedModule_gmodule`** (lines 1367 and 1426): both have `\lean{}` hints and full proof blocks but no `\leanok`. These are downstream of `lem:sectionMul_coherent`; they will acquire `\leanok` once the SNAP target is scaffolded + proved and `sync_leanok` runs.

---

## DAG integrity summary

| Check | Status |
|-------|--------|
| `unknown_uses` | **0** — all `\uses{}` labels resolve |
| `unmatched_lean` | 55 entries — all expected (Mathlib anchors + `lem:gr_modules_glue_unique`, `def:gr_modules_glueHom` forward declarations) |
| Isolated blueprint nodes | 4 (FlatteningStratification: 3 `lem:mathlib_*` missing `\mathlibok`, 1 proved orphan) |
| Isolated lean_aux nodes | 122 — expected (uncovered Lean helpers, not removal candidates) |
| `with_sorry` | 13 total — 2 in GlueDescent (active targets), remainder spread across other decls |

---

## Gate decisions

| Prover lane | Verdict | Rationale |
|-------------|---------|-----------|
| GlueDescent (sorry `glueOverlapFactor_transpose` + `glueChartFamily_equalizes`) | **PROCEED** | All 23+ helpers present; both sorry targets have detailed proof blocks; `\uses{}` gaps are advisory |
| GrassmannianQuot (`grPointOfRankQuotient` overlap) | **PROCEED** | All upstream blocks `\leanok`; proof-prose divergence in `lem:chartLocus_isOpenCover` doesn't block — Lean source is authoritative; blueprint-writer rewrite is a separate task |
| SectionGradedRing SNAP (`sectionsMul_assoc_unit`) | **PROCEED** | `lem:sectionMul_coherent` block is adequate for scaffolding; all infrastructure is `\leanok` |

---

## Blueprint-writer task queue (ordered by priority)

1. **(WARN / GrassmannianQuot)** Rewrite `lem:chartLocus_isOpenCover` proof block to describe the affine-splitting route (`exists_section_of_epi_free_spec` → `exists_rightInverse_of_epi_matrixEndRect` → `exists_isUnit_submatrix` → basic-open cut). The existing NOTE at lines 2006–2014 has the full recipe.

2. **(WARN / GrassmannianQuot)** Add blueprint blocks for the 15 iter-078 matrix-calculus helpers listed above. Suggest inserting a "Matrix-calculus toolbox" subsection before the `def:gr_matrixEndRect` block. Priority order: `exists_section_of_epi_free_spec`, `exists_isUnit_submatrix`, `exists_rightInverse_of_epi_matrixEndRect[_spec]`, then the remaining 11.

3. **(WARN / FlatteningStratification)** Add `\mathlibok` markers to the 3 isolated `lem:mathlib_*` nodes (near lines 1848–1952). Wire-up or remove the 1 proved-isolated `lem:isLoc*` node.

4. **(WARN / GlueDescent)** Add missing proof `\uses{}` edges:  
   - `lem:gr_glueOverlapFactor_transpose` proof: add `lem:modules_restrictFunctorIsoPullback_mathlib`  
   - `lem:gr_glueChartFamily_equalizes` proof: add `lem:gr_glueOverlapFactor_mate`

5. **(WARN / SectionGradedRing)** Add missing proof `\uses{}` edges to `lem:sectionMul_coherent` proof block:  
   - add `lem:sheafTensorPow_add` and `cor:sheafTensorObjAssoc`

6. **(INFO / GrassmannianQuot)** Remove spurious `lem:isIso_pullback_isoLocus_map` from `lem:chartLocus_isOpenCover` statement `\uses{}`; add `def:isoLocus` to the proof `\uses{}`.

---

## Unstarted-phase proposals

### SNAP-S1/S3 — new chapter needed when Q1 unblocks

**Phase:** SNAP-S1 (section-module input) + SNAP-S3 (Φ_s extraction)  
**Current status:** BLOCKED on Open Q1 (`existsUnique_hilbertPoly` + every coherent F on Proj S is M̃ for a f.g. graded module M)  
**What's missing:** No blueprint chapter covers the section-module infrastructure or Φ_s. When Q1 unblocks, a new chapter (suggested name: `Picard_SectionModule.tex`) should be written covering:
- The Hilbert polynomial uniqueness result (`existsUnique_hilbertPoly`)  
- The algebraisation lemma ("F = M̃ for coherent F on Proj S")  
- The Φ_s extraction: the truncated-section functor and the map from the Grassmannian functor to Quot

No action required this iter (blocked). Flag for plan agent to schedule when Q1 resolves.

---

## Return value

`blueprint-reviewer-iter079: PARTIAL/PARTIAL — 9 chapters audited, 15 findings (0 BLOCK / 5 WARN / 4 INFO / 1 unstarted-phase proposal [SNAP-S1/S3]); all 3 active prover lanes CLEARED`
