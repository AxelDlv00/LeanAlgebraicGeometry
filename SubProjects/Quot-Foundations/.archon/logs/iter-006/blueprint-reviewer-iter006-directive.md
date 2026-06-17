# Blueprint-Reviewer Directive — iter-006

Run your standard whole-blueprint audit. Read every chapter under
`blueprint/src/chapters/` and produce your per-chapter completeness + correctness
checklist plus the unstarted-phase proposals.

## Context for this audit (what changed since your last completed review, iter-004)

- iter-005 was a graph/dag-only stage. The blueprint was edited there and again
  this iter (iter-006) by the plan agent. Your iter-005 dispatch did not land a
  report, so iter-004 is your last completed verdict of record.
- NEW chapter this iter: `Cohomology_RegroupHelper.tex` — a thin 1:1 chapter for
  the new Lean file `AlgebraicJacobian/Cohomology/RegroupHelper.lean` (created this
  iter by a refactor). It holds one block, `lem:base_change_regroup_linearEquiv`,
  the pure-tensor-algebra `R'`-linear regrouping equivalence. It is `\input` in
  content.tex and is `\uses`-ed by `lem:base_change_mate_regroupEquiv` in the
  FlatBaseChange chapter. Confirm this resolves the prior coverage debt the
  iter-005 lean-vs-blueprint-checker flagged for `base_change_regroup_linearEquiv`.
- EDITED: `Picard_FlatteningStratification.tex` — the stale `% LEAN SIGNATURE`
  block for `lem:gf_noether_clear_denominators` (L4) was corrected to include the
  retained `(_ : Algebra A_g B_g)` existential binder (the iter-005 checker's one
  major finding). Confirm it now matches.
- EDITED: `Cohomology_FlatBaseChange.tex` — `lem:base_change_mate_regroupEquiv` now
  `\uses{... , lem:base_change_regroup_linearEquiv}` and its proof references the
  `LinearEquiv.toModuleIso` route.

## What I most need from you (gates this iter's prover dispatch)

1. **HARD-GATE the two ACTIVE prover chapters**: `Cohomology_FlatBaseChange.tex`
   and `Picard_FlatteningStratification.tex`. For each, confirm `complete` +
   `correct` with no must-fix-this-iter finding, OR name precisely what blocks the
   gate. These back the only two prover lanes I intend to dispatch this iter.
2. **New chapter `Cohomology_RegroupHelper.tex`**: is the single block well-formed
   (statement, `\lean{}`, `\uses{}`, informal proof, source citation) and correct?
3. The QUOT/GR/SNAP chapters (`Picard_QuotScheme.tex`, `Picard_GrassmannianCells.tex`)
   are NOT under active prover work this iter (gated behind FBC/GF). Still audit
   them — I want to know whether `def:modules_annihilator`, `def:is_locally_free_of_rank`,
   `def:sectionGradedRing`, `def:gr_affine_chart` (the leandag frontier nodes) are
   complete+correct enough that I could open a QUOT-defs scaffold lane NEXT iter.

Report in your standard format. I will act on the per-chapter checklist and the
unstarted-phase proposals.
