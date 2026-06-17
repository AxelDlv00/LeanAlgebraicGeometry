# Blueprint Review: iter073
**Iter:** 073

## Top-level summaries

- **HARD GATE**: `Cohomology_CechHigherDirectImage.tex` → **PASS** — complete: true / correct: true / no must-fix. CSI prover lane may run.
- **New block `lem:sectionCechAugV_π`**: PASS — statement matches Lean sig `AlgebraicGeometry.sectionCechAugV_π` (confirmed in DAG), all 5 `\uses{}` labels valid (DAG confirmed), proof sketch detailed and formalizable, `\textit{Project-local.}` attribution correct.
- **Bundled helpers (26)**: PASS — `leandag unknown_uses: []` (zero broken `\uses{}`), `blueprint-doctor malformed_refs: []` (zero rendering issues), no `\ref` drift.
- **Bad Lean targets (gaps)**: 5 nodes missing `\lean{}` hint — `lem:cech_free_eval_prepend_homotopy` (rdep=3), `lem:cech_free_eval_prepend_homotopy_spec` (rdep=2), `lem:tile_section_comparison` (rdep=0, leaf; intentional per iter-044 NOTE), `lem:isIso_fromTildeGamma_of_quasicoherent` (leaf), `lem:pushforward_commutes_restriction` (leaf). **None on CSID critical path.**
- **Isolated**: 0 blueprint nodes isolated (leandag `isolated: 0`).
- **Sorries active**: 4 total — `lem:coreIso_comm_leg` (target), `lem:sectionCechAugV_π` (target), `lem:cech_augmented_resolution` (upstream, has `\leanok`), `lem:cech_computes_cohomology` (protected goal, has `\leanok`).

## Unstarted-phase proposals

*NONE.* Both remaining phases (P5a-resolution, P5b comparison assembly) have full blueprint coverage in `Cohomology_CechHigherDirectImage.tex`.

## Per-chapter

### `Cohomology_HigherDirectImage.tex`
- **Complete**: true
- **Correct**: true
- **Notes**: Single-definition chapter; `def:higher_direct_image` with `\leanok`, source quoted, citation discipline present.

### `Cohomology_AcyclicResolution.tex`
- **Complete**: true
- **Correct**: true
- **Notes**: All declarations have `\leanok` or `\mathlibok`; `\uses{}` edges clean; no sorry. `lem:horseshoe_twist` and `lem:horseshoe_chainMap` missing from `leandag` unmatched analysis — all their `\lean{}` hints in the `unmatched_lean` list but these are project Lean declarations still pending (not Mathlib); `proved=False` for those two, consistent. No issue with correctness.

### `Cohomology_CechHigherDirectImage.tex`
- **Complete**: true
- **Correct**: true
- **Notes (gate-critical)**:
  - `lem:sectionCechAugV_π`: new block fully formed — `\lean{AlgebraicGeometry.sectionCechAugV_π}` matched in DAG (has_sorry=True as expected), `\uses{def:sectionCechAugV, lem:coreIso_obj_iso, lem:pushPull_sigma_iso, lem:pushPull_leg_sections, lem:pushPull_eval_prod_iso}` all confirmed in DAG, proof sketch specifies the degree-0 simplification (no coface combinatorics), references `pushPull_sigma_iso_π` by name — formalizable.
  - Bundled helpers in `lem:cechSection_contractible` (24 helpers), `lem:pushPull_sigma_iso` (1 helper: `pushPull_sigma_iso_π`), `lem:coreIso_comm_sum` (1 helper: `abHom_finsetSum_apply`): zero `unknown_uses` in leandag — no `\uses{}` corruption from the bundling.
  - `lem:coreIso_comm_leg` (the other active sorry target): statement block present, `\leanok` absent (correct), `\uses{}` valid, proof sketch detailed.
- **Notes (non-gate, soon)**:
  - `lem:cech_free_eval_prepend_homotopy` and `lem:cech_free_eval_prepend_homotopy_spec`: no `\lean{}` hints; rdep=3 and 2 respectively; used by the free-Čech bridge chain. Not on CSID path. Add `\lean{}` hints when the P5a presheaf-Čech bridge is formalized.
  - `lem:tile_section_comparison`: `\leanok` on both statement and proof but no `\lean{}` hint; rdep=0 (leaf, no downstream impact). Explicitly documented in iter-044 `% NOTE` as intentional. No action needed this iter.
  - `lem:isIso_fromTildeGamma_of_quasicoherent`, `lem:pushforward_commutes_restriction`: missing `\lean{}` hints, both leaves (rdep=0). No downstream impact.

## Severity summary

- **must-fix (this iter)**: NONE.
- **soon**: 5 nodes missing `\lean{}` hints (see per-chapter notes above); `lem:tile_section_comparison` `\leanok`-without-lean-hint documented discrepancy.
