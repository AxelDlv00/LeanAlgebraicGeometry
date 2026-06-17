# Mathlib Analogist — `IsRegularLocalRing → IsDomain` (Stacks 00NQ)

## Mode: api-alignment

## Slug
isregularlocalring-isdomain

## Iteration
182

## Question

Does Mathlib have `IsRegularLocalRing R → IsDomain R` (or equivalently,
the Stacks 00NQ statement "regular local ring is a domain")? This is
the load-bearing gap in
`Albanese/AuslanderBuchsbaum.lean:435 exists_isRegular_of_regularLocal`
(iter-181 Lane G substantive helper sorry).

Without it (or an alternative route), `CohenMacaulay.of_regular`
cannot have a kernel-clean body. The iter-181 Lane G task_result
explores three candidate routes:

1. **Direct route**: formalize 00NQ via minimal-primes + Krull
   intersection theorem. Mathlib partial:
   `Mathlib.RingTheory.Ideal.MinimalPrime` +
   `Mathlib.RingTheory.Ideal.KrullIntersection`.
2. **Inductive route**: regular-quotient `R/x₁R` regular of dim `d-1`,
   then `Ideal.height_le_one_of_principal` (in Mathlib) closes by
   induction.
3. **Bypass via Serre's regularity**: `pd_R(κ) + depth(κ) = depth(R)`
   with `pd_R(κ) = d`. Mathlib has neither piece.

## Project artifact(s)

- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:435-447`
  (`exists_isRegular_of_regularLocal`) — typed sorry, substantive
  signature.
- `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean:527+`
  (`CohenMacaulay.of_regular`) — inline assembly via
  `length_le_ringKrullDim_of_isRegular` (axiom-clean iter-181) +
  `exists_isRegular_of_regularLocal` (the gap).
- iter-181 Lane G task_result
  `.archon/task_results/Albanese_AuslanderBuchsbaum.lean.md`.

## Decisions identified

### Decision 1: Mathlib status of `IsRegularLocalRing → IsDomain`

Does Mathlib expose this directly as a `theorem` /`instance`? Search
`Mathlib.RingTheory.RegularLocalRing` (Mathlib's IsRegularLocalRing
file). Also check `Mathlib.RingTheory.LocalRing.IsRegular`. If
present, the gap collapses to a 1-line `inferInstance`-style
discharge.

### Decision 2: If absent, which of the 3 routes is cheapest?

For each: estimate LOC, list Mathlib atoms in scope at pinned commit,
flag any sub-gap that itself needs an upstream PR.

### Decision 3: Alternative route via `IsRegularLocalRing.spanFinrank`

iter-181 closed `length_le_ringKrullDim_of_isRegular` axiom-clean.
The dual `(spanFinrank maximalIdeal) ≤ rs.length` for some maximal
regular sequence — is this independently in scope? It bypasses
00NQ if there's a *constructive* maximal regular sequence available.

## Hard ask

For each Decision, return verdicts. Produce a **persistent recipe at
`analogies/isregularlocalring-isdomain.md`** with:

- Concrete Lean snippets for whichever route is recommended.
- Estimated LOC + Mathlib atom list.
- Explicit recommendation: dispatch a prover lane to close
  `exists_isRegular_of_regularLocal` body THIS iter, OR escalate to
  a Mathlib upstream PR (which would be a multi-iter project-side
  effort).

If the gap is genuinely out of reach at the pinned commit, the
recipe should say so with `NOT_FOUND` / `ESCALATE` verdict and
propose pivoting the Lane G prover to a different depth-dependent
lemma (e.g. `depth_of_short_exact` L268 or
`depth_eq_smallest_ext_index` L228, both with their own substantive
content).
