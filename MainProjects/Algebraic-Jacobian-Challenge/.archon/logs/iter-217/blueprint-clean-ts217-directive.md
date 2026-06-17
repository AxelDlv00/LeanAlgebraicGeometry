# Blueprint-clean directive (iter-217)

## Target
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` was just edited by
blueprint-writer ts217 (two proof blocks rewritten: `lem:tensorobj_restrict_iso` and
`lem:tensorobj_assoc_iso`; a new companion lemma block
`lem:restrictscalars_ringiso_strongmonoidal` pinning 5 ModuleCat-level H2 declarations).

## Task
Run your standard post-write purity pass on this chapter:
- Strip any Lean syntax / tactic leakage, project-history or iter-narrative verbosity
  that crept into the prose (e.g. "iter-216", "the prover did X", route-letter
  bookkeeping that is not mathematical content).
- Verify every `% SOURCE:` has a matching verbatim `% SOURCE QUOTE:` and a visible
  `\textit{Source: ...}` line; the writer cited the `(f^*, f_*)` adjunction from
  `references/stacks-modules.tex` (Lemma `lemma-exactness-pushforward-pullback`) —
  confirm the quote is verbatim against that local file and insert it if missing.
- Confirm LaTeX environments are balanced and all `\cref`/`\uses`/`\label` are
  well-formed.
- Do NOT touch `\leanok` / `\mathlibok` markers.

## Authorization
Your write-domain includes `references/**` so you may spawn a `reference-retriever`
child if a SOURCE QUOTE is missing its local source. Edit only the one chapter.
