# lean-vs-blueprint-checker — FlatBaseChange (iter-026)

Compare exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

This iter's prover work centered on `base_change_mate_fstar_reindex_legs`,
`base_change_mate_inner_value_eq`, and `base_change_mate_gstar_transpose` (all still carry
`sorry`). Verify:
- Does the blueprint faithfully describe the actual Lean statements/signatures (the
  `lem:base_change_mate_*` chain)?
- Is the chapter detailed enough to guide the remaining `_legs` cancellation assembly (the
  prover reports the next step is term-mode `…_gammaDistribute` distribution + unfolding
  `base_change_mate_codomain_read_legs`, NOT `simp [Functor.map_comp]`)? Or is the blueprint
  too thin where the Lean clearly needed more detail?
- Any signature mismatches, fake/placeholder statements, or `\lean{}` pins that name the
  wrong declaration.

Report to your task_results file.
