# Lean Auditor Directive

## Slug
iter020

## Scope (files)
all

## Focus areas (optional)
- `AlgebraicJacobian/Picard/QuotScheme.lean` — received prover work this iter (a base-case
  `iSupIndep` leaf was closed; a new private helper `iSupIndep_map_of_mem_ker_sup` was added).
  Pay attention to whether any large comment block near the closed leaf is now stale
  (describing the closed goal as still-open / as a "residual sorry" / "OBSTRUCTION").
- `AlgebraicJacobian/Picard/FlatteningStratification.lean` — received prover work this iter
  (`genericFlatnessAlgebraic` dévissage motive + 2 of 3 obligations closed; one obligation and
  the L4 finiteness leaf remain `sorry`). Check whether the `sorry`-bearing blocks carry honest
  scaffolding comments vs. excuse-comments, and whether any comment describes a state that no
  longer matches the code.

## Known issues
- The 4 file-skeleton stubs in QuotScheme.lean (lines ~126/165/201/228) are deliberate typed
  `sorry` placeholders for a downstream file skeleton — already known, do not re-flag as must-fix.
- `genericFlatness` (GF-geo) and the L4 finiteness leaf in FlatteningStratification.lean are
  known-open honest residuals (out of scope this iter) — flag only if the comments are dishonest
  about that status.
