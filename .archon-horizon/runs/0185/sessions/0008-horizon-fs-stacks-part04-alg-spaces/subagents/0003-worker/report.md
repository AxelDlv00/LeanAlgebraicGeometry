Added the requested Part04 fibered-category APIs:

- [FiberedGroupoids.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part04_AlgebraicSpaces/StacksPart04Lib/FiberedGroupoids.lean)
- [FiberedSetoids.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part04_AlgebraicSpaces/StacksPart04Lib/FiberedSetoids.lean)

They port the checked Part07 declarations for fibered groupoids/setoids, iff/build characterizations, fiber hom isomorphisms, vertical isomorphisms, and thin-fiber hom uniqueness. No `sorry`, `admit`, or `axiom`; umbrella imports were intentionally untouched.

Verification passed:

- `lake build StacksPart04Lib.FiberedGroupoids`
- `lake build StacksPart04Lib.FiberedSetoids`
- Horizon serialized checks for both files
- Post-edit LSP diagnostics: clean
- `git diff --check`: clean
