# Bounds for the Stalks of Perverse Sheaves in Characteristic p

<!-- archon:readme -->
<!-- Claude fills in the prose sections below. Keep the section headers. -->

## Project

This project formalizes results from Will Sawin's paper *"Bounds for the stalks of
perverse sheaves in characteristic p and a conjecture of Shende and Tsimerman"*
(arXiv:1907.04850, with an appendix by Jacob Tsimerman). The paper proves a
characteristic-`p` analogue of Massey's bound: the dimension of the stalk
`H^{-i}(K)_x` of a perverse `F_ℓ`-sheaf is bounded by the `i`-th *polar
multiplicity* of its characteristic cycle `CC(K)` at `x`, built on Saito's and
Beilinson's theory of singular support and characteristic cycles. This is applied
to prove a conjecture of Shende and Tsimerman bounding the Betti numbers of
intersections of translates of theta loci in a hyperelliptic Jacobian
(`≤ 28^g/16 + 4·8^g + 2·4^g`), which in turn yields a function-field analogue of
the Michel–Venkatesh mixing conjecture.

The deep geometric machinery (étale cohomology, perverse sheaves, characteristic
cycles, nearby/vanishing cycles, intersection theory on cotangent bundles) is
largely beyond current Mathlib. The realistically formalizable core consists of
the self-contained **combinatorial and arithmetic** statements: the
generating-function identities computing the multiplicities `m_{w1,w2,a,b}`, the
polar-multiplicity bounds (Lemmas in §5), and the final numerical Betti-number
estimate. The structural sheaf-theoretic statements are recorded in the blueprint
as scaffolding with their hypotheses axiomatized where Mathlib lacks the theory.

## References

See [`references/summary.md`](references/summary.md) for a description of each source.

## Structure

- `MR4228499BoundsForTheStalksOfPerverseSheavesInCharacteristicPAndAConjectureO/` — main Lean source
- `blueprint/` — leanblueprint source (build with `leanblueprint pdf` and `leanblueprint web`)
- `references/` — PDFs, papers, and informal notes backing the formalization
- `archon-protected.yaml` — declarations agents must not modify
- `.archon/` — agent state (not committed)

## How to build

```bash
lake exe cache get   # download Mathlib olean cache
lake build           # compile the project
```

## How to run the formalization loop

```bash
archon loop .
```

This launches the plan → prove → review loop and opens a dashboard.
