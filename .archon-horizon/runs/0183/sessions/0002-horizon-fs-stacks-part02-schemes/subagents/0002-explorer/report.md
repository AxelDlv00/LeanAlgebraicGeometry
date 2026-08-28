Read-only survey complete.

Part02 currently contains only [StacksPart02Lib/Schemes.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part02_Schemes/StacksPart02Lib/Schemes.lean), with 14 sorry-free wrappers. All 3,363 hgraph nodes are still `lean_status: empty`, including every chapter-1 node. The frontier CLI produced no usable output here, likely an indexing/CLI issue.

Highest-value realistic targets:

1. `schemes-lemma-open-immersion` (node `c684d9cb4f86`, order 5). Build on `Mathlib.AlgebraicGeometry.OpenImmersion`, `Scheme.restrict`, `Scheme.ofRestrict`, and the existing `openSubschemeι_isOpenImmersion`.

2. `schemes-lemma-standard-open` (node `a3360f157e48`, order 14), followed by `schemes-lemma-f-open` (`7dd14b252875`, order 20) and `schemes-lemma-standard-open-affine` (`6b88bc7df96b`, order 24). Part01 already exposes the needed `PrimeSpectrum.basicOpen` APIs in `StacksPart01Lib.Spectrum` and `Zariski`: openness, membership, products, powers, basis, and cover/unit-ideal criteria.

3. `schemes-lemma-basis-affine-opens` (`b124513de345`, order 45), likely using `Scheme.local_affine` plus topological-basis APIs; moderate complexity.

`schemes-lemma-spec-sheaves` (`63f42430f943`, order 17) is mathematically central but broad: sections, stalks, modules, localization, and functoriality make it a poor one-session target.

Low-risk additions immediately compatible with current code are wrappers for open-subscheme inclusion injectivity/open-map behavior and basic preimage identities (top, bottom, intersections), using `Scheme.Hom.preimage_iSup`, `Scheme.Hom.comp_preimage`, and `IsOpenImmersion` APIs.

Sibling projects follow the same pattern: direct wrappers over mathlib facts plus small local proofs. The worktree is heavily dirty from unrelated projects; no files were edited.
