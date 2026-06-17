# Blueprint-writer directive — Picard_GrassmannianQuot.tex Nitsure §5 inverse blocks (iter-077)

Target: `blueprint/src/chapters/Picard_GrassmannianQuot.tex` (EXISTING — add new blocks, do not
disturb existing ones). The Nitsure §5 "from quotient to morphism" sub-lemmas are SORRY in Lean
(L2065, L2147, L2160, L2249) with ZERO blueprint coverage; the `represents`
(`thm:grassmannian_universal_property`) sketch already invokes them but they have no blocks.

Action: add these blocks in section `sec:grquot_universal` (dependency order). Names = real Lean pins:

1. `\lemma{lem:tautologicalQuotient_epi}` `\lean{Grassmannian.tautologicalQuotient_epi}` —
   `u : O^r ↠ U` is epi. Proof: each `u^I` is split-epi (`lem:gr_chartQuotientMap_epi`) and epi is
   local on the chart cover. \uses{lem:gr_chartQuotientMap_epi, def:tautological_quotient}.
2. `\definition{def:isoLocus}` `\lean{Grassmannian.isoLocus}` — the open sub `isoLocus φ ⊆ X` where
   `φ : M ⟶ N` is locally an iso.
3. `\lemma{lem:isIso_pullback_isoLocus_map}` `\lean{Grassmannian.isIso_pullback_isoLocus_map}` —
   the pullback of `φ` to `isoLocus φ` is an iso. Proof: sheaf locality + the Mathlib stalk-iso
   criterion. \uses{def:isoLocus, lem:isIso_of_stalkFunctor_map_iso_mathlib}.
4. `\definition{def:chartLocus}` `\lean{Grassmannian.chartLocus}` — `chartLocus x I ⊆ T`, the locus
   where the I-columns of the quotient form a basis. \uses{def:isoLocus, def:gr_chart_quotient}.
5. `\lemma{lem:chartLocus_isOpenCover}` `\lean{Grassmannian.chartLocus_isOpenCover}` — the
   `chartLocus x I` cover `T`. Proof: at any point `t` the fiber quotient is surjective, so some
   `I` gives an iso on the fiber; Nakayama extends it to a neighbourhood.
   \uses{def:chartLocus, def:gr_rankQuotient}.
6. `\definition{def:grPointOfRankQuotient}` `\lean{Grassmannian.grPointOfRankQuotient}` (sorry L2249)
   — the morphism `T → Gr(d,r)` induced by a rank-d quotient `x`, glued from the chart-local
   classifying morphisms `T_I → U^I` via `lem:chartLocus_isOpenCover`.
   \uses{lem:chartLocus_isOpenCover, lem:isIso_pullback_isoLocus_map, def:gr_affine_chart, lem:gr_cocycle}.

Citation discipline: the "T_I cover T (Nakayama)" argument is Nitsure §1. Read
`references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` (or the .pdf) for the verbatim source
quote; add `% SOURCE` + `% SOURCE QUOTE` + `\textit{Source: Nitsure §1.}` to the cover lemma block.
If you need a source not present, spawn a reference-retriever (references/** is in your domain).

Mathlibok: you MAY `\mathlibok` ONLY the genuine Mathlib anchor `lem:isIso_of_stalkFunctor_map_iso_mathlib`
(short block, project-notation statement + its real Mathlib `\lean{}`). Do NOT add `\leanok` anywhere.
Constraints: this chapter only. Each block has ≥1 detailed informal-proof paragraph (formalizable).
