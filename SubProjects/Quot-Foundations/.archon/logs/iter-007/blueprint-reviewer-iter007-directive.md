# Blueprint-reviewer directive — iter-007 (whole-blueprint audit)

Audit the WHOLE blueprint (all chapters under `blueprint/src/chapters/`). Two chapters were rewritten
this iter to decompose the FBC and GF cruxes into sub-lemma chains (the progress-critic's CHURNING
corrective). Your verdict gates the iter-008 prover dispatch on these two files. Focus the per-chapter
checklist especially on:

## Cohomology_FlatBaseChange.tex (rewritten this iter)
- `lem:base_change_mate_regroupEquiv` proof was REWRITTEN: the prior prescription (a one-liner via
  `LinearEquiv.toModuleIso (base_change_regroup_linearEquiv …)`) was UNSOUND for the current Mathlib
  pin (the two A-module tensor carriers are different types) — confirm the new proof is now
  mathematically correct and formalizable (eT identity-A-linear bridge as essential glue + generator-
  wise R'-linearity computation). Confirm the must-fix from iter-006's lean-vs-blueprint-checker
  (`fbc-iter006`) is RESOLVED.
- THREE new sub-lemma blocks added: `lem:base_change_mate_unit_value`,
  `lem:base_change_mate_fstar_reindex`, `lem:base_change_mate_gstar_transpose`. Confirm each has a
  well-formed statement, `\lean{}` pin, `\uses{}`, and a sound informal proof; confirm
  `lem:base_change_mate_generator_trace_eq` is now a thin assembly over them with a consistent
  `\uses{}` graph.

## Picard_FlatteningStratification.tex (rewritten this iter)
- THREE new sub-lemma blocks: `lem:gf_generic_rank_ses`, `lem:gf_torsion_reindex`,
  `lem:gf_clear_one_denominator`. Confirm statements are concretely typed and sound (generic rank
  `m := finrank (FractionRing P_d) (LocalizedModule (nonZeroDivisors P_d) N)`; SES over `P_d` with no
  `g`-inversion; reindex with `m' = d-1`; L4 single-denominator clear).
- `lem:gf_polynomial_core` (L5) rewritten as a thin assembly; it carries a `% LEAN PROOF STRUCTURE`
  note that the strong induction must generalize the BASE DOMAIN `A` (not just `N`). Confirm this is
  mathematically sound and that the assembly's `\uses{}` is consistent.
- `lem:gf_noether_clear_denominators` (L4) rewritten as a Finset-fold over `gf_clear_one_denominator`.

## Whole-blueprint checks (as usual)
- Per-chapter complete/correct verdict; broken `\uses{}` / isolated nodes / orphan chapters; SOURCE
  citation discipline on the new blocks (Nitsure §4, Stacks "Affine base change" — verbatim quotes).
- Re-confirm the QUOT chapters (`Picard_QuotScheme.tex`, `Picard_GrassmannianCells.tex`) are still
  complete + correct for the QUOT-defs scaffold lanes being dispatched THIS iter
  (`def:modules_annihilator`, `def:is_locally_free_of_rank`, `def:sectionGradedRing`,
  `def:gr_affine_chart`).
- Report any `## Unstarted-phase blueprint proposals` as usual.

Give the standard per-chapter checklist + HARD GATE verdict (complete + correct + must-fix) for each
active chapter.
