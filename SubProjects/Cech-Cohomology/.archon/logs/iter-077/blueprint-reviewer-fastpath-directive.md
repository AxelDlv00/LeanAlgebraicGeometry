# Blueprint Reviewer Directive — fast-path re-review (iter-077)

Standard whole-blueprint audit. Focus the HARD-GATE verdict on the consolidated chapter
`Cohomology_CechHigherDirectImage.tex`, which now covers the new capstone leaf files
`CechToHigherDirectImage.lean` and `CechTermAcyclic.lean`.

## Context for the re-review
The prior review (`capstone-iter077`) flagged this chapter `partial/partial` with these must-fix items.
A blueprint-writer round (`capstone-iter077`) + blueprint-clean have since landed. Confirm each is now
resolved (or flag if not):

1. **Seam (a)** — was "NOT definitional, missing sub-lemma." Now added as
   `lem:pushforward_mapHC_cechComplexOnX` (`\lean{AlgebraicGeometry.pushforward_mapHomologicalComplex_cechComplexOnX}`).
   Check: statement + proof sketch adequate to formalize the additive-functor / `map_sum` argument.
2. **Seam (b)** — was "non-trivial conversion, missing sub-lemma." Now added as
   `lem:cechAugmented_to_acyclicResolutionInput`. Check: the augment index-shift + `e:F≅cycles 0`
   extraction is spelled out enough.
3. **`lem:rightAcyclic_finite_prod`** (new): finite product of acyclic objects acyclic — check
   statement/proof/`\uses`.
4. **`lem:cech_computes_cohomology_affineCover`** (new, the TRUE Stacks-02KE capstone with explicit
   `h𝒰`/`[X.IsSeparated]`): check the assembly proof sketch (steps a–d) and `\uses` are complete and
   the counterexample remark is mathematically correct.
5. **Covers**: `% archon:covers` now lists `CechToHigherDirectImage.lean`; confirm. (Note: a sibling
   `CechTermAcyclic.lean` is being added this iter holding `rightAcyclic_finite_prod` +
   `cechTerm_pushforward_acyclic`; both are blueprinted in THIS chapter — flag if the covers line
   should list it too, but its absence is being fixed in the same iter.)
6. **`lem:cech_term_pushforward_acyclic`** `\uses` was missing `lem:pushPull_sigma_iso` +
   `lem:rightAcyclic_finite_prod`; confirm now present.

## Verdict needed
Per-chapter `complete`/`correct` for `Cohomology_CechHigherDirectImage.tex`, plus any remaining
must-fix-this-iter findings that would block a prover on the two capstone leaf files.
