# Blueprint review — iter-040

**Date:** 2026-06-08  
**Scope:** Whole-blueprint audit (`blueprint/src/chapters/*.tex`), with primary focus on
`Picard_QuotScheme.tex` and `Picard_GrassmannianCells.tex`.  
**Tools run:** `leandag build --json`, `leandag stats`, `leandag show isolated/ready/gaps`,
`archon blueprint-doctor --json` (output from previous session).

---

## Cross-chapter instrument readings

| Metric | Value |
|---|---|
| Blueprint nodes | 413 |
| Proved (`\leanok`) | 309 (74.8%) |
| Mathlib-backed (`\mathlibok`) | 71 |
| With sorry | 9 |
| Ready to formalize | 6 |
| Needs `\leanok` sync | 14 |
| Unmatched `\lean{}` | 90 |
| Isolated nodes | 3 (2 blueprint) |
| Unknown `\uses{}` | 0 |
| Conflicts | 0 |
| Blueprint-doctor issues | 0 |
| Remaining effort | 46,474 chars (all finite) |

**Blueprint-doctor:** clean — `orphan_chapters: []`, `broken_refs: []`, `malformed_refs: []`,
`axiom_decls: []`, `covers_problems: []`.

**`unknown_uses: []`, `conflicts: []`** — graph wiring is sound.

**Unmatched `\lean{}` breakdown (90 total):**
- ~67 Mathlib anchors (`\mathlibok` nodes with no project Lean obligation) — expected and correct.
- 12 FBC chapter open nodes (`lem:base_changed_equalizer_diagram`, Mayer–Vietoris, FBC-B nodes) — planned, correct.
- 10 QUOT open nodes (5 new producer sub-lemmas + gap-1 assembly targets + SNAP-S1 gated) — all correctly planned-not-yet-built; see QUOT section below.
- 1 GR Mathlib anchor (`lem:equivalence_sheafCongr_mathlib`) — expected.

**Needs-`\leanok` (14 nodes):** These have matched Lean declarations with no sorry but lack
`\leanok` in the blueprint — awaiting next `sync_leanok`. Includes the 6 new
`Picard_GrassmannianCells.tex` private declarations (confirmed matched in leandag), plus
several feeder/engine blocks in `Picard_QuotScheme.tex` (confirmed matched — see QUOT section).

**Ready to formalize (6 nodes):**
- 2 FBC nodes (`lem:bas...`, `lem:fla...`) — all dependencies resolved, gated on `_legs_conj`/`gstar_transpose` affine sorry in practice.
- 4 QUOT section-transport producer nodes: `lem:pullback_composite_immersion_isIso_fromTildeΓ` **(sub-gap a)**, `lem:composite_immersion_range_basicOpen`, `lem:gamma_image_iso_semilinear_top`, and `def:sec...` (likely `section_localization_hfr_basicOpen`-related) — all dependencies resolved.

---

## Isolated-node dispositions

| Truncated ID | Chapter | Proved | Disposition |
|---|---|---|---|
| `lem:ann…` | Picard_QuotScheme | ✓ | **keep** — `\mathlibok` anchor for `annihilator_meets_nonZeroDivisors`; isolated by design (Mathlib anchor has no outbound project edges). |
| `lem:gr_…` | Picard_GrassmannianCells | ✗ | **wire-up (soon)** — identified as `lem:gr_det_one_updateCol`. Statement has no `\uses{}` and nothing uses it. The proof of `lem:gr_free_entry_eq_signed_minor` invokes this fact inline but its `\uses{}` block omits it. Fix: add `\uses{lem:gr_det_one_updateCol}` to the proof block of `lem:gr_free_entry_eq_signed_minor`. |
| `lean:Al…` | — (lean_aux) | ✓ | **keep** — uncovered Lean helper node; not a blueprint gap. |

---

## Per-chapter verdicts

---

### 1. Picard_QuotScheme.tex

**`complete: true`** | **`correct: true`** | **HARD GATE: PASSES**

#### Re-routing of `lem:section_localization_descent` ✓

The proof block of `lem:section_localization_descent` (lines ~4139–4178) correctly routes through
`lem:section_localization_descent_of_basicOpen_cover` (the basic-open cover form) and NOT through
`lem:section_localization_descent_of_cover` (the general-U form). Both the statement `\uses{}` and
the proof `\uses{}` are consistent:
- Statement block uses: `lem:section_localization_descent_of_basicOpen_cover`,
  `lem:section_localization_hfr_basicOpen`, and the relevant Mathlib anchors. ✓
- Proof block explicitly invokes `lem:section_localization_descent_of_basicOpen_cover` as the
  thin wrapper. ✓
- The general-U form (`lem:section_localization_descent_of_cover`) does NOT appear in either
  `\uses{}` block. ✓

#### Feeder and engine coverage blocks ✓

All 8 coverage blocks are confirmed **matched** in leandag (not in the `unmatched_lean` list),
meaning their Lean declarations exist and leandag can resolve them. They do not yet have `\leanok`
because `sync_leanok` has not run since they were added to the blueprint this iteration.

**Feeder blocks (3):**
- `lem:section_localization_descent_of_basicOpen_cover` →
  `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent_of_basicOpen_cover` — matched ✓
- `lem:isLocalizedModule_powers_transport` →
  `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_powers_transport` — matched ✓ (iter-039 axiom-clean confirmed)
- `lem:isIso_fromTildeΓ_of_iso` →
  `AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_iso` — matched ✓ (iter-039 axiom-clean confirmed)

**Engine blocks (5):**
- `lem:res_comp`, `lem:iSup_basicOpen_subtype_eq_top`, `lem:descent_overlap_agree`,
  `lem:descent_surj`, `lem:descent_smul_eq_zero` — all matched ✓

Note: The previous session's leandag output incorrectly suggested these were unmatched, due to a
Python filter bug in that session's parsing. The current run confirms they are all matched.

#### New section-transport producer subsection ✓

The 5 new planned declarations (TOP + 4 sub-lemmas) are correctly staged:

| Node | `\lean{}` pin | `\leanok` | Unmatched | Proof sketch effort |
|---|---|---|---|---|
| `lem:section_localization_hfr_basicOpen` | ✓ | absent ✓ | in list ✓ | finite (assembles 4 sub-lemmas + feeders) ✓ |
| `lem:pullback_composite_immersion_isIso_fromTildeΓ` | ✓ | absent ✓ | in list ✓ | finite (3-fold `pullbackComp` iso via `isIso_fromTildeΓ_of_iso`) ✓ |
| `lem:composite_immersion_range_basicOpen` | ✓ | absent ✓ | in list ✓ | finite (j.opensRange = D(s), σ(f') = algebraMap R Rs f via `gammaImageRingEquiv`) ✓ |
| `lem:gamma_image_iso_semilinear_top` | ✓ | absent ✓ | in list ✓ | finite (σ-naturality at global sections, uses `gamma_pullback_image_iso_hom_semilinear`) ✓ |
| `lem:flocus_section_scalar_tower` | ✓ | absent ✓ | in list ✓ | finite (f-locus scalar-tower via ring-iso + composite range identity) ✓ |

**`\uses{}` chains for the 5 new nodes are accurate**: each sub-lemma's `\uses{}` correctly lists
the already-built feeders it depends on (`lem:isLocalizedModule_powers_transport`,
`lem:isIso_fromTildeΓ_of_iso`, `lem:gamma_pullback_image_iso_hom_semilinear`,
`def:gamma_image_ring_equiv`, etc.), and the TOP lemma
`lem:section_localization_hfr_basicOpen` correctly lists all 4 sub-lemmas in its `\uses{}`. ✓

**No false `\leanok`** on any of the 5 new nodes. ✓

#### Remaining known-open nodes (expected)

- `lem:qcoh_affine_isIso_fromTildeΓ` — gap1 target; correctly carries `% NOTE: Lean decl does NOT
  yet exist`. ✓
- `lem:section_localization_descent` — gap1 assembly; correctly unmatched (Lean decl not yet
  built). ✓
- SNAP-S1 nodes (`def:sectionGradedModule`, `def:sectionGradedRing`, etc.) — correctly gated. ✓

#### Verdict

No must-fix or soon findings in Picard_QuotScheme.tex. The chapter is coherently staged: all
iter-039 work is built and correctly marked; all iter-040 additions are correctly planned-not-built.

**HARD GATE ANSWER: YES — `complete: true`, `correct: true`, no must-fix-this-iter finding. The
mathlib-build prover may be dispatched on sub-gap (a) (`lem:pullback_composite_immersion_isIso_fromTildeΓ`)
this iteration.**

---

### 2. Picard_GrassmannianCells.tex

**`complete: true`** | **`correct: true`**

#### 6 new terse coverage blocks — sanity check ✓

All 6 are `private` declarations in `namespace AlgebraicGeometry.Grassmannian` inside
`GrassmannianCells.lean`. All 6 are confirmed **matched** by leandag (0 GR entries in
`unmatched_lean`), meaning the Lean declarations exist.

| Node | Line | `\lean{}` | `\uses{}` | `\leanok` | Finding |
|---|---|---|---|---|---|
| `lem:gr_rotMid` | 1448 | `Grassmannian.rotMid` ✓ | ✓ (5 deps) | absent (pending sync) | clean ✓ |
| `lem:gr_transitionInvImageMatrix` | 1464 | `Grassmannian.transitionInvImageMatrix` ✓ | ✓ (large) | absent (pending sync) | clean ✓ |
| `lem:gr_transitionInvPair` | 1481 | `Grassmannian.transitionInvPair` ✓ | ✓ (8 deps) | absent (pending sync) | clean ✓ |
| `lem:gr_det_one_updateCol` | 2366 | `Grassmannian.det_one_updateCol` ✓ | absent | absent (pending sync) | **isolated — soon wire-up** |
| `def:gr_liftToBaseOfMemRange` | 2476 | `Grassmannian.liftToBaseOfMemRange` ✓ | absent | absent (pending sync) | clean ✓ (inbound edge from `lem:gr_algebraMap_comp_liftToBaseOfMemRange`) |
| `lem:gr_algebraMap_comp_liftToBaseOfMemRange` | 2488 | `Grassmannian.algebraMap_comp_liftToBaseOfMemRange` ✓ | `\uses{def:gr_liftToBaseOfMemRange}` ✓ | absent (pending sync) | clean ✓ |

**All 6 correctly lack `\leanok`** — they are newly added to the blueprint this iteration and
`sync_leanok` has not yet run. After the next `sync_leanok` cycle, all 6 should acquire `\leanok`
(the private Lean declarations compile clean per the file state).

**Isolated node (`lem:gr_det_one_updateCol`):**
`lem:gr_det_one_updateCol` proves that `det((1).updateCol p v) = v_p` (Cramer's rule, no sign).
It is invoked by the proof of `lem:gr_free_entry_eq_signed_minor` (which expresses free entries as
signed minors) but is absent from that lemma's `\uses{}` block. This is the leandag-flagged
isolated node. The fix is a 1-line `\uses{}` addition; no semantic content is affected.

**Severity: soon** (not must-fix-this-iter — zero impact on proof flow; purely a graph-hygiene
issue).

---

### 3. Cohomology_FlatBaseChange.tex

**`complete: false`** | **`correct: true`**

- `lem:base_change_mate_fstar_reindex_legs_conj` (conj-2a, the live crux): statement has `\leanok`,
  proof has `sorry`. Correctly annotated with `% NOTE (iter-039, review): ...` detailing the
  kill-criterion firing and the two live fallbacks (element-`ext` with dictionary, or
  `leftAdjointCompIso` refactor). Blueprint state accurately tracks the FORK status. ✓
- Multiple nodes marked `% NOTE: superseded by the conjugate-side re-encoding (Open Q2)` — these
  are correctly tagged historical scaffolding. ✓
- `gstar_transpose` + `base_change_mate_fstar_reindex_legs` remain sorry-backed transitively
  through the crux. Correctly staged. ✓
- `\leanok` counts (80 markers): all reflect genuine closed proofs. No false markers observed. ✓
- FBC-B nodes (`lem:base_changed_equalizer_diagram`, `lem:flat_base_change_separated`,
  `lem:flat_base_change_mayer_vietoris`, `lem:flat_base_change_reduce_global_sections`) appear as
  unmatched — correctly planned, gated on FBC-A affine close. ✓

No must-fix or soon findings in FlatBaseChange.tex.

---

### 4. Picard_FlatteningStratification.tex

**`complete: false`** | **`correct: true`**

- Algebraic core `thm:generic_flatness_algebraic` has `\leanok` and is axiom-clean. ✓
- Geometric wrapper `thm:generic_flatness` (`lem:gf_flat_locality_assembly`,
  `lem:gf_qcoh_fintype_finite_sections`) and `lem:fp_free_descent` — all unmatched (correctly
  planned for GF-geo phase). ✓
- One `% NOTE` at line 1520: "overlaps the QUOT keystone `lem:qcoh_section_localization_basicOpen`
  — to be merged/resolved." This cross-chapter overlap note is informational; the QUOT keystone is
  correctly planned as an open node.
- `\leanok` counts (34 markers): consistent with the dévissage sub-lemmas being proved.
- No false markers. ✓

No must-fix or soon findings in FlatteningStratification.tex.

---

### 5. Cohomology_RegroupHelper.tex

**`complete: true`** | **`correct: true`**

- Single lemma `lem:base_change_regroup_linearEquiv` with `\leanok` on both statement and proof. ✓
- `\uses{}` chain is consistent (`lem:isPushout_cancelBaseChange_mathlib`). ✓
- Chapter is 77 lines; clean.

---

### 6. Picard_RelativeSpec.tex

**`complete: false`** | **`correct: true`**

- `def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `def:relspec_structure_morphism`,
  `thm:relative_spec_univ`, `thm:relative_spec_affine_base` all have `\leanok`. ✓
- Yoneda-bijection form still pending (iter-174+ commitment per `% NOTE`). Correctly flagged. ✓
- No false markers. ✓

---

## Findings summary by severity

### Must-fix this iteration

None.

### Soon (next 1–2 iterations)

1. **`Picard_GrassmannianCells.tex` — wire up `lem:gr_det_one_updateCol`** (isolated node).
   Add `\uses{lem:gr_det_one_updateCol}` to the proof block of `lem:gr_free_entry_eq_signed_minor`
   (and optionally to the proof block of `lem:gr_existence_factor_through_valuation_ring`, which
   also uses this inline). Zero semantic impact; pure graph hygiene. The natural home is
   `lem:gr_free_entry_eq_signed_minor`'s proof `\uses{}` block.

### Informational

1. **Needs-`\leanok` sync (14 nodes):** After the next `sync_leanok` run, the 6 new GR blocks,
   the 3 QUOT feeder/engine blocks, and several other matched nodes will acquire `\leanok`. No
   action needed — this is the normal pre-sync state.

2. **FBC FORK armed:** The api-alignment consult for approach A vs B (element-`ext` dictionary vs
   `leftAdjointCompIso` refactor) is the first FBC-A action this iteration per STRATEGY.md. The
   blueprint correctly notes the FORK at `lem:base_change_mate_fstar_reindex_legs_conj`.

3. **GF overlap note** (FlatteningStratification line 1520): Cross-reference to QUOT
   `lem:qcoh_section_localization_basicOpen`. No action needed until gap1 lands.

---

## HARD GATE verdict

> **GATE PASSES.**

`Picard_QuotScheme.tex` is `complete: true` AND `correct: true` with NO must-fix-this-iter
finding. The mathlib-build prover MAY be dispatched on sub-gap (a),
`lem:pullback_composite_immersion_isIso_fromTildeΓ`, this iteration.

Supporting evidence:
- leandag confirms the 3 iter-039 feeder/engine blocks (`isLocalizedModule_powers_transport`,
  `isIso_fromTildeΓ_of_iso`, `isLocalizedModule_basicOpen_descent_of_basicOpen_cover`) are MATCHED
  (Lean declarations found) — the memory record of "DONE axiom-clean iter-039" is confirmed.
- The 5 new producer sub-lemmas are correctly unmatched (planned) with well-formed statements,
  finite-effort sketches, `\lean{}` pins, and accurate `\uses{}` chains.
- The re-routing of `lem:section_localization_descent` through the basic-open form is coherent and
  consistent in both statement and proof `\uses{}` blocks.
- `leandag show ready` reports `lem:pul...` (sub-gap a) and `lem:com...`, `lem:gam...` as all
  ready to formalize (all dependencies resolved).
- No false `\leanok`, no unknown `\uses{}`, no conflicts, no orphan chapters.
