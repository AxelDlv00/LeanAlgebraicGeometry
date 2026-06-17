# blueprint-reviewer directive — iter-038

Whole-blueprint audit (read every chapter under `blueprint/src/chapters/`). Produce your standard per-chapter
completeness + correctness checklist, plus the unstarted-phase proposals section.

This is a HARD-GATE review: the planner will dispatch provers THIS iter on two files and needs your verdict on
their chapters first. Pay particular attention to the chapters newly edited this iter:

- **Picard_QuotScheme.tex** — gates `QuotScheme.lean`. NEW this iter (planner-authored): coverage blocks
  `lem:isLocalizedModule_ringEquiv_semilinear` (I) and `lem:isLocalizedModule_restrictScalars_powers_algebraMap`
  (II) for already-proved decls; and the NEW prover-target sub-build `def:gamma_image_ring_equiv` (`σ_V`,
  open-immersion structure-sheaf ring iso) + `lem:gamma_pullback_image_iso_hom_semilinear` (semilinearity of
  the pullback section transport). Judge whether the semilinearity block is complete + correct enough to guide
  a `mathlib-build` prover (statement well-posed, variance of `σ_V` sensible, proof sketch actionable).
- **Picard_GrassmannianCells.tex** — gates `GrassmannianCells.lean`. NEW: coverage block
  `lem:gr_free_entry_eq_signed_minor` (cofactor sub-step, pins `exists_minorDet_eq_free_entry`); and the live
  prover target `lem:gr_existence_lift` (E4 — already present, with a concrete LEAN SIGNATURE comment + full
  top/bottom-triangle proof sketch). Confirm E4 is complete + correct enough to scaffold + build.
- **Cohomology_FlatBaseChange.tex** — NEW: coverage block
  `lem:base_change_mate_extendScalars_inner_value_counit` (redundant variant of `gstar_generator_close`). No
  FBC prover this iter; just confirm the coverage block is honest and the `gstar_transpose` block still
  accurately reflects the stuck state.

For each chapter report: complete (true/partial/false), correct (true/partial/false), any must-fix-this-iter
findings, and whether the prover-TARGET blocks are well-formulated. Note any Lean-syntax leakage / project-
history verbosity in the newly-authored blocks (the planner skipped blueprint-clean this iter and is relying
on you to flag purity issues).
