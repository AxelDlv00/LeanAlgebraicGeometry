# Blueprint-writer directive (iter-163) — rewrite the base-case section of AbelianVarietyRigidity.tex for Route C (Milne §I.3); CORRECT the cube error

## Chapter to edit (ONLY this file)
`blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Strategic context (the slice that matters)
The Rigidity-Lemma chain (`thm:rigidity_lemma` and its sub-lemmas) is PROVEN axiom-clean and must
NOT be touched. What changes is the **base-case section** — "morphisms from ℙ¹ to an abelian
variety are constant" and the genus-0 headline. The project has DECIDED (iter-163) to complete the
genus-0 arm via **Route C = Milne, *Abelian Varieties*, §I.3** (NOT the theorem of the cube, NOT
the differential/Frobenius route).

## CRITICAL CORRECTION (the chapter currently contains a mathematical error)
The current chapter asserts — in `\section{The theorem of the cube (deferred deep input)}`, in the
`\uses{...thm:theorem_of_the_cube}` edges of `prop:morphism_P1_to_AV_constant`, and in
`rmk:cube_is_load_bearing` — that the single-curve base case "ℙ¹→A constant" RESTS ON the theorem
of the cube. **This is FALSE.** Reading Milne §I.3 directly (verified iter-163):
Milne's Rigidity Theorem 1.1 IS the project's proven Rigidity Lemma; from it Milne derives
"ℙ¹→A constant" (Prop 3.9, the base case of Prop 3.10) WITHOUT the cube, using:
  - **Theorem 3.2**: a rational map from a nonsingular variety into an abelian variety is defined
    on the whole variety (proved via Theorem 3.1 = the valuative criterion of properness + Lemma
    3.3 = the indeterminacy locus of a rational map to a group variety is pure codimension 1);
  - **Corollary 1.2**: a regular map of abelian varieties carrying 0 to 0 is a homomorphism (from
    the Rigidity Theorem via the difference map);
  - **Corollary 1.5**: additivity — `h : V×W → A` with `h(v₀,w₀)=0` decomposes uniquely as
    `h = f∘p + g∘q` (a corollary of the Rigidity Theorem);
  - the **𝔾_a/𝔾_m incompatibility** (Prop 3.9): after translation `f|_{𝔸¹}` is an additive-group
    homomorphism `𝔾_a → A`; but `𝔸¹∖0 = 𝔾_m` is also a group variety giving `f(xy)=f(x)+f(y)+c`;
    the two structures are incompatible unless `f` is constant.
The theorem of the cube (Milne §I.5) is used ONLY for projectivity, the seesaw/square, dual abelian
varieties, polarizations, and the Poincaré sheaf — NONE on the genus-0 path. (For confirmation:
the Albanese universal property the positive-genus Route A needs, Milne Prop 6.1/6.4, is ALSO
cube-free — same Thm 3.2 + Cor 1.2 + Cor 1.5 ingredients.)

## Required structural changes

### (1) DELETE the cube section and the load-bearing remark
- Remove the entire `\section{The theorem of the cube (deferred deep input)}` block including
  `\begin{theorem}[Theorem of the cube]\label{thm:theorem_of_the_cube}...\end{theorem}` and its
  surrounding "Deferred prerequisite" prose.
- Remove `\begin{remark}\label{rmk:cube_is_load_bearing}...\end{remark}`.
- Remove every `\uses{...thm:theorem_of_the_cube...}` edge (in `prop:morphism_P1_to_AV_constant`'s
  statement AND proof). If you wish to record WHY the cube is not needed, write a SHORT new remark
  `rmk:cube_not_needed` stating that Milne §I.3/§III.6 derive both the genus-0 base case and the
  Albanese UP from the Rigidity Theorem + Thm 3.2 + Cor 1.2/1.5 with no theorem of the cube
  (cite Milne §I.3, §III.6) — keep it to ~4 lines, no verbatim cube quote needed.

### (2) ADD the Milne §I.3 decomposition (new lemma blocks, textbook-level proofs)
Add a new section, e.g. `\section{The Milne §I.3 chain: additivity, homomorphisms, extension}`,
BEFORE the "Morphisms from ℙ¹..." section, with these blocks (give each a `\label`, a `\lean{...}`
hint with the PROPOSED Lean name in the `AlgebraicGeometry` namespace, `\uses` edges, a textbook
proof, and full citation discipline — see below):

- `lem:hom_additivity_over_product` — **Milne Corollary 1.5.** Statement: let `V, W` be complete
  varieties over `k̄` with `k̄`-points `v₀, w₀`, `p, q` the projections `V×W→V`, `V×W→W`, and `A`
  an abelian variety; a morphism `h : V×W → A` with `h(v₀,w₀)=0` can be written uniquely as
  `h = f∘p + g∘q` with `f : V→A`, `g : W→A`, `f(v₀)=0`, `g(w₀)=0`. Proof: set
  `f = h|_{V×{w₀}}`, `g = h|_{{v₀}×W}`; the difference `φ = h − (f∘p + g∘q) : V×W → A` vanishes on
  both axes `V×{w₀}` and `{v₀}×W` (compute), so by the **Rigidity Lemma** (`thm:rigidity_lemma`,
  with `V` complete and `V×W` geometrically irreducible) `φ ≡ 0`; uniqueness because `f, g` are
  recovered as the axis-restrictions. `\uses{thm:rigidity_lemma}`. Proposed Lean name:
  `AlgebraicGeometry.hom_additive_decomp_of_rigidity` (the prover may rename).
- `lem:av_regular_map_is_hom` — **Milne Corollary 1.2.** A regular map `α : A → B` of abelian
  varieties is the composite of a homomorphism with a translation; equivalently if `α(0)=0` then
  `α` is a homomorphism. Proof: form `φ(a,a') = α(a+a') − α(a) − α(a') : A×A → B`; `φ` vanishes on
  `A×0` and `0×A`; Cor 1.5 / Rigidity forces `φ=0`. `\uses{lem:hom_additivity_over_product}`.
- `lem:rational_map_to_av_extends` — **Milne Theorem 3.2 (+ Thm 3.1, Lemma 3.3).** A rational map
  from a nonsingular variety to an abelian variety is defined on the whole variety. Proof sketch:
  Theorem 3.1 (valuative criterion of properness, Mathlib `IsProper.of_valuativeCriterion` /
  `ValuativeCriterion`) gives a representative defined outside codimension ≥ 2; Lemma 3.3 (the
  indeterminacy locus of a rational map to a GROUP variety is pure codimension 1, via the
  difference map `Φ(x,y)=φ(x)φ(y)⁻¹`) then shows there is no codimension-1 indeterminacy, so the
  map is everywhere defined. Flag clearly (in a `\begin{remark}`) that the codim-1 indeterminacy
  step (Lemma 3.3) has NO Mathlib Weil-divisor support and is the route's riskiest sub-build; note
  the open question whether a pointwise valuative extension at each codimension-1 point side-steps
  building divisor theory. `\uses{}` as appropriate. Proposed Lean name to be decided by the prover.
- `lem:hom_from_Ga_trivial` — **the 𝔾_a/𝔾_m core of Milne Prop 3.9.** A morphism `f : ℙ¹ → A`
  with `f(∞)=0`, restricted to `𝔾_a = 𝔸¹ = ℙ¹∖{∞}`, is (by Thm 3.2 + Cor 1.2) an additive-group
  homomorphism `f(x+y)=f(x)+f(y)`; restricting instead to `𝔾_m = 𝔸¹∖{0}` gives
  `f(xy)=f(x)+f(y)+c`; these are incompatible unless `f` is constant. Conclude `f` constant.
  `\uses{lem:av_regular_map_is_hom, lem:rational_map_to_av_extends}`.

### (3) REWRITE `prop:morphism_P1_to_AV_constant` proof as the Milne Prop 3.9 assembly
Replace the current cube-based proof body. New proof: `f : ℙ¹ → A` (already a morphism, ℙ¹ is
complete nonsingular so no extension needed for `f` itself); translate so `f(∞)=0`; apply
`lem:hom_from_Ga_trivial` to conclude `f` constant; un-translate. For the multi-factor Prop 3.10
(general unirational `V`) note the induction from Cor 1.5 reducing to one ℙ¹ factor, but only the
`d=1` base case is needed here. `\uses{lem:hom_from_Ga_trivial}` (and drop the cube edge). Keep the
existing verbatim Milne Prop 3.10 SOURCE QUOTE that is already in the block.

### (4) The headline `thm:rigidity_genus0_curve_to_AV` and `prop:genusZero_curve_iso_P1`
Leave `prop:genusZero_curve_iso_P1` (genus-0 ⟹ ℙ¹, Hartshorne IV.1.3.5) as-is — it is correct and
still needed. The headline proof is essentially correct (iso + ℙ¹-constancy); just ensure its
prose no longer references the cube and its `\uses` edges are consistent with the new chain.

## Citation discipline (MANDATORY — read the source yourself)
`pdftotext`/`pdftoppm` are NOT installed. Extract verbatim Milne text with a python snippet:
```
python3 -c "from pypdf import PdfReader; r=PdfReader('references/abelian-varieties.pdf'); print(r.pages[N].extract_text())"
```
PDF page = document page + 6. The text uses custom glyph encodings (e.g. `/STX` renders as `×`,
`/SOH`, `/NUL`); transcribe the MATHEMATICAL content faithfully but you may normalize these glyph
artifacts to standard notation in the `% SOURCE QUOTE:` — preserve every word, restore the obvious
symbol (×, ⁻¹, etc.). Pages to read for verbatim quotes:
- **Cor 1.5**: PDF page 15 (doc p.9) — "COROLLARY 1.5. Let V and W be complete varieties..."
- **Cor 1.2**: PDF page 15 (doc p.9) — "COROLLARY 1.2. Every regular map α:A→B of abelian
  varieties is the composite of a homomorphism with a translation."
- **Thm 3.2 / Thm 3.1 / Lemma 3.3**: PDF pages 22–24 (doc p.16–18).
- **Prop 3.9**: PDF pages 25–26 (doc p.19–20) — "PROPOSITION 3.9. Every rational map A¹⇢A or
  P¹⇢A is constant."
Each new block needs: `% SOURCE: [Milne, Abelian Varieties], <Cor/Thm/Prop number>, §I.<n>, doc
p.<N> (read from references/abelian-varieties.pdf, PDF page <N+6>)`, a `% SOURCE QUOTE:` verbatim
statement, a `% SOURCE QUOTE PROOF:` (before the proof env) when you transcribe the source proof,
and a visible `\textit{Source: Milne, Abelian Varieties, <number>.}` first line.

## Out of scope (do NOT touch)
- Any block of the proven Rigidity-Lemma chain (`thm:rigidity_lemma`, `rigidity_core`,
  `lem:rigidity_eqOn_dense_open`, `lem:rigidity_eqOn_saturated_open_to_affine`,
  `lem:morphism_eq_of_eqAt_closedPoints`, `lem:eq_comp_of_isAffine_of_properIntegral`,
  `lem:isIntegral_of_retract_of_integral`, `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`).
- Marker management: do NOT add or remove `\leanok` or `\mathlibok` (managed elsewhere). You MAY
  add `\lean{...}` hints with proposed declaration names.
- Other chapters.

## Report
In your report, list each block added/edited/removed, the Lean-name hints you proposed, and any
"Strategy-modifying findings" (e.g. if reading the source reveals Thm 3.2's extension genuinely
needs more than the planner assumed). If you discover you need a source not in `references/`,
dispatch a reference-retriever (your write-domain authorizes `references/**`).
