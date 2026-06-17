# Blueprint-clean directive — iter-058

## Chapter

`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

This chapter received two write rounds this iter:
1. An effort-breaker split `lem:coproduct_distrib_fibrePower` into 4 sub-lemmas + a reduced assembly
   + a Mathlib anchor (`lem:over_mkIdTerminal_mathlib`).
2. A blueprint-writer decomposed the Need#1 jShriekOU transport into 5 build-target sub-lemmas + 1
   Mathlib anchor, cleared 13 coverage-debt nodes (new small blocks + bundled `\lean{}` names),
   repointed `lem:affine_cech_vanishing_general_seed` and `lem:affine_serre_vanishing_general_open`.

Enforce blueprint purity on the newly-written/edited blocks: strip any Lean tactic syntax or
implementation-detail leakage from informal proofs, remove project-history / iteration-narrative
verbosity, ensure each new block reads as textbook-level mathematics. Validate that `\uses{}` lists
reference real labels and that no `\leanok` was introduced by hand. Do NOT remove the `% NOTE: build
target` annotations (they are legitimate planner signals) or the Mathlib-anchor `\mathlibok` marks.
Do NOT alter the mathematical content of the Stub-1 or Need#1 decompositions — only clean.
