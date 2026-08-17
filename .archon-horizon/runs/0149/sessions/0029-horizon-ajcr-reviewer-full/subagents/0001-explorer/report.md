Read the full 18-page PDF. The binding execution map is:

**Critical Chain**

`Div^g represented -> DivRankOneOpen -> rankOneAbelIso -> PicRankOneOpen -> translated cover over k^s -> pic0_sepClosed_representableBy -> representableBy_of_finiteGalois_baseChange -> pic0_representableBy -> jacobianData/JacobianData` (PDF pp. 2-4, 18).

**Files And Contracts**

- `Picard/Pic0EndgameContract.lean` must expose `PicRankOneOpen`, `DivRankOneOpen`, `rankOneAbel`, `divisorOfRankOne`, `rankOneAbelIso`, `rankOne_translate_cover_sepClosed`, `pic0_sepClosed_representableBy`, and `pic0_representableBy`. Every declaration must record its mathematical source, Lean prerequisites, and immediate consumer (p. 6).
- `Picard/Pic0CriticalPath.lean` is the narrow root. The PDF’s proposed imports include `DivRepChartClassUnivAffRepresentable`, `Pic0ChartLocusH0Rank`, `Pic0RankOneOpen`, and `Pic0RepresentabilityFinal`; it must `#check` the genus divisor producer, `rankOneAbelIso`, `pic0_sepClosed_representableBy`, and `pic0_representableBy` (p. 5).
- `Curve/RelativeCurveBridge.lean` owns canonical `relCurve C L` spelling, transported instances, `inferInstanceAs` bridges, and base-change simp lemmas (p. 7).
- The PDF does not prescribe a separate final implementation filename beyond the contract/root imports. It prescribes declarations and consumption edges.

**`rankOneAbelIso` Gate**

- `PicRankOneOpen` is the single public good locus: for every test scheme `T`, line bundles satisfy `R¹f_*L = 0`, `f_*L` locally free rank one, and the required arbitrary-base-change compatibility (p. 8).
- `DivRankOneOpen` is the maximal open in the genus-degree divisor representer where the universal divisor’s line bundle lies in `PicRankOneOpen`; `rankOneAbel` is its restricted Abel map (p. 8).
- The inverse must be canonical on arbitrary test schemes: set `N = f_*L`, use `f^*N -> L`, equivalently the section of `L tensor f^*(N⁻¹)`, and take its zero scheme. Choosing a generator of `N` is forbidden (p. 8).
- Prove the zero scheme is finite locally free of degree `g`, commutes with arbitrary base change, and has the same relative Picard class because `O(D)` differs from `L` only by a pullback from `T` (p. 8).
- Prove both inverse laws, package `rankOneAbelIso`, and immediately consume it in `rankOneAbel_isOpenImmersion` by composing with the open inclusion into Picard (p. 8).
- Delete/demote generator-selection code, fieldwise uniqueness, source/test coupling wrappers, and anything not used by the iso or openness proof. This milestone should cause net deletion (p. 9).

**Coverage And Separably Closed Gate**

- For every extension `K/k` and input Picard class `lam`, produce a base-field line bundle `L0` whose translate has `h⁰ = 1`, `h¹ = 0`. `L0` must originate over `k`, so the translated open is defined over `k` (p. 9).
- Required strategy: positive twist until `H¹=0` and `H⁰≠0`; repeatedly choose a `k`-rational point where a section is nonzero, subtract it, lower `h⁰`, and preserve `H¹=0` until rank one (p. 9).
- The result must be explicitly tied to `lam`, directly feed gluing, and introduce no unrelated witness. The detailed theorem is `exists_translation_mem_picRankOneOpen`; the contract-level cover is `rankOne_translate_cover_sepClosed` (pp. 6, 9, 15).
- Translated rank-one opens must cover field-valued points after arbitrary extensions, and the open-cover criterion must produce both `pic_sepClosed_representableBy` and `pic0_sepClosed_representableBy` (pp. 9-10).
- First headline gate: `#check` and `#print axioms pic0_sepClosed_representableBy`, narrow-root build, full AJCR-root build, and recorded time/memory/axioms (p. 10).

**Descent And Arbitrary-Field Gate**

- Package `Pic0SepClosedDescentInput` with the same `J`, representation, finite type, properness, group structure, geometric irreducibility, and universal element (p. 10).
- Descend finite-presentation data and the universal element to finite separable `L/k`; enlarge to finite Galois; derive the semilinear action and cocycle by uniqueness; produce a Galois-stable affine cover with orbit-in-affine conditions; form affine invariant quotients, prove overlap compatibility, glue, and descend the universal element/Yoneda equivalence (pp. 10-11).
- `representableBy_of_finiteGalois_baseChange` must return both the descended scheme and its `RepresentableBy` certificate. It must be shared/imported from AJC and immediately consumed by `pic0_representableBy`; a second AJCR descent stack is forbidden (p. 11).
- Run `#check pic0_representableBy` and `#print axioms pic0_representableBy` (p. 11).

**`JacobianData` / Challenge Gate**

- `jacobianData : JacobianData C` must consume the same pinned `pic0_representableBy` datum. Group object, identity component, universal element, base-change isomorphism, and cocycle coherence may not be independently chosen or reconstructed via repeated choice (pp. 4, 11).
- Then prove finite type, properness, smoothness, dimension `g`, Abel-Jacobi, Albanese universality, field-base-change compatibility, and cocycle coherence; finally audit every protected Challenge declaration (p. 11).
- Final checks are `#check jacobianData`, `#print axioms jacobianData`, no project-specific axioms or `sorryAx`, and successful narrow-root plus full-root builds (pp. 11-12).
- AJC must consume the shared representability engine or derive its producer from that shared implementation; it must not pursue a parallel FGA proof (pp. 4, 12).

**Credit And Forbidden Shortcuts**

- Endpoint credit requires: contract theorem completed, imported by the narrow root, used by its immediate consumer, relevant module kernel-builds, axiom output recorded, and obsolete implementation deleted or reduced to a specialization (p. 14).
- Zero credit: aliases/wrappers without consumers, unused `_at` lemmas, root-unreachable modules, fieldwise claims standing in for arbitrary-family naturality, quotients without effective universal property, witnesses unrelated to inputs, or new global heartbeat/depth/synthesis limits (p. 14).
- The positive-genus `n > g` unrestricted Abel map must have a root-imported negative route guard: fibres have at least two sections, so it cannot be the desired open immersion. High-degree representability is infrastructure only (pp. 4, 6).
- A quotient route is allowed only after a complete non-circular contract constructing the quotient, universal property, base-change compatibility, and map to Picard without assuming Picard representability (pp. 4, 14, 16).
- Core required checks are exactly: `rankOneAbelIso`, `rankOneAbel_isOpenImmersion`, `exists_translation_mem_picRankOneOpen`, `pic0_sepClosed_representableBy`, `representableBy_of_finiteGalois_baseChange`, `pic0_representableBy`, and `jacobianData` (p. 15).

Current-tree cross-check: `rankOneAbelIso` is in `Pic0RankOneAbelInverse.lean`, with the canonical inhabitant exposed as `canonicalRankOneAbelIso`; `pic0_sepClosed_representableBy` exists in `Pic0SepClosedRepresentable.lean`. `Pic0CriticalPath.lean` explicitly records that arbitrary-field `pic0_representableBy` and `JacobianData` are still missing. No exact `pic0_representableBy` or `jacobianData` declaration was found; the frozen Challenge headline remains `AlgebraicGeometry.Jacobian` in `AlgebraicJacobian/Challenge.lean`. No files were edited and no builds were run.
