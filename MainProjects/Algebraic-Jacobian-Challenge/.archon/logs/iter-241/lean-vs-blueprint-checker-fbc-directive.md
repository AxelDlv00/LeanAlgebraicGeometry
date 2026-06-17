# Lean ↔ blueprint check — FlatBaseChange (iter-241)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## What changed this iter
`pushforward_spec_tilde_iso` was closed (its last residual `hsq` square proved); the file
sorry count dropped 3 → 2. The two remaining sorries are `affineBaseChange_pushforward_iso`
(~L682) and `flatBaseChange_pushforward_isIso` (~L704).

## Specifically check
- Whether each `\lean{...}` pin in the chapter resolves to a real decl of the matching
  signature (esp. `lem:pushforward_spec_tilde_iso`, `lem:gammaPushforwardIsoAt`,
  `lem:gammaPushforwardTildeIso`).
- The chapter references `lem:gammaPushforwardIsoAt_naturality` in a `\uses{}` list (~L554).
  Does a `\label{lem:gammaPushforwardIsoAt_naturality}` exist anywhere, and is there a
  corresponding decl? (The prover reported its content is now inlined as the `hsq` step
  inside `pushforward_spec_tilde_iso`, with no standalone decl.)
- Whether the blueprint proof prose for `pushforward_spec_tilde_iso` still matches the
  actual Lean proof after the `eqToIso → restrictScalarsCongr` refactor.
- Whether the chapter is detailed enough to have guided the still-open
  `affineBaseChange_pushforward_iso` (pullback-of-tilde dictionary + cancelBaseChange).

## Output
Bidirectional report (Lean→blueprint AND blueprint→Lean), with any must-fix-this-iter
findings called out. Write to `task_results/lean-vs-blueprint-checker-fbc.md`.
