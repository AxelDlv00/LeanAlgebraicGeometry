Implemented and committed the torsion inclusion API in [Uniformization.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/AbelianVarieties/Mumford/MumfordLib/Uniformization.lean:67).

Commit: `56fd06d0b61eb3c9b707f5535b2d1d52416c9261`

Added signed and natural divisibility inclusions with injectivity, identity/composition coherence, and compatibility with additive maps.

Checks passed:

- `lake env lean MumfordLib/Uniformization.lean`
- `horizon check MumfordLib --json` with all 3,065 jobs
- Forbidden-token and ledger-content scans

Lean LSP diagnostics were unavailable. A workspace-root `horizon check --lean` invocation failed from the wrong project context; project-root and configured Horizon checks passed.
