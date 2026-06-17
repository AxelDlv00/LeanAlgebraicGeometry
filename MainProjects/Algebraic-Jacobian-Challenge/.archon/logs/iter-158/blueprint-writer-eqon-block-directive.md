# Blueprint-writer directive — pin the deferred dense-open lemma hypothesis-complete

## Chapter (sole write domain)
`blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Why
The iter-157 Lean decomposition of `thm:rigidity_lemma` silently dropped the collapse
hypothesis from its helper lemmas, producing a FALSE deferred `sorry` that the
blueprint did not pin. iter-158 re-signed the Lean helpers to thread the collapse
hypothesis. The chapter must now expose the genuine deferred geometric target as a
hypothesis-complete block so the missing hypothesis can never silently recur. The
checker (`lean-vs-blueprint-checker av-rigidity-iter157`) recommended exactly this:
"Add a `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}` block stating the deferred
dense-open agreement WITH the collapse hypothesis explicit."

## Lean target to pin (now landed, build-green)
`AlgebraicGeometry.rigidity_eqOn_dense_open`, in
`AlgebraicJacobian/AbelianVarietyRigidity.lean`. Its current (corrected) signature:

- `X Y Z : Over (Spec (.of kbar))`, instances
  `[IsProper X.hom] [GeometricallyIrreducible (X ⊗ Y).hom] [IsReduced (X ⊗ Y).left] [IsSeparated Z.hom]`;
- `(f : X ⊗ Y ⟶ Z)`, a point `(x₀ : 𝟙_ ⟶ X)`, the collapse data
  `(y₀ : 𝟙_ ⟶ Y) (z₀ : 𝟙_ ⟶ Z)` and
  `(_hf : lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀)` [= "`f(X × {y₀})` is the
  single point `z₀`"];
- conclusion: there is a non-empty open `U ⊆ (X ⊗ Y).left` on which `f` agrees (as a
  scheme morphism) with the collapsed map `retract ≫ f`, where
  `retract := lift (toUnit (X⊗Y) ≫ x₀) (snd X Y)` [= "`(x,y) ↦ (x₀,y)`"].

## What to add (one new block + a short decomposition note)
1. Inside the `\section{The Rigidity Lemma}` section, AFTER the existing
   `thm:rigidity_lemma` proof + `rmk:rigidity_lemma_cube_free`, add a **lemma block**
   `\label{lem:rigidity_eqOn_dense_open}`, `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}`,
   `\uses{thm:rigidity_lemma}` (or no `\uses` if cleaner), stating in project prose the
   dense-open agreement WITH the collapse hypothesis `f(X × {y₀}) = {z₀}` made explicit
   as a hypothesis. This is the **isolated geometric heart** of Mumford's proof: the
   construction of the non-empty open `V := Y ∖ G` (`G = p₂(f⁻¹(Z∖U))`, closed because
   `X` complete ⇒ `p₂` closed; `y₀ ∉ G` *because* `f(X×{y₀}) = {z₀} ⊆ U` — THIS is where
   `_hf` is essential) plus slice-constancy on `X × V`. Cite the same Mumford source as
   `thm:rigidity_lemma` (the dense-open construction IS the body of that proof):
   `% SOURCE: [Mumford, Abelian Varieties], Rigidity Lemma (Form I.), Ch. II §4, book
   p.43 (read from references/mumford-abelian-varieties.pdf, PDF page 54)` and reuse the
   verbatim `% SOURCE QUOTE PROOF:` fragment already present in this chapter (the
   "Choose any point x₀ … Y − G = V is a non-empty open … f(x,y) = f(x₀,y) = g∘p₂(x,y)"
   passage) — do NOT invent a new quote; copy the relevant sentences verbatim from the
   existing `% SOURCE QUOTE PROOF:` block in this same file.
2. Add one short prose sentence (in the `rmk:rigidity_lemma_cube_free` remark or a new
   one-line remark) recording the Lean three-helper decomposition: `rigidity_snd_lift`
   (cartesian-monoidal algebra) → `rigidity_core` (scheme-level gluing: agreement on a
   dense open propagates to everywhere via separatedness) → `rigidity_eqOn_dense_open`
   (the non-empty open + slice-constancy, the genuine geometry). This lets future
   reviewers map the Lean chain to the prose and prevents the dropped-hypothesis
   regression from recurring.

## Emphasis to bake into the new block's prose
The hypothesis `_hf` (`f(X × {y₀}) = {z₀}`) is **load-bearing**: it is precisely what
makes `V := Y ∖ G` non-empty (`y₀ ∉ G`). A version without it is false (`f = fst` on
`X=Y=Z` is a counterexample — the agreement open is empty). State this explicitly so
the formal target can never again drop the collapse hypothesis.

## Out of scope (do NOT touch)
- Do NOT add or remove any `\leanok` or `\mathlibok` marker (sync-managed / review-owned).
- Do NOT edit or remove the existing `% NOTE (iter-157 review)` comment in the
  `thm:rigidity_lemma` proof block — `% NOTE:` is the review agent's domain; it will be
  reconciled at review.
- Do NOT modify `thm:theorem_of_the_cube`, `prop:morphism_P1_to_AV_constant`,
  `prop:genusZero_curve_iso_P1`, or `thm:rigidity_genus0_curve_to_AV` (the deferred /
  headline blocks) — they are correct and out of scope.
- Do NOT change the `thm:rigidity_lemma` statement or its verbatim source quotes.

## Report
Confirm the new `lem:rigidity_eqOn_dense_open` block (with the explicit collapse
hypothesis) and the decomposition note were added, and that no marker / `% NOTE:` /
deferred block was touched. Flag any "Strategy-modifying findings" if the prose
surfaces one (none expected — this is a pin, not a re-route).
