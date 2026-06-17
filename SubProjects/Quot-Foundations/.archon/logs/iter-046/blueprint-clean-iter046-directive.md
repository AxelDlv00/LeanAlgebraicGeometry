# Blueprint-clean — iter-046

Purify the chapters edited this iter. Strip Lean tactic syntax, project-history/iter-NNN narrative, and
verbosity from prose; validate `% SOURCE` / `% SOURCE QUOTE` discipline (verbatim, original language) and
insert missing source quotes from the cited reference files where a block claims a source but lacks the
verbatim quote.

Chapters edited this iter (focus here; light-touch elsewhere):
- `Picard_SectionGradedRing.tex` — NEW chapter (tensor powers → lax-monoidal Γ → graded assembly). Check the
  `\mathlibok` anchors are genuine Mathlib deps and the Stacks 01CA/01CU/01CV quotes are verbatim.
- `Picard_FlatteningStratification.tex` — G1 re-decomposed (base-case seams + 2 coverage-debt helper blocks).
  Verify the Stacks 01PB quote and that the base-case prose is math-only (no Lean).
- `Cohomology_FlatBaseChange.tex` — 2 new project-bespoke definition blocks (`def:keystone_adjR`,
  `def:keystone_beta`); no external source (omit SOURCE lines is correct). Strip any Lean leakage.
- `Picard_QuotScheme.tex` — only `\uses` edges added to `def:sectionGradedRing`/`def:sectionGradedModule`.

Do NOT add/remove `\leanok`. Do NOT alter `\lean{}` pins or `\label{}`s. Preserve `\mathlibok` anchors.
