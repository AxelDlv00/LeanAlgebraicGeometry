# Blueprint Review Report

## Slug
iter046

## Iteration
046

## Top-level summaries

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:tile_section_localization` → `lem:tile_scalar_compat_genV`: **missing `\uses{}` edge**. The proof body (line 4893) explicitly cites `Lemma~\ref{lem:tile_scalar_compat_genV}` ("At the target open V=D(f̄) it is the general-open companion Lemma~\ref{lem:tile_scalar_compat_genV}…"), but `lem:tile_scalar_compat_genV` is absent from both the statement `\uses{}` (lines 4831–4835) and the proof `\uses{}` (lines 4845–4848). **wire-up** — add `lem:tile_scalar_compat_genV` to both `\uses{}` lists.

- Isolated node: one `lean_aux` node (no chapter, 0 blueprint nodes isolated). **keep** — it is an uncovered Lean helper, not scaffolding.

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

- **complete**: true
- **correct**: partial
- **notes**:
  - **MUST-FIX** `lem:tile_section_localization` `\uses{}` gap: `lem:tile_scalar_compat_genV` is cited in the proof body but absent from both the statement and proof `\uses{}` — the DAG edge `tile_section_localization → tile_scalar_compat_genV` is missing. Fix: add `lem:tile_scalar_compat_genV` to the statement `\uses{…,` list after `lem:tile_scalar_compat` and to the proof `\uses{…,` list after `lem:tile_scalar_compat`.
  - New companion block `lem:modulesRestrictBasicOpen_smul_eq_genV`: statement, `\lean{AlgebraicGeometry.modulesRestrictBasicOpen_smul_eq'}`, `\uses{lem:tile_image_opens_identities}`, and proof are all correct. The Lean declaration exists (line 756 of `QcohTildeSections.lean`, closes by `rfl`).
  - New companion block `lem:tile_section_ring_identity_genV`: statement, `\lean{..., AlgebraicGeometry.appIso_inv_res, AlgebraicGeometry.appIso_inv_res_assoc}` (the two private helpers are intentionally bundled), `\uses{lem:tile_section_ring_identity}`, and proof are all correct. `tile_section_ring_identity'` (line 934) and the private helpers (lines 913, 922) all exist sorry-free.
  - New companion block `lem:tile_scalar_compat_genV`: statement, `\lean{AlgebraicGeometry.tile_scalar_compat'}`, `\uses{lem:modulesSpecToSheaf_smul_eq, lem:modulesRestrictBasicOpen_smul_eq_genV, lem:tile_section_ring_identity_genV}`, and proof are all correct. `tile_scalar_compat'` (line 986) exists sorry-free.
  - Rewritten Step 4/5 of `lem:tile_section_localization`: mathematically sound. Step 4 correctly frames the scalar reconciliation as restriction of scalars along R→R_g, consuming `lem:tile_scalar_compat` (source open V=⊤) and `lem:tile_scalar_compat_genV` (target open V=D(f̄)). Step 5 correctly applies `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap`. The dead-approach recipe (module-structure installation, W1–W3) is gone.
  - `lem:tile_section_comparison` carries `\leanok` on both statement and proof blocks but has no `\lean{}` pin (intentional per review notes — the full R_g-linear iso over all V is not yet formalized; only the scalar core at V=⊤ is). The `\leanok` marker was preserved from prior iters. This is an acknowledged, deliberate state; no writer action needed this iter.
  - `leandag build --json`: `unknown_uses: []` — no broken `\uses{}` labels. Blueprint-doctor: no broken refs, no malformed refs, no orphan chapters.

## Severity summary

**must-fix-this-iter**:
- `Cohomology_CechHigherDirectImage.tex` / `lem:tile_section_localization` → `lem:tile_scalar_compat_genV`: missing `\uses{}` wire-up. Blocks the HARD GATE (`correct: partial`). Fix is a one-line `\uses{}` addition; use the same-iter fast path (blueprint-writer → re-review) to clear the gate this iter.

**Overall verdict**: `Cohomology_CechHigherDirectImage.tex` is `correct: partial` due to one missing `\uses{}` edge (`tile_section_localization` → `tile_scalar_compat_genV`); the rewritten Step 4/5 proof sketch is mathematically sound and the three new companion blocks are correct — the gate clears immediately once the wire-up is applied.
