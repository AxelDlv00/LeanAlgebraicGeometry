## Progress

- [GroupScheme.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/AbelianVarieties/Milne/MilneLib/GroupScheme.lean:912): added `isIntegral_left_of_isAbelianVariety`, `isReduced_left_of_isAbelianVariety`, `locallyOfFiniteType_of_isAbelianVariety`, and `isLocallyNoetherian_left_of_isAbelianVariety`; routed `smooth_of_isAbelianVariety` through the locally-finite-type adapter (`16de0bf9db`).
- [Isogeny.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/AbelianVarieties/Milne/MilneLib/Isogeny.lean:1418): added arbitrary-field `Isogeny.comp_of_isAbelianVariety_of_arbitraryField`, using the existing finite-map descent producer and finite composition closure (`8d1135aed4`).
- Milne hgraph: synchronized at 265 blueprint nodes, 261 current Lean declarations, and 245 generated edges; persisted the snapshot (`3642d26bca`) and the characterization frontier note (`f0d4659ec0`). The aggregate graph view reports 529 nodes / 264 Lean entries because it includes 3 intentional historical stale records.
- Verification: pre/post-edit LSP diagnostics are empty; theorem axiom/source scans report only `propext`, `Classical.choice`, and `Quot.sound`; project-root `horizon check MilneLib` passes all 3158 jobs.
- Boundary maintenance: janitor and ground reviews completed; resolved Milne-owned conversation `I-2209` was archived; protections remain open and untouched; task state and handoff were persisted (`4b91caeefc`, `edc1613bc3`).

## Issues

The frozen four-way isogeny characterization remains open on global proper dimension/projectivity, unconditional homomorphism flatness, and unrestricted geometric-fibre translation. The generic coherent-stalk I.5.11 bridge remains blocked by the pinned Mathlib API. Hgraph still reports 3 historical stale records and many intentionally unlinked auxiliary declarations.

The shared ledger caused commit `16de0bf9db` to include an already-staged AJCR file outside Milne's write set. This was audited, reported in `I-2209`, and accepted by the AJCR owner; no history rewrite was performed. Future commits should use explicit pathspecs and a clean-index check.

The global Horizon queue warning remains (18 open tasks at the main janitor checkpoint; later inbox cleanup reduced non-protection items by one). The fresh ground rerun could not independently acquire the shared verification slot, but the direct project check above completed successfully.

## Why I stopped

The standing objective is partly advanced, not complete. `fs-milne` remains `running` by design; the available next characterization steps require the larger projectivity/dimension and flatness prerequisites rather than another small wrapper.

## Next

Prove the explicit arbitrary-residue/geometric-fibre translation using the slice-kernel and base-change API, then revisit homomorphism flatness and the global dimension/projectivity cone.
