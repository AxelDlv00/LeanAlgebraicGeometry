# Blueprint Review — iter-060
**Date:** 2026-06-10  
**Reviewer:** blueprint-reviewer subagent  
**Directive:** `.archon/logs/iter-060/blueprint-reviewer-iter060-directive.md`

---

## DAG Snapshot (leandag build)

| Metric | Value |
|---|---|
| blueprint_nodes | 562 |
| proved (`\leanok`) | 432 (76.9%) |
| mathlib_ok | 102 |
| with_sorry (own source has sorry) | 13 |
| unmatched_lean | 121 |
| isolated (non-aux) | 5 |
| gaps (no `\lean{}` pin) | 1 |
| edges | 1225 |

---

## Focus Area 1 — GF Closure Verification (`Picard_FlatteningStratification.tex`)

**VERDICT: COMPLETE and CORRECT. GF is fully closed axiom-clean.**

**Evidence from full chapter read (lines 938–2672):**

- `thm:generic_flatness` (`AlgebraicGeometry.genericFlatness`) at line 2578:
  - Statement has `\leanok` (line 2575)
  - Proof has `\leanok` (line 2614)
  - Proof `\uses{}` block at lines 2606–2613 explicitly includes **both** new helpers:
    `lem:flat_localization_models` and `lem:isLocalizedModule_powers_restrictScalars`

- `lem:flat_localization_models` (`AlgebraicGeometry.flat_localization_models`) at line 2122:
  - `\leanok` on statement AND proof — confirmed present

- `lem:isLocalizedModule_powers_restrictScalars` (`AlgebraicGeometry.isLocalizedModule_powers_restrictScalars`) at line 2149:
  - `\leanok` on statement AND proof — confirmed present

- Grep for `G3.*gate`, `sorry`, `TODO`, `FIXME` in the chapter: **zero results**. No stale "G3 gate open" claim anywhere in the file.

**DAG anomaly (low priority):**  
`lem:isLocalizedModule_powers_restrictScalars` shows `rdep_count=0` and `lem:flat_localization_models` shows `rdep_count=0` in the DAG, despite both appearing in `thm:generic_flatness`'s proof-level `\uses{}`. This is a leandag edge-tracking gap for proof-level `\uses{}` blocks — the blueprint is correct. No corrective action needed beyond noting the discrepancy.

**Must-fix this iter:** None for FlatteningStratification.

---

## Focus Area 2 — SNAP Readiness (`Picard_SectionGradedRing.tex`)

### HARD GATE VERDICT

| Criterion | Status |
|---|---|
| `def:relTensorProj` blueprint proved | ✓ (`\leanok` on statement) |
| `def:relTensorProj` Lean sorry | ✗ (has_sorry=True — naturality proof) |
| `def:relTensorActL`, `def:relTensorActR` | ✓ proved and sorry-free |
| `lem:snap_ztensor_whisker_localIso` proved | ✗ (proved=False, lean=None) |
| `lem:snap_ztensor_whisker_localIso` `\lean{}` pin | ✗ **MISSING** (only GAPS node in whole project) |
| Chapter complete | ✗ |

**Complete: NO. Correct (for proved nodes): YES.**

### Live sorry: `relTensorProj.naturality`

The naturality proof is ready to dispatch. The sketch in the chapter is mathematically sufficient:
> "Both composites of the naturality square send `m ⊗ n` to `(m|_V) ⊗_{𝒪(V)} (n|_V)`, checked by ⊗-induction."

This is a concrete tensor-product calculation that reduces to two applications of the `TensorProduct.induction_on` principle over the restriction maps. The `def:relTensorDomainPresheaf` prerequisite is proved and sorry-free (proved=True, has_sorry=False). The induction skeleton is clear.

**Dispatch verdict:** READY for a naturality prover — but **must add `\lean{}` pin for `lem:snap_ztensor_whisker_localIso` first** (currently the only GAPS node). Without the pin, leandag cannot track that node's proof status.

### Must-fix this iter:
1. **Add `\lean{}` pin to `lem:snap_ztensor_whisker_localIso`** — this is the only node in the entire project missing a Lean name. Until pinned, a prover can't target it and leandag can't credit it.

---

## Focus Area 3 — GR C2 Readiness (`Picard_GrassmannianQuot.tex`)

### HARD GATE VERDICT

| Criterion | Status |
|---|---|
| C1 `lem:gr_bundleCocycle_id` | ✓ proved (`\leanok`, sorry-free) |
| C2 `lem:gr_bundleCocycle_mul` | ✗ proved=False, has_sorry=True |
| `def:gr_modules_glueRestrictionIso` | ✗ unmatched_lean (forward declaration) |
| `lem:gr_modules_glue_unique` | ✗ unmatched_lean (forward declaration) |
| `def:gr_modules_glueHom` | ✗ unmatched_lean (forward declaration) |
| Infrastructure (pullbackFreeIso, chartQuotientMap, etc.) | ✓ all proved |
| `def:scheme_modules_glue` | ✓ proved (`\leanok`) |
| Chapter complete | ✗ |

**Complete: NO. Correct (for proved nodes): YES.**

### C2 proof sketch assessment

The blueprint proof sketch for `lem:gr_bundleCocycle_mul` reads:
> "Matrix identity `(X^J_K)^{-1}(X^I_J)^{-1} = (X^I_K)^{-1}` on `V_{IJK}`, from minor multiplicativity. Upgrade via `pullbackBaseChangeTransport + glueData_bridges + biproduct assembly`. Substantive difficulty: endpoint bookkeeping."

**Assessment: sketch provides the mathematical core but remains under-specified for Lean formalization.**

The sketch omits the specific Lean-level linkage that was flagged in iter-059: `matrixEnd_comp` and `matrixToFreeIso` are the two lean_aux axioms in the DAG (`lean:AlgebraicGeometry.Grassmannian.matrixEnd_comp`, `lean:AlgebraicGeometry.Grassmannian.matrixToFreeIso`) that bridge the matrix computation to the module-endomorphism category. The phrase "endpoint bookkeeping" is code for this gap. Without naming these two declarations explicitly in the proof sketch, a prover assigned C2 is likely to lose several iterations rediscovering the correct chain.

**Dispatch verdict: C2 is DISPATACHABLE but benefits from an effort-break that adds:**
1. Explicit `matrixEnd_comp` step (how the triple matrix product factors in `matrixEnd` notation)
2. Explicit `matrixToFreeIso` identification (how `matrixEnd_comp` translates to module-pullback composition)
3. The `lem:gr_glueData_bridges` application as a named intermediate (already in `\uses{}`)

Without the effort-break, a prover can still proceed given the available Lean infrastructure, but should be instructed to use `lean:AlgebraicGeometry.Grassmannian.matrixEnd_comp` and `lean:AlgebraicGeometry.Grassmannian.matrixToFreeIso` as the core assembly steps.

**Downstream impact of C2:** Three GR sorry nodes unblock:
- `def:gr_universal_quotient_sheaf` (universalQuotient)
- `def:tautological_quotient`
- `thm:grassmannian_universal_property` (Grassmannian.represents)

And transitively: `thm:grassmannian_representable` in QuotScheme.

### Must-fix this iter:
1. Add `matrixEnd_comp`/`matrixToFreeIso` linkage to C2 proof sketch (effort-break).
2. The 3 unmatched forward declarations will close once C2 is proved.

---

## Coverage Debt

### Unmatched lean (121 nodes)

The 121 unmatched_lean entries break down into three categories:

**Category A — Mathlib anchors (~97 nodes):** Legitimate. These are nodes marked `\mathlibok` whose Lean names exist in Mathlib but leandag cannot resolve them from the local source scan. Examples: `Module.Flat.of_free`, `IsLocalization.flat`, `Module.free_of_isLocalizedModule`, etc. No action needed.

**Category B — Forward declarations (3 nodes, GR-quot open sorries):**
- `def:gr_modules_glueRestrictionIso` → `AlgebraicGeometry.Scheme.Modules.glueRestrictionIso`
- `lem:gr_modules_glue_unique` → `AlgebraicGeometry.Scheme.Modules.glue_unique`
- `def:gr_modules_glueHom` → `AlgebraicGeometry.Scheme.Modules.glueHom`

These will be resolved when C2 (`lem:gr_bundleCocycle_mul`) is proved.

**Category C — Project decls that exist with sorry or are not yet formalized (~21 nodes):**
Key entries:
- `def:sectionGradedRing` / `def:sectionGradedModule` — blocked on SNAP tensor infrastructure
- `thm:hilbertPoly_of_sectionModule` — blocked on sectionGradedRing
- FBC conjugate-calculus Mathlib anchors (unit_conjugateEquiv, conjugateIsoEquiv, etc.) — these are Mathlib decls not yet indexed
- `lem:pushforward_base_change_mate_sections_direct` — explicitly abandoned route (NOTE at FBC chapter line 3330-3335: "treat as abandoned route record, do NOT dispatch a prover at it")

### Gaps node (1 node)

**`lem:snap_ztensor_whisker_localIso`** — proved=False, lean=None.  
Uses: `lem:localIso_toPresheaf_map_unit`, `def:relTensorDomainPresheaf`.  
This is the only node in the entire blueprint missing a `\lean{}` pin. **Must be pinned before SNAP can be closed.**

### Isolated nodes (5 non-aux)

| Node | Status | Note |
|---|---|---|
| `lem:mathlib_flat_localization_preserves` | proved=False | Mathlib anchor, isolated because its only user is a Lean-source dep not tracked by leandag edges |
| `lem:mathlib_flat_of_localized_maximal` | proved=False | Same |
| `lem:mathlib_free_of_isLocalizedModule` | proved=False | Same |
| `lem:isLocalizedModule_powers_restrictScalars` | proved=True | DAG edge omission — it IS used by `thm:generic_flatness` proof but proof-level `\uses{}` not tracked |
| `lem:gr_homEquiv_conjugateEquiv_app` | proved=True | GR-quot proved helper. Used by `def:grassmannian_functor` per blueprint `\uses{}` but DAG edge missing |

The 3 Mathlib isolated anchors are artifacts of leandag not tracking Lean-internal Mathlib imports. The 2 proved isolated nodes (new GF helper and GR-quot helper) have a correct blueprint — the isolation is a DAG synchronization issue, not a blueprint problem.

---

## FBC-A2 Readiness

**Verdict: NO keystone-independent route exists.**

The blueprint confirms this at lines 3330–3335:
> "NOTE (review iter-044): the 'direct' bypass claimed above is ILLUSORY. iter-043 verified that the concrete affine square's inner unit is the `g'=pullback.fst` unit (no element normal form), so Γ(alpha) must transit the same tilde dictionaries as the conjugate intertwining — this lemma collapses onto the SAME open keystone `lem:base_change_mate_fstar_reindex_legs_conj`. [...] do NOT dispatch a prover at it."

**Current FBC sorry chain:**

| Node | has_sorry | Lean decl | Rdeps |
|---|---|---|---|
| `lem:base_change_mate_fstar_reindex_legs_conj` (conj-2a keystone) | ✓ | `base_change_mate_fstar_reindex_legs_conj` | 1 (`_reindex_legs`) |
| `lem:base_change_mate_gstar_transpose` | ✓ | `base_change_mate_gstar_transpose` | 0 (DAG-isolated) |
| `lem:affine_base_change_pushforward` | ✓ | `affineBaseChange_pushforward_iso` | 1 (`thm:flat_base_change`) |
| `thm:flat_base_change_pushforward` | ✓ | `flatBaseChange_pushforward_isIso` | depends on affine |

The conj-2a keystone feeds into `_reindex_legs` → `_reindex` → `_inner_value_eq` (all proved, sorry-free downstream of conj-2a in the current DAG). The gstar_transpose sorry (FBC-B) has rdep=0 — it's not yet wired into a live dependency chain, which means FBC-B is parked pending FBC-A2.

The affine_base_change sorry chain (Cluster C) is independent of conj-2a. Its prerequisites are all sorry-free (`lem:pushforward_base_change_mate_cancelBaseChange` is proved=True, has_sorry=False). The affine base change sorry is self-contained — the Lean proof body needs to be written (the strategy is fully specified in the blueprint NOTE at lines 3650–3656).

**FBC-A2 action required:** Dispatch a prover on `lem:base_change_mate_fstar_reindex_legs_conj` using the peel-one-layer-at-a-time conjugate route (blueprint lines 2295–2312). All supporting legs (conj-2b/2c/2d) are proved and sorry-free.

---

## Per-Chapter Checklist

### `Cohomology_RegroupHelper.tex`
- **Complete:** ✓ | **Correct:** ✓ | **Must-fix:** None
- Single lemma `lem:base_change_regroup_linearEquiv` with `\leanok` on statement and proof. Perfect chapter.

### `Cohomology_FlatBaseChange.tex`
- **Complete:** ✗ (4 sorry nodes) | **Correct (for proved):** ✓ | **Must-fix:** See FBC-A2 above
- 4 sorry nodes: conj-2a keystone, gstar_transpose, affine_base_change, flat_base_change
- `lem:pushforward_base_change_mate_sections_direct`: marked abandoned route, no `\leanok`, no Lean decl — leave as is (blueprint NOTE correctly flags it)
- `lem:base_change_mate_gstar_transpose`: DAG-isolated sorry (rdep=0); this is FBC-B parked

### `Picard_FlatteningStratification.tex`
- **Complete:** ✓ | **Correct:** ✓ | **Must-fix:** None
- GF fully closed axiom-clean (iter-059 confirmed). Both new helpers present with `\leanok`.

### `Picard_RelativeSpec.tex`
- **Complete:** ✓ | **Correct:** ✓ | **Must-fix:** None
- All 4 declarations (`thm:relative_spec_exists`, `def:relspec_structure_morphism`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base`) have `\leanok`.

### `Picard_GrassmannianCells.tex`
- **Complete:** ✓ | **Correct:** ✓ | **Must-fix:** None
- 155 `\leanok` markers, 0 sorry/TODO/FIXME. Fully clean.

### `Picard_GrassmannianQuot.tex`
- **Complete:** ✗ | **Correct (for proved):** ✓ | **Must-fix:** C2 effort-break + `matrixEnd_comp`/`matrixToFreeIso` linkage
- Open: C2 cocycle (proved=False, has_sorry=True), 3 forward declarations (glueRestrictionIso, glue_unique, glueHom)
- Proved: C1, all infrastructure, `def:scheme_modules_glue`, `def:grassmannian_functor`, `thm:grassmannian_universal_property` (but the latter has sorry from C2 cascade)
- C2 dispatch: READY but add matrixEnd linkage to sketch first

### `Picard_SectionGradedRing.tex`
- **Complete:** ✗ | **Correct (for proved):** ✓ | **Must-fix:** `\lean{}` pin for `lem:snap_ztensor_whisker_localIso`
- Live sorry: `relTensorProj.naturality` (dispatch READY after pin is added)
- `def:relTensorProj`, `def:relTensorActL`, `def:relTensorActR`: all `\leanok` (ActL/ActR sorry-free; relTensorProj naturality sorry)
- `lem:snap_ztensor_whisker_localIso`: proved=False, lean=None — must be pinned this iter

### `Picard_QuotScheme.tex`
- **Complete:** ✗ | **Correct (for proved):** ✓ | **Must-fix:** None this iter (all blockers are upstream)
- 169 `\leanok` markers but 4 sorry cascades
- `def:sectionGradedRing`/`def:sectionGradedModule`: no `\leanok`, blocked on SNAP tensor infrastructure
- `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`: sorry (downstream of SNAP/GR)
- `thm:grassmannian_representable`: has NOTE that proof is "blocked on RepresentableBy form vs weaker skeleton" — the current `\lean{}` pin (`Grassmannian.representable`) under-delivers the prose statement (missing smoothness, properness, tautological quotient, Plücker embedding). This is a known deferred open question.

---

## Priority Action Items for iter-060

### Must-fix this iter (blockers for next prover dispatch)

1. **Add `\lean{}` pin to `lem:snap_ztensor_whisker_localIso`** in `Picard_SectionGradedRing.tex`
   - Without this, the SNAP naturality prover cannot be targeted and leandag can't credit the node
   - This is the **only GAPS node** in the entire project (1/562 blueprint nodes)

2. **Add effort-break to `lem:gr_bundleCocycle_mul` (C2)** in `Picard_GrassmannianQuot.tex`
   - Add explicit mention of `matrixEnd_comp` (lean:Grassmannian.matrixEnd_comp) and `matrixToFreeIso` (lean:Grassmannian.matrixToFreeIso) as the core assembly steps
   - Without this, the prover will burn iterations discovering what "endpoint bookkeeping" means concretely

### Dispatch-ready once must-fixes above are done

1. **SNAP**: Dispatch prover on `relTensorProj.naturality` (the `def:relTensorProj` sorry)
2. **GR-C2**: Dispatch prover on `lem:gr_bundleCocycle_mul` after C2 effort-break
3. **FBC-A2**: Dispatch prover on `lem:base_change_mate_fstar_reindex_legs_conj` (conj-2a keystone)

### Low priority / deferred

- Fix DAG edge omission for `lem:isLocalizedModule_powers_restrictScalars` and `lem:gr_homEquiv_conjugateEquiv_app` (isolated in DAG but correct in blueprint)
- `thm:grassmannian_representable` blueprint strength: consider adding a weaker `\lean{}` pin label that matches the current Lean skeleton, or strengthening the Lean decl — deferred open question per existing NOTE
- 3 Mathlib anchor isolated nodes: no action (artifacts of leandag not scanning Mathlib)
