# Blueprint Reviewer Directive (scoped re-review — P4 HARD GATE fast path)

## Slug
acyclic-rereview

## Focus
This is a fast-path re-review to clear the P4 HARD GATE for
`blueprint/src/chapters/Cohomology_AcyclicResolution.tex`. Your iter-003 whole-blueprint
review (`task_results/blueprint-reviewer-iter003.md`) flagged exactly ONE must-fix on this
chapter: the `lem:homology_long_exact_sequence` `\mathlibok` anchor was unfaithful
(`\lean{}` named only `homology_exact₃` while the block asserts the full LES + δ).

A blueprint-writer + blueprint-clean pass has since fixed the anchor so its `\lean{}` names
all four Mathlib declarations the block asserts (`CategoryTheory.ShortComplex.ShortExact.homology_exact₁`,
`homology_exact₂`, `homology_exact₃`, `δ`), all verified present in Mathlib.

## What I need
Re-assess `Cohomology_AcyclicResolution.tex` and report whether it is now
`complete: true` AND `correct: true` with **no remaining must-fix-this-iter finding**.
Specifically confirm the anchor fix is faithful and that the chapter's proofs
(`lem:acyclic_dimension_shift`, `lem:acyclic_resolution_computes_derived`) are fully
supported by the now-corrected anchor. If complete+correct with no must-fix, state plainly
"P4 HARD GATE CLEARS" so the plan agent may scaffold `AcyclicResolution.lean` and dispatch
a prover THIS iter.

The project-side to-build declarations in this chapter
(`def:right_acyclic` / `IsRightAcyclic`, `lem:injective_resolution_of_ses` / the horseshoe
`InjectiveResolution.ofShortExact`, `lem:acyclic_dimension_shift`,
`lem:acyclic_resolution_computes_derived`) are EXPECTED to be unmatched in Lean — they will
be scaffolded this iter. Do NOT treat their current absence from the Lean tree as a defect.

You may read the whole blueprint as usual, but the verdict that matters here is for
`Cohomology_AcyclicResolution.tex` alone.
