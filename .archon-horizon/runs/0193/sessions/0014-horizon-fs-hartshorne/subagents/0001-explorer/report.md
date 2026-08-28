Investigation complete. The current Hartshorne API has:

- `CurveDivisor.degree` / `degreeHom` in `HartshorneLib/Chapter4Curves.lean:56-63`, with additive laws at `:170-194`.
- `principalDivisor`, coefficient evaluation, and multiplicative/additive laws in `HartshorneLib/Chapter4PrincipalDivisors.lean:141-202`.
- The blueprint target is actually `blueprint/src/ch02-schemes.tex:915-924`, corollary `II.6.10`; its hgraph node `bae530b051e9.md` remains empty.
- The explicit placeholder hypothesis is `PrincipalDivisorsHaveDegreeZero` at `HartshorneLib/Chapter4DegreeClass.lean:33-40`.

Horizon search found no mathlib global product-formula theorem. Mathlib only supplies local order-of-vanishing facts (`Mathlib/RingTheory/OrderOfVanishing/Noetherian.lean:124-221`). AJCR’s actual degree-zero proof uses a substantial χ-ledger plus residue-degree transport (`ChiLedger.lean:123-132`, `ResidueOneAlgClosed.lean:94-160`, `PrincipalTransport.lean:93-123`), so it is not realistically portable into this project yet.

The live `Chapter4PrincipalDivisorDegree.lean` now contains the appropriate unconditional algebraic layer:

- product/inverse/quotient degree identities;
- `principalDivisorDegreeHom`;
- the order-one criterion and its degree consequence;
- a concrete global-unit specialization.

All of these compile, and the full project build succeeds:

```text
lake build HartshorneLib
Build completed successfully (3116 jobs).
```

The global-unit specialization was tested independently and compiles using the explicit generic stalk germ:
`Units.map ((X.left.presheaf.germ ⊤ (genericPoint X.left) trivial).hom.toMonoidHom) s`.
Using `Scheme.germToFunctionField ⊤` directly fails elaboration because Lean does not synthesize `Nonempty ⊤`; the explicit germ avoids that issue.
