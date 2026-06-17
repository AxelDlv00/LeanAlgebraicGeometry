# Blueprint Review — Iter-046

**Reviewer:** blueprint-reviewer subagent  
**Date:** 2026-06-09  
**Scope:** ALL 6 blueprint chapters (`blueprint/src/chapters/*.tex`)

---

## Summary Dashboard

| Chapter | Status | Issues |
|---|---|---|
| `Cohomology_RegroupHelper.tex` | **COMPLETE** | — |
| `Cohomology_FlatBaseChange.tex` | **PARTIAL** | 2 missing blueprint blocks |
| `Picard_GrassmannianCells.tex` | **COMPLETE** | — |
| `Picard_RelativeSpec.tex` | **PARTIAL** | QUOT-repr subphases uncovered (expected) |
| `Picard_FlatteningStratification.tex` | **PARTIAL** | 2 missing blocks; G1 not effort-broken in blueprint; base-case sub-lemma absent |
| `Picard_QuotScheme.tex` | **PARTIAL** | `lem:modules_annihilator_ideal` open (CLEAR FOR PROVER); 3 gap nodes absorbed inline (KEEP); SNAP blocked |

---

## leandag Diagnostics

- **Broken edges:** 0
- **Unmatched lean hints:** 1  
  - `lem:pushforward_base_change_mate_sections_direct` → `AlgebraicGeometry.pushforward_base_change_mate_sections_direct`  
    **Disposition:** INTENTIONAL — this is an abandoned-route record; the note in FlatBaseChange.tex reads "Lean target NOT added (correctly)"; the decl was never created. No action needed.
- **Isolated nodes:** 4 (all `lean_aux` helpers) → **KEEP**
- **Gap nodes (no `\lean{}` hint):** 3 — all in `Picard_QuotScheme.tex`, all absorbed inline:
  1. `lem:composite_immersion_flocus_basicOpen` (line 4784): absorbed into `section_localization_hfr_basicOpen`
  2. `lem:gamma_image_iso_semilinear_top` (line 4818): absorbed into `section_localization_hfr_aux`
  3. `lem:flocus_section_scalar_tower` (line 4846): absorbed into `section_localization_hfr_aux`  
  All three carry NOTE comments documenting the absorption. **Disposition: KEEP** as mathematical records.

---

## Focus Area Findings

### 1. `lem:modules_annihilator_ideal` (Picard_QuotScheme.tex, line 2414)

**Verdict: CLEAR FOR PROVER.** All deps proved; proof sketch is logically sound.

| Dep | Status |
|---|---|
| `def:modules_annihilator` (line 2327) | `\leanok` ✓ |
| `lem:modules_annihilator_ideal_le` (line 2393) | `\leanok` ✓ |
| `lem:annihilator_localization_eq_map` (line 2451) | `\leanok` ✓ |
| `lem:qcoh_section_localization_basicOpen` (line 2512) | `\leanok` ✓ (gap2 closed) |
| **`lem:modules_annihilator_ideal`** (line 2414) | **NO `\leanok`** — OPEN TARGET |

Proof route: the forward inclusion (`≤`) is `lem:modules_annihilator_ideal_le`. The reverse inclusion uses `lem:annihilator_localization_eq_map` at each basic open of a cover (qcoh gives the localization identification), then `lem:qcoh_section_localization_basicOpen` to reduce to the local annihilator condition. The infimum-over-basic-opens route is mathematically complete.

Lean target: `AlgebraicGeometry.Scheme.Modules.annihilator_ideal`

### 2. G1 effort-break (Picard_FlatteningStratification.tex)

**Problem: G1 block is MONOLITHIC in the blueprint.** `lem:gf_qcoh_fintype_finite_sections` (line ~1513) carries a single `\lean{AlgebraicGeometry.gf_qcoh_fintype_finite_sections}` hint but NO `\leanok`. There is no separate sub-lemma for the finite-type base case.

- **Locality reduction half** (`finite_localizedModule_of_isLocalizedModule` + `gf_finite_sections_of_basicOpen_finite_cover`): DONE axiom-clean in Lean (iter-045), but no blueprint blocks exist for either.
- **Base case half** (SheafOfModules.IsFiniteType + sheaf-epi on sections ⟹ finite Γ): mathematically needed and NOT stated anywhere in the blueprint.
- STRATEGY.md describes the effort-break explicitly ("locality reduction DONE; base case REMAINING") but this is not reflected in the blueprint.

**Must-fix:** Add `lem:gf_fintype_base_case` as a standalone sub-lemma in the G1 block stating the base case claim, so the prover lane has a clear target.

### 3. Coverage Debt — 4 Lean Helpers Still Missing Blueprint Blocks

All 4 helpers confirmed absent from blueprint chapters (grep of `*.tex` finds no mentions):

| Lean decl | File | Line | Blueprint block |
|---|---|---|---|
| `keystoneAdjR` | `FlatBaseChange.lean` | 1755 | **ABSENT** |
| `keystoneBeta` | `FlatBaseChange.lean` | 1772 | **ABSENT** |
| `finite_localizedModule_of_isLocalizedModule` | `FlatteningStratification.lean` | 2173 | **ABSENT** |
| `gf_finite_sections_of_basicOpen_finite_cover` | `FlatteningStratification.lean` | 2231 | **ABSENT** |

The planner directive states these blocks are being added this iter. As of this review they remain missing.

---

## Per-Chapter Verdicts

### `Cohomology_RegroupHelper.tex` — COMPLETE/CORRECT

Single lemma `lem:base_change_regroup_linearEquiv` with `\leanok`. No open targets, no missing blocks, no rendering issues. Nothing to fix.

### `Cohomology_FlatBaseChange.tex` — PARTIAL

**Complete/correct sections:**
- FBC-A2 (`lem:base_change_map_affine_local`, `\leanok`)
- conj-0 through conj-2d (including `lem:base_change_mate_fstar_reindex_legs_conj` with `\leanok`)
- Steps (a) and (c) of gstar_counit crux not formalized

**Open targets:**
- `lem:base_change_mate_gstar_counit_transport` (`huce`): has `\lean{...}` but NO `\leanok` — the open FBC keystone remnant. This is expected per current strategy (FBC parked at keystone).
- `keystoneAdjR` (line 1755): NO blueprint block
- `keystoneBeta` (line 1772): NO blueprint block

**Unmatched hint (intentional):** `lem:pushforward_base_change_mate_sections_direct` — documented abandoned route, no decl added. KEEP.

**Must-fix:** Add blueprint blocks for `keystoneAdjR` and `keystoneBeta`.

### `Picard_GrassmannianCells.tex` — COMPLETE/CORRECT

All chart constructions, transition maps, minor determinant, E1-E5, and `isProper` have `\leanok`. GR-cells/glue/sep/proper all done per STRATEGY.md. No issues.

### `Picard_RelativeSpec.tex` — PARTIAL (expected)

**Complete/correct:**
- `thm:relative_spec_exists` (`\leanok`)
- `def:relspec_structure_morphism` (`\leanok`)
- `thm:relative_spec_univ` (`\leanok`)

**Uncovered:** QUOT-repr subphases (GR-quot, GR-repr). These are not started per STRATEGY.md — expected absence, not a missing block. No blocking issues for the current prover lane.

### `Picard_FlatteningStratification.tex` — PARTIAL

**Complete/correct:**
- All dévissage sub-lemmas L1–L5b: `\leanok`
- Nagata machinery and transport helpers: `\leanok`
- `thm:generic_flatness`: `\leanok` (but among sorry-bearing nodes per leandag — consistent with strategy)

**Open / must-fix:**
- `lem:gf_qcoh_fintype_finite_sections` (G1): `\lean{...}` but NO `\leanok`; MONOLITHIC (see §2 above)
- `lem:gf_flat_locality_assembly` (G3): `\lean{...}` but NO `\leanok`
- Missing blueprint blocks: `finite_localizedModule_of_isLocalizedModule`, `gf_finite_sections_of_basicOpen_finite_cover`
- Missing sub-lemma: G1 finite-type base case (no blueprint block for the sheaf-epi ⟹ Γ-finite claim)

### `Picard_QuotScheme.tex` — PARTIAL

**Complete/correct (gap1/gap2 closed):**
- All gap1 helper blocks: `\leanok`
- All gap2 blocks: `\leanok`
- Annihilator deps (see §1 above): all `\leanok`

**Open targets:**
- `lem:modules_annihilator_ideal`: CLEAR FOR PROVER (see §1)
- `def:sectionGradedRing` (SNAP, line 157): NO `\leanok` — blocked on tensor powers for sheaves of modules; expected per strategy

**Gap nodes (all absorbed inline, KEEP):**
- `lem:composite_immersion_flocus_basicOpen` (line 4784)
- `lem:gamma_image_iso_semilinear_top` (line 4818)
- `lem:flocus_section_scalar_tower` (line 4846)

All three have NOTE comments explaining absorption into `section_localization_hfr_aux`/`section_localization_hfr_basicOpen`. Mathematically correct as records; no standalone Lean decls needed.

---

## Must-Fix This Iter

Priority order:

1. **[FlatBaseChange]** Add blueprint block for `keystoneAdjR` (FlatBaseChange.lean:1755) in `Cohomology_FlatBaseChange.tex`
2. **[FlatBaseChange]** Add blueprint block for `keystoneBeta` (FlatBaseChange.lean:1772) in `Cohomology_FlatBaseChange.tex`
3. **[Flattening]** Add blueprint blocks for `finite_localizedModule_of_isLocalizedModule` (FlatteningStratification.lean:2173) and `gf_finite_sections_of_basicOpen_finite_cover` (FlatteningStratification.lean:2231) in `Picard_FlatteningStratification.tex`
4. **[Flattening]** Add `lem:gf_fintype_base_case` sub-lemma to `Picard_FlatteningStratification.tex` — statement: given a quasi-coherent `SheafOfModules.IsFiniteType` sheaf on a Noetherian affine scheme, if the global section map is surjective after localization at each element of a finite generating set, then `Γ(X, F)` is a finite `Γ(X, O_X)`-module. This is the base case of the G1 dévissage.
5. **[QuotScheme prover]** `lem:modules_annihilator_ideal` is CLEAR FOR PROVER — dispatch to prove `AlgebraicGeometry.Scheme.Modules.annihilator_ideal`

---

## Unstarted-Phase Proposals

**SNAP phase — `Picard_SectionGradedRing.tex`**  
Blueprint chapter needed for: section graded ring construction, Hilbert series, Hilbert-Serre theorem (algebraic + sheaf-of-modules form). This chapter gates `GradedHilbertSerre.lean`. The tensor-powers API for sheaves of modules is the blocking sub-phase (currently unresolved per STRATEGY.md). Suggest dispatch blueprint writer once planner unblocks the tensor-power API (i.e., resolves the `TensorProduct ℤ (MvPolynomial …) …` semiring inference issue or routes around it).

---

## Cross-Chapter Notes

- **Dependency coherence:** No cross-chapter broken edges per leandag. All `\uses{}` links inside chapters resolve to defined labels.
- **Lean target naming:** All `\lean{...}` hints use the fully qualified `AlgebraicGeometry.…` namespace consistently.
- **Single-route policy:** No multi-route redundancy detected. The abandoned `sections_direct` route in FlatBaseChange is documented and has no live `\lean{}` hint pointing at it.
- **Sorry count:** leandag reports `thm:generic_flatness` among sorry-bearing nodes (expected, as G1/G3 sub-lemmas are not yet closed). All other `\leanok` nodes are consistent with axiom-clean status per iter-041/042/044/045 reports.
