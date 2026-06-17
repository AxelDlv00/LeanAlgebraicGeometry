# Blueprint Writer Report

## Slug
route-c

## Status
COMPLETE — base-case section of `AbelianVarietyRigidity.tex` rewritten for Route C (Milne §I.3); the theorem-of-the-cube error is corrected and removed.

## Target chapter
`blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Summary of the correction
The chapter had asserted (in the cube `\section`, the `\uses{...thm:theorem_of_the_cube}` edges,
and `rmk:cube_is_load_bearing`) that the single-curve base case "ℙ¹→A constant" rests on the
theorem of the cube. Reading Milne §I.3 directly confirms this is **false**: Milne derives the base
case (Prop 3.9 = the d=1 case of Prop 3.10) directly from the Rigidity Theorem 1.1 (= our proven
`thm:rigidity_lemma`) via Cor 1.5 + Cor 1.2 + Thm 3.2 and a 𝔾_a/𝔾_m group-law incompatibility — no
cube. The proven Rigidity-Lemma chain (`thm:rigidity_lemma` … `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`)
was NOT touched.

## Changes Made
- **Revised** chapter intro paragraph ("The minimal chain has four links…") → "The chain has two
  parts…": removed the cube as a load-bearing link; now describes the Milne §I.3 additive chain and
  points to `rmk:cube_not_needed`. (`thm:rigidity_lemma` described as proven axiom-clean.)
- **Removed** the entire `\section{The theorem of the cube (deferred deep input)}` block, including
  `\begin{theorem}\label{thm:theorem_of_the_cube}…\end{theorem}` and its "Deferred prerequisite"
  prose.
- **Removed** `\begin{remark}\label{rmk:cube_is_load_bearing}…\end{remark}`.
- **Added section** `\section{The Milne §I.3 chain: additivity, homomorphisms, extension}` (placed
  before the "Morphisms from ℙ¹…" section), with:
  - **Added remark** `\label{rmk:cube_not_needed}` — ~4-line note: Milne §I.3/§III.6 derive both the
    genus-0 base case and the Albanese UP cube-free; cube (§I.5) is only for projectivity/seesaw/
    dual AV/polarizations/Poincaré.
  - **Added lemma** `\label{lem:hom_additivity_over_product}` `\lean{AlgebraicGeometry.hom_additive_decomp_of_rigidity}`
    — Milne Cor 1.5 (additive decomposition `h = f∘p + g∘q` over a product). Proof sketch added:
    Y, via the difference φ vanishing on both axes + Rigidity Lemma. `\uses{thm:rigidity_lemma}`.
  - **Added lemma** `\label{lem:av_regular_map_is_hom}` `\lean{AlgebraicGeometry.av_regularMap_isHom_of_zero}`
    — Milne Cor 1.2 (pointed regular map of AVs is a homomorphism). Proof sketch added: difference
    map `φ(a,a')=α(a+a')−α(a)−α(a')` vanishes on axes ⟹ 0. `\uses{lem:hom_additivity_over_product}`.
  - **Added lemma** `\label{lem:rational_map_to_av_extends}` `\lean{AlgebraicGeometry.rationalMap_to_av_extends}`
    — Milne Thm 3.2 (rational map nonsingular→AV is everywhere defined). Proof sketch added: Thm 3.1
    (valuative criterion ⟹ codim ≥ 2) + Lemma 3.3 (difference map ⟹ indeterminacy is pure codim 1).
  - **Added remark** `\label{rmk:thm32_codim1_mathlib_gap}` — flags Lemma 3.3 (pure-codim-1 via Weil
    divisors) as the route's riskiest sub-build with NO Mathlib divisor API; raises the pointwise-
    valuative-extension open question; notes the lemma is NOT invoked for V=ℙ¹ (defer it).
  - **Added lemma** `\label{lem:hom_from_Ga_trivial}` `\lean{AlgebraicGeometry.morphism_Ga_to_av_const}`
    — the 𝔾_a/𝔾_m core of Milne Prop 3.9. Proof sketch added: 𝔾_a-restriction is additive hom
    (via Cor 1.2), 𝔾_m-restriction gives `f(xy)=f(x)+f(y)+c`; incompatible unless constant.
    `\uses{lem:av_regular_map_is_hom, lem:rational_map_to_av_extends}`.
- **Revised** `prop:morphism_P1_to_AV_constant` — statement `\uses` changed from
  `{thm:rigidity_lemma, thm:theorem_of_the_cube}` to `{lem:hom_from_Ga_trivial}`; proof body fully
  rewritten as the Milne Prop 3.9 assembly (translate to f(∞)=0, apply `lem:hom_from_Ga_trivial`,
  un-translate; multi-factor note via Cor 1.5). The verbatim Milne Prop 3.10 SOURCE QUOTE in the
  block is preserved.
- **Left as-is** `prop:genusZero_curve_iso_P1` (Hartshorne IV.1.3.5) and the headline
  `thm:rigidity_genus0_curve_to_AV` — the headline proof already contained no cube reference and its
  `\uses{prop:morphism_P1_to_AV_constant, prop:genusZero_curve_iso_P1}` edges remain consistent.

## Cross-references introduced
- `\uses{thm:rigidity_lemma}` in `lem:hom_additivity_over_product` — target exists (proven chain, same chapter).
- `\uses{lem:hom_additivity_over_product}` in `lem:av_regular_map_is_hom` — same chapter.
- `\uses{lem:av_regular_map_is_hom, lem:rational_map_to_av_extends}` in `lem:hom_from_Ga_trivial` — same chapter.
- `\uses{lem:hom_from_Ga_trivial}` in `prop:morphism_P1_to_AV_constant` (statement + proof) — same chapter.
- Verified: all `\cref`/`\uses` targets resolve to a `\label` in-chapter except `chap:Genus`,
  `chap:Jacobian`, `chap:RigidityKbar` (legitimate other-chapter refs, pre-existing). All
  begin/end environments balanced (lemma 11/11, theorem 1/1, proposition 2/2, proof 14/14, remark 5/5).

## Lean-name hints proposed (all in `AlgebraicGeometry` namespace; prover may rename)
- `hom_additive_decomp_of_rigidity` (Cor 1.5)
- `av_regularMap_isHom_of_zero` (Cor 1.2)
- `rationalMap_to_av_extends` (Thm 3.2)
- `morphism_Ga_to_av_const` (Prop 3.9 core)

## References consulted
- `references/abelian-varieties.pdf` (Milne, *Abelian Varieties*) — extracted verbatim text via
  `pypdf`, normalizing glyph artifacts (×, −, ⁻¹, ∘, ⊆, ≥) per directive:
  - PDF p.15 (doc p.9): Cor 1.2 statement + proof, Cor 1.5 statement → blocks
    `lem:av_regular_map_is_hom`, `lem:hom_additivity_over_product`.
  - PDF p.16 (doc p.10): Cor 1.5 proof tail → `lem:hom_additivity_over_product` SOURCE QUOTE PROOF.
  - PDF pp.22–24 (doc p.16–18): Thm 3.1 (+ valuative-criterion proof), Thm 3.2, Lemma 3.3 (difference
    map) → `lem:rational_map_to_av_extends` + `rmk:thm32_codim1_mathlib_gap`.
  - PDF pp.25–26 (doc p.19–20): Prop 3.9 statement + proof, Prop 3.10 (unirational) → `lem:hom_from_Ga_trivial`
    and confirmation of the pre-existing `prop:morphism_P1_to_AV_constant` quote.
- `references/summary.md` — confirmed Milne file path and that `abelian-varieties.pdf` has a text layer.

## Macros needed (if any)
- None new. (`\fatsemi` already locally `\providecommand`'d at chapter top, untouched.)

## Reference-retriever dispatches (if any)
- None. All required verbatim source text was present in `references/abelian-varieties.pdf`.

## Notes for Plan Agent
- **`\leanok` markers:** the four new blocks (and `rmk:cube_not_needed`, `rmk:thm32_codim1_mathlib_gap`)
  carry NO `\leanok` (they are unformalized) — per descriptor I did not add markers. `sync_leanok`
  will manage. The existing chain blocks retain their `\leanok` markers untouched. Note: the rewritten
  `prop:morphism_P1_to_AV_constant` proof now `\uses` an unproven lemma chain, so its existing
  `\leanok` should be re-evaluated by `sync_leanok` (its Lean `morphism_P1_to_grpScheme_const` body
  state is what governs, not the blueprint dependency).
- The headline `thm:rigidity_genus0_curve_to_AV` and `prop:genusZero_curve_iso_P1` were left intact;
  both already read correctly for Route C.
- Re-running the blueprint review this iteration is advisable: the dependency graph changed shape
  (cube node removed; four new §I.3 nodes inserted between the Rigidity Lemma and the ℙ¹ proposition).

## Strategy-modifying findings
1. **The theorem of the cube is NOT a prerequisite of the genus-0 arm (corrects prior strategy).**
   The iter-156/162 framing that committed (or weighed committing) the theorem of the cube as the
   characteristic-free engine for "ℙ¹→A constant" was based on a misreading. Milne §I.3 derives the
   base case cube-free (Rigidity Thm 1.1 + Cor 1.5 + Cor 1.2 + Thm 3.2 + 𝔾_a/𝔾_m incompatibility),
   and the Albanese UP for Route A (Milne Prop 6.1/6.4, §III.6) is also cube-free. **Action:** the
   plan agent should update STRATEGY.md to drop the theorem-of-the-cube sub-build from the genus-0
   (and Albanese) critical path and retire the cube OVER_BUDGET re-estimate trigger noted for iter-162.
2. **New riskiest sub-build identified: Milne Lemma 3.3 (pure-codimension-1 indeterminacy).**
   Thm 3.2's everywhere-extension splits into Thm 3.1 (within reach of Mathlib's `ValuativeCriterion`)
   and Lemma 3.3 (no Mathlib Weil-divisor API). Captured in `rmk:thm32_codim1_mathlib_gap`. CRUCIAL
   mitigation: **for the genus-0 application V=ℙ¹ the map is already a morphism, so Lemma 3.3 / Thm 3.2
   are NOT invoked** — `prop:morphism_P1_to_AV_constant` only needs `lem:hom_from_Ga_trivial`, which in
   turn needs Thm 3.2 only to assert the 𝔸¹-restriction extends (trivial for an already-defined
   morphism on ℙ¹). The full Thm 3.2 (with Lemma 3.3) is needed only for the higher Albanese inputs of
   Route A and can be deferred. The plan agent should sequence provers so Lemma 3.3's divisor-theory
   sub-build does NOT block the genus-0 close.
