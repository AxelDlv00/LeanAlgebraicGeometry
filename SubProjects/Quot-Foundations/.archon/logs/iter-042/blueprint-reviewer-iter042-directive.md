# Blueprint review — iter-042 (Quot-Foundations)

Audit the WHOLE blueprint under `blueprint/src/chapters/`. Produce your standard
per-chapter completeness + correctness checklist and the
`## Unstarted-phase blueprint proposals` section.

## Context for this iter (do not let it scope-limit your whole-blueprint read)

- **QUOT gap1 CLOSED axiom-clean (iter-041).** `isIso_fromTildeΓ_of_isQuasicoherent`
  + keystone `isLocalizedModule_basicOpen_descent` + the `Hfr` producer chain are
  formalized in `QuotScheme.lean`. The chapter `Picard_QuotScheme.tex` has three
  **stale `\lean{}` pin mismatches** flagged by the iter-041 lean-vs-blueprint
  checker — blocks `lem:composite_immersion_flocus_basicOpen`,
  `lem:gamma_image_iso_semilinear_top`, `lem:flocus_section_scalar_tower` pin
  non-existent decls (content was absorbed inline into `section_localization_hfr_aux`).
  Four prover helpers have no blueprint block (`image_basicOpen_of_affine`,
  `compositeBasicOpenImmersion_image_basicOpen`, `image_basicOpen_eq_inf`,
  `section_localization_hfr_aux`). Plus stale `% NOTE: does NOT yet exist` comments
  in `lem:section_localization_descent` / `lem:qcoh_affine_isIso_fromTildeΓ` /
  `lem:section_localization_hfr_basicOpen`. Confirm whether the **G1-core** block
  `lem:qcoh_affine_section_localization` (Lean target
  `isLocalizedModule_basicOpen_of_isQuasicoherent`, not yet built — now a corollary
  of gap1) is complete + correct enough to send a prover at it THIS iter.

- **FBC conjugate route EXHAUSTED in-loop (5 iters).** STRATEGY pivots to an
  **affine tilde-transport** route: prove IsIso of the canonical
  `pushforwardBaseChangeMap` at the affine-local level via the proven
  `pullback_spec_tilde_iso` + the locality criterion
  (`lem:base_change_map_affine_local`), bypassing the section-level
  `gstar_transpose` coherence (`lem:base_change_mate_fstar_reindex_legs_conj`,
  still `sorry`). Assess `Cohomology_FlatBaseChange.tex`: does it already carry the
  affine-locality machinery this pivot needs, and what blueprint section is MISSING
  for the tilde-transport route? Treat the tilde-transport route as an
  unstarted-phase needing a chapter outline (give me one).

## What I need from you

1. Per-chapter checklist (complete? correct? must-fix-this-iter findings?).
2. For `Picard_QuotScheme.tex`: is it gate-clear for a prover on
   `isLocalizedModule_basicOpen_of_isQuasicoherent` (G1-core) once the 3 pin
   mismatches + 4 helper blocks + stale NOTEs are reconciled?
3. For `Cohomology_FlatBaseChange.tex`: a concrete chapter outline for the affine
   tilde-transport route (statements + `\uses` seams), so a blueprint-writer can
   author it this iter.
4. Any broken `\uses{}` / phantom-pin DAG corruption.
