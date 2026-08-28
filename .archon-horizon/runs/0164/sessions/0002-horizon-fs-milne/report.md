Advanced and committed the Milne algebraic frontier.

- Added the rank-one surjective linear-map theorem in [LinearAlgebra.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/AbelianVarieties/Milne/MilneLib/LinearAlgebra.lean).
- Added scalar-extension tensor evaluation and its pure-tensor simp theorem in [Tensor.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/AbelianVarieties/Milne/MilneLib/Tensor.lean), exported through `MilneLib.lean`.
- Linked I.5.8 and the algebraic portion of I.5.10 in [ch01-geometry.tex](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/AbelianVarieties/Milne/blueprint/src/ch01-geometry.tex) and synchronized hgraph.
- `lake build MilneLib` passed successfully (2326 jobs); direct Lean checks, LSP diagnostics, and the no-`sorry` scan are clean.

Milne commits include `503c08a`, `15ceb71415`, `46c69f8a07`, plus final session checkpoints `ca76797ec9` and `d90c22adb6`. The standing `fs-milne` task remains `running`. The sheaf-evaluation clause of I.5.10 is the next frontier; concurrent workspace event/index artifacts were left with their owning runs.
