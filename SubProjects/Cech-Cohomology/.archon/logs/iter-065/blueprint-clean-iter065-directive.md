# Blueprint-clean directive — slug `iter065`

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Context
A blueprint-writer round (slug `gate065`) just added/expanded the following blocks in this chapter:
- NEW `lem:coprodToProd_isIso_of_equiv` (reindexing leaf) — statement + proof.
- NEW `def:coprodOverIncl`, `def:coprodToProdMap` (framing definitions).
- NEW `lem:coprodToProd_isIso_option` (closed Option-step, for record).
- REALIGNED proof of `lem:pushPull_coprod_prod_empty` (now the `IsZero`-over-empty-scheme route).
- EXPANDED proof of `lem:slice_reverse_ring_map` (φ'' part (a)/(b) pointers).
- Edits to `lem:pushPull_coprod_prod`'s "Reindexing" paragraph + `\uses{}`.

## Your job
Enforce blueprint purity on this chapter (focus on the just-edited regions, but scan the whole chapter):
- Strip any Lean tactic syntax / Lean-identifier leakage from PROSE (the math should read as mathematics;
  Mathlib construction names like `Sigma.whiskerEquiv`, `Pi.lift`, `Functor.sheafPushforwardContinuousComp'`,
  `Over.map`, `Over.post`, `Sigma.desc` are the project's accepted notation for these constructions and may
  remain where they denote a specific construction — but remove anything that reads as a tactic block or
  proof-state dump).
- Remove project-history / iteration-narrative verbosity if any crept in (e.g. "iter-064", "the prover
  found", "CLOSED axiom-clean" inside prose — `% NOTE` comments documenting build state are acceptable).
- Verify all `\uses{}` labels resolve and the new blocks are well-formed LaTeX.
- Do NOT touch `\leanok` (owned by sync_leanok). Do NOT add `\mathlibok` to project-bespoke blocks.
- If a citation/quote is genuinely needed for any block, you may spawn a reference-retriever — but these
  are Archon-original constructions with no external source, so none should be required.
