# Blueprint Review Report

**Slug:** iter039
**Iteration:** 039
**Reviewer:** blueprint-reviewer subagent
**Date:** 2026-06-08

---

## 1. leandag Health Summary

| Metric | Value | Assessment |
|--------|-------|------------|
| `unknown_uses` | 0 | GOLD — no broken `\uses{}` references |
| `unmatched_lean` | 87 | Expected — all `\mathlibok` anchors + the two open QUOT targets |
| Isolated nodes (blueprint) | 1 | `lem:annihilator_localization_eq_map` — KEEP (intentional; see §5) |
| Isolated nodes (Lean) | 12 | Internal (snapshot files, etc.) — not actionable |
| Sorry-bearing nodes | 9 | 4 FBC, 1 GF-geo, 4 QUOT — all tracked |

**DAG integrity: CLEAN.** `unknown_uses: []` means every `\uses{}` label resolves to an existing blueprint declaration. No structural defects.

Sorry-bearing node breakdown:
- FBC: `base_change_mate_gstar_transpose` (crux), `base_change_mate_fstar_reindex_legs_conj`, `affine_base_change_pushforward`, `flat_base_change_pushforward`
- GF-geo: `generic_flatness_geometric`
- QUOT: `hilbert_polynomial`, `quot_functor`, `grassmannian_scheme`, `grassmannian_representable`

---

## 2. Blueprint-Doctor

**Result: CLEAN.** No malformed refs, no broken `\ref`/`\uses`/`\proves`, no orphan chapters, no new `axiom` declarations flagged.

---

## 3. Per-Chapter Audit

### 3.1 `Cohomology_FlatBaseChange.tex`

| Check | Result |
|-------|--------|
| `complete` | **true** |
| `correct` | **true** |
| Must-fix-this-iter | NONE |
| HARD GATE | **CLEAR — dispatch FBC prover** |

**Block count:** 102 blueprint blocks, 78 `\leanok` markers (76.5% closed).

**Target nodes for this iter:**

**conj-2b — `lem:base_change_mate_reindex_conj_pullbackLeg`** (lines 2122–2148):
- `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_pullbackLeg}` — no `\leanok`, Lean decl absent (expected open target)
- `\uses{lem:conjugateEquiv_pullbackComp_inv_mathlib, lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib, lem:pullbackComp_eq_leftAdjointCompIso}` — all three labels resolve:
  - `lem:conjugateEquiv_pullbackComp_inv_mathlib` → `\mathlibok` anchor; verified in Mathlib at `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean` (`AlgebraicGeometry.Scheme.Modules.conjugateEquiv_pullbackComp_inv`)
  - `lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib` → `\mathlibok` anchor; verified in Mathlib at `Mathlib/CategoryTheory/Adjunction/CompositionIso.lean` (`CategoryTheory.Adjunction.conjugateEquiv_leftAdjointCompIso_inv`)
  - `lem:pullbackComp_eq_leftAdjointCompIso` → project theorem, confirmed in `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Proof sketch present and sufficiently fine-grained: "both identifications are direct applications of the cited conjugation identities to the free legs e, Spec ι_A; the interchange of pullbackComp and leftAdjointCompIso is Lemma pullbackComp_eq_leftAdjointCompIso." Prover-actionable.

**conj-2d — `lem:base_change_mate_reindex_conj_crossLayer`** (lines 2176–2207):
- `\lean{AlgebraicGeometry.base_change_mate_reindex_conj_crossLayer}` — no `\leanok`, Lean decl absent (expected open target)
- `\uses{lem:base_change_mate_unit_value, lem:unit_conjugateEquiv_symm_mathlib, lem:conjugateEquiv_comp_mathlib, lem:gammaPushforwardIso}` — all four labels resolve:
  - `lem:base_change_mate_unit_value` → project lemma, present in FlatBaseChange.lean
  - `lem:unit_conjugateEquiv_symm_mathlib` → `\mathlibok` anchor; verified in Mathlib at `Mathlib/CategoryTheory/Adjunction/Mates.lean` (`CategoryTheory.unit_conjugateEquiv_symm`)
  - `lem:conjugateEquiv_comp_mathlib` → `\mathlibok` anchor; verified in Mathlib at `Mathlib/CategoryTheory/Adjunction/Mates.lean` (`CategoryTheory.conjugateEquiv_comp`)
  - `lem:gammaPushforwardIso` → project declaration, present and `\leanok`
- Proof sketch detailed (lines 2186–2205): unit value rewrite, conjugate symm application, comp lemma chain, gammaPushforwardIso natural isomorphism step. Prover-actionable.

**conj-2a — `lem:base_change_mate_fstar_reindex_legs_conj`** (lines 2209–2260):
- `\leanok` present (sorry-backed). NOTE in chapter text: "this conj-2a node is now OFF the critical path (pruning debt)... conj-2b and conj-2d are not typed in Lean." After conj-2b/2d land, the sorry in this node can be discharged.
- This node is correctly ordered in `\uses{}` of `lem:base_change_mate_gstar_transpose` (the crux). Chain is complete.

**crux — `lem:base_change_mate_gstar_transpose`** (line 2983):
- `\leanok` present (sorry-backed, the live crux). Detailed recipe at lines 3015–3040. After conj-2b/2d/2a close, this node's sorry body becomes immediately provable by the recipe.

**Assessment:** Chapter complete and structurally sound. All `\uses{}` deps of the target nodes are present and their Mathlib anchors verified. Proof sketches are fine-grained. **GATE CLEAR.**

---

### 3.2 `Cohomology_RegroupHelper.tex`

| Check | Result |
|-------|--------|
| `complete` | **true** |
| `correct` | **true** |
| Must-fix-this-iter | NONE |
| HARD GATE | N/A (no prover dispatched to this file this iter) |

Both declarations `\leanok`. Minimal chapter, fully closed. No action needed.

---

### 3.3 `Picard_FlatteningStratification.tex`

| Check | Result |
|-------|--------|
| `complete` | **partial** |
| `correct` | **true** |
| Must-fix-this-iter | NONE |
| HARD GATE | N/A (no prover dispatched this iter) |

**Partial rationale:** Two geometric goal blocks — `lem:gf_qcoh_fintype_finite_sections` and `lem:gf_flat_locality_assembly` — have no `\lean{}` annotations and no Lean declarations yet. The algebraic core `thm:generic_flatness_algebraic` is `\leanok`. The geometric assembly blocks represent the GF-geo lane (currently ACTIVE but not dispatched this iter).

**Correctness:** Blueprint prose is consistent with the algebraic core. Unbuilt geometric blocks have adequate informal descriptions. No structural errors found.

---

### 3.4 `Picard_GrassmannianCells.tex`

| Check | Result |
|-------|--------|
| `complete` | **true** |
| `correct` | **true** |
| Must-fix-this-iter | NONE |
| HARD GATE | N/A (no prover dispatched this iter) |

**GR sanity check — `lem:gr_existence_chart_kpoint_eq`** (line 2437):
- `\lean{AlgebraicGeometry.Grassmannian.existence_chart_kpoint_eq}` — Lean decl present (not in `unmatched_lean`), confirmed via `lean_local_search`.
- `\uses{lem:gr_chartTransition_comp_chartIncl, def:gr_the_glue_data, lem:gr_transitionPreMap_minorDet}` — all three labels exist in the chapter. No broken references.
- Block correctly wired into `lem:gr_existence_lift`'s `\uses` at line 2468.
- **Verdict: well-formed. No issues.**

Properness lane (`lem:gr_proper`, `lem:gr_isProper_of_valuativeExistence`) — both `\leanok`, DONE.

---

### 3.5 `Picard_QuotScheme.tex`

| Check | Result |
|-------|--------|
| `complete` | **true** |
| `correct` | **true** |
| Must-fix-this-iter | NONE |
| HARD GATE | **CLEAR — dispatch QUOT prover** |

**Re-assessment from iter-038 `partial/partial`:**

The iter-038 `partial` verdict was conditioned entirely on two unmatched semilinearity targets. Both are now built:
- `def:gamma_image_ring_equiv` → `\lean{AlgebraicGeometry.Scheme.Modules.gammaImageRingEquiv}` — `\leanok`
- `lem:gamma_pullback_image_iso_hom_semilinear` → `\lean{AlgebraicGeometry.Scheme.Modules.gammaPullbackImageIso_hom_semilinear}` — `\leanok`

The `\sigma_V` direction correction (source→image) noted by the planner is reflected correctly in the current blueprint text.

**Target nodes for this iter:**

**keystone — `lem:section_localization_descent`** (line 3887):
- `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent}` — no `\leanok`, Lean decl absent (expected open target; cover-form `isLocalizedModule_basicOpen_descent_of_cover` landed iter-038, named form is the gap)
- `\uses{}` lists 9 deps — verified all present and `\leanok`:
  1. `lem:isLocalizedModule_ringEquiv_semilinear` — `\leanok` (Bridge I)
  2. `lem:isLocalizedModule_restrictScalars_powers_algebraMap` — `\leanok` (Bridge II)
  3. `def:gamma_image_ring_equiv` — `\leanok` (semilinearity, newly built)
  4. `lem:gamma_pullback_image_iso_hom_semilinear` — `\leanok` (semilinearity, newly built)
  5. `lem:pullback_gamma_top_iso` — `\leanok`
  6. `lem:qcoh_sheaf_restriction_presheaf_eq` — `\leanok` (P1 transport)
  7. `lem:qcoh_restrict_eq_overRestrictEquiv` — `\leanok`
  8. `lem:section_localization_descent_cover` — `\leanok` (cover form, landed iter-038)
  9. `lem:isLocalizedModule_cover_to_named` — `\leanok` (slice→Spec R_r bridge, Hfr)
- Full proof sketch present at lines ~3897–3986. The sketch traces: (i) extract cover-form result, (ii) transport via semilinear bridge (gammaImageRingEquiv + gammaPullbackImageIso_hom_semilinear), (iii) apply slice→Spec bridge to obtain named form. Detail sufficient for a mathlib-build prover.

**consumer — `lem:qcoh_affine_isIso_fromTildeΓ`** (line 3988):
- `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent}` — no `\leanok`, Lean decl absent
- `\uses{lem:section_localization_descent}` — resolves cleanly
- One-line proof sketch: the `isIso` follows directly from `lem:section_localization_descent` via the standard QCoh-affine characterization. Prover-actionable.

**Assessment:** All `\uses{}` deps of the two open target nodes are present and `\leanok`. Semilinearity blocker cleared. Proof sketches are complete. **GATE CLEAR.**

---

### 3.6 `Picard_RelativeSpec.tex`

| Check | Result |
|-------|--------|
| `complete` | **true** |
| `correct` | **true** |
| Must-fix-this-iter | NONE |
| HARD GATE | N/A (no prover dispatched this iter) |

Well-formalized. Majority of blocks `\leanok`. No open targets or structural issues. No action needed.

---

## 4. Findings by Severity

### HARD GATE CLEARS

| Lane | Chapter | Verdict |
|------|---------|---------|
| FBC prover: conj-2b/2d/legs_conj | `Cohomology_FlatBaseChange.tex` | **DISPATCH OK** |
| QUOT prover: section_localization_descent + consumer | `Picard_QuotScheme.tex` | **DISPATCH OK** |

### Must-fix-this-iter

**(none)**

### Informational

**INFO-1:** `lem:annihilator_localization_eq_map` is a blueprint-isolated node (no `\uses{}` pointing to it). The NOTE at `def:modules_annihilator` (lines 2329–2334) in `Picard_QuotScheme.tex` explicitly documents this: "The definition carries no `\uses`: the Lean construction does NOT depend on the localization bridges at definition time. The two facts `lem:annihilator_localization_eq_map` and `lem:qcoh_section_localization_basicOpen` are needed only for the downstream CHARACTERIZATION... which is not yet a blueprint block." **Verdict: KEEP isolated. No action required.**

---

## 5. Unstarted-Phase Proposals

**(none)**

All six phases with active blueprint coverage (FBC-A, FBC-B, GF-geo, GR-proper, QUOT-defs, QUOT-repr) have ≥3 meaningful blueprint blocks. No phase is unstarted without coverage.

---

## 6. Overall Verdict

Both prover lanes are **dispatch-ready**:

1. **FBC lane** (`FlatBaseChange.lean` → conj-2b, conj-2d, legs_conj): Chapter `complete=true, correct=true`. All `\uses{}` deps verified. Mathlib anchors (`conjugateEquiv_pullbackComp_inv`, `conjugateEquiv_leftAdjointCompIso_inv`, `unit_conjugateEquiv_symm`, `conjugateEquiv_comp`) confirmed in Mathlib. Project dep `pullbackComp_eq_leftAdjointCompIso` confirmed in FlatBaseChange.lean. Proof sketches are fine-grained. **GATE CLEAR.**

2. **QUOT lane** (`QuotScheme.lean` → `isLocalizedModule_basicOpen_descent` + `isIso_fromTildeΓ_of_isQuasicoherent`): Chapter `complete=true, correct=true`. Iter-038 `partial/partial` verdict overturned — semilinearity targets now `\leanok`. All 9 `\uses{}` deps of `lem:section_localization_descent` are present and `\leanok`. Proof sketch complete and mathlib-build prover-actionable. **GATE CLEAR.**

GR sanity check: `lem:gr_existence_chart_kpoint_eq` well-formed (Lean decl present, all `\uses{}` deps resolve, correctly wired into `lem:gr_existence_lift`). No issues.

DAG integrity: `unknown_uses: []`, blueprint-doctor CLEAN. No structural debt introduced this iter.
