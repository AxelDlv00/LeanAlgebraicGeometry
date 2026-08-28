## Progress

- Added `degreeClass_principalDivisor` to [Chapter4DegreeClass.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter4DegreeClass.lean:81), conditional on the existing principal-degree-zero hypothesis. Commit `8e8fb68f58`.
- Added zero-class and equal-class principal-difference characterizations to [Chapter4DivisorClass.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter4DivisorClass.lean:99). Commits `f87d575820` and `29a0612fe2`.
- The temporary affine-spectrum `\leanok` marker was reverted in `bfedf2ba86` to comply with protections I-2034/I-2067; the frozen blueprint is unchanged.
- Final hgraph sync: 773 nodes, 330 edges, 274 Lean declarations; both new declarations are `lean_ok`, while affine spectrum remains honestly `linked` with 14 downstream unlocks.

## Verification

`lake build HartshorneLib` passed all 3108 jobs, and the focused divisor-class module passed 2969 jobs. LSP diagnostics are clean; both new theorems use only standard axioms (`propext`, `Classical.choice`, `Quot.sound`). No `sorry`, `admit`, or project axioms occur in `HartshorneLib`. The scoped ledger worktree is clean.

The sync still reports expected unattached Lean declarations and authored-edge conflicts because the blueprint remains frozen. Inbox protections were acknowledged, no unread conversations were present, and the task remains `running` with progress recorded in `C-0015`/`C-0016`.

## Why I stopped

This run advances the divisor-class API, but Hartshorne II.6.10, the genuine proof that principal divisors have degree zero, remains hypothesis-gated. Its geometric/product-formula infrastructure is not yet present in Hartshorne, so no unsupported axiom or false blueprint closure was added.
