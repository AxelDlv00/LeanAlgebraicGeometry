# Blueprint-clean directive — iter-032

Three chapters were edited this iter by writers/effort-breaker. Clean them: strip any Lean syntax /
tactic leakage, project-history or per-iter narrative, and verbosity; validate `\uses{}` resolves;
ensure required source quotes are present for externally-sourced blocks.

## Chapters to clean

1. `blueprint/src/chapters/Picard_GrassmannianCells.tex` — added `def:gr_the_glue_data`,
   `lem:gr_chartTransition'_cocycle`, `lem:gr_awayMulCommEquiv_comp_awayInclLeft` (project-bespoke, no
   external source — these correctly have no `% SOURCE`).
2. `blueprint/src/chapters/Picard_QuotScheme.tex` — added `def:over_restrict_equiv`,
   `lem:over_restrict_functor_iso`, `lem:over_restrict_pullback_iso` (project-bespoke); P1 node
   `\uses{}` re-wired.
3. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — FBC-B (`thm:flat_base_change_pushforward`)
   decomposed into a 7-block `\uses`-chain (1 Mathlib anchor + 6 to-build sub-lemmas around the
   H⁰-as-finite-equalizer packaging). Verify the Mathlib anchor's `% SOURCE` cites a real file and the
   sub-lemma statements carry no Lean tactic strings.

Do NOT touch `\leanok` markers. `\mathlibok` only on genuine Mathlib anchors. Report any `\uses` that
fails to resolve.
