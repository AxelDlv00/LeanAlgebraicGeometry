# Blueprint Writer Directive

## Target chapter
`blueprint/src/chapters/Cohomology_AcyclicResolution.tex`

## Strategy context (the slice that matters)
This chapter is the P4 abstract homological-algebra core of the project: "an acyclic
resolution computes the right-derived functor" (Stacks Tag 015E), built at the level of
Mathlib's `CategoryTheory.Functor.rightDerived n`. Its proofs derive a long exact
sequence of right-derived functors from the COMPLEX-LEVEL homology long exact sequence
(via a horseshoe lift). The chapter is otherwise complete and correct; this is a SINGLE
targeted fix.

## The one fix required (must-fix this iter — blocks the P4 prover gate)
The Mathlib dependency anchor `lem:homology_long_exact_sequence` is **unfaithful**. It
currently carries
`\lean{CategoryTheory.ShortComplex.ShortExact.homology_exact₃}` with `\mathlibok`,
but the block's stated content is the FULL long exact homology sequence — exactness at
ALL three positions PLUS the connecting map δ — and the chapter's proofs
(`lem:acyclic_dimension_shift`, `lem:acyclic_resolution_computes_derived`) consume all
four Mathlib pieces.

Fix the anchor so its `\lean{}` faithfully names every Mathlib declaration the block
asserts. **All four of the following are VERIFIED to exist** (plan agent confirmed via
grep of `Mathlib/Algebra/Homology/HomologySequence.lean`; the three exactness results
are `ShortComplex.ShortExact` methods, δ is at HomologySequence.lean:282):

- `CategoryTheory.ShortComplex.ShortExact.homology_exact₁`
- `CategoryTheory.ShortComplex.ShortExact.homology_exact₂`
- `CategoryTheory.ShortComplex.ShortExact.homology_exact₃`
- `CategoryTheory.ShortComplex.ShortExact.δ`

**How to fix** (pick whichever keeps the leandag graph clean — verify with
`archon dag-query node --node lem:homology_long_exact_sequence` afterward that the anchor
is matched and no `\uses{}` breaks):
- Preferred: if `\lean{}` accepts a comma-separated list in this project (check an
  existing block / leandag behavior), list all four names in the single
  `lem:homology_long_exact_sequence` block's `\lean{}`, keeping `\mathlibok`.
- Otherwise: split into separate `\mathlibok` anchor blocks — e.g. one block for the
  connecting map `\lean{CategoryTheory.ShortComplex.ShortExact.δ}` and one (or three)
  for the exactness results `homology_exact₁/₂/₃` — each with its own `\label`,
  `\textit{Provided by Mathlib.}`, and `\mathlibok`. Keep all downstream `\uses{}`
  references resolving (if you split, update any block that `\uses{lem:homology_long_exact_sequence}`
  so it points at the right new label(s), or keep `lem:homology_long_exact_sequence`
  as the umbrella label so existing `\uses{}` edges remain valid).

## Out of scope
- Do NOT touch any other block in this chapter — all proof sketches (horseshoe lift,
  dimension shift, staircase) were reviewed as correct and complete.
- Do NOT add `\leanok` anywhere (the sync_leanok phase owns it).
- Do NOT change the project's own to-be-proved declarations
  (`def:right_acyclic`, `lem:injective_resolution_of_ses`, `lem:acyclic_dimension_shift`,
  `lem:acyclic_resolution_computes_derived`) — they are correct as written and will be
  scaffolded into Lean this iter.

## Citation discipline
The existing `% SOURCE`/`% SOURCE QUOTE` comments on the block are fine. If you author
new anchor blocks, a Mathlib anchor needs only `\textit{Provided by Mathlib.}` + the
`\lean{}` + `\mathlibok` (no external SOURCE QUOTE required for a Mathlib re-export).
