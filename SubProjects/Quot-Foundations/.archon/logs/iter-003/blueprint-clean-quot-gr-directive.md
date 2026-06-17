# blueprint-clean directive

## Chapters to clean (edited this iter by blueprint-writers)
- `blueprint/src/chapters/Picard_QuotScheme.tex` — rewritten to the graded
  Hilbert-function encoding of `def:hilbert_polynomial`; new `\section{Graded Hilbert
  polynomial}` with `def:sectionGradedRing`, `def:sectionGradedModule`,
  `lem:sectionGradedModule_fg`, `lem:hilbertPoly_exists_mathlib` (`\mathlibok`),
  `lem:gradedHilbertSerre_rational` (project-own), `thm:hilbertPoly_of_sectionModule`.
- `blueprint/src/chapters/Picard_GrassmannianCells.tex` — NEW chapter: `def:gr_affine_chart`,
  `def:gr_transition`, `lem:gr_cocycle`, `def:gr_glued_scheme`, `lem:gr_separated`,
  `lem:gr_proper`.

## Task
Standard purity pass on these two chapters ONLY:
- Strip any Lean tactic syntax / Lean-code leakage from prose and proofs (math only).
- Strip project-history / per-iter narrative verbosity (e.g. "iter-NNN", "queued task",
  "this iteration") — keep the math.
- Validate the `% SOURCE` / `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` blocks against the
  named local files (`references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`;
  Mathlib `HilbertPoly.lean` for the `\mathlibok` anchor). If a verbatim quote is missing
  or paraphrased, insert/correct it from the source (you may spawn a reference-retriever
  into `references/**` if a needed source is genuinely absent locally).
- Do NOT change any `\lean{}` pin, `\label`, `\uses` edge, `\mathlibok`, or `\leanok`
  marker. Do NOT touch any other chapter. Do NOT alter the mathematical content of the
  declarations — purity only.
