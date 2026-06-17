# Blueprint-clean directive — iter-064

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Context
A blueprint-writer round this iter (slug `decompose-iter064`) decomposed two terminal lemma chains into
fine-grained sub-lemmas and corrected one definition (φ''):
- Part A: new blocks `lem:sigmaOptionIso`, `lem:pushPullObjCongr`, `lem:over_sigmaOptionIso`, `lem:piOptionIso`,
  `lem:pushPull_coprod_prod_empty`, coverage `lem:pushPullCoprodLegIso`; rewrote `lem:pushPull_coprod_prod`'s proof.
- Part B: new blocks `lem:slice_overs_equiv_continuity`, `lem:slice_reverse_ring_map`,
  `lem:pushforward_slice_adjunction_h1`, `lem:pushforward_slice_adjunction_h2`; corrected φ'' in
  `lem:pushforward_slice_two_adjunction` + `lem:pushforward_slice_pullback_iso`; added 4 `\mathlibok` anchors.

## Task
Enforce blueprint purity on the edited regions (and the chapter generally if you spot drift):
- Strip any Lean tactic syntax / Lean identifiers that leaked into PROSE (the `\lean{}`/`\uses{}` machinery and
  named Mathlib/declaration anchors are fine; bare tactic strings or `rfl`/`eqToHom`/`simp`-style leakage in the
  informal prose is not).
- Remove project-history / iter-narrative verbosity if any crept in.
- Confirm every new `\uses{label}` resolves to an existing `\label` in the chapter.
- Do NOT add or remove `\leanok`. Do NOT alter mathematical content or `\mathlibok` anchors.
