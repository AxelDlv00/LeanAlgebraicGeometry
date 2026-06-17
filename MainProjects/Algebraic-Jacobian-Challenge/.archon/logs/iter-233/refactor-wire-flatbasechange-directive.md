# Refactor directive — wire FlatBaseChange into the aggregator (iter-233)

## Task (mechanical, single import line)
The file `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` exists, builds standalone
green (8317 jobs, 2 expected sorry warnings), and is axiom-clean except for its 2
documented sorries — but it is NOT imported by the package aggregator
`AlgebraicJacobian.lean`, so its declarations are invisible to the canonical build
and its 2 sorries are uncounted.

Add the line:
```
import AlgebraicJacobian.Cohomology.FlatBaseChange
```
to `AlgebraicJacobian.lean`, placed alongside the other `import AlgebraicJacobian.Cohomology.*`
lines (keep them grouped/sorted with the existing Cohomology imports near the top of the file).

## Constraints
- This is a pure import-wiring change. Do NOT modify `FlatBaseChange.lean` itself, do
  NOT touch any proof, do NOT remove or add any sorry.
- Do NOT slim `FlatBaseChange.lean`'s `import Mathlib` this iter (deferred polish).
- After the edit, run `lake build` and confirm it completes (the only new warnings
  should be the 2 sorry warnings from `FlatBaseChange.lean`). Report the exit status
  and the new total sorry-warning count.

## Write domain
Only `AlgebraicJacobian.lean`.
