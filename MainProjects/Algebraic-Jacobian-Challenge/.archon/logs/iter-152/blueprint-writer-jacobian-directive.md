# Blueprint Writer Directive

## Slug
jacobian-descent

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Strategy context (the slice that matters)
The project pivoted: rigidity (`rigidity_over_kbar`) is now proved ONLY over an
algebraically closed base field k̄ (it gains `[IsAlgClosed kbar]`). This reverses
the prior "iter-127 over-k commitment" that asserted rigidity was established
directly over an arbitrary base field k with NO base-change and NO Galois
descent. The genus-0 Albanese/Jacobian witness `genusZeroWitness` over a general
base field k must therefore now DESCEND the over-k̄ rigidity conclusion to k.

Disposition committed in STRATEGY.md: the descent of morphism equality along
Spec k̄ → Spec k is a SHORT consequence of
`AlgebraicGeometry.Flat.epi_of_flat_of_surjective` (a faithfully-flat surjective
base change Spec k̄ → Spec k is an epimorphism of schemes; two morphisms equal
after such a base change are equal), plus base-change-square commutativity. This
is verified cheap (a strategy-critic confirmed ~2 lines), and is cheaper than
the proper-cohomology flat-base-change gap it replaces.

## Required edits to this chapter
- In `def:genusZeroWitness` and in the C.2.f / C.2.g / §(γ) passages of
  `thm:nonempty_jacobianWitness`, and the Layer-I prose: REWRITE every assertion
  of the over-k commitment ("rigidity established directly over the base field
  k", "no base-change to k̄", "Galois descent DROPPED", "rigidity_over_kbar
  signature is k-agnostic") to the new picture:
  * Rigidity is proved over the algebraic closure k̄ (= `AlgebraicClosure k`)
    via `rigidity_over_kbar` (now `[IsAlgClosed kbar]`).
  * The genus-0 witness J over a general field k is the trivial dim-0 abelian
    variety Spec k (unchanged). To prove its universal property over k (a map
    C → A killing the point P is the constant morphism), base-change the data to
    k̄: C_{k̄} → A_{k̄} kills P_{k̄}; genus is stable under base change to k̄ for a
    geometrically irreducible curve, so `rigidity_over_kbar` applies and the
    base-changed map is constant.
  * DESCEND: the two morphisms (the given map and the constant map) over k agree
    after base change along the faithfully-flat surjection Spec k̄ → Spec k,
    hence agree over k. Cite `AlgebraicGeometry.Flat.epi_of_flat_of_surjective`
    as the descent engine and add a short proof sketch (faithfully-flat cover ⟹
    epimorphism ⟹ injective on Hom-sets after base change).
- Keep the pointed-vs-unpointed spine prose intact (the object J is real on both
  arms; vacuity touches only the ∀P field for unpointed C).
- The Route A (Picard scheme) §"Route A" content is unaffected by this pivot —
  do not touch it except where it inherits stale over-k rigidity framing.

## Out of scope
- Do NOT edit other chapters; flag cross-chapter issues in Notes for Plan Agent.
- Do NOT add `\leanok`/`\mathlibok` markers. Do NOT write Lean tactics.
- Do NOT change the protected `Jacobian` / `nonempty_jacobianWitness` /
  `genus` signatures or their `\lean{}` hints.
