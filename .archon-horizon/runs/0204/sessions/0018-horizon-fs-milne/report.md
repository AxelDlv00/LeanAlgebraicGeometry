## Progress

- `FormalizedSources/AbelianVarieties/Milne/MilneLib/FibreCorollaries.lean`: added the arbitrary-field finite underlying preimage theorem for isogenies in commit `c756abab5d`.
- `FormalizedSources/AbelianVarieties/Milne/MilneLib/DimensionCorollaries.lean`: added cotangent-rank and regular-stalk transport along section translations in commit `19eaa3c0b4`.
- `FormalizedSources/AbelianVarieties/Milne/MilneLib.lean`: exports the fibre corollaries module.
- `.archon-horizon/blueprints/Milne.json`: synchronized and refreshed the countable cache in commits `076c743314` and `74dd46edf1`; hgraph reports 265 blueprint records, 304 Lean declarations, 245 edges, and 3 historical stale records.
- Verification: lean-check LSP diagnostics, focused `lean_verify`, `lake build MilneLib` (3171 jobs), the correctly scoped Horizon root check, and the final `lake env lean MilneLib.lean` all pass. Proofs use only `propext`, `Classical.choice`, and `Quot.sound`; no `sorry`, `admit`, or project axioms were added.

## Issues

- The frozen four-way isogeny characterization remains intentionally unlinked. Projectivity/global dimension and intrinsic homomorphism flatness are still blocked dependencies.
- Sync still reports auxiliary Lean declarations as unlinked; the existing dependency cycle and 3 stale graph records are unchanged. Queue/inbox hygiene warnings remain (18 open tasks; I-2157 and I-2213).
- An initial Horizon check used a member-relative path from the workspace root and failed module resolution; rerunning from the Milne project passed. No source or build failure remains, and a full workspace build was not run.

## Why I stopped

The objective is partly advanced, not complete. This is a standing task, so it remains `running`; the remaining frontier requires the geometric projectivity/dimension and flatness results above rather than another routine wrapper.

## Next

Prioritize the proper abelian-variety projectivity/global-dimension bridge, then the unconditional flatness theorem for homomorphisms and the generic coherent-stalk/cotangent bridge. Reconcile the stale graph records and missing task anchors only with owner guidance.
