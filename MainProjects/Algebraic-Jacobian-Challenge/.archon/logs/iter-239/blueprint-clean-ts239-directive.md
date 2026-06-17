# blueprint-clean directive — iter-239, slug `ts239`

## Chapter
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — focus on the NEW section
`\section{Pullback-monoidality: invertibility under a general scheme morphism}`
(`\label{sec:tensorobj_pullback_monoidality}`) added this iter by the `invpull` writer, containing
`lem:pullback_tensor_iso`, `lem:pullback_unit_iso`, `lem:isinvertible_pullback`. Also sanity-check the
two small plan-agent prose edits to `lem:tensorobj_assoc_iso` (title now "(unconditional)"; the stale
`IsLocallyTrivial`-hypothesis note replaced).

## What to enforce
- Strip any Lean leakage (tactic strings, `#print`, Lean syntax) from the new proof sketches — they must
  be mathematical prose only.
- Strip project-history / iter-narrative verbosity if present.
- Validate the verbatim `% SOURCE QUOTE` (Stacks `lemma-tensor-product-pullback`, L2392–2400) and
  `% SOURCE QUOTE` + `% SOURCE QUOTE PROOF` (Stacks `lemma-pullback-invertible`, L4142–4147 / L4149–4157)
  are byte-accurate against `references/stacks-modules.tex`. `lem:pullback_unit_iso` is Archon-original
  (no external source) — confirm it correctly carries NO `% SOURCE` lines.
- Do NOT add or remove `\leanok` / `\mathlibok`.
- Do NOT alter the group-law section or any other chapter.

You are authorized `references/**` (for quote validation / a child reference-retriever only if a quote
cannot be validated against the local file).
