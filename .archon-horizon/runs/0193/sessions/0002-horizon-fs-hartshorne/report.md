## Progress

- [Chapter2Sheaves.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter2Sheaves.lean): added verified ringed/locally-ringed-space and stalk-map APIs; commit `0632de8582`.
- [Chapter1Curves.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter1Curves.lean): added the valuation-ring fraction-field dichotomy and the one-dimensional normal-local/DVR criterion; commit `468a9a4f8f`.
- [Chapter4Curves.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter4Curves.lean): added raw point divisors plus the properly restricted algebraically closed smooth proper curve divisor/degree API; correction commit `4c91211995` supersedes the earlier draft.
- [Chapter2LineBundles.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter2LineBundles.lean): added local line-bundle triviality and isomorphism transport; commit `06c599bec3`.
- [HartshorneLib.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib.lean): integrated the new modules; commit `50903690b7`.
- Horizon’s aggregate `lake build HartshorneLib` passed all 2,594 jobs. LSP diagnostics, focused declaration verification, and placeholder/source scans are clean; no `sorry`, `admit`, or project axioms were introduced.

## Issues

- Blueprint files remain frozen and unchanged. Graph sync reports 700 nodes (499 TeX, 201 Lean), 131 unattached Lean declarations, and 485 empty TeX nodes; the new source declarations have no speculative blueprint bindings. Open issue `I-2067` remains valid, although its recorded counts are stale.
- Concurrent Horizon runs leave unrelated workspace, inbox, roadmap, and project paths dirty; they were not staged or committed. The shared queue warning (20 open tasks) and stale fs-stacks run markers are outside this project.

## Why I stopped

The standing objective is partly advanced, not complete. Hartshorne has a clean verified checkpoint and no remaining Hartshorne-owned source edits from this run; the task intentionally remains `running`.

## Next

Attach only exact source-facing declarations to frozen Chapter I/II/IV nodes under the permitted missing-link policy, then continue principal divisors, sheaf consequences, and the Picard/curve API.
