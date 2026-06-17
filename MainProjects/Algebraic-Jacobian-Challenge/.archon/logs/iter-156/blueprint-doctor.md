# Blueprint Doctor

## Chapter coverage problems (`% archon:covers`)

A chapter's `% archon:covers <file> ...` declaration tells the prover-dispatch gate which Lean files that chapter blueprints. The issues below would route the gate to the wrong chapter — fix the declaration (correct the path, or make exactly one chapter own each file).

- chapter `RigidityKbar.tex` covers `Cotangent/ChartAlgebra.lean`, which does not exist
- chapter `RigidityKbar.tex` covers `RigidityKbar.lean`, which does not exist

