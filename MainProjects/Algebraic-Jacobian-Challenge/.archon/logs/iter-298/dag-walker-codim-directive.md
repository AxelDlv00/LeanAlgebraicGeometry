# DAG Walker Directive

## Slug
codim-cluster

## Seed
chap:Albanese_CodimOneExtension. The chapter has 29 nodes already wired into the goal cone
but **14 of its own helper lemmas form 3 disconnected sub-clusters** that the chapter's main
theorems never `\uses`. Wire them in.

## Strategy context
This chapter (A.4.a) proves the codimension-1 indeterminacy-locus extension used in the
Albanese construction: a rational map from a smooth variety to an abelian variety extends over
codimension-≥2 loci, via Krull-dimension / regular-sequence / Matsumura-cotangent estimates on
`MvPolynomial` localizations. The 3 clusters below ARE the Krull-dimension and
regular-sequence engine the main extension theorem rests on.

## Depth / scope
The chapter's top-level theorem(s) (the codimension-1 / coheight bridge result —
`av_codimOneFree_of_indeterminacy` and the height/krull-dim formula `smooth_algebra_krull_dim_formula`,
or whatever the chapter's exit lemmas are) mathematically depend on these helpers but their
`\uses{}` omits them. **Read the chapter, find the consuming theorem for each cluster, and add the
missing `\uses{}` edges.** Also complete each helper's own `\uses{}` (chain the height lemmas to the
regular-sequence lemmas to the cotangent/submersive lemmas as the mathematics dictates).
Do NOT change any statement; only add `\uses{}` edges (and add a block only if a `\uses` target
genuinely has none).

### The 3 disconnected sub-clusters (Lean basenames; find their blueprint labels)
- Krull-dim / height (8): mvPolynomial_maximalIdeal_height_eq_card, _eq_natCard, _ge_card,
  _le_natCard, ringKrullDim_localization_atMaximal_mvPolynomial, ringKrullDim_localization_eq_height_atPrime,
  ringKrullDim_quotient_add_eq_regular_sequence, ringKrullDim_quotient_localization_mvPolynomial_regular
- Regular sequence / Matsumura cotangent (4): isRegular_cons_of_quotient_ring,
  matsumura_descent_cotangent, matsumura_isRegular_of_linearIndependent_cotangent,
  quotSMulTop_quotientRing_linearEquiv
- Submersive cotangent (2): submersive_relation_cotangent_linearIndependent, _localized

## References
- `references/stacks-algebra.md` (Krull dimension, regular sequences, tag 00T7) if a statement
  needs a source. Most are already-blueprinted statements needing only edge wiring — prefer adding
  `\uses{}` over rewriting.

## Out of scope
- Edit ONLY `blueprint/src/chapters/Albanese_CodimOneExtension.tex`.
- No `\leanok`. No statement rewrites — wiring (`\uses{}`) only, plus missing blocks if a
  `\uses` target is undefined.
