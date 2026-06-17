# Blueprint Writer Directive

## Slug
gf-l4step3

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Strategy context
GF-alg route: prove the algebraic core of generic flatness. L4
(`lem:gf_noether_clear_denominators`, Lean
`AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial`) is the
Noether-normalisation-with-denominator-clearing lemma: for `A` a noetherian domain with fraction
field `K`, `B` a finite-type `A`-algebra domain with `B_K = K⊗_A B ≠ 0`, there exist `n`, `g≠0`, and an
injective `A_g`-algebra map `φ: A_g[X_1..X_n] → B_g` making `B_g` module-finite over `im φ`. A prover
landed Steps 1–2 and the foundation but could not close the residual assembly **from the blueprint
prose alone**: a per-file blueprint-vs-Lean check flagged **Step 3 (the AlgHom assembly: injectivity +
finiteness) as under-specified** — it must be expanded so the mathematical mechanism of injectivity and
of finiteness is spelled out, not just asserted.

## Required content
Revise ONLY the `\begin{proof}` of `lem:gf_noether_clear_denominators` (the L4 lemma, statement at
line ~381, proof at ~442–482). Keep the statement, `\label`, `\lean{}`, and the existing `% SOURCE`/
`% SOURCE QUOTE PROOF` lines unchanged. Steps 1 and 2 are adequate — leave them. **Expand Step 3** into
the following mathematically-detailed sub-arguments (mathematical prose only — NO Lean tactic syntax,
NO Lean lemma names in the rendered prose; describe the mathematics):

- **The comparison map `ν: B_g → B_K`.** Since `g ↦` a unit of the field `K` (as `g ≠ 0` in the domain
  `A ⊆ K`), the localisation `B_g = B[g^{-1}]` admits a canonical `A`-algebra map `ν: B_g → B_K = K⊗_A B`
  extending `b ↦ 1⊗b` and inverting `g`. `ν` is injective: `B` is a domain and `B_g ⊆ B_K` are both
  localisations of `B` at multiplicative sets contained in the nonzerodivisors, with `B_g`'s inverted
  set a subset of `B_K`'s. Under `ν`, the chosen lifts `b_j ∈ B_g` of the Noether generators map to the
  `K`-algebraically-independent elements `b̄_j ∈ B_K` of Step 1 (`ν(b_j) = b̄_j`).

- **Injectivity of `φ` via algebraic-independence descent.** `φ: A_g[X_1..X_n] → B_g` is the
  `A_g`-algebra map `X_j ↦ b_j`. Injectivity of `φ` is equivalent to the algebraic independence of the
  family `(b_j)` over `A_g`. The `b̄_j` are algebraically independent over `K` (Step 1). Because
  `A_g ↪ K` is an injection of `A_g`-algebras (the localisation `A_g` embeds in the fraction field `K`),
  algebraic independence over the larger field `K` restricts to algebraic independence over the subring
  `A_g`: any `A_g`-polynomial relation among the `b_j` would, pushed through the injective `ν` and viewed
  over `K`, give a `K`-relation among the `b̄_j`, forcing all coefficients to vanish. Hence `(b_j)` is
  algebraically independent over `A_g` and `φ` is injective.

- **Finiteness of `B_g` over `im φ`.** Fix the finite set of `B`-algebra generators of `B_K` over
  `K[b̄_1..b̄_n]` from Step 2; each satisfies a monic equation of integral dependence with coefficients
  in `K[b̄_1..b̄_n]`. Step 2's common denominator `g` was chosen so that, after inverting `g`, every such
  coefficient already lies in `A_g[b_1..b_n] = im φ`. Pushing these integral-dependence equations back
  through the injective `ν` (equivalently: they are the `ν`-images of relations holding in `B_g`), each
  generator of `B_g` is integral over `im φ`. A finite-type algebra that is integral over a subalgebra
  is module-finite over it; hence `B_g` is module-finite over `im φ`, which (via the injection `φ`) is
  module-finiteness of `B_g` over `A_g[X_1..X_n]`. This is the conclusion.

Keep `\uses{lem:noether_normalization_fg, lem:gf_clear_one_denominator}` on the proof; if your expanded
Step 3 invokes any additional already-existing blueprint block in this chapter, add it to `\uses{}`
(verify with leandag that you introduce no broken `\uses`).

## Out of scope
- Do NOT touch any other lemma block (L5 `gf_polynomial_core`, `gf_generic_rank_ses`,
  `gf_torsion_reindex`, `genericFlatnessAlgebraic`, `genericFlatness`).
- Do NOT add `\leanok`. Do NOT add Lean lemma names to the rendered prose (the prover gets those from
  PROGRESS.md). You MAY keep them in `% NOTE:` comments if helpful, but the prose must read as
  mathematics.
- Do NOT change the statement or its signature comment.

## References
- references/nitsure-hilbert-quot.md → the src .tex at L1747–L1772 (§4 "Lemma on Generic Flatness",
  the Noether-normalisation + denominator-clearing step). The verbatim `% SOURCE QUOTE PROOF` is ALREADY
  in the chapter above the statement and proof — do not duplicate it; your expansion is the project's
  restated, more-detailed Step 3 in project notation. Read the local file to confirm the source's phrasing
  ("$B_g$ is finite over $A_g[b_1,…,b_n]$") matches your finiteness paragraph.

## Expected outcome
The proof of `lem:gf_noether_clear_denominators` now has a Step 3 that spells out (a) the comparison map
`ν` and its injectivity, (b) injectivity of `φ` via algebraic-independence descent `K → A_g`, and (c)
module-finiteness via pushing integral-dependence relations through `ν` — detailed enough that a prover
can formalize each sub-argument. Steps 1–2 unchanged.
