## Progress

- Added affine polynomial evaluation, zero sets, algebraic-set closure, and vanishing ideals in [Chapter1.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter1.lean).
- Added arbitrary-intersection closure and the opt-in affine Zariski topology in [Chapter1Topology.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter1Topology.lean).
- Added sorry-free ideal laws in [Chapter1Ideals.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter1Ideals.lean).
- Added the affine-variety predicate and closed-set characterization in [Chapter1Variety.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter1Variety.lean).
- Committed as `d722c22e42`, `37e23efe69`, and `135474971d`.
- `lake build HartshorneLib`, direct Lean checks, Horizon check, and axiom scans pass. No `sorry`, `admit`, or project axioms; only standard Lean axioms are reported.
- Synced hgraph: 549 nodes, 239 edges, 50 closed Lean nodes, stale count 0. Added seven explicit `formalizes` edges for the implemented I.1 definitions.

## Issues

The frozen blueprint has no `\lean{}` annotations, so its 499 TeX nodes remain `lean_status: empty` despite the explicit graph correspondences. The intentional scoped topology instance is documented because `AffinePoint` is definitionally a function type and would otherwise shadow Mathlib’s product topology.

## Why I stopped

Partly advanced, not complete. The standing `fs-hartshorne` task remains `running` as required.

## Next

Continue with affine coordinate-ring and Nullstellensatz infrastructure, then extend the TeX-to-Lean graph mapping without modifying the frozen blueprint.
