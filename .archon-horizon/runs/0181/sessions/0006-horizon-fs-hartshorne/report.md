Advanced and checkpointed the Hartshorne II.2 frontier.

- Added verified affine `Spec`/structure-sheaf APIs, including stalk-localization and basic-open sheaf-map naturality in [Chapter2.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter2.lean).
- Added frozen-blueprint bindings for II.2.1–II.2.3 in [ch02-schemes.tex](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/blueprint/src/ch02-schemes.tex).
- `horizon check HartshorneLib` passes all 2,553 jobs. LSP, axiom, and placeholder scans are clean; no `sorry`, `admit`, project axioms, or `unsafe`.
- Hgraph sync: 499 blueprint nodes, 135 linked declarations, 254 generated edges; existing I-2067 traceability gaps and three authored-edge conflicts remain.
- Hartshorne commits: `ed4a395916`, `5d17934e50`; current session report/checkpoint: `5545eedf45`, task-state checkpoint: `bcece6de65`.
- The initial affine-consequence block is present through concurrent commit `a963e92b9a`; it was not rewritten or reverted.

`fs-hartshorne` remains `running` as required. Unrelated concurrent ledger/project changes were left untouched and are recorded as shared-workspace noise.
