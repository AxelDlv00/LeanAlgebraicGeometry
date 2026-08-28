Read-only frontier report for `/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part08_TopicsInModuliTheory`:

- Current graph: 203 nodes, 62 hard edges; 121 blueprint/Tex nodes remain `empty`, 82 Lean nodes are `lean_ok`; no `formalizes` edges currently exist.
- Kernel verification: `lake build StacksPart08Lib` succeeds, all 2,428 jobs.

Highest-impact frontier nodes:

1. `2cf44398e326` — “Coherent diagonal affine fp” (Stacks `0DLY`, 19 unlocks), source at [`ch01-moduli-stacks.tex:80`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part08_TopicsInModuliTheory/blueprint/src/ch01-moduli-stacks.tex:80). It feeds `d4ba46072961` (coherent qs/lfp) and `0cfd2bf736c4` (Pic diagonal). No existing coherent-sheaf/stack infrastructure supports an honest proof.
2. `d3722e454a1f` — “Quot diagonal closed” (`0DM2`, 15 unlocks), at [`ch01-moduli-stacks.tex:514`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part08_TopicsInModuliTheory/blueprint/src/ch01-moduli-stacks.tex:514). It feeds Quot separated/lfp and downstream existence/quotient results. Likewise blocked by absent Quot/sheaf geometry.
3. `83f09f237253` — “Coherent functorial” (`0DN9`, 14 unlocks), at [`ch01-moduli-stacks.tex:181`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part08_TopicsInModuliTheory/blueprint/src/ch01-moduli-stacks.tex:181); requires pushforward of coherent sheaves and base-change machinery not present.
4. `0d0ac9a1fe4c` — “Situation: Numerical invariants” (`0DNC`, 12 unlocks), at [`ch01-moduli-stacks.tex:327`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part08_TopicsInModuliTheory/blueprint/src/ch01-moduli-stacks.tex:327). This is the best immediately provable/source-adjacent target.

Current relevant declarations:

- [`Numerical.lean:27`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part08_TopicsInModuliTheory/StacksPart08Lib/Numerical.lean:27): `NumericalInvariant`, `NumericalSituation`, arbitrary-profile closed loci, finite-profile clopen/open loci, `locusOn` restriction/union/monotonicity, and continuous pullback laws through line 215.
- [`Representability.lean:17`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part08_TopicsInModuliTheory/StacksPart08Lib/Representability.lean:17): categorical Yoneda-relative representability facade, composition/base-change/isomorphism stability, relative morphism properties, and diagonal criterion.
- [`ModuliCurves.lean:25`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part08_TopicsInModuliTheory/StacksPart08Lib/ModuliCurves.lean:25): abstract `FamilyOfCurves`, reindexing identities, and stability transport/reflection through line 253.

Concrete recommendation: continue in `Numerical.lean` with `locusOn_empty`, `locusOn_univ`, singleton/restriction/profile-equality lemmas and connected-base corollaries. An explicit abstract polynomial-profile layer could eventually support the finite-list node `35bc431977aa` (`0DNE`), but should remain clearly auxiliary. Preserve the existing scope comment on `b4ce5dcf2024` (`0DND`): the current code does not prove algebraicity, flat closed immersion, or stack representability.

Part07 parity checks found two low-risk categorical additions absent from Part08 (`scheme_morphism_representable` and `representableTransformation_iff_of_iso`), but they do not close a Part08 Tex node.
