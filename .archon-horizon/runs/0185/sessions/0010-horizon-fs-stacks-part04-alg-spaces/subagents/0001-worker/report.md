Added [FreeAction.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part04_AlgebraicSpaces/StacksPart04Lib/FreeAction.lean:25), proving:

- `isFree_iff_actionPair_injective`, the pointwise content of Stacks tag 06P9.
- `isFree_iff_hom_subsingleton`, characterizing freeness as thinness of the action groupoid.

Verified with LSP, `lake env lean StacksPart04Lib/FreeAction.lean`, and axiom/source scans. Commit: `77adb775878535b82c946dab8cf84d95ad45f764`.

The shared ledger index also swept in a concurrent Part06 file despite explicit staging. I did not revert it; the parent has been notified.
