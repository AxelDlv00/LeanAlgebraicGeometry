# Blueprint Writer Directive

## Slug
a4a-codim1

## Target chapter
`blueprint/src/chapters/Albanese_CodimOneExtension.tex` (NEW)

## Lean file this chapter is the blueprint for
`AlgebraicJacobian/Albanese/CodimOneExtension.lean` (NEW — does not yet exist).

Add the standard `% archon:covers AlgebraicJacobian/Albanese/CodimOneExtension.lean` line at the top.

## Strategy context

This is Route A.4.a — the codim-1 indeterminacy extension lemma (Milne §I.3 Lemma 3.3) and the Weil-divisor API needed for it. Together these form the **risk-dominant** Route A piece: STRATEGY.md L29 calls it "project-fatal if it stalls." Estimated ~900-1200 LOC, ~8-13 iters.

The lemma is invoked by Milne's proof of Theorem 3.2 (rational-map-extension from a smooth variety to an abelian variety), which is in turn invoked by Milne's proof of Proposition 6.1 (the Albanese universal property of `Pic⁰_{C/k}`). Without A.4.a, A.4.c cannot run, and the positive-genus arm cannot close.

This chapter **shares material with RR.1** (`RiemannRoch_WeilDivisor.tex` already on disk): both need closed-point order, divisor degree, codim-1 indeterminacy. Coordinate by pointing this chapter's Weil-divisor pieces at the RR.1 chapter where they coincide. Add a `% NOTE: Weil-divisor API extension of `RiemannRoch_WeilDivisor.tex` — re-uses `Scheme.WeilDivisor`, `Scheme.PrimeDivisor`, `Scheme.RationalMap.order`.` near the top.

## Required content

### Definition: codimension-1 indeterminacy locus
For a rational map `f : X ⇢ Y` between schemes, the **indeterminacy locus** `Z := X \ Dom(f)` is the closed complement of the domain of definition. The map is said to be of **codimension-1 indeterminacy** if every irreducible component of `Z` has codimension ≥ 2 in `X`.

### Theorem: Milne Lemma 3.3 — codim-1 extension over a smooth surface
Statement (Milne *Abelian Varieties* §I.3, Lemma 3.3): Let `X` be a smooth variety over an algebraically closed field `k`, and let `f : X ⇢ A` be a rational map into an abelian variety `A`. Assume:
- `X` is smooth (the **smoothness hypothesis** is essential — it ensures the local rings at codim-1 points are DVRs).
- The indeterminacy locus has codimension ≥ 2 in `X` (no codim-1 indeterminacy).

Then `f` extends uniquely to a regular morphism `X → A`.

The key case in our application (per Milne's proof of Theorem 3.2): `X = ℙ¹ × ℙ¹`, where the indeterminacy locus is a finite set of points (codim-2). The Weil-divisor formulation reduces this to "a rational function on a smooth surface with no codim-1 zeros/poles extends across codim-2 points."

### Lemma: smooth surface = local UFD at codim-1 points
The mechanical reduction step: for a smooth variety `X` over `k`, the local ring `O_{X, x}` at a codim-1 point `x` is a DVR; this lets us read off the order-of-vanishing of a rational function at each prime divisor.

### Definition: order of a rational function at a prime divisor (shared with RR.1)
This re-uses `Scheme.RationalMap.order` already pinned in `RiemannRoch_WeilDivisor.tex`. Add a `% NOTE: see Scheme.RationalMap.order in chapter RiemannRoch_WeilDivisor` rather than re-introducing.

### Theorem: Weil-divisor characterization of codim-1 extension obstructions
The obstruction to extending `f : X ⇢ A` across a codim-1 closed point reduces to the order of vanishing of the natural coordinates of `f` at that point — if all orders are non-negative, the extension exists. Statement should be precise enough to formalize.

### Proof sketch (Milne §I.3 verbatim, then project notation)
Quote the Milne proof verbatim. Then split into sub-steps:
1. Local reduction: in a neighborhood of a codim-2 indeterminacy point `x ∈ X`, write `f` in coordinates.
2. Codim-1 stops: if `f` has codim-1 indeterminacy, the order computation forces a pole, contradicting the abelian-variety target's properness.
3. Codim-2 fills in: the smooth surface = local UFD lemma + abelian variety's properness fill in the rational map at codim-2 points.
4. Combine: extension is unique by separatedness.

### Lean signature targets

Use `\lean{...}` markers on the following intended Lean declarations (file `AlgebraicJacobian/Albanese/CodimOneExtension.lean`):

- `def:indeterminacy_locus` → `AlgebraicGeometry.Scheme.RationalMap.indeterminacyLocus`
- `def:codim_one_indeterminacy` → `AlgebraicGeometry.Scheme.RationalMap.CodimOneFree`
- `lem:smooth_codim_one_dvr` → `AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one`
- `thm:codim_one_extension` → `AlgebraicGeometry.Scheme.RationalMap.extend_of_codimOneFree_of_smooth`
- `thm:weil_divisor_obstruction` → `AlgebraicGeometry.Scheme.RationalMap.extend_iff_order_nonneg`

## Required citations

`% SOURCE: [Milne, Abelian Varieties], Lemma 3.3, §I.3, p.~15` and similar.

Read source verbatim from:
- `references/abelian-varieties.pdf` §I.3 pp. 15-20 (Lemma 3.3 + the proof).
- `references/hartshorne-algebraic-geometry.pdf` II.6 (Weil divisor section, for the order-extension mechanics).
- `references/stacks-varieties.tex` if a specific Stacks tag matches (search for codim-1 / DVR / extension theorems).

Each block needs `% SOURCE:` + verbatim `% SOURCE QUOTE:` + `\textit{Source: ...}` per the citation rules.

## Out of scope

- Do NOT write the Lean file.
- Do NOT add `\leanok` or `\mathlibok` markers.
- Do NOT duplicate the `Scheme.RationalMap.order` definition (point at the RR.1 chapter).
- Do NOT scope the chapter to depend on Auslander–Buchsbaum (that's A.4.b's chapter; this chapter is the geometric statement, A.4.b supplies the algebra).
- Do NOT touch `content.tex`.

## Verification

`\input{chapters/Albanese_CodimOneExtension}` will be added to `content.tex` by the plan agent, not you.

## Report format

Standard. Include "Notes for Plan Agent" if the writing reveals:
- That Milne Lemma 3.3 requires hypotheses Mathlib cannot supply (forcing a strategy pivot).
- That the codim-1 extension lemma reduces, via Mathlib, to a single named lemma we already have (which would shrink the A.4.a budget).
- Strategy-modifying findings (route swap, etc.).
