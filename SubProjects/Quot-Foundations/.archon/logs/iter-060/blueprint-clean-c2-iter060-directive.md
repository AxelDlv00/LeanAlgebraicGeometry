Target: blueprint/src/chapters/Picard_GrassmannianQuot.tex
Action: Post-effort-break purity pass. The effort-breaker (iter-060) split `lem:gr_bundleCocycle_mul`
(C2) into sub-lemmas `bundleTransition_cocycle_matrix` (L1), `matrixToFreeIso_mul` (L2),
`bundleTransition_cocycle_transport` (L3) + ~7 supporting infra blocks. Strip any Lean syntax / tactic
strings / project-history verbosity that leaked into the new blocks; ensure each new block's prose is
math-only and self-contained; verify \uses{} targets resolve. Do NOT touch \leanok/\mathlibok.
Constraints: edit ONLY this chapter. Math content of C1/C2 and the GL_d cocycle must be preserved.
