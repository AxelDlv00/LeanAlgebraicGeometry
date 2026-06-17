# Blueprint Writer Report

## Slug
eqon-block

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Changes Made
- **Added remark** `\remark`/`\label{rmk:rigidity_lemma_decomposition}` — records the Lean
  three-helper decomposition `rigidity_snd_lift` (cartesian-monoidal algebra) →
  `rigidity_core` (scheme-level gluing via separatedness) → `rigidity_eqOn_dense_open`
  (the non-empty open + slice-constancy geometry), and states explicitly that the collapse
  hypothesis must be threaded through all three helpers (dropping it from the lower helpers
  is unsound). Placed immediately after `rmk:rigidity_lemma_cube_free`.
- **Added lemma** `\lemma`/`\label{lem:rigidity_eqOn_dense_open}`/
  `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}`/`\uses{thm:rigidity_lemma}` — the
  isolated geometric heart: existence of a non-empty open `U = X × V` (`V := Y − G`,
  `G = p₂(f⁻¹(Z − U₀))`, closed because `X` complete ⇒ `p₂` closed) on which `f` agrees with
  the collapsed map `retract ≫ f`, **with the collapse hypothesis `f(X × {y₀}) = {z₀}` made
  explicit as an antecedent** (in both project prose and the Lean `lift … = toUnit X ≫ z₀`
  encoding). Includes a dedicated "the collapse hypothesis is load-bearing" paragraph: `y₀ ∉ G`
  holds *because* the rigidified slice lands in the affine `U₀`, and the hypothesis-free version
  is false (`f = p₁` counterexample, agreement locus has empty interior).
  - Proof sketch added: Y — restated body of Mumford's Rigidity-Lemma proof (the dense-open
    construction), pinpointing that the collapse hypothesis is used at exactly one place
    (`y₀ ∉ G`), with a pointer to `rigidity_core`'s docstring for the two Lean slice-constancy
    bridges.

## Citations
- `lem:rigidity_eqOn_dense_open` reuses the **same Mumford source** as `thm:rigidity_lemma`:
  `% SOURCE: [Mumford, Abelian Varieties], Rigidity Lemma (Form I.), Ch. II §4, book p.43`
  `(read from references/mumford-abelian-varieties.pdf, PDF page 54)`. The `% SOURCE QUOTE:`
  (statement) and `% SOURCE QUOTE PROOF:` (the "Choose any point x₀ … this proves our
  assertion" passage) are **copied verbatim from the existing quotes already present in this
  same chapter** (the `thm:rigidity_lemma` block, lines 60–64 and 74–83) — no new quote
  invented, per directive.

## Cross-references introduced
- `\uses{thm:rigidity_lemma}` in `lem:rigidity_eqOn_dense_open` (statement + proof) — target
  exists in this same chapter.
- `\cref{lem:rigidity_eqOn_dense_open}` referenced from the new
  `rmk:rigidity_lemma_decomposition` — both new in this edit, consistent.

## References consulted
- `blueprint/src/chapters/AbelianVarietyRigidity.tex` (the target chapter itself) — reused the
  verbatim Mumford `% SOURCE QUOTE:` and `% SOURCE QUOTE PROOF:` already vetted there; no
  external reference file newly opened (the directive instructed reuse of existing in-file
  quotes, so no `reference-retriever` dispatch was needed).
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` (read-only, for signature verification) —
  confirmed the landed `rigidity_eqOn_dense_open` signature carries `(_hf : lift (𝟙 X)
  (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀)` and the `retract := lift (toUnit (X⊗Y) ≫ x₀) (snd X Y)`
  conclusion, so the prose block matches the formal target exactly.

## Markers / NOTE / deferred blocks
- No `\leanok` or `\mathlibok` added or removed (sync/review-owned).
- The existing `% NOTE (iter-157 review)` comment in the `thm:rigidity_lemma` proof block was
  NOT touched.
- The deferred / headline blocks (`thm:theorem_of_the_cube`, `prop:morphism_P1_to_AV_constant`,
  `prop:genusZero_curve_iso_P1`, `thm:rigidity_genus0_curve_to_AV`) and the `thm:rigidity_lemma`
  statement/quotes were NOT modified.

## Macros needed (if any)
- None new. The block uses the chapter-local `\fatsemi` (already `\providecommand`'d at the top
  of this chapter) and standard mathmode; no new macro required.

## Notes for Plan Agent
- LaTeX validity: the two new environments (`\begin{remark}…\end{remark}`, `\begin{lemma}…
  \end{lemma}`) plus the new `\begin{proof}…\end{proof}` are balanced; braces in
  `\label`/`\lean`/`\uses`/`\cref` are balanced.

## Strategy-modifying findings
None. This was a pin (exposing the deferred geometric target with its load-bearing hypothesis
explicit), not a re-route; the prose surfaced no strategy-level issue.
