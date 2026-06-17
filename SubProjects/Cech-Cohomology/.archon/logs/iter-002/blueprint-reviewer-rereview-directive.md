# Blueprint Reviewer Directive

## Slug
iter002-rereview

## Purpose (same-iter HARD GATE fast-path)
This is a scoped re-review to clear the HARD GATE for the active **P1 prover lane**
(`AlgebraicGeometry.pushPullMap_comp` and its supporting push–pull functor lemmas in
`AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`). The covering chapter
`Cohomology_CechHigherDirectImage.tex` was rated `correct: partial` in the prior review
(slug iter002) due to TWO findings on P3/P5 sub-lemmas, now patched this iter:

1. `lem:cech_to_cohomology_on_basis` — missing `% SOURCE QUOTE:` for the statement.
   FIX APPLIED: a verbatim `% SOURCE QUOTE:` of Stacks Tag 01EO `lemma-cech-vanish-basis`
   was added from the newly-retrieved `references/stacks-cohomology.tex` (L1695–1714).
2. `lem:cech_term_pushforward_acyclic` — two proof steps (presheaf description of `R^k f_*`;
   affine-open-immersion vanishing + Grothendieck composition degeneration) were invoked but
   neither in `\uses{}` nor separately blueprinted. FIX APPLIED: two new declaration blocks
   (`lem:higher_direct_image_presheaf`, `lem:open_immersion_pushforward_comp`) with verbatim
   Stacks quotes, wired into `\uses{}`.

## What to confirm
You read the WHOLE blueprint (per your descriptor). Produce the standard per-chapter checklist.
The gating questions for THIS iter:

- **`Cohomology_CechHigherDirectImage.tex`**: are the two patched nodes now citation-complete and
  dependency-complete? Is the chapter now `complete: true` AND `correct: true` with no must-fix
  finding? The push–pull sub-graph feeding `lem:push_pull_comp` (Lean `pushPullMap_comp`) must be
  clean (it was clean in the prior review and should be untouched). If yes → the P1 lane clears
  the gate this iter.
- **`Cohomology_AcyclicResolution.tex`** (also rewritten this iter): the LES/δ-functor
  must-fix from the prior review was addressed by routing the proofs through the
  comparison-of-resolutions / SES-acyclicity-propagation kernel built from a new `\mathlibok`
  homology-LES anchor (`lem:homology_long_exact_sequence` →
  `ShortComplex.ShortExact.homology_exact₃`) and a to-build horseshoe block
  (`lem:injective_resolution_of_ses`). Confirm whether this chapter is now `correct: true`
  (informational — P4 is NOT being proved this iter; this just tells the planner whether iter-003
  can scaffold `AcyclicResolution.lean`). Audit the new `\mathlibok` anchor for faithfulness.

## References
- `references/stacks-cohomology.tex` (newly retrieved): Tags 01EO (L1695–1714), 01XJ (L591–603),
  relative-Leray (L2295–2306).
- `references/stacks-coherent.tex`: `lemma-relative-affine-vanishing` (L180–199).
- `references/homological-acyclic-derived.tex`: Tags 0157/015C/015D/015E/05TA.

## Known issues (don't re-report)
- `AcyclicResolution.lean` does not exist yet (sanctioned forward reference; scaffold planned
  for iter-003). The to-build `\lean{}` names in both rewritten chapters (`unmatched_lean`) are
  expected.
- Route B has no blueprint coverage by design.
