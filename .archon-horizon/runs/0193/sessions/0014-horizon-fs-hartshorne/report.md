## Progress

Implemented and committed:

- `IsLineBundle.pullback` in [Chapter2LineBundles.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter2LineBundles.lean:54), transporting affine local trivializations through module pullback.
- New [Chapter4PrincipalDivisorDegree.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter4PrincipalDivisorDegree.lean:34), containing principal-divisor degree identities, the additive obstruction homomorphism, an order-one vanishing criterion, and global-unit triviality.

Commits: `591bead891`, `8e77fcb621`, `2124d296a5`, and `9aefbb1d81`.

## Verification

The Horizon Hartshorne build passed all 3,116 jobs. LSP and direct Lean checks pass; representative axiom scans use only standard Lean axioms, and the Hartshorne library source scan found no `sorry`, `admit`, or project `axiom`.

Hgraph sync reports 499 blueprint nodes, 322 Lean declarations, 294 generated edges, and zero stale nodes. The 252 unattached declarations are documented as intentional under the frozen-blueprint protection; no blueprint files were modified. Ground and janitor audits found no Hartshorne source issues.

## Remaining

The unconditional Hartshorne II.6.10 theorem that every principal divisor has degree zero remains open. The library continues to expose `PrincipalDivisorsHaveDegreeZero` as an explicit hypothesis; the next substantive step is porting the required Riemann–Roch/product-formula substrate.

The standing `fs-hartshorne` task remains `running`.
