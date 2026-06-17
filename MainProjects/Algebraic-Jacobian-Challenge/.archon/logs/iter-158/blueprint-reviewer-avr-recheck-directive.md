# Blueprint-reviewer directive — scoped fast-path re-review (iter-158)

## Scope (fast path — single chapter)
This is the sanctioned same-iter fast-path re-review. Read and verdict ONLY:
`blueprint/src/chapters/AbelianVarietyRigidity.tex`
(`% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean`).

## Context: what changed this iter and what to verify
The iter-157 whole-blueprint review + the per-file checker flagged a must-fix on this
chapter: the Lean decomposition of `thm:rigidity_lemma` had silently dropped the
collapse hypothesis, and the chapter did not pin the deferred geometric target
hypothesis-complete. This iter:

1. A `refactor` re-signed the Lean helpers `rigidity_eqOn_dense_open` and `rigidity_core`
   to carry the collapse data `(y₀) (z₀) (_hf : lift (𝟙 X) (toUnit X ≫ y₀) ≫ f =
   toUnit X ≫ z₀)`, so `rigidity_eqOn_dense_open` is now TRUE as stated and
   `rigidity_lemma`/`rigidity_core` genuinely consume `_hf`. Build GREEN; axiom-clean
   (sorryAx only via the one honest `rigidity_eqOn_dense_open` sorry).
2. A `blueprint-writer` added a `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}`
   lemma block (`lem:rigidity_eqOn_dense_open`) stating the dense-open agreement WITH
   the collapse hypothesis explicit, plus a three-helper decomposition remark
   (`rmk:rigidity_lemma_decomposition`), reusing the existing in-file Mumford verbatim
   quote.

## Verdict required (gate decision)
Report this chapter's `complete:` and `correct:` and any must-fix-this-iter findings.
Specifically confirm:
- The new `lem:rigidity_eqOn_dense_open` block's `\lean{}` target name matches the Lean
  declaration `AlgebraicGeometry.rigidity_eqOn_dense_open`, and its stated hypotheses
  (collapse `_hf`, the variety instances) match the corrected Lean signature — i.e. the
  blueprint target can no longer silently drop the collapse hypothesis.
- The chapter is now an adequate, hypothesis-complete guide for a prover lane on
  `rigidity_eqOn_dense_open` (the dense-open construction: `X` complete ⇒ `p₂` closed ⇒
  `G` closed; `y₀ ∉ G` via `_hf`; slice-constancy on `X × V`).
- No regression in the deferred/headline blocks (`thm:theorem_of_the_cube`,
  `prop:morphism_P1_to_AV_constant`, `prop:genusZero_curve_iso_P1`,
  `thm:rigidity_genus0_curve_to_AV`) — they remain honestly-deferred.

This verdict gates whether a prover lane on `rigidity_eqOn_dense_open` fires THIS iter.
