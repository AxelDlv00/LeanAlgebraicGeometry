## Progress

Refactored the roadmap into a truthful 22-node `AJC.jacobian` tree, cleaned the principal blueprint chapters, corrected Albanese/Lean mismatches, and updated [T2](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/tasks/items/T2.yaml) to its three actual obligations.

The Cech optimization reduced measured shared-runner builds:

- `CechHigherDirectImage`: 852s to 135s
- `CechSectionIdentificationBase`: 1010s to 58s
- Focused builds are green through `CechSectionIdentificationLeg`

The work is recorded in 12 commits. AJC paths are clean, the graph is synchronized, and no AJC build processes remain.

## Why I stopped

The meaningful next step is a deeper proof refactor, not another import-only pass. The remaining frontier is documented in [TO_USER.md](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/TO_USER.md): 23 executable `sorry` terms, 92 umbrella imports, 206 heartbeat scopes including 3 unlimited, and a 1293s `CechSectionIdentificationLeg` build. Its WPCI inverse chain is the next performance target.

The broad optimization task remains open rather than being marked done. A complete project build was not claimed; the initial full baseline was stopped after 50.7 minutes once it had isolated the relevant hotspots.
