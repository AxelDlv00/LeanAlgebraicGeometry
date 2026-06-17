# Blueprint-writer directive — AbelianVarietyRigidity.tex: rewrite the genus-0 base case to the direct ℙ¹×𝔾_a rigidity route (the "4th route")

## Chapter to edit
`blueprint/src/chapters/AbelianVarietyRigidity.tex` (ONLY this chapter). You may also
read/fetch under `references/**` if you need to re-quote Milne.

## Strategy context (the slice that matters)

The genus-0 base case is "over `k̄`, a pointed morphism `f : ℙ¹ → A` to an abelian
variety `A` is constant". A blueprint-reviewer flagged the current frontier blocks
`lem:hom_from_Ga_trivial` (Milne Prop 3.9 core) and `lem:rational_map_to_av_extends`
(Milne Thm 3.2) as NOT prover-ready, and a strategy-critic then RESOLVED the route:

**The base case does NOT need Theorem 3.2, Lemma 3.3, Auslander–Buchsbaum, the theorem
of the cube, or differentials.** The earlier blueprint conflated it with Milne's
*general* Theorem 3.4 (which extends a map on a NON-complete source over a complete
surface). But here `ℙ¹` is already complete and `f` is already a total morphism, so the
defect map is total with no abstract extension. The correct, char-general argument
(verified against Milne *Abelian Varieties* PDF p.19, `references/abelian-varieties.pdf`):

1. **Translation action** `σ : ℙ¹ × 𝔾_a → ℙ¹`, `σ(x,y) = x + y` — the `𝔾_a`-action on
   `ℙ¹ = 𝔸¹ ∪ {∞}` by Möbius maps fixing `∞`. This is a GENUINE TOTAL scheme morphism on
   all of `ℙ¹ × 𝔾_a`: in the chart `u = 1/x` at `∞`, the target coordinate
   `1/(x+y) = u/(1+uy)` is regular at `u = 0`; the locus `x+y=0` is covered by the other
   target affine chart. No indeterminacy, char-free.
2. **`h := σ ≫ f : ℙ¹ ⊗ 𝔾_a → A`** is a total morphism. Normalise `f(0) = η[A]` (translate).
   Apply the ALREADY-PROVEN `hom_additive_decomp_of_rigidity` (Milne Cor 1.5,
   `lem:hom_additivity_over_product`) — whose Lean signature requires only the FIRST
   factor proper — with `V := ℙ¹` (proper), `W := 𝔾_a` (no completeness needed):
   - `h(v₀,w₀) = f(0+0) = f(0) = η[A]` (the `h(v₀,w₀)=0` hypothesis of Cor 1.5).
   - V-axis restriction `x ↦ h(x,0) = f(x)`; W-axis restriction `y ↦ h(0,y) = f(y)`.
   - Cor 1.5 gives `h = (p ≫ f) · (q ≫ g)`, i.e. `f(x + y) = f(x) + f(y)` on `𝔸¹(k̄)`.
   So `f|_{𝔾_a}` is an additive-group homomorphism `𝔾_a → A`.
3. **`Hom(𝔾_a, A) = 0`**: a homomorphism from the additive group `𝔾_a` (affine,
   connected) into an abelian variety `A` (complete group) is trivial. (Milne's Prop 3.9
   `𝔾_a`/`𝔾_m` double-additivity: the same `σ`-argument on the multiplicative group `𝔾_m`
   gives `f(xy) = f(x)+f(y)+c`; the additive and multiplicative homomorphism structures
   on the overlap are incompatible unless the image is a point.) Hence `f` is constant.

This is Milne's Prop 3.9 read correctly: Milne invokes Thm 3.2 ONLY to extend a *general*
`α`; with `σ ≫ f` (where `f` is already total) the extension is free.

## What to write (precise)

Rewrite the `\section{The Milne §I.3 chain...}`/Prop-3.9 region as follows. Keep the
already-landed, complete+correct blocks UNTOUCHED: `thm:rigidity_lemma`, the whole
rigidity chain, `lem:hom_additivity_over_product` (Cor 1.5), `lem:av_regular_map_is_hom`
(Cor 1.2). Only the base-case frontier changes.

1. **NEW definition block** for the concrete genus-0 base objects + the action:
   - A concrete `ℙ¹` over `Spec k̄` (projective line as an `Over (Spec k̄)` object) and the
     additive group object `𝔾_a` (the affine line `𝔸¹` with its `GrpObj` additive
     structure). `\lean{...}` hints may be marked [expected] if the exact Mathlib idiom
     is uncertain; note "Mathlib has `AffineSpace 𝔸(n;S)` + `GrpObj`; ℙ¹ via projective
     space / `Proj`". Tag these as Archon-original infra (no external `% SOURCE` needed
     for the Lean encoding, but cite Milne/Hartshorne for the math where relevant).
   - `\definition` for `σ : ℙ¹ × 𝔾_a → ℙ¹` the translation action, with the explicit
     chart computation above as the construction sketch. `\lean{AlgebraicGeometry.gaTranslationP1}`
     [expected name — the prover may rename].
2. **NEW lemma block `Hom(𝔾_a, A) = 0`** (`\lean{AlgebraicGeometry.hom_Ga_to_av_trivial}`
   [expected]): a `GrpObj`-homomorphism `𝔾_a → A` into an abelian variety is the trivial
   (constant `η[A]`) map. Proof sketch: the `𝔾_a`/`𝔾_m` incompatibility, OR a cleaner
   completeness argument if you can state one (a non-constant hom would give a non-constant
   affine-to-complete map; rigidity / properness forces constancy). Decompose enough to
   formalize — do NOT leave it as a one-sentence assertion. If the cleanest formalizable
   statement is "an affine-source homomorphism into a complete group object is trivial",
   state THAT and note the `𝔾_a/𝔾_m` route as the classical proof.
3. **REWRITE `lem:hom_from_Ga_trivial`** (`\lean{AlgebraicGeometry.morphism_Ga_to_av_const}`)
   to the 4th-route proof: build `h := σ ≫ f`, apply `lem:hom_additivity_over_product`
   (Cor 1.5) with `V=ℙ¹`, `W=𝔾_a` to get `f(x+y)=f(x)+f(y)`, then invoke the
   `Hom(𝔾_a,A)=0` lemma. Update its `\uses{}` to: `{thm:rigidity_lemma,
   lem:hom_additivity_over_product, def:gaTranslationP1, lem:hom_Ga_to_av_trivial}` —
   and REMOVE the `lem:rational_map_to_av_extends` dependency.
4. **`lem:rational_map_to_av_extends` + `rmk:thm32_codim1_mathlib_gap`**: reframe as a
   **Route-A-only** item (the Albanese universal property, Milne Prop 6.x), explicitly
   NOT on the genus-0 path. Update the prose to say the genus-0 base case no longer uses
   it (the direct `σ ≫ f` argument replaces the surface extension). Do NOT delete the
   block (Route A may consume it later) but clearly demote it. Remove any `\uses` edge
   from a genus-0 block to it.
5. Update the chapter intro/overview prose (lines ~15–57) to describe the 4th route
   (direct `ℙ¹×𝔾_a` rigidity) instead of the Thm-3.2 surface-extension story.
6. Ensure `\uses` graph stays forward-acyclic. `prop:morphism_P1_to_AV_constant`
   continues to `\uses{lem:hom_from_Ga_trivial}` (now via the 4th route).

## Citation discipline
- Re-read Milne Prop 3.9 (`references/abelian-varieties.pdf`, PDF p.25–26, doc p.19–20)
  and keep/refresh the verbatim `% SOURCE QUOTE` + `% SOURCE QUOTE PROOF`. The existing
  block already has the Prop 3.9 quote; ensure the proof prose matches the σ≫f reading.
- For the concrete ℙ¹/𝔾_a/σ infra, these are Archon-original Lean encodings — no external
  `% SOURCE` needed for the encoding itself, but you may cite Milne/Hartshorne for the math.

## Out of scope
- Do NOT touch the proven rigidity chain / Cor 1.5 / Cor 1.2 statement or proof blocks
  (other than `\uses` edges if strictly needed — they should not need changes).
- Do NOT touch the 3 deferred genus-0 scaffold blocks' Lean targets.
- Do NOT add or remove `\leanok` / `\mathlibok` markers (managed elsewhere).
- Do NOT write Lean tactic code; mathematical prose + `\lean{}`/`\uses{}` hints only.

## Report back
- Which blocks you added/rewrote, the `\lean{}` names you assigned (so the prover and I
  can scaffold them), and any "Strategy-modifying findings" you surface while writing.
