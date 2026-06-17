# Blueprint Writer Report

## Slug
gf-l4step3

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Changes Made
- **Revised** `lem:gf_noether_clear_denominators` (L4) — expanded the terse one-paragraph
  *Step 3 — AlgHom assembly* of the `\begin{proof}` into three mathematically-detailed
  sub-steps. Statement, `\label`, `\lean{}`, `% SOURCE`/`% SOURCE QUOTE PROOF`, and the
  proof's `\uses{}` are all unchanged. Steps 1 and 2 are untouched.
  - **Step 3a — comparison map `ν : B_g → B_K`.** Constructs `ν` via the universal
    property of localisation (`g` maps to a unit of `K`, hence to a unit of `B_K`),
    gives the explicit formula `ν(b/g^k) = (1⊗b)(1⊗g)^{-k}`, and proves injectivity:
    `B` a domain, both `B_g` and `B_K` localisations of `B` at multiplicative sets of
    non-zerodivisors with the `B_g`-set contained in the `B_K`-set; records `ν(b_j) = b̄_j`.
  - **Step 3b — injectivity of `φ` by algebraic-independence descent `K → A_g`.**
    Injectivity ⇔ algebraic independence of `(b_j)` over `A_g`; uses the injection of
    `A_g`-algebras `A_g ↪ K`, pushes any nontrivial `A_g`-relation through the injective
    `ν` to a nonzero `K`-relation among the `b̄_j`, contradicting Step 1 independence.
  - **Step 3c — module-finiteness of `B_g` over `im φ`.** Each Step-2 generator of `B_K`
    satisfies a monic integral-dependence equation over `K[b̄_1..b̄_n]`; `g` was the common
    denominator so the coefficients land in `A_g[b_1..b_n] = im φ` after inversion; pulls
    the monic equations back through injective `ν` to hold in `B_g`; "finite-type + integral
    ⇒ module-finite" gives `B_g` module-finite over `im φ`, transported along `φ` to the
    stated conclusion. Explicitly notes this recovers the source's "$B_g$ is finite over
    $A_g[b_1,…,b_n]$".

## Cross-references introduced
- None new. The proof's `\uses{lem:noether_normalization_fg, lem:gf_clear_one_denominator}`
  is unchanged and still correct: Step 3a's `ν` is an internal construction, and the
  integral-dependence/algebraic-independence inputs come from Steps 1–2, already covered by
  those two dependencies. `leandag build --json` reports `unknown_uses: []` and zero
  conflicts after the edit.

## References consulted
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` (L1747–L1772) — confirmed
  the source's phrasing "$B_g$ is finite over $A_g[b_1,\ldots, b_n]$" matches the Step 3c
  finiteness paragraph; no new `% SOURCE QUOTE` added (the existing verbatim block above the
  statement is unchanged, as directed).

## Macros needed (if any)
- None. Step 3 uses only existing math macros and `\operatorname{}`.

## Notes for Plan Agent
- Step 3a's injectivity of `B → B_K` is phrased mathematically as "kernel = elements of `B`
  annihilated by a non-zero element of `A`, which is `0` because `A` acts faithfully on the
  domain `B`". A prover may prefer to route injectivity of `ν` through the chapter's existing
  domain/localisation facts rather than this annihilator description; the mathematics is the
  same. Not a blueprint defect — just an implementation-route note.

## Strategy-modifying findings
None.
