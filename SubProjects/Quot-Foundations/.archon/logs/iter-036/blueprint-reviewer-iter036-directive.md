# Blueprint Reviewer — iter-036 HARD GATE

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex` via `blueprint/src/content.tex`).
Produce your standard per-chapter checklist (`complete` / `correct` booleans + must-fix items),
the incomplete-proof summary, the Lean-target well-formedness pass, and the
`## Unstarted-phase blueprint proposals` section.

## This iter's HARD-GATE focus (3 chapters feed live prover lanes)

These three chapters were rewritten by blueprint-writers THIS iter and then purity-passed by
blueprint-clean; I need a current complete+correct verdict on each before dispatching provers:

1. **`Cohomology_FlatBaseChange.tex`** — FBC route. The obligation-2 discharge was **reverted**
   from a short-lived explicit-inverse/element-`ext` rewrite back to the **conjugate-counit `huce`
   calculus**. Verify:
   - The explicit-inverse blocks (`def:base_change_mate_section_inverse`,
     `lem:base_change_mate_section_map_inverse_id`, `lem:base_change_mate_section_inverse_map_id`)
     are GONE and nothing still `\uses{}` them.
   - `lem:base_change_mate_gstar_transpose`'s proof block states the concrete `huce` remainder
     (master counit-transport identity + the three telescoping steps (a) inner reindex reproven
     inline from `…_legs_unitExpand`/`…_legs_gammaDistribute`, (b) one-generator close against
     `regroupEquiv`, (c) dictionary cancellation), and its `\uses{}` route through those proved
     standalone lemmas + the `\mathlibok` anchor `lem:conjugateEquiv_counit_symm_mathlib`, and do
     NOT `\uses{}` the sorry-backed `lem:base_change_mate_fstar_reindex_legs` / conj-2a.
   - `lem:pushforward_base_change_mate_cancelBaseChange` routes through
     `generator_trace`/`section_identity`/`gstar_transpose` (conjugate route), consistent with the
     live Lean body.
   - Is the `gstar_transpose` proof sketch detailed enough for a fine-grained prover to extract
     atomic lemmas for steps (a)/(b)/(c)? Flag if any step is too thin.

2. **`Picard_QuotScheme.tex`** — QUOT gap1-D. New: `lem:section_localization_descent_of_cover`
   (landed cover-form keystone), `lem:pullback_gamma_top_iso` (the iter-036 section-transport
   prover target `gammaPullbackTopIso`), `lem:eq_of_locally_eq_mathlib` anchor; rewired
   `lem:section_localization_descent`. Verify the section-transport lemma's sketch is detailed
   enough to formalize and its `\uses{}` is accurate.

3. **`Picard_GrassmannianCells.tex`** — GR-proper. New: 7 coverage blocks for landed scaffold +
   the E1–E4 + existence decomposition (`lem:gr_existence_chart_factorization` = E1 the primary
   missing-API target, E2/E3/E4, `lem:gr_valuativeExistence_toSpecZ`). Verify E1's statement is
   well-formed as a Lean target and the E1–E4 chain `\uses{}` is correct.

Report per-chapter `complete`/`correct` and any must-fix-this-iter findings. If any of these 3
chapters is `partial`/`false` or carries a must-fix, say so plainly — that defers its prover lane.
