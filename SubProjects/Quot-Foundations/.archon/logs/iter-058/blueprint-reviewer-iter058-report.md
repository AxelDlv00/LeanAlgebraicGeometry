# Blueprint Review Report — iter-058

**Reviewer:** blueprint-reviewer subagent  
**Date:** 2026-06-10  
**Scope:** Whole-blueprint audit of all 8 chapters under `blueprint/src/chapters/`  
**Tools run:** `leandag build --json`, `leandag show isolated --json`, `archon blueprint-doctor --json`  
**Rendering verdict:** blueprint-doctor found **0 malformed refs** (no undefined-macro, no math-delim, no literal-ref, no bare-label)  
**DAG verdict:** `leandag build` found **0 unknown_uses** (all `\uses{}` labels resolve)

---

## Executive Summary

Both prover gates for this iteration need remediation before dispatch:

- **GF (Picard_FlatteningStratification):** The flatV route helpers are all present, leanok, and logically faithful. However, two helper decls proved in iter-056 (`gf_flat_of_isEpi`, `gf_isEpi_restrict_of_affine_le`) are missing `\leanok` markers, `gf_stalk_flat_localBase` has no blueprint block at all, and `Module.free_of_isLocalizedModule` has no mathlibok anchor. These are DAG-coverage debts, not route gaps. The prover can close the `flatV` sorry using the existing proof sketch; a blueprint-writer pass before dispatch is strongly recommended to avoid stale DAG tracking.

- **SNAP (Picard_SectionGradedRing):** `relTensorActL` (the prover's target) and its carrier construction `relTensorTriplePresheaf` have **no blueprint blocks**. Without a spec block, the prover has no formal specification to work from. This is a **hard blocker** — a blueprint-writer must add `def:relTensorActL` and `def:relTensorTriplePresheaf` blocks before dispatch.

- **GR-Quot:** 3 phantom blocks (abandoned presheaf route) + 3 forward-spec blocks with stale proof sketches + 1 stale construction paragraph. Not gating a prover this iter; remediation needed before any future GR prover dispatch.

---

## Unstarted-Phase Blueprint Proposals

### SNAP — relTensorActL specification phase

**Status:** Zero blueprint coverage for the action nat-trans target.  
**Required blocks:**
- `def:relTensorActL` — the action nat-trans `P ⊗ Q → Q` (or the appropriate variant). Should specify: type `(Opens X)ᵒᵖ ⥤ Ab` or `SheafOfModules` morphism; construction via the presheaf coequalizer; universal property with respect to `lem:relativeTensor_as_coequalizer`.
- `def:relTensorTriplePresheaf` — the carrier `(Opens X)ᵒᵖ ⥤ Ab` with objectwise `P(U) ⊗[ℤ] (X.sheaf(U) ⊗[ℤ] Q(U))`; used as the domain row of the coequalizer; should cite `lem:relativeTensor_as_coequalizer` in `\uses{}`.

Without these, `lem:relativeTensor_as_coequalizer` describes the codomain fork but the domain map is unspecified.

### GR-Quot — GL_d bundle cocycle phase

**Status:** The 3 remaining sorries (`universalQuotient` line 393, `tautologicalQuotient` line 404, `represents` line 898) all require the GL_d bundle transition cocycle. The blueprint has no decomposition for this cocycle.  
**Required:** A section in `Picard_GrassmannianQuot.tex` decomposing the GL_d-equivariance structure into checkable pieces: (1) definition of the transition maps on the tautological bundle, (2) cocycle identity, (3) descent to `universalQuotient` and `tautologicalQuotient`, (4) functor-representability conclusion for `represents`.

---

## Per-Chapter Verdicts

### 1. Picard_FlatteningStratification.tex

```
complete: false
correct:  true
must-fix-this-iter: yes (recommended before prover dispatch; see detail below)
```

**Coverage:** Full dévissage chain (L1–L5 leanok), Nagata machinery (leanok), G1 leanok, seam-1/2/3 leanok, algebraic generic flatness (leanok), geometric `genericFlatness` (leanok at statement level, `flatV` sorry open in Lean).

**flatV route — helpers confirmed present:**
- `lem:gf_flat_localizedModule_sameBase` (`gf_flat_localizedModule_sameBase`) — **leanok** ✓
- `lem:gf_flat_descend_isEpi` → `\lean{gf_flat_of_isEpi}` — **present; Lean proved (iter-056); missing `\leanok`** ✗
- `lem:gf_openImmersion_isEpi` → `\lean{gf_isEpi_restrict_of_affine_le}` — **present; Lean proved (iter-056); missing `\leanok`** ✗
- `isLocalizedModule_basicOpen` — blueprinted in Picard_QuotScheme.tex (iter-044), used transitively via `lem:qcoh_section_localization_basicOpen` ✓
- `Module.free_of_isLocalizedModule` — Mathlib lemma used directly in Lean assembly; **no mathlibok anchor** ✗

**DAG holes (must-fix):**
1. Add `\leanok` to `lem:gf_flat_descend_isEpi` and `lem:gf_openImmersion_isEpi`.
2. Add blueprint block for `gf_stalk_flat_localBase` (Lean source exists at `.lean:2746`, already proved; uses `IsLocalization.flat` + `Module.Flat.trans`).
3. Add mathlibok anchor for `Module.free_of_isLocalizedModule` (used at `.lean:3083,3176,3275`).
4. Wire `\uses{lem:mathlib_localization_flat, lem:mathlib_flat_trans}` into the new `gf_stalk_flat_localBase` proof block.
5. Wire `\uses{lem:mathlib_flat_localization_preserves}` into `lem:gf_flat_localizedModule_sameBase` proof (`\cref{}` already present in prose at line 1936, `\uses{}` missing).

**Note on 4 isolated mathlibok nodes (detail in Isolated Node Triage):** `lem:mathlib_flat_localization_preserves` and `lem:mathlib_flat_of_localized_maximal` are cited in prose for CONTRAST (the Lean source explicitly notes these don't apply; see `.lean:2781,3010`); isolation is semi-intentional for these two. `lem:mathlib_localization_flat` and `lem:mathlib_flat_trans` should be wired once item 2 above is done.

---

### 2. Picard_SectionGradedRing.tex

```
complete: false
correct:  true
must-fix-this-iter: yes (HARD BLOCKER — prover cannot proceed without spec)
```

**Coverage:** Tensor power infrastructure (leanok), lax-monoidal global sections (leanok), graded ring/module assembly (leanok), `lem:relativeTensor_as_coequalizer` (leanok), `lem:isIso_sheafification_whiskerRight_unit` (leanok).

**Missing blocks:**
- `def:relTensorActL` — **no blueprint block at all.** The prover's target has no specification.
- `def:relTensorTriplePresheaf` — **no blueprint block.** Lean decl exists (`SectionGradedRing.lean`), objectwise `P(U) ⊗[ℤ] (X.sheaf(U) ⊗[ℤ] Q(U))`; needed as the domain of the coequalizer for `relTensorActL`.
- `lem:snap_ztensor_whisker_localIso` (line 443) — **present with proof sketch; missing `\lean{}` and `\leanok`.** Should link to the Lean decl name once the prover names it.

**Pipeline adequacy for `relTensorActL`:** The presheaf-promotion infrastructure is present (`lem:relativeTensor_as_coequalizer`, `lem:isIso_sheafification_whiskerRight_unit`, `def:relTensorDomainPresheaf`). The pipeline route is sound in principle. However the action nat-trans itself is not specified, leaving the prover with no formal target.

---

### 3. Picard_GrassmannianQuot.tex

```
complete: false
correct:  partial (6 unmatched \lean{} pins)
must-fix-this-iter: no (not dispatching a prover; remediate before any future GR dispatch)
```

**Phantom blocks (REMOVE):** Lines 190-196 carry a NOTE comment labeling these abandoned:
- `def:gr_modules_gluePresheaf` → `\lean{AlgebraicGeometry.Scheme.Modules.gluePresheaf}` — decl does NOT exist in Lean; abandoned route
- `def:gr_modules_gluePresheafModule` → `\lean{…gluePresheafModule}` — same
- `lem:gr_modules_gluePresheaf_isSheaf` → `\lean{…gluePresheafIsSheaf}` — same

**Forward-spec blocks with stale proofs (UPDATE):** These describe planned post-glue downstream work; `\lean{}` pins are unmatched; proof sketches reference the abandoned `def:gr_modules_gluePresheaf`:
- `def:gr_modules_glueRestrictionIso` → `\lean{…glueRestrictionIso}` — decl not yet implemented
- `lem:gr_modules_glue_unique` → `\lean{…glue_unique}` — decl not yet implemented
- `def:gr_modules_glueHom` → `\lean{…glueHom}` — decl not yet implemented

Proof sketches for these three must be rewritten using the equalizer-of-pushforwards route (not compatible-families). Until implemented in Lean, they should carry `\sorry`-style markers (no `\leanok`), which they currently don't have (already the case — no `\leanok` present). The `\uses{def:gr_modules_gluePresheaf}` in their proof blocks must be removed or replaced.

**Stale construction paragraph:** `def:scheme_modules_glue` (lines 329–338) still reads: "assembled in three steps … compatible families … pointwise module structure … sheaf condition." This describes the abandoned presheaf route. Must be rewritten to describe the equalizer-of-pushforwards route (`∏ᵢ(ιᵢ)_*Mᵢ ⇉ ∏(j_ij)_*(f_ij^*Mᵢ)`).

**Isolated node:** `lem:gr_homEquiv_conjugateEquiv_app` — leanok, no `\uses{}` in or out; should be wired as a dependency of `lem:gr_pullbackObjUnitToUnit_comp` (see Isolated Node Triage).

**GL_d bundle cocycle:** No decomposition for the 3 remaining sorries (`universalQuotient`, `tautologicalQuotient`, `represents`). See Unstarted-Phase section.

---

### 4. Cohomology_FlatBaseChange.tex

```
complete: true
correct:  true
must-fix-this-iter: no
```

`def:pushforward_base_change_map` present (leanok). Chapter is compact and well-structured. Both `FlatBaseChange.lean` and `FlatBaseChangeGlobal.lean` are covered.

---

### 5. Cohomology_RegroupHelper.tex

```
complete: true
correct:  true
must-fix-this-iter: no
```

Single lemma `lem:base_change_regroup_linearEquiv` (leanok). Chapter complete.

---

### 6. Picard_GrassmannianCells.tex

```
complete: true
correct:  true
must-fix-this-iter: no
```

`def:gr_affine_chart` (leanok). E1–E5 chain and `isProper` all leanok per prior memory (iter-056).

---

### 7. Picard_QuotScheme.tex

```
complete: true
correct:  true
must-fix-this-iter: no
```

`def:hilbert_polynomial` (leanok). Gap1–Gap2 chain fully closed (iter-041,044). `isLocalizedModule_basicOpen` blueprinted here, used by GF chapter.

---

### 8. Picard_RelativeSpec.tex

```
complete: true
correct:  true
must-fix-this-iter: no
```

`def:qc_sheaf_of_algebras` (leanok). Chapter compact and complete.

---

## HARD-GATE Verdicts

### GF — Picard_FlatteningStratification.tex

**HARD GATE: CONDITIONAL PASS**

The `flatV` sorry is well-specified by the existing proof sketch (lines 2348–2445). All route helpers are either leanok (`gf_flat_localizedModule_sameBase`) or proved in Lean without blueprint markers (`gf_flat_of_isEpi`, `gf_isEpi_restrict_of_affine_le` from iter-056). The Mathlib anchors needed by the Lean assembly exist in Mathlib and are cited in the proof sketch prose. A prover can close the sorry by following the proof sketch.

**Condition:** A blueprint-writer should add the missing `\leanok` markers and `gf_stalk_flat_localBase` block before or immediately after dispatch. These are DAG-tracking hygiene items, not route blockers.

### SNAP — Picard_SectionGradedRing.tex

**HARD GATE: FAIL**

`relTensorActL` has no blueprint block. `relTensorTriplePresheaf` has no blueprint block. The prover has no specification for what it is building. A blueprint-writer must produce `def:relTensorActL` and `def:relTensorTriplePresheaf` blocks — including type signature, construction plan (via presheaf coequalizer `lem:relativeTensor_as_coequalizer`), and `\uses{}` edges — before prover dispatch.

---

## Isolated Node Triage

**Total isolated nodes: 8** (0 in-edges AND 0 out-edges in DAG)

| Node | Chapter | Type | Disposition | Action |
|------|---------|------|-------------|--------|
| `lem:mathlib_flat_localization_preserves` | GF | mathlibok | **KEEP** | Cited in prose at line 1936 for contrast ("existing Mathlib results … here a separate argument is required"). Lean source explicitly says `Module.Flat.of_isLocalizedModule` does not apply (`.lean:3010`). Intentional educational anchor. |
| `lem:mathlib_localization_flat` | GF | mathlibok | **WIRE-UP** | Used by `gf_stalk_flat_localBase` (`.lean:2752`). Wire: add `\uses{lem:mathlib_localization_flat, lem:mathlib_flat_trans}` to the `gf_stalk_flat_localBase` proof block (to be created). |
| `lem:mathlib_flat_of_localized_maximal` | GF | mathlibok | **KEEP** | Cited at `.lean:2729` comment for contrast (distinct from the approach taken). Not actually used in any proof. Intentional educational anchor. |
| `lem:mathlib_flat_trans` | GF | mathlibok | **WIRE-UP** | Used by `gf_stalk_flat_localBase` (`.lean:2753`). Wire: add to `gf_stalk_flat_localBase` proof block (same action as above). |
| `lem:gr_homEquiv_conjugateEquiv_app` | GR-Quot | project leanok | **WIRE-UP** | Proved leanok in iter-055 (memory: `GR-quot functor DROPPED`). Should be a dependency of `lem:gr_pullbackObjUnitToUnit_comp`. Add `\uses{lem:gr_homEquiv_conjugateEquiv_app}` to the `gr_pullbackObjUnitToUnit_comp` proof block. |
| `relTensorTriplePresheaf` | SNAP | lean_aux | **WIRE-UP** | New decl in `SectionGradedRing.lean` (objectwise triple Z-tensor). Needs blueprint block `def:relTensorTriplePresheaf` with `\lean{}` pin. This is the SNAP HARD GATE blocker. |
| `opensTopology` | SNAP | lean_aux | **KEEP** | Private abbreviation for `Opens.grothendieckTopology` in `SectionGradedRing.lean`. Private → intentionally unblueprinted. No action needed. |
| `gf_stalk_flat_localBase` | GF | lean_aux | **WIRE-UP** | Proved axiom-clean in `.lean:2746`. Needs blueprint block `lem:gf_stalk_flat_localBase` with `\lean{AlgebraicGeometry.gf_stalk_flat_localBase}`, `\leanok`, and `\uses{lem:mathlib_localization_flat, lem:mathlib_flat_trans}`. |

---

## GR Phantom Block Triage

### Fully Phantom (REMOVE)

These three `\lean{}` pins point at decls that do not exist and will never exist (abandoned presheaf route):

1. `def:gr_modules_gluePresheaf` → `AlgebraicGeometry.Scheme.Modules.gluePresheaf`
2. `def:gr_modules_gluePresheafModule` → `AlgebraicGeometry.Scheme.Modules.gluePresheafModule`
3. `lem:gr_modules_gluePresheaf_isSheaf` → `AlgebraicGeometry.Scheme.Modules.gluePresheafIsSheaf`

The NOTE comment at GrassmannianQuot.tex lines 190-196 already labels these correctly. Recommended action: **remove** these three blocks entirely, or replace with a short historical note (no `\lean{}` pin). They currently break the unmatched_lean DAG count.

### Forward-Spec (UPDATE proof sketches)

These three blocks describe planned post-glue downstream work. The decls do not yet exist in Lean (`grep` confirms). Their proof sketches reference `def:gr_modules_gluePresheaf` (phantom):

4. `def:gr_modules_glueRestrictionIso` → `AlgebraicGeometry.Scheme.Modules.glueRestrictionIso`
5. `lem:gr_modules_glue_unique` → `AlgebraicGeometry.Scheme.Modules.glue_unique`
6. `def:gr_modules_glueHom` → `AlgebraicGeometry.Scheme.Modules.glueHom`

Recommended action: **update** proof sketches to use the equalizer route (reference `def:scheme_modules_glue` directly; remove `\uses{def:gr_modules_gluePresheaf}`); retain `\lean{}` pins as forward declarations; add a NOTE comment marking as planned work pending GL_d cocycle phase.

### Stale Construction Paragraph

`def:scheme_modules_glue` body paragraph (lines 329–338) describes "compatible families assembled in three steps … pointwise module structure … sheaf condition." This is the abandoned presheaf route. **Rewrite** to describe the equalizer-of-pushforwards route: the limit of the diagram `∏ᵢ(ιᵢ)_*Mᵢ ⇉ ∏_{ij}(j_ij)_*(f_ij^*Mᵢ)` in `Scheme.Modules`, with the two parallel arrows being the C1 and C2 cocycle maps.

---

## Coverage-Debt Anchors

| Lean decl | Chapter | Status | Recommendation |
|-----------|---------|--------|----------------|
| `Scheme.Modules.relTensorTriplePresheaf` | SNAP | lean_aux isolated; **no blueprint block** | **Add `def:relTensorTriplePresheaf`** — SNAP HARD GATE blocker |
| `Scheme.Modules.opensTopology` | SNAP | lean_aux isolated; private | **KEEP** — private abbrev, intentionally unblueprinted |
| `gf_stalk_flat_localBase` | GF | lean_aux isolated; **no blueprint block** | **Add `lem:gf_stalk_flat_localBase`** — DAG debt (already proved, low urgency) |

---

## Severity Summary

| Severity | Count | Items |
|----------|-------|-------|
| **CRITICAL** | 3 | SNAP: `relTensorActL` no spec; `relTensorTriplePresheaf` no blueprint block; `lem:snap_ztensor_whisker_localIso` missing `\lean{}` + `\leanok` |
| **HIGH** | 4 | GF: `gf_flat_of_isEpi` missing `\leanok`; `gf_isEpi_restrict_of_affine_le` missing `\leanok`; `gf_stalk_flat_localBase` no block; `Module.free_of_isLocalizedModule` no mathlibok anchor |
| **MEDIUM** | 4 | GR: 3 phantom blocks with broken `\lean{}` pins; stale Construction paragraph in `def:scheme_modules_glue` |
| **LOW** | 6 | GR: 3 forward-spec blocks with stale proof sketches; `lem:gr_homEquiv_conjugateEquiv_app` isolated; GF: 2 contrast-anchor mathlibok nodes isolated (semi-intentional) |
| **INFO** | 1 | SNAP: `opensTopology` isolated (private, intentional) |

---

## Blueprint-Writer Action List (Priority Order)

1. **[SNAP, CRITICAL]** Add `def:relTensorTriplePresheaf` block with `\lean{AlgebraicGeometry.Scheme.Modules.relTensorTriplePresheaf}`, objectwise-triple-Z-tensor spec, `\uses{lem:relativeTensor_as_coequalizer}`.
2. **[SNAP, CRITICAL]** Add `def:relTensorActL` block with type, construction plan via presheaf coequalizer, `\uses{def:relTensorTriplePresheaf, lem:relativeTensor_as_coequalizer, lem:isIso_sheafification_whiskerRight_unit}`.
3. **[SNAP, CRITICAL]** Add `\lean{}` and `\leanok` to `lem:snap_ztensor_whisker_localIso` once Lean decl name is known.
4. **[GF, HIGH]** Add `\leanok` to `lem:gf_flat_descend_isEpi` and `lem:gf_openImmersion_isEpi`.
5. **[GF, HIGH]** Add `lem:gf_stalk_flat_localBase` block (leanok, `\lean{gf_stalk_flat_localBase}`, `\uses{lem:mathlib_localization_flat, lem:mathlib_flat_trans}`).
6. **[GF, HIGH]** Add mathlibok anchor for `Module.free_of_isLocalizedModule`.
7. **[GF, MEDIUM]** Wire `\uses{lem:mathlib_flat_localization_preserves}` into `lem:gf_flat_localizedModule_sameBase` proof block.
8. **[GR, MEDIUM]** Remove 3 phantom blocks (`gluePresheaf`, `gluePresheafModule`, `gluePresheaf_isSheaf`) or replace with historical note.
9. **[GR, MEDIUM]** Rewrite `def:scheme_modules_glue` Construction paragraph to describe the equalizer-of-pushforwards route.
10. **[GR, LOW]** Update 3 forward-spec proof sketches (`glueRestrictionIso`, `glue_unique`, `glueHom`) to reference equalizer route.
11. **[GR, LOW]** Wire `lem:gr_homEquiv_conjugateEquiv_app` into `lem:gr_pullbackObjUnitToUnit_comp` via `\uses{}`.
