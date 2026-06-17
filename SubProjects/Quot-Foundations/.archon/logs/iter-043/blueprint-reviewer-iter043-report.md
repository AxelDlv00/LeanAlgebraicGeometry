# Blueprint Review: iter043
**Iter:** 043
**Date:** 2026-06-09
**Reviewer:** blueprint-reviewer subagent
**Scope:** Whole-blueprint audit (all chapters); HARD GATE clearance for FBC-A1, gap2, GF-G1 prover lanes.

---

## Top-level summaries

### DAG statistics (leandag)
| Metric | Count |
|---|---|
| Total blueprint nodes | 426 |
| Proved (`proved=True`) | 340 |
| Mathlib-ok | 71 |
| Has sorry | **9** |
| Unmatched lean (Lean decls without blueprint blocks) | **4** |
| Isolated (no edges) | **6** (2 blueprint + 4 lean) |

### Sorry nodes (9)
Three categories:

**Active-dead conjugate route (2)** — not on critical path; inflate sorry count as dead-end dictionary nodes:
- `lem:base_change_mate_fstar_reindex_legs_conj`
- `lem:base_change_mate_gstar_transpose`

**Active prover targets (3)** — expected sorry stubs:
- `lem:affine_base_change_pushforward` (Lean: `affineBaseChange_pushforward_iso`) — statement `\leanok`, proof sorry'd; gated on `sections_direct`
- `thm:flat_base_change_pushforward` — FBC-B stub
- `thm:generic_flatness` — GF-geo stub

**QUOT/GR stubs (4)** — protected placeholder decls, expected:
- `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`, `thm:grassmannian_representable`

### Unmatched lean nodes (4) — coverage debt
All 4 exist in `AlgebraicJacobian/Picard/QuotScheme.lean` axiom-clean (proved=True) but have **no blueprint block**:
- `AlgebraicGeometry.Scheme.Modules.restrictₗ`
- `AlgebraicGeometry.Scheme.Modules.restrictBasicOpenₗ`
- `AlgebraicGeometry.Scheme.Modules.fromSpec_image_top_section_coherence`
- `AlgebraicGeometry.Scheme.Modules.section_localization_hfr_aux_general`

These are gap2 helpers. Must be blueprinted before gap2 prover dispatch (see HARD GATE §gap2).

### Blueprint rendering
`archon blueprint-doctor`: 0 malformed refs, 0 broken refs, 0 orphan chapters. Clean.

---

## Unstarted-phase proposals

### SNAP tensor-powers — proposed chapter `Picard_SectionGradedRing.tex`

**Status:** BLOCKED (STRATEGY). Zero blueprint coverage.

**STRATEGY says:** `def:sectionGradedRing` / `def:sectionGradedModule` owed regardless of Q1 route decision. `L_s^{⊗m}` tensor powers and lax-monoidal `Γ` are Mathlib-absent; sub-build needed before any SNAP/S1 prover.

**Proposed outline:**
```
\section{Section graded ring and module}
\label{sec:snap_section_graded}

def:sectionGradedRing
  Lean: AlgebraicGeometry.sectionGradedRing
  \uses{def:hilbert_polynomial}
  The graded ring ⊕_{m≥0} Γ(X_s, L_s^{⊗m}) at a point s ∈ S.
  Mathlib gap: SheafOfModules.tensorPow + lax-monoidal Γ on SheafOfModules.

def:sectionGradedModule
  Lean: AlgebraicGeometry.sectionGradedModule
  \uses{def:sectionGradedRing}
  The graded module ⊕_{m≥0} Γ(X_s, F_s ⊗ L_s^{⊗m}).
  Mathlib gap: same lax-monoidal gap + tensor-hom adjunction for SheafOfModules.

lem:sectionGradedModule_fg
  Lean: AlgebraicGeometry.sectionGradedModule_fg
  \uses{def:sectionGradedModule, lem:gf_qcoh_fintype_finite_sections}
  If F is coherent and L is ample, the graded module is finitely generated
  over the graded ring in large degree (Serre, Hartshorne II.5.17-form).
  Mathlib gap: ampleness + tensor iteration for SheafOfModules.
```

**Blocking open question (Q1):** The `m≫0`-agreement ("Hartshorne II.5.17" attribution unverified) must be resolved before S1. Propose dispatching reference-retriever on Q1 this iter or next before writing this chapter.

### GR-quot/repr — proposed chapter `Picard_GrassmannianRepr.tex`

**Status:** BLOCKED (STRATEGY). Only stubs (`def:grassmannian_scheme`, `thm:grassmannian_representable`) with sorry; no route scaffolded.

**STRATEGY says:** GR-cells/glue/sep/proper DONE. Remaining: GR-quot (tautological rank-d quotient + universal property), GR-repr (functor-of-points → `RepresentableBy` via `thm:relative_spec_univ`).

**Proposed outline:**
```
\section{Tautological quotient and representability}
\label{sec:gr_repr}

def:gr_tautological_quotient
  Lean: AlgebraicGeometry.Grassmannian.tautologicalQuotient
  \uses{def:grassmannian_scheme}
  The rank-d tautological quotient bundle Q on Gr(d,r): on each chart U_I,
  Q|_{U_I} = cokernel of the tautological inclusion i_I : O^d ↪ O^r.

def:gr_tautological_map
  Lean: AlgebraicGeometry.Grassmannian.tautologicalMap
  \uses{def:gr_tautological_quotient}
  The universal surjection φ : O_Gr^r ↠ Q (cocycle compatibility from
  lem:gr_cocycle).

lem:gr_universal_property
  Lean: AlgebraicGeometry.Grassmannian.universalProperty
  \uses{def:gr_tautological_map, def:quot_functor}
  For any scheme T, morphisms T → Gr(d,r) correspond naturally to rank-d
  locally-free quotients of O_T^r (natural bijection of sets).

thm:grassmannian_representable
  Lean: AlgebraicGeometry.Grassmannian.isRepresentable  [upgrade from sorry stub]
  \uses{lem:gr_universal_property, thm:relative_spec_univ}
  The Quot functor QuotFunctor(𝟙 S, V, Φ_d) is representable by
  Grassmannian(d,r) (IsRepresentable).
```

**Prereqs before writing:** Confirm `thm:relative_spec_univ` signature is sufficient for the functor-of-points recognition; confirm `def:quot_functor` stub encodes the correct rank-d quotient data.

---

## Per-chapter

### Cohomology_RegroupHelper.tex
- **Complete:** YES
- **Correct:** YES
- **Notes:** Single lemma `lem:base_change_regroup_linearEquiv`, proved, no sorry. No open items.

---

### Cohomology_FlatBaseChange.tex — HARD GATE: **CLEARED** for FBC-A1 prover

#### Tilde-transport pivot (iter-042 additions) — verified

Three new blocks authored this iter are present with correct `\uses{}` chains:

| Block | proved | has_sorry | Primary uses |
|---|---|---|---|
| `lem:pushforward_base_change_mate_sections_direct` | **False** | False | `base_change_mate_domain_read`, `base_change_mate_codomain_read`, `pullback_spec_tilde_iso`, `pushforward_spec_tilde_iso`, `cancelBaseChange_mathlib` |
| `lem:pushforward_base_change_mate_cancelBaseChange` | True | False | `lem:pushforward_base_change_mate_sections_direct` |
| `lem:affine_base_change_pushforward` (= `affineBaseChange_pushforward_iso`) | True (stmt) | **True** (proof) | `lem:pushforward_base_change_mate_cancelBaseChange` |

**`\uses{}` chain is CLEAN** — no residual dependence on `gstar_transpose` or any conjugate-route node in the critical path from `sections_direct` to `affineBaseChange_pushforward_iso`. The tilde-transport route is self-contained.

**FBC-A1 prover target:** `pushforward_base_change_mate_sections_direct`. Blueprint is complete and correct; the prover must close this one lemma, after which `cancelBaseChange` closes automatically (already proved) and `affineBaseChange_pushforward_iso` drops its sorry.

#### Old conjugate route nodes (dead-end dictionary)
- `lem:base_change_mate_fstar_reindex_legs_conj` and `lem:base_change_mate_gstar_transpose` remain in the chapter with NOTE comments marking them as dead-end records.
- These have `has_sorry=True` but are **not on any critical-path `\uses{}` chain** to the affine close or globalization.
- **Carry-forward finding (MAJOR):** These 2 dead sorry nodes inflate the project sorry count. Recommend leaving them as dictionary stubs (per armed protocol) but noting their existence so the sorry count does not mislead progress reporters. No prover action needed.

#### FBC-B globalization blocks
Present in blueprint: `lem:flat_base_change_separated`, `lem:flat_base_change_mayer_vietoris`, `lem:flat_base_change_reduce_global_sections`, `thm:flat_base_change_pushforward`. All unproved (`thm:flat_base_change_pushforward` has_sorry=True). Gated on FBC-A affine close. Blueprint correct.

FBC-B A-module eqLocus blocks (`def:fbcb_groundRing` through `lem:fbcb_baseChangeGammaEquiv`): all proved, clean.

#### Must-fix findings
None for this chapter. Blueprint is complete and correct for the PIVOT route.

---

### Picard_RelativeSpec.tex
- **Complete:** YES
- **Correct:** YES
- **Notes:** 4 main theorem blocks (`thm:relative_spec_exists`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base`, `def:relspec_structure_morphism`) all proved. `def:qc_sheaf_of_algebras` proved. 9 `\leanok` markers, rendering clean. No open items.

---

### Picard_FlatteningStratification.tex — HARD GATE: **CLEARED** for GF-G1 blueprint

#### G1 lemma — verified
`lem:gf_qcoh_fintype_finite_sections`:
- **proved=False, has_sorry=False** — blueprint block present, Lean not yet proved
- `\uses{lem:qcoh_section_localization_basicOpen}` — correct; this is the only genuine input (reduce affine to section-localization, then glue by finite-generation-local criterion; Stacks Tag 01PB)
- Proof sketch: complete, mathematically sound (identifies Γ(F,W) as N via quasi-coherence, invokes section-localization on basic opens, applies finite-generation gluing criterion)
- **Blueprint is complete and correct** for G1 dispatch. Prover is gated only on `lem:qcoh_section_localization_basicOpen` being available (a Lean dependency, not a blueprint defect).

#### G3 lemma
`lem:gf_flat_locality_assembly`: `\uses{lem:gf_qcoh_fintype_finite_sections}` — correct. Proof sketch present (per-patch freeness + flat-locality assembly). Not yet proved; expected at stub level this iter.

#### thm:generic_flatness
`has_sorry=True`, stub-level. Correct `\uses{thm:generic_flatness_algebraic, lem:gf_qcoh_fintype_finite_sections, lem:gf_flat_locality_assembly}`. Expected state.

#### Must-fix findings
None. Blueprint complete and correct for GF-G1 and GF-G3. Prover prereqs are gap2 (for G1) and G1 itself (for G3); both are Lean dependencies, not blueprint defects.

---

### Picard_GrassmannianCells.tex
- **Complete:** YES
- **Correct:** YES
- **Notes:** All main blocks proved: cells, cocycle, glue, `lem:gr_separated`, `lem:gr_proper`. One isolated node (see §Isolated). Rendering clean.

---

### Picard_QuotScheme.tex — HARD GATE: **NOT CLEARED** for gap2 prover

#### Gap2 block status
`lem:qcoh_section_localization_basicOpen` (Lean: `isLocalizedModule_basicOpen`):
- **proved=False, has_sorry=False** — primary gap2 target, not yet closed in Lean
- `\uses{lem:isLocalization_basicOpen_mathlib, lem:qcoh_affine_section_localization, lem:section_localization_descent, lem:exists_finite_basicOpen_cover_le_quasicoherentData, lem:eq_of_locally_eq_mathlib}` — correct

#### Must-fix defects (CRITICAL — block gap2 prover dispatch)

**Defect 1: Proof sketch is outdated at L2560**
Current text says:
> "sole genuinely new piece the prover must supply on top of G1-core"

This is wrong. `section_localization_hfr_aux_general` (the general-U transport) exists axiom-clean in Lean. The "sole new piece" framing no longer matches reality. Writer must update the proof sketch to describe the actual route: gap2 = G1-core (Spec R corollary of gap1) + affine-cover descent via `section_localization_hfr_aux_general`.

**Defect 2: `fromSpec_image_top_section_coherence` missing from proof sketch**
This crux lemma (`AlgebraicGeometry.Scheme.Modules.fromSpec_image_top_section_coherence`) exists proved in Lean but is not mentioned in the blueprint proof sketch at all. The proof sketch is therefore incomplete: the key section-coherence step is invisible to the blueprint reader.

**Defect 3: 4 helper decls lack blueprint blocks (coverage debt)**
All 4 exist axiom-clean in Lean (proved=True) but appear only as unmatched lean nodes with no `\label{}` or `\lean{}` entry:
- `restrictₗ` — restriction of a Modules sheaf to a smaller open
- `restrictBasicOpenₗ` — restriction to a basic open
- `fromSpec_image_top_section_coherence` — top-section coherence of `fromSpec`
- `section_localization_hfr_aux_general` — the general-U transport (key gap2 engine)

Each needs a `\begin{lemma}...\end{lemma}` block with `\lean{...}` and `\uses{...}` in QuotScheme.tex. Until these exist, the gap2 `\uses{}` chain is incomplete and the proof sketch cannot accurately describe the route.

**Defect 4: Piece A (QC-pullback along `fromSpec`) has no blueprint block**
The route for gap2 requires: Piece A (the pullback of a quasi-coherent sheaf M along `hU.fromSpec` is quasi-coherent — this is a Mathlib-absent step) + Piece B (affine-cover transport). Piece A currently has:
- No `\lean{}` entry
- No `\label{}` entry
- No `\uses{}` chain specified

This means the prover for Piece A cannot be dispatched (no HARD GATE passes without a complete blueprint block). Blueprint-writer must add a `\begin{lemma}...\end{lemma}` block for the QC-pullback-along-fromSpec claim with its `\uses{}` chain.

**Summary of required writer patches for gap2:**
1. Update proof sketch at L~2560 to reflect actual route
2. Add `fromSpec_image_top_section_coherence` to proof sketch narrative
3. Add 4 blueprint blocks: `restrictₗ`, `restrictBasicOpenₗ`, `fromSpec_image_top_section_coherence`, `section_localization_hfr_aux_general`
4. Add 1 blueprint block: Piece A (QC-pullback along `fromSpec`)

**After these patches:** gap2 `\uses{}` chain will be complete and correct, HARD GATE will clear, and both Piece A and Piece B provers can be dispatched.

#### G1-core, gap1, annihilator downstream
- Gap1 (`lem:qcoh_affine_section_localization`, i.e. `isLocalizedModule_basicOpen_of_isQuasicoherent`): blueprint present, correct; NOTE comment acknowledges Lean decl does not yet exist (derived as downstream corollary of gap1).
- P1 predicates (`def:schematic_support`, `def:has_proper_support`): proved.
- `lem:annihilator_localization_eq_map`: proved in Lean, isolated (see §Isolated).

#### Carry-forward finding (MAJOR)
`thm:grassmannian_representable` Lean weaker than blueprint prose (pre-existing). Blueprint says `RepresentableBy`; Lean has sorry stub. No blueprint defect, but Lean gap remains.

---

## Isolated node dispositions

### `lem:annihilator_localization_eq_map` — WIRE-UP
- **Status:** proved=True (Lean: `Module.annihilator_isLocalizedModule_eq_map`), no blueprint edges
- **Cause:** The geometric annihilator characterization block (downstream consumer) has not yet been blueprinted.
- **Action:** Blueprint-writer should add a `\begin{lemma}...\end{lemma}` block for the geometric statement "for a quasi-coherent M on X, the annihilator ideal sheaf satisfies `ann(M)(U) = Ann_{Γ(X,U)} Γ(M,U)` on affine opens" and include `\uses{lem:annihilator_localization_eq_map}` in that block.
- **Priority:** LOW (does not gate any current prover lane).

### `lem:gr_det_one_updateCol` — WIRE-UP
- **Status:** proved=True (Lean: `AlgebraicGeometry.Grassmannian.det_one_updateCol`), no blueprint edges
- **Cause:** This lemma appears in `lem:gr_free_entry_eq_signed_minor`'s **proof** `\uses{}` block, but NOT in its **statement** `\uses{}` block. leandag only tracks statement-level `\uses{}` for the DAG.
- **Action:** Move `lem:gr_det_one_updateCol` from `lem:gr_free_entry_eq_signed_minor`'s proof `\uses{}` to its statement `\uses{}` in `Picard_GrassmannianCells.tex`.
- **Priority:** LOW (leandag counts; no prover impact).

### 4 × lean-isolated nodes
The 4 unmatched lean nodes (`restrictₗ`, `restrictBasicOpenₗ`, `fromSpec_image_top_section_coherence`, `section_localization_hfr_aux_general`) are isolated because they lack blueprint blocks. Resolved by Defect 3 fix above.

---

## Severity summary

| Severity | Finding | Chapter | Blocks prover? |
|---|---|---|---|
| **CRITICAL** | gap2 proof sketch outdated (L~2560): "sole new piece" framing wrong | QuotScheme | YES — gap2 |
| **CRITICAL** | `fromSpec_image_top_section_coherence` absent from proof sketch | QuotScheme | YES — gap2 |
| **CRITICAL** | 4 helper decls lack blueprint blocks (`restrictₗ`, `restrictBasicOpenₗ`, `fromSpec_image_top_section_coherence`, `section_localization_hfr_aux_general`) | QuotScheme | YES — gap2 |
| **CRITICAL** | Piece A (QC-pullback along `fromSpec`) has no blueprint block | QuotScheme | YES — Piece A prover |
| **MAJOR** | 2 dead-end conjugate sorry nodes inflate sorry count (not critical-path) | FlatBaseChange | NO |
| **MAJOR** | `thm:grassmannian_representable` Lean stub weaker than blueprint prose (pre-existing carry-forward) | QuotScheme | NO (long-range) |
| **MINOR** | `lem:annihilator_localization_eq_map` isolated — needs downstream geometric block | QuotScheme | NO |
| **MINOR** | `lem:gr_det_one_updateCol` isolated — needs move to statement-level `\uses{}` | GrassmannianCells | NO |
| **DEBT** | SNAP tensor-powers: no blueprint chapter | — | YES (SNAP prover) |
| **DEBT** | GR-quot/repr: no blueprint chapter beyond stubs | — | YES (repr prover) |

---

## HARD GATE verdicts

| Prover lane | Blueprint | HARD GATE |
|---|---|---|
| **FBC-A1** (`pushforward_base_change_mate_sections_direct`) | Complete + correct | **CLEARED** |
| **Gap2** (`isLocalizedModule_basicOpen`) | INCOMPLETE (4 helper blocks + Piece A missing; sketch outdated) | **NOT CLEARED** — writer patch required |
| **GF-G1** (`gf_qcoh_fintype_finite_sections`) | Complete + correct | **CLEARED** (Lean prereq: gap2) |

## Recommended writer actions this iter (ordered by priority)

1. **[CRITICAL]** Patch `Picard_QuotScheme.tex` gap2 block:
   - Add `\begin{lemma}...\end{lemma}` blocks for `restrictₗ`, `restrictBasicOpenₗ`, `fromSpec_image_top_section_coherence`, `section_localization_hfr_aux_general` with correct `\lean{}` and `\uses{}`.
   - Add `\begin{lemma}...\end{lemma}` for Piece A (QC-pullback along `fromSpec`) with Mathlib-absent flag.
   - Update proof sketch at L~2560: remove "sole new piece" framing, describe actual route through `section_localization_hfr_aux_general`.
   - Mention `fromSpec_image_top_section_coherence` in proof sketch.
2. **[MINOR]** Move `lem:gr_det_one_updateCol` from `lem:gr_free_entry_eq_signed_minor` proof `\uses{}` to statement `\uses{}` in `Picard_GrassmannianCells.tex`.
3. **[DEBT, resolve before Q1]** Decide SNAP route (Q1 open question) and draft `Picard_SectionGradedRing.tex` outline per §Unstarted-phase proposals.
