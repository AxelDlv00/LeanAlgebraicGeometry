# Blueprint Review Report

## Slug
iter047

## Iteration
047

---

## Top-level summaries

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:isScalarTower_restrictScalars_obj`: Isolated
  blueprint node — Deps=0, Impact=0 in the statement DAG. Root cause: leanblueprint only creates
  statement-graph edges from statement-block `\uses{}`; this lemma appears only in the
  **proof-block** `\uses{}` of `lem:tile_section_localization`. Its own statement block has no
  `\uses{}` (correct — scalar-tower for restrictScalars needs no dependencies). Disposition:
  **keep** — `lem:tile_section_localization` is already `\leanok` (axiom-clean), so no
  statement-level ordering dependency exists. Adding this to the statement-level `\uses{}` of
  `tile_section_localization` would be mathematically incorrect. The isolated status is the
  expected and correct state for proof-only scaffolding of a proved theorem.

- `Cohomology_CechHigherDirectImage.tex` / `lem:tileReconcileEquiv`: Not isolated (has Deps=2
  from its own statement `\uses{lem:tile_scalar_compat_genV, lem:modulesSpecToSheaf_smul_eq}`),
  but Impact=0 in the main-goal reachability chain (only cited in proof blocks, not statement
  `\uses{}`). Expected behavior for proof scaffolding of an already-proved theorem. Informational.

### Lean difficulty quality

- `lem:cech_free_eval_prepend_homotopy` and `lem:cech_free_eval_prepend_homotopy_spec`: Both lack
  a `\lean{}` hint. The NOTE comments explain this is intentional — the evaluated-complex form is
  not a separate Lean declaration but is obtained by transporting `cechEnginePrepend` across
  `cechFreeEvalEngineIso`. Not in the kernel-comparison prover cone.

---

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **Gate-specific: `lem:qcoh_section_kernel_comparison` block.** Statement, proof sketch, and
    `\uses{}` all complete. Four `\uses{}` deps (`qcoh_finite_presentation_cover`,
    `qcoh_section_equalizer`, `localized_module_map_exact_mathlib`, `tile_section_localization`)
    are all present as labelled blueprint nodes; Lean hints exist and have `unmatched_lean=0`
    (all four declarations exist in the Lean files, `has_sorry=False` for all four).
    `tile_section_localization` is `\leanok` (axiom-clean since iter-046). The proof sketch
    is detailed enough for formalization: it names the two equalizer sequences explicitly, the
    localization step at `f`, the per-tile isomorphisms, the differential-intertwining
    naturality argument, and the kernel-comparison conclusion. **HARD GATE CLEARS for this lane.**

  - **`lem:tileReconcileEquiv` correctness check.** Added in iter-047. Statement `\uses{}` =
    `{tile_scalar_compat_genV, modulesSpecToSheaf_smul_eq}` — both labels are defined and
    present in the DAG. Proof `\uses{}` identical. Statement (R-linear reconciliation iso,
    identity on underlying elements) and proof sketch (scalar-tower compatibility derived from
    `tile_scalar_compat_genV` + `modulesSpecToSheaf_smul_eq`) are mathematically correct and
    internally consistent. Lean hints (`tileReconcileEquiv`, `tileReconcileEquiv_apply`,
    `tileReconcileEquiv_symm_apply`) exist (`unmatched_lean=0`). No wiring error introduced.

  - **`lem:isScalarTower_restrictScalars_obj` correctness check.** Added in iter-047. No
    `\uses{}` (correct for a trivial scalar-tower consequence). Lean hint
    (`AlgebraicGeometry.isScalarTower_restrictScalars_obj`) exists. Statement (scalar tower
    for `(restrictScalars_{R→S}) M`) is mathematically correct — it is the trivial
    definitional consequence that the R-action is `r · m = φ(r) · m`. Proof sketch is
    appropriate. No `\leanok` yet (sync_leanok hasn't run this iter); the Lean declaration
    exists and is cited axiom-clean by `tile_section_localization`. No wiring error introduced.
    See isolation finding above (keep disposition).

  - **`lem:tile_section_localization` `\uses{}` update (iter-047 wiring fix).** Statement
    `\uses{}` no longer contains `lem:qcoh_finite_presentation_cover` (correct — the
    statement is purely tile-local). Proof `\uses{}` now contains `lem:tileReconcileEquiv`
    and `lem:isScalarTower_restrictScalars_obj` (correct replacements for the removed
    `tile_scalar_compat` and the iter-046 scaffolding). The proof text references
    `lem:tile_scalar_compat` at line 4946 for the V=⊤ case, but the proof `\uses{}` only
    lists `tile_scalar_compat_genV` (the general-V version, which subsumes the V=⊤ case).
    This is a minor prose/`\uses{}` drift — informational, since `tile_section_localization`
    is `\leanok` and the Lean proof compiles axiom-clean.

  - **Nodes with `\lean{}` gap (4 total, all pre-existing or intentional):**
    `lem:cech_free_eval_prepend_homotopy` and `lem:cech_free_eval_prepend_homotopy_spec` —
    P3b area, not separate Lean declarations (see NOTE comments), not in active prover cone.
    `lem:tile_section_comparison` — has `\leanok` but no `\lean{}`; documented intentional
    mismatch (only the V=⊤ scalar core is formalized, not the full natural R_g-linear iso;
    pre-existing since iter-044 review). `lem:isIso_fromTildeGamma_of_quasicoherent` — Route-A
    dormant fallback; no `\lean{}` by design (NOTE says target is covered by
    `lem:qcoh_isIso_fromTildeGamma` on Route B). None of these are in the kernel-comparison cone.

  - **`with_sorry`: 2 nodes** — `lem:cech_computes_cohomology` (the frozen protected final goal
    stub, expected) and `lean:AlgebraicGeometry.CechAcyclic.affine` (lean_aux, expected). Neither
    is in the kernel-comparison prover cone.

  - **`unmatched_lean`: 0** — all `\lean{}` hints across the entire chapter point to existing
    Lean declarations. ✓

  - **Blueprint-doctor**: clean — no orphan chapters, no broken refs, no malformed_refs, no
    undefined macros, no literal-REF tokens, no axiom declarations, no covers problems. ✓

---

## Severity summary

Severity summary: HARD GATE CLEARS — no must-fix-this-iter findings.

**Soon (3 items — none touch the kernel-comparison cone):**
- `CechHigherDirectImage.tex` / `lem:isScalarTower_restrictScalars_obj`: isolated in statement
  DAG (keep disposition; proof-only scaffolding for an already-proved theorem). Wire-up to the
  statement `\uses{}` of `tile_section_localization` is NOT the right fix — isolation is correct
  for proof-only scaffolding.
- `CechHigherDirectImage.tex` / `lem:cech_free_eval_prepend_homotopy`: no `\lean{}` hint. A
  dedicated Lean declaration + blueprint `\lean{}` pin would improve coverage of the P3b
  free-complex contracting homotopy. Not urgent (the engine-level formalization covers it).
- `CechHigherDirectImage.tex` / `lem:cech_free_eval_prepend_homotopy_spec`: same.

**Informational (3 items):**
- `CechHigherDirectImage.tex` / `lem:tileReconcileEquiv`: Impact=0 from main-goal perspective
  (proof-only scaffolding for `tile_section_localization`). Expected; no action needed.
- `CechHigherDirectImage.tex` / `lem:tile_section_comparison`: has `\leanok` but no `\lean{}`.
  Pre-existing documented mismatch (NOTE explains the V=⊤ / all-V discrepancy).
- `CechHigherDirectImage.tex` / `lem:tile_section_localization` proof `\uses{}`: cites
  `tile_scalar_compat_genV` but the proof text at Step 4 also names `lem:tile_scalar_compat`
  (V=⊤ instance). The `\uses{}` is technically complete (genV subsumes the V=⊤ case), but the
  prose/`\uses{}` drift is a minor cosmetic inconsistency.

Overall verdict: Blueprint is complete and correct across all three chapters; `Cohomology_CechHigherDirectImage.tex` is `complete: true` and `correct: true`. The `lem:qcoh_section_kernel_comparison` prover lane **CLEARS the HARD GATE**: all four `\uses{}` deps are present and wired, `tile_section_localization` is `\leanok` axiom-clean, the proof sketch is formalization-ready, and the two new iter-047 scaffolding blocks (`lem:tileReconcileEquiv`, `lem:isScalarTower_restrictScalars_obj`) introduce no correctness or wiring errors. No unstarted-phase proposals: all active phases (02KG, 01I8, P5a, P5b) have adequate blueprint coverage in the consolidated chapter.
