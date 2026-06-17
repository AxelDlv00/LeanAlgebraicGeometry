# Blueprint Clean Directive

## Slug
iter003

## Chapters to clean (both edited this iter by blueprint-writers)
1. `blueprint/src/chapters/Cohomology_AcyclicResolution.tex`
   - A blueprint-writer just fixed the `lem:homology_long_exact_sequence` Mathlib anchor
     (now names `homology_exact₁/₂/₃` + `δ`). Verify the anchor block reads cleanly and is
     a proper Mathlib anchor (`\textit{Provided by Mathlib.}`, `\lean{}`, `\mathlibok`).
2. `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
   - A blueprint-writer rewrote the `lem:push_pull_comp` proof body (the old
     `conjugateEquiv` route) and added `def:push_pull_functor` + `def:cech_nerve_cosimplicial`.
   - **Priority: strip any Lean leakage / project-history phrasing** that may have crept
     into the new `lem:push_pull_comp` proof body or the new definition blocks (no Lean
     tactic names, no "raw form"/"subst"/"whnf"/"iter" implementation jargon presented as
     math — the body must read as a timeless mathematical sketch: pentagon coherence of the
     pullback pseudofunctor + composite-unit decomposition + transport coherence). Keep the
     mathematical content; remove the syntactic/process residue.

## Scope
Purity + LaTeX validity + citation discipline only. Do NOT alter mathematical content,
statements, or `\uses{}`/`\label{}` structure beyond formatting fixes. Do NOT add
`\leanok`. The Mathlib anchors here are re-exports and need no external `% SOURCE QUOTE`.

## Note
`references/**` is in your write-domain in case a missing quote requires a retriever, but
no new external sources are expected for this cleanup (both edits are internal: a Mathlib
anchor and project-bespoke definitions).
