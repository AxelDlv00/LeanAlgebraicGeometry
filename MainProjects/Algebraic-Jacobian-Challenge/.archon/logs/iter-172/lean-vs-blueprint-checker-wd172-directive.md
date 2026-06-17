# Lean ↔ Blueprint Checker Directive

## Slug
wd172

## Lean file
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

## Blueprint chapter
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`

## Iter-172 changes this iter
- NEW file (Lane C file-skeleton). 9 `\lean{...}`-pinned declarations scaffolded from the chapter, plus one helper `Scheme.PrimeDivisor` structure not blueprint-pinned (the prover's task result calls this out as honest scaffolding with placeholder field `isCodim1AndIntegral : True := trivial`).
- 6 sorry warnings on file (5 noncomputable defs + 1 theorem); 3 declarations close `sorry`-free (`WeilDivisor`, `degree`, `LinearEquivalence`).

## Audit scope
Bidirectional:
(A) Does the Lean follow the blueprint? — verify each of the 9 `\lean{...}` pins maps to the right declaration with the right type. Specifically scrutinise:
  - Whether `Scheme.WeilDivisor X := X.PrimeDivisor →₀ ℤ` is faithful to the chapter's "free abelian group on prime divisors" definition, given that `PrimeDivisor` carries a placeholder `isCodim1AndIntegral : True` rather than the real codim-1 witness.
  - Whether `Scheme.WeilDivisor.LinearEquivalence` being a `Prop` (`∃ f hf, ...`) matches the chapter's statement, given its dependency on the body-`sorry` `principal`.
  - Whether `Scheme.RationalMap.order` signature (uses `Scheme.functionField`, `IsIntegral X`) matches the chapter's order-of-vanishing definition (Stacks/Hartshorne style).
(B) Is the blueprint adequate? — for the helper `Scheme.PrimeDivisor` structure, is the blueprint clear enough on what a "prime divisor" is to specify the missing field? The chapter's `def:prime_divisor` (or equivalent) should pin a real codim-1-and-integral condition; flag if the chapter is too thin to inform iter-173+ refinement.

## Out of scope
- Other RR chapters (RR.2/3/4) that don't exist yet.
- Sibling Lean files.

## Notes
- The chapter is ~445 LOC with 9 `\lean{...}` pins (landed iter-171).
- `sync_leanok` added 9 `\leanok` markers this iter (per `.archon/sync_leanok-state.json`); your audit should still ignore `\leanok` (it's deterministic).
