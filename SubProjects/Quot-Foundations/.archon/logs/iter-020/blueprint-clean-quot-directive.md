# Blueprint Clean Directive

## Slug
quot

## Target chapter
`blueprint/src/chapters/Picard_QuotScheme.tex` (ONLY this chapter).

## Context
A `blueprint-writer` round this iter (`quot-iter020`) added/revised these blocks in this chapter:
- New base-case lemma `lem:graded_subquotient_base_eventuallyZero` (with ROUTE (a)/(b) discipline
  `% NOTE:` blocks) and a revised `lem:graded_subquotient_isRatHilb` base case.
- A new "Finiteness-transfer infrastructure" subsubsection (7-pin `lem:graded_lastVarAlgHom`
  definition, `lem:graded_polyEndHom_mem_of_stable`, `lem:graded_polyEndHom_lastVar_sub_mem`,
  `lem:graded_polyQuot_finite_of_le_numerator`, `lem:graded_polyQuot_finite_of_le_denominator`).
- A new "Subquotient constructors" subsubsection (`lem:graded_ker_stable_full`,
  `lem:graded_coker_stable_full`, `def:graded_subquotientDatum_ker`,
  `def:graded_subquotientDatum_coker`) and a re-stated `lem:graded_subquotient_finite_transfer`.
- Six `\mathlibok` dependency anchors.

## Job
Standard purity pass over the chapter, focused on (but not limited to) the blocks above:
- Strip any **Lean syntax leakage** from rendered prose and from `% NOTE:` blocks — concrete Lean
  identifiers used as *prose* (e.g. `Submodule.mem_iSup_iff_exists_dfinsupp`, `Submodule.liftQ`,
  `Module.Finite.of_surjective`, `DirectSum.decomposeLinearEquiv`) should be replaced by their
  mathematical descriptions in the visible prose. Mathlib identifiers inside `\lean{}` /
  `\mathlibok` anchor pins are fine and must be PRESERVED.
- Remove project-history / iteration-narrative verbosity ("iter-NNN", "this iter", "route (a) dead
  end because the prover…") from rendered prose. The route (a)/(b) DISTINCTION is mathematically
  meaningful and should be KEPT as a concise mathematical remark (which degree-component argument is
  used), but stripped of prover/iter framing.
- Validate `% SOURCE` / `% SOURCE QUOTE` citations are present and verbatim on blocks that derive
  from `references/hilbert-serre-algebra.tex`; if a quote is missing where a source is cited, insert
  it from the local source file.

## Out of scope
- Do NOT remove or rename any `\lean{}`, `\label{}`, `\uses{}`, or `\mathlibok`.
- Do NOT add or remove `\leanok`.
- Do NOT touch any other chapter.
- `references/**` is in your write-domain only so a child reference-retriever can be spawned if a
  cited quote is genuinely missing locally (not expected).
