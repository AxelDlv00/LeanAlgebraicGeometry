# blueprint-clean bc252 — directive

Target: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (the chapter blueprint-writer bw252
just edited this iter — three updates: a new `lem:dual_unit_iso` block; the (A)+(B) two-leg rewrite of
`lem:dual_restrict_iso` Step 4; one math sentence in `lem:pullback_tensor_map_natural`'s proof).

Enforce blueprint purity on these edits:
- Strip any Lean syntax / tactic leakage or Lean-elaboration idiom that crept into the new prose
  (the (A)+(B) decomposition and the D1′ sentence must read as mathematics, not Lean).
- Strip project-history / per-iter narrative ("iter-251", "the prover discovered…", consult slugs) from
  any visible prose; such references belong in `analogies/`, not the blueprint.
- Validate the new `\uses{}`/`\cref{}` edges resolve to existing labels.
- Do NOT add or remove `\leanok`/`\mathlibok`. Do NOT alter the pre-existing `% SOURCE`/`% SOURCE QUOTE`
  citation blocks (they were left verbatim by the writer).
- If a new statement block legitimately needs a verbatim source quote it lacks, you may dispatch a
  reference-retriever — but `lem:dual_unit_iso` is an Archon-original project lemma (evaluation-at-1 on
  the internal-hom unit), so no external source is required; leave it source-free if so.

Light pass — only the bw252 edits are in scope; do not rewrite untouched blocks.
