# Mr4199442 Standard Conjectures For Abelian Fourfolds

<!-- archon:readme -->
<!-- Claude fills in the prose sections below. Keep the section headers. -->

## Project

This project formalizes results from Giuseppe Ancona's *Standard conjectures for
abelian fourfolds* (arXiv:1806.03216, MR4199442) in Lean 4 with Mathlib. The
paper proves the **standard conjecture of Hodge type** for an abelian fourfold
`A` in characteristic `p`: the intersection product on codimension-2 cycles
modulo numerical equivalence, `Z²_num(A)_ℚ × Z²_num(A)_ℚ → ℚ`, has signature
`(ρ₂ − ρ₁ + 1 ; ρ₁ − 1)` (equivalently, it is positive definite on primitive
classes for any polarization). The strategy reformulates the question as a
`p`-adic problem and solves it with `p`-adic Hodge theory. As a corollary
(via a theorem of Clozel), numerical equivalence agrees with `ℓ`-adic
homological equivalence on `A` for infinitely many primes `ℓ`. This is deep
algebraic geometry — motives, complex multiplication, quadratic forms over
local fields, and crystalline periods — so formalization proceeds incrementally
through the blueprint, starting from the foundational definitions and reductions.

## References

See [`references/summary.md`](references/summary.md) for a description of each source.

## Structure

- `MR4199442StandardConjecturesForAbelianFourfolds/` — main Lean source
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
