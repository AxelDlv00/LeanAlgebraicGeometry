# Blueprint-clean directive

## Target
`blueprint/src/chapters/Picard_QuotScheme.tex` — just received 8 new blocks (effort-breaker route-1 Piece A
chain L1–L6 + 2 Mathlib anchors) plus a planner-added block `lem:isLocalizedModule_basicOpen_of_hP1`.

## Action
Purity pass on the NEW blocks only: strip any Lean tactic syntax / leaked term-mode glue from prose, remove
project-history or iter-narrative verbosity, ensure each block's prose is math-only and self-contained.
Verify the 2 Mathlib-anchor blocks (`lem:presentation_isQuasicoherent_mathlib`,
`lem:isQuasicoherent_of_coversTop_mathlib`) carry a correct `\lean{}` + `\mathlibok` and a one-line
statement. Do NOT touch `\leanok`. Do NOT alter `\label`/`\lean{}`/`\uses` targets (the dependency graph
was just validated clean). Leave older blocks untouched.
