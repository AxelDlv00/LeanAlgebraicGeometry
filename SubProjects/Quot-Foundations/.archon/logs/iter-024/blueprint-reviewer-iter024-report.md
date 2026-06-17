# Blueprint Review Report — iter-024

**Reviewer:** blueprint-reviewer subagent  
**Date:** 2026-06-07  
**Scope:** All six chapters under `blueprint/src/chapters/`  
**Focus Areas (HARD GATE):** `Cohomology_FlatBaseChange.tex` (inner_eCancel atom chain) and `Picard_FlatteningStratification.tex` (G1/G3 geometric bridges)

---

## Diagnostics Summary

| Tool | Status |
|------|--------|
| `archon blueprint-doctor` | **CLEAN** — 271 labels defined, 0 orphan chapters, 0 broken refs, 0 malformed refs, 0 axiom decls, 0 covers problems |
| `leandag` dag.json (current) | **STALE** — built before iter-024 blueprint updates; three `inner_eCancel` atom lemmas absent; two removed `\lean{}` pins still present. **Action: run `archon dag` to rebuild.** |
| Total nodes / edges | 233 / 462 |
| Proved (statement + proof `\leanok`) | 150 / 233 |
| Active sorry stubs | 11 nodes |
| `unmatched_lean` total | 48 (37 axiom stubs, 11 project-frontier) |
| Isolated nodes | 0 |
| Leaf nodes | 11 |

---

## HARD GATE Findings

### HG-1 — `Cohomology_FlatBaseChange.tex` (FBC-A atom chain) — **PASS**

The three `inner_eCancel` atom lemmas were added this iter. Audit findings:

**`lem:base_change_mate_inner_eCancel_eUnit` (A-2a)**
- `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_eUnit}` — well-formed target
- `\uses{lem:pullback_isEquivalence_of_iso}` — correct single dependency
- Proof sketch: unit of adjunction whose left adjoint is an equivalence is an iso. Sound and independently formalizable.
- NO `\leanok` — correct (Lean decl not yet written)
- NOT yet in dag.json (stale DAG)

**`lem:base_change_mate_inner_eCancel_pushforwardComp` (A-2b)**
- `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_pushforwardComp}` — well-formed target
- `\uses{lem:gammaMap_pushforwardComp_hom_eq_id}` — correct single dependency
- Proof sketch: pushforwardComp hom section value is identity via two functorial identity applications. Sound and independently formalizable.
- NO `\leanok` — correct
- NOT yet in dag.json (stale DAG)

**`lem:base_change_mate_inner_eCancel_pullbackComp` (A-2c)**
- `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_pullbackComp}` — well-formed target
- `\uses{lem:base_change_mate_codomain_read, lem:pullback_fst_snd_specMap_tensor}` — correct dependencies (codomain read + leg factorization)
- Proof sketch: `hom_inv_id_app` for a natural iso. Single line in Lean. Sound and independently formalizable.
- NO `\leanok` — correct
- NOT yet in dag.json (stale DAG)

**`lem:base_change_mate_inner_eCancel` (A-2) Assembly**
- `\lean{}` pin correctly REMOVED this iter (per `% LEAN INTERNAL: ... dangling \lean pin REMOVED, iter-024 fbc-ecancel` annotation)
- `\uses{_eUnit, _pushforwardComp, _pullbackComp, lem:pullbackPushforward_unit_comp, lem:gammaMap_pushforwardComp_hom_eq_id, lem:base_change_mate_codomain_read}` — complete dependency list covering all three atoms plus the orchestrating unit-comp lemma
- NO `\leanok` — correct (narrative assembly node, obligation lives in the three atoms + `inner_value_eq` body)
- **DAG still shows stale lean_name `AlgebraicGeometry.base_change_mate_inner_eCancel`** — will resolve after `archon dag` rebuild

**`lem:base_change_mate_inner_value_eq` (A)**
- `\lean{AlgebraicGeometry.base_change_mate_inner_value_eq}` — matched in dag.json
- `proved: True, has_sorry: True` — scaffolded, sorry active
- `\leanok` on both statement and proof blocks — correct (the stub exists, sorry active awaiting atoms)
- `\uses{}` list covers the three atoms, the assembly, `pullbackPushforward_unit_comp`, all three seam-A dependencies, `inner_value` def — complete

**Verdict: HG-1 PASS.** All three atom lemmas have well-formed `\lean{}` targets, correct `\uses{}`, and sound independently-formalizable proof sketches. The assembly node correctly has no standalone Lean decl. `inner_value_eq` is correctly scaffolded. FBC-A prover lane can dispatch.

---

### HG-2 — `Picard_FlatteningStratification.tex` (G1/G3 bridges) — **CONDITIONAL PASS**

**`lem:gf_qcoh_fintype_finite_sections` (G1)**
- `\lean{AlgebraicGeometry.gf_qcoh_fintype_finite_sections}` — unmatched_lean frontier (correct: no Lean decl yet)
- `\uses{lem:qcoh_section_localization_basicOpen}` — correct; this is the `isLocalizedModule_basicOpen` frontier dependency
- Stacks Tag 01PB citation present: `\textit{Source: [Stacks Project], "Properties of Schemes", Tag 01PB.}`
- `% LEAN STATUS: G1 — project-built (mathlib-build target this iter)` — honest labeling
- NO `\leanok` — correct
- NOT a fill-sorry: the G1 block is a genuine project-built scaffold with the correct external dependency (`isLocalizedModule_basicOpen`) identified and labeled as a frontier node.

**`lem:gf_flat_locality_assembly` (G3)**
- `\lean{AlgebraicGeometry.gf_flat_locality_assembly}` — unmatched_lean frontier (correct)
- `\uses{lem:gf_qcoh_fintype_finite_sections}` — correct; downstream of G1
- `% LEAN STATUS: G3 — project-built; ... Stub-level this iter; built after G1.` — honest
- NO `\leanok` — correct

**`lem:qcoh_section_localization_basicOpen`** (shared dependency)
- `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}` — unmatched_lean
- `proved: False, has_sorry: False` — confirmed: NO Lean decl exists (neither sorry stub nor proof)
- `\uses{lem:isLocalization_basicOpen_mathlib}` — correct single Mathlib dependency
- This is the ready-to-prove frontier node blocking G1. Its absence is EXPECTED and KNOWN per the directive.

**`thm:generic_flatness`**
- `proved: False, has_sorry: True` — scaffolded sorry stub
- `\uses{thm:generic_flatness_algebraic}` — uses the algebraic core which is axiom-clean
- NO `\leanok` — correct for sorry stub

**GF sync_leanok status**: All 43 chapter nodes show `proved: False` — this is the known flaky GF-chapter `\leanok` resolution issue (recurring tooling issue, not a blueprint defect per the directive). The algebraic core Lean proofs exist in `FlatteningStratification.lean` but markers have not been applied.

**Verdict: HG-2 CONDITIONAL PASS.** G1 is honest: project-built frontier with Stacks 01PB citation, `\uses{lem:qcoh_section_localization_basicOpen}` correct, no fill-sorry. `isLocalizedModule_basicOpen` confirmed as frontier (no Lean decl). GF-geo prover lane can dispatch with G1 declared as a blocked stub pending `isLocalizedModule_basicOpen`. G3 is correctly gated on G1.

---

## Per-Chapter Checklists

### Chapter 1: `Cohomology_RegroupHelper.tex`

| Item | Status |
|------|--------|
| Node count | 1 |
| Proved | 1/1 |
| Sorry | 0 |
| Unmatched lean | 0 |
| Blueprint-doctor | CLEAN |

**Checklist:**
- [x] `lem:base_change_regroup_linearEquiv` — `\leanok` on both statement and proof, `\lean{AlgebraicGeometry.base_change_regroup_linearEquiv}`, `\uses{lem:isPushout_cancelBaseChange_mathlib}`. Fully closed, no sorry.
- [x] Cross-chapter `\uses{}` reference to `lem:isPushout_cancelBaseChange_mathlib` (defined in FBC chapter) resolves correctly.
- [x] Stacks source attribution present.

**Status: COMPLETE — no action needed.**

---

### Chapter 2: `Cohomology_FlatBaseChange.tex`

| Item | Status |
|------|--------|
| Node count | 51 |
| Proved | 42/51 |
| Sorry stubs | 6 |
| Unmatched lean (total) | 9 |
| Unmatched lean (axioms) | 7 |
| Unmatched lean (frontier) | 2 (stale DAG; see below) |
| Blueprint-doctor | CLEAN |

**Proved nodes (sample):** `lem:pullback_fst_snd_specMap_tensor`, `lem:base_change_mate_domain_read`, `lem:base_change_mate_codomain_read`, `lem:pullback_isEquivalence_of_iso`, `lem:base_change_mate_regroupEquiv`, `lem:base_change_mate_unit_value`, `def:base_change_mate_inner_value`, `lem:pullbackPushforward_unit_comp`, `lem:gammaMap_pushforwardComp_hom_eq_id`, `lem:gammaMap_pushforwardComp_inv_eq_id`, `lem:gammaMap_pushforwardCongr_hom`, five superseded dead-code lemmas, `lem:base_change_mate_inner_value_eq`, `lem:base_change_mate_gstar_generator_close`, `lem:base_change_mate_gstar_counit_transport`, `lem:base_change_mate_gstar_transpose`, `lem:base_change_mate_section_identity`, `lem:base_change_mate_generator_trace`, `lem:pushforward_base_change_mate_cancelBaseChange`, `lem:affine_base_change_pushforward`, `thm:flat_base_change_pushforward`.

**Sorry stubs (all legitimate scaffolds):**
1. `lem:base_change_mate_fstar_reindex_legs` — Seam C dead-code skeleton retained, sorry active
2. `lem:base_change_mate_inner_value_eq` — Seam A active proof, awaiting three atom lemmas
3. `lem:base_change_mate_gstar_generator_close` — Seam B scaffold
4. `lem:base_change_mate_gstar_transpose` — leaf node sorry
5. `lem:affine_base_change_pushforward` — affine main lemma scaffold
6. `thm:flat_base_change_pushforward` — theorem scaffold

**Frontier unmatched (stale DAG artifacts — will resolve after `archon dag` rebuild):**
- `lem:base_change_mate_inner_unitReduce` — `\lean{}` pin removed this iter; old lean_name still in dag.json
- `lem:base_change_mate_inner_eCancel` — `\lean{}` pin removed this iter; old lean_name still in dag.json

**Missing from DAG (iter-024 additions):**
- `lem:base_change_mate_inner_eCancel_eUnit` — added this iter, not in dag.json
- `lem:base_change_mate_inner_eCancel_pushforwardComp` — added this iter, not in dag.json
- `lem:base_change_mate_inner_eCancel_pullbackComp` — added this iter, not in dag.json

**`uses{}` correctness:**
- All `\uses{}` chains verified: mathlibok stubs (`pullbackSpecIso_mathlib`, `cancelBaseChange_mathlib`, `isPushout_cancelBaseChange_mathlib`, `unit_conjugateEquiv_mathlib`, `comp_unit_app_mathlib`, `conjugateEquiv_pullbackComp_inv_mathlib`) correctly referenced.
- `inner_value_eq` uses all three atom labels plus the full dependency set.
- No `unknown_uses` (no reference to undefined label IDs).

**Status: FBC-A prover lane READY TO DISPATCH (three atom lemmas are the target).**

---

### Chapter 3: `Picard_FlatteningStratification.tex`

| Item | Status |
|------|--------|
| Node count | 43 |
| Proved | 0/43 (known flaky sync_leanok — see Known Issues) |
| Sorry stubs | 1 (`thm:generic_flatness`) |
| Unmatched lean (total) | 9 |
| Unmatched lean (axioms) | 7 |
| Unmatched lean (frontier) | 2 (G1 + G3) |
| Blueprint-doctor | CLEAN |

**Key proved nodes (algebraic core — `\leanok` missing due to flaky sync, proofs exist in Lean):**
The L5 chain (Nagata / torsion / polynomial quotient / tower descent / polynomial core), GF generic rank SES, and the algebraic `thm:generic_flatness_algebraic` are reported as axiom-clean in the Lean file.

**Sorry stubs:**
- `thm:generic_flatness` — geometric wrapper with sorry; uses `thm:generic_flatness_algebraic` (algebraic core, closed).

**Frontier (project-built, no Lean decl yet):**
- G1: `lem:gf_qcoh_fintype_finite_sections` → `AlgebraicGeometry.gf_qcoh_fintype_finite_sections` (Stacks 01PB, blocked on `isLocalizedModule_basicOpen`)
- G3: `lem:gf_flat_locality_assembly` → `AlgebraicGeometry.gf_flat_locality_assembly` (blocked on G1)

**Mathlib axiom stubs (expected unmatched):** `lem:fp_free_descent`, `lem:noeth_prime_filtration`, `lem:noether_normalization_fg`, `lem:annihilator_meets_nonZeroDivisors`, `lem:polynomial_monic_quotient_finite`, `lem:isLocalization_away_mul_of_associated`, `lem:module_free_of_ringEquiv`.

**`uses{}` correctness:**
- G1 `\uses{lem:qcoh_section_localization_basicOpen}` — correct (QuotScheme chapter node)
- G3 `\uses{lem:gf_qcoh_fintype_finite_sections}` — correct
- `thm:generic_flatness` `\uses{thm:generic_flatness_algebraic}` — correct
- No `unknown_uses`.

**Status: GF-geo prover lane READY TO DISPATCH (G1 gated on `isLocalizedModule_basicOpen` frontier).**

---

### Chapter 4: `Picard_GrassmannianCells.tex`

| Item | Status |
|------|--------|
| Node count | 41 |
| Proved | 34/41 |
| Sorry stubs | 0 |
| Unmatched lean (total) | 7 |
| Unmatched lean (axioms) | 4 |
| Unmatched lean (frontier) | 3 |
| Blueprint-doctor | CLEAN |

**Proved nodes (affine chart building blocks — all in `GrassmannianCells.lean`):**
`def:gr_affine_chart`, `def:gr_transition`, `def:gr_cocycle`, `def:cocycleΘIJ`, `def:cocycleΘJK`, `def:cocycleΘIK`, `lem:gr_cocycle` (`cocycleCondition`), `lem:gr_imageMatrix_submatrix_I`, and related algebraic cell lemmas. The cocycle condition (leaf node) is proved. 34 of 41 nodes fully proved with no sorry.

**Frontier (project-built, no Lean decl yet):**
- `def:gr_glued_scheme` → `AlgebraicGeometry.Grassmannian.scheme` — the glued scheme (Nitsure §1, finite-type gluing via cocycle datum)
- `lem:gr_separated` → `AlgebraicGeometry.Grassmannian.isSeparated` — separatedness via diagonal-subscheme criterion
- `lem:gr_proper` → `AlgebraicGeometry.Grassmannian.isProper` — properness via DVR valuative criterion

All three frontier nodes have well-formed `\lean{}` targets, correct `\uses{}`, and detailed proof sketches with Nitsure §1 source citations. NO `\leanok` on any of the three — correct, the Lean decls do not exist yet. The blueprint-doctor does NOT flag any of these as broken refs.

**Mathlib axiom stubs (expected unmatched):** `lem:isProper_mathlib`, `lem:mathlib_away_algebraMap_isUnit`, `lem:mathlib_nonsing_inv_mul`, `lem:mathlib_mul_nonsing_inv`.

**`uses{}` correctness:**
- `def:gr_glued_scheme` `\uses{def:gr_affine_chart, def:gr_transition, lem:gr_cocycle}` — all proved upstream
- `lem:gr_separated` `\uses{def:gr_glued_scheme, def:gr_transition}` — correct
- `lem:gr_proper` `\uses{def:gr_glued_scheme, lem:gr_separated}` — correct
- No `unknown_uses`.

**Status: Grassmannian gluing/properness lane is the natural NEXT target after the affine chart building blocks. Requires `Grassmannian.scheme` (scheme-theoretic gluing API) to be formalized first.**

---

### Chapter 5: `Picard_QuotScheme.tex`

| Item | Status |
|------|--------|
| Node count | 92 |
| Proved | 68/92 |
| Sorry stubs | 4 |
| Unmatched lean (total) | 23 |
| Unmatched lean (axioms) | 19 |
| Unmatched lean (frontier) | 4 |
| Blueprint-doctor | CLEAN |

**Sorry stubs (legitimate QUOT-defs scaffolds):**
1. `def:hilbert_polynomial` — Hilbert polynomial definition stub
2. `def:quot_functor` — Quot functor definition stub (`AlgebraicGeometry.Scheme.QuotFunctor`)
3. `def:grassmannian_scheme` — Grassmannian as a scheme stub
4. `thm:grassmannian_representable` — representability theorem stub (weakened existence skeleton in Lean)

**Frontier (project-built, no Lean decl yet):**
- `def:sectionGradedModule` → `AlgebraicGeometry.sectionGradedModule`
- `lem:sectionGradedModule_fg` → `AlgebraicGeometry.sectionGradedModule_fg`
- `thm:hilbertPoly_of_sectionModule` → `AlgebraicGeometry.Scheme.hilbertPolynomialOfSectionModule`
- `lem:qcoh_section_localization_basicOpen` → `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen` — **load-bearing frontier node** blocking both G1 (GF lane) and `def:modules_annihilator` (QUOT lane)

**`def:modules_annihilator`**: `\leanok` but NOTE annotation present: only inclusion direction (`⊆`) is closed; reverse direction (`⊇`) is gated on `isLocalizedModule_basicOpen`. This is an honest partial formalization.

**Proved sections (sample — graded Hilbert machinery complete):**
- `lem:graded_homogeneousSubmodule_iSupIndep`, `lem:graded_homogeneousSubmodule_iSup_eq`
- `def:graded_subquotientHilb`, `def:graded_raisesDegree` and all ambient calculus lemmas
- `def:graded_subquotientDatum_ker`, `def:graded_subquotientDatum_coker`
- `lem:graded_subquotient_degreewise_diff` (Tag 00K1)
- `lem:graded_subquotient_finite_transfer`, `lem:graded_subquotient_isRatHilb`
- All SNAP-S2 graded subquotient / rationality nodes

**`uses{}` correctness:**
- All cross-chapter `\uses{}` references resolve (RegroupHelper, FBC mathlibok stubs).
- No `unknown_uses`.
- `lem:qcoh_section_localization_basicOpen` `\uses{lem:isLocalization_basicOpen_mathlib}` — correct.

**Status: QUOT-defs chapter is in ACTIVE development. Graded Hilbert machinery (SNAP-S2) is complete. SNAP-S1, hilbert polynomial, Quot functor, and Grassmannian repr are the live frontier.**

---

### Chapter 6: `Picard_RelativeSpec.tex`

| Item | Status |
|------|--------|
| Node count | 5 |
| Proved | 5/5 |
| Sorry stubs | 0 |
| Unmatched lean | 0 |
| Blueprint-doctor | CLEAN |

All 5 nodes have `\leanok` on both statement and proof, with NOTE annotations recording the weaker-than-blueprint Lean encoding (Yoneda form deferred to iter-180+). No action needed.

**Status: COMPLETE.**

---

## Dependency / Isolation Findings

**No isolated nodes** (0 nodes with dep_count=0 AND rdep_count=0).

**Leaf nodes (11 total):**
| Leaf | Chapter | Status |
|------|---------|--------|
| `lem:base_change_mate_fstar_reindex` | FBC | sorry, superseded dead code |
| `lem:base_change_mate_gstar_transpose` | FBC | sorry scaffold |
| `thm:flat_base_change_pushforward` | FBC | sorry scaffold, main theorem |
| `lem:gf_flat_finite` | GF | no sorry (Mathlib-backed?) |
| `lem:gf_free_moduleFinite` | GF | no sorry |
| `lem:gf_flat_locality_assembly` | GF | no sorry, G3 frontier |
| `thm:generic_flatness` | GF | sorry scaffold |
| `lem:graded_polyModule_isScalarTower` | QUOT | no sorry |
| `lem:graded_polySubmodule_coe` | QUOT | no sorry |
| `thm:grassmannian_representable` | QUOT | sorry scaffold |
| `lem:gr_imageMatrix_submatrix_I` | GrCells | proved, no sorry |

The leaf structure is consistent with the project's phase topology: main theorems are leaves fed by multi-level dependency chains.

**Cross-chapter dependency integrity:**
- RegroupHelper → FBC (correct cross-chapter `\uses{}`)
- GF G1 → QuotScheme (`isLocalizedModule_basicOpen`) — correct
- All `unknown_uses` count: **0** (no dangling label references)

---

## Unstarted Phase Proposals

### UP-1: DAG Rebuild (IMMEDIATE — infra)
**Trigger:** `archon dag`  
**Why:** The dag.json is stale w.r.t. iter-024 blueprint updates. Three new atom lemma nodes (`_eUnit`, `_pushforwardComp`, `_pullbackComp`) are absent. Two removed `\lean{}` pins (`inner_unitReduce`, `inner_eCancel`) still appear as frontier nodes. After rebuild, unmatched_lean frontier count should drop by 2 (removed pins) and rise by 3 (new atoms), net +1.

### UP-2: `isLocalizedModule_basicOpen` formalization (NEXT — load-bearing frontier)
**Target:** `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen`  
**Why:** Unblocks both G1 (`lem:gf_qcoh_fintype_finite_sections`) and the reverse direction of `def:modules_annihilator`. It is a ready-to-prove node with a single Mathlib dependency (`lem:isLocalization_basicOpen_mathlib`). The proof is: for a quasi-coherent module F on a scheme X and an affine open U = Spec A, the sections F(D(f)) are localized at f over F(U).

### UP-3: `Grassmannian.scheme` gluing + separatedness + properness (NEXT — GrCells lane)
**Targets:** `Grassmannian.scheme`, `Grassmannian.isSeparated`, `Grassmannian.isProper`  
**Why:** The cocycle condition is proved; the gluing datum is complete. The three frontier nodes have detailed blueprint proof sketches. This is a self-contained lane (no dependency on `isLocalizedModule_basicOpen`).

### UP-4: `sync_leanok` re-run for GF chapter (INFRA — known flaky issue)
**Why:** GF chapter shows `proved: 0` for all 43 nodes despite algebraic core being closed. A fresh sync_leanok run should recover the `\leanok` markers for the algebraic core nodes. The GF lane dispatch report should note this separately from genuine prover obligations.

### UP-5: Three `inner_eCancel` atom proofs (FBC-A dispatch — THIS ITER)
**Targets:** `base_change_mate_inner_eCancel_eUnit`, `..._pushforwardComp`, `..._pullbackComp`  
**Why:** These are the explicitly identified dispatch targets for this iter per the directive. Each is independently formalizable (5–30 LOC each). Once all three are closed, `base_change_mate_inner_value_eq` can be de-sorried.

---

## Severity Summary

| Severity | Finding | Chapter | Action |
|----------|---------|---------|--------|
| CRITICAL | DAG stale — 3 atom lemmas absent, 2 removed pins still present | FBC | Run `archon dag` immediately |
| WARNING | FlatteningStratification `proved: 0` despite algebraic core being closed | GF | Re-run `sync_leanok` for GF chapter |
| WARNING | `lem:base_change_mate_inner_eCancel` shows `unmatched_lean` for a since-removed `\lean{}` pin | FBC (stale DAG) | Resolves after `archon dag` rebuild |
| INFO | 11 project-frontier unmatched_lean nodes (all legitimate scaffold targets) | All | Expected; track in dag after rebuild |
| INFO | 11 sorry-bearing nodes (all legitimate scaffolds at active frontiers) | FBC, GF, QUOT | Expected; clear as provers dispatch |
| INFO | `def:modules_annihilator` partial (inclusion only, reverse direction gated) | QUOT | Noted in blueprint via % NOTE |
| INFO | GrCells `def:gr_glued_scheme` / `isSeparated` / `isProper` are unformalized frontier | GrCells | Ready for gluing lane dispatch |
| OK | blueprint-doctor: 0 broken refs, 0 malformed refs, 0 orphan chapters | All | No action |
| OK | 0 isolated nodes | All | No action |
| OK | RegroupHelper and RelativeSpec chapters fully closed | RegroupHelper, RelativeSpec | No action |

---

## Gate Verdicts

```yaml
hard_gate_fbc_a:
  complete: true
  correct: true
  verdict: PASS
  notes: >
    All three inner_eCancel atom lemmas well-formed. Assembly node correctly
    de-pinned. inner_value_eq correctly scaffolded. FBC-A prover lane can dispatch.

hard_gate_gf_geo:
  complete: true
  correct: true
  verdict: CONDITIONAL_PASS
  notes: >
    G1 honest frontier (Stacks 01PB, project-built, isLocalizedModule_basicOpen dependency
    correctly identified as a non-existent Lean decl). G3 correctly gated on G1.
    GF-geo prover lane can dispatch with G1 declared as blocked stub pending
    isLocalizedModule_basicOpen formalization (UP-2).
```
