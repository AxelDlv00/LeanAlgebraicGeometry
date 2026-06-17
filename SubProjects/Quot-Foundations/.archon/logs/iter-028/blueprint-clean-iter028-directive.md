# Blueprint-clean directive — iter-028 post-writer purity gate

Three chapters were edited this iter by blueprint-writers. Clean them: strip any Lean-syntax leakage
(tactic strings, `rw`/`erw`/`simp`/`subst`, Lean term-mode fragments, raw lemma-application syntax) from
the PROSE — keeping mathematical content, `\lean{}`/`\uses{}`/`\label{}` machinery, `% SOURCE`/`% SOURCE
QUOTE` comments, and `\mathlibok` anchors intact. Remove project-history/iteration verbosity from prose
bodies (e.g. "the iter-026 prover", "this iter", attempt narratives) — those belong in sidecars, not the
blueprint. Validate that every `% SOURCE QUOTE` present is a faithful verbatim quote of its named source;
if a quote is missing for a block that cites an external source, flag it (you may spawn a reference-retriever
via your `references/**` domain if a source file is needed).

## Chapters to clean
- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — the Seam-A routing reconciliation (writer
  `fbc-reroute`): check the revised narrative blocks (`% --- Seam A …`, `lem:base_change_mate_inner_value_eq`,
  `lem:base_change_mate_fstar_reindex_legs`, the new `lem:base_change_mate_inner_eCancel_assemble`) for Lean
  leakage and iteration narrative. The "definitional vs propositional leg equality / dependent-motive
  obstruction" language is legitimate mathematics — keep it (rephrase only if it reads as Lean-tactic
  commentary).
- `blueprint/src/chapters/Picard_QuotScheme.tex` — the Route-F rewrite (writer `quot-routef`): the G1-core
  proof body, the new G1-assemble subsection, and the 12 new `\mathlibok` anchors. Keep the Mathlib decl
  names inside `\lean{}` (that is what anchors are), but strip any bare Lean syntax from the surrounding
  prose. Keep the Stacks 01HA `% SOURCE QUOTE`.
- `blueprint/src/chapters/Picard_GrassmannianCells.tex` — the new "Scheme-level glue-data layer" section +
  the expanded `def:gr_glued_scheme` construction paragraph (writer `gr-glue`). Keep the Nitsure
  `% SOURCE QUOTE`.

## Boundaries
Do NOT add or remove `\leanok` (sync_leanok's job). Do NOT change `\mathlibok` placement (review-agent /
writer domain — only strip leakage, do not re-judge anchors). Do NOT alter the mathematical statements or
the `\uses{}` dependency edges the writers established.
