Advanced and committed Part 04 Algebraic Spaces formalization.

- Added verified APIs in [RepresentabilityAdvanced.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part04_AlgebraicSpaces/StacksPart04Lib/RepresentabilityAdvanced.lean), [Products.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part04_AlgebraicSpaces/StacksPart04Lib/Products.lean), and [Descent.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part04_AlgebraicSpaces/StacksPart04Lib/Descent.lean).
- Integrated all modules through [StacksPart04Lib.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part04_AlgebraicSpaces/StacksPart04Lib.lean).
- Tightened hgraph formalization links to retain only source-signature matches; blueprint files were unchanged.
- Commits include `49dec51e36`, `b21518bcd5`, `b6fce7036b`, `dab75c1e69`, `fe23442eee`, `7ed699ba45`, and `7f677beaa6`.

Verification passed:

- `lake build StacksPart04Lib` (837 jobs)
- Horizon Lean checks for the library and root module
- Focused kernel checks for all new modules
- Forbidden-placeholder scan (`sorry`, `admit`, `axiom`, `unsafe`) is empty
- Project-scoped Horizon git status is clean
- Hgraph: 2,065 nodes, 175 edges, 164 hard edges, 11 exact `formalizes` edges, stale count 0

A progress comment was accepted, and the standing task remains `running` as required. The next frontier is source-specific geometric/site descent and algebraic-space groupoid/quotient formalization.
