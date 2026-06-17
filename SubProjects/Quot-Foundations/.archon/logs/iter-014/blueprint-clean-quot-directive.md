# Blueprint-clean directive — Picard_QuotScheme.tex (post graded-API writer round)

## Chapter
`blueprint/src/chapters/Picard_QuotScheme.tex` (ONLY this file).

## Context
A blueprint-writer just added subsection `subsec:gradedModuleApi` (the graded-grading wrapper G1–G5
+ D5 + 6 `\mathlibok` anchors) and re-pointed the `lem:gradedHilbertSerre_rational` inductive-step
proof. Run the standard post-writer purity gate on this chapter.

## Tasks
- Strip any Lean-syntax leakage from informal prose (raw identifiers like `DirectSum.Decomposition`,
  `SetLike.GradedSMul`, `QuotSMulTop`, `mkQ`, `Ideal.Quotient.mk` appearing as Lean code rather than
  as named mathematical objects — they are fine inside `\lean{}`/`\mathlibok` pins and `%` comments,
  NOT in displayable prose).
- Remove any project-history / iter-N / "prover" / "next-iter" verbosity that leaked into prose.
- Validate `\label`/`\lean`/`\uses` well-formedness; confirm the new chain is `\uses`-linked into
  `lem:gradedHilbertSerre_rational` and introduces no isolated nodes.
- Do NOT touch `\leanok` (sync phase owns it). Leave `\mathlibok` anchors as-is. Do NOT alter
  mathematical statements.
- Verify any `% SOURCE`/`% SOURCE QUOTE` blocks present remain accurate; insert missing source
  quotes only if a block claims an external citation it lacks.
