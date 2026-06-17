# Blueprint-clean — Picard_GrassmannianCells.tex (post effort-break)

The chapter `blueprint/src/chapters/Picard_GrassmannianCells.tex` was just rewritten by
an effort-breaker that decomposed `def:gr_transition` into a 7-step matrix-algebra chain
(`def:gr_universal_matrix`, `def:gr_minor_det`, `def:gr_universal_minor`,
`lem:gr_minorDet_unit`, `def:gr_universalMinorInv`, `lem:gr_universalMinorInv_identities`,
`def:gr_image_matrix`, `def:gr_transition_pre`, `lem:gr_transition_pre_unit`,
`def:gr_transition`, `lem:gr_transition_self`) plus 5 `\mathlibok` Mathlib anchors.

Clean this chapter to blueprint purity standards:
- Strip any Lean tactic syntax / code leakage from prose or proof bodies (the
  `% LEAN SIGNATURE` comment blocks are allowed to carry Lean signatures — those are
  the prover's contract — but the visible prose must be math-only).
- Remove project-history verbosity / iter-NNN narrative from prose.
- Validate the `% SOURCE` / `% SOURCE QUOTE` Nitsure §1 citations are present on the
  blocks that need them and that the verbatim quotes match the local source file
  `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex`.
- Confirm LaTeX is balanced and all `\uses{}` labels resolve (the doctor was clean;
  re-confirm after your edits).
- Do NOT add or remove `\leanok` (the deterministic sync owns it). Do NOT touch
  `\mathlibok` on the genuine Mathlib anchors.

Scope: this one chapter only.
