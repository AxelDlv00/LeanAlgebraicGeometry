# Blueprint Clean Directive

## Slug
iter009

## Chapters to clean (edited this iter — validate + purify)
1. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — FBC route swap (mate tower dropped;
   new `lem:base_change_mate_section_identity`; `lem:base_change_mate_regroupEquiv` reconstructed
   on `Algebra.IsPushout.cancelBaseChange`; new `\mathlibok` anchor
   `lem:isPushout_cancelBaseChange_mathlib`).
2. `blueprint/src/chapters/Cohomology_RegroupHelper.tex` — `base_change_regroup_linearEquiv`
   construction prose rewritten to the pushout core.
3. `blueprint/src/chapters/Picard_FlatteningStratification.tex` — GF effort-break: new
   `lem:gf_torsion_annihilator`, `lem:gf_nagata_monic_lastVar`,
   `lem:gf_mvPolynomial_quotient_finite_monic`, the Mathlib anchors
   `lem:annihilator_meets_nonZeroDivisors` / `lem:polynomial_monic_quotient_finite`, and the
   rewired `lem:gf_torsion_reindex` proof. (This chapter was written by an effort-breaker whose
   process was interrupted before it emitted a completion report — give it a careful pass for any
   half-finished prose, dangling environments, or Lean-syntax leakage.)

## What to enforce (per your descriptor)
- Strip Lean tactic syntax / Lean-code leakage from prose and proofs (the blueprint is math-only;
  `% LEAN SIGNATURE` comment blocks and `\lean{}`/`\uses{}`/`\label{}` macros are allowed and must
  be preserved).
- Strip project-history / per-iter narrative from prose (e.g. "iter-008", "the prover refused",
  "this iter") — keep the mathematics; iteration history is not blueprint content. The
  `% ===` effort-break banner comment in the GF chapter is fine to keep (it is a structural map),
  but remove any "iter-009"-style narrative from rendered prose.
- Validate every `% SOURCE:` / `% SOURCE QUOTE:` / `\textit{Source:}` triple: the quote must be
  verbatim from the named local file. If a block derives from a reference but is missing a
  verbatim quote, insert it (you may spawn a reference-retriever if the source file is absent —
  `references/**` is in your write-domain). Do NOT invent quotes.
- Confirm LaTeX environment balance and that no `\uses{}` references a non-existent label.
- Do NOT add or remove `\leanok` (sync owns it). Do NOT change `\mathlibok` placement except to
  REMOVE it if you find it on a non-Mathlib (project-to-be-proved) declaration.

## Out of scope
All other chapters. Do not alter mathematical content or signatures — only purify, validate, and
insert missing verbatim source quotes.
