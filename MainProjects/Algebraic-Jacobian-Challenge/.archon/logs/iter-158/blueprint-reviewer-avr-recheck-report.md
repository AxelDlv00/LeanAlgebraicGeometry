# Blueprint Review Report

## Slug
avr-recheck

## Iteration
158

## Scope note
Sanctioned same-iter fast-path re-review of a SINGLE chapter:
`blueprint/src/chapters/AbelianVarietyRigidity.tex`
(`% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean`). Other chapters were
NOT re-read this dispatch (the iter-157 whole-blueprint verdicts stand for them).

## Per-chapter

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **MUST-FIX from iter-157 is RESOLVED.** The new `lem:rigidity_eqOn_dense_open` block
    (`\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}`) now states the dense-open
    agreement WITH the collapse hypothesis explicit. Verified against the Lean source:
    the target `AlgebraicGeometry.rigidity_eqOn_dense_open` exists
    (`AbelianVarietyRigidity.lean:89`) and its signature carries the collapse datum
    `(x₀)(y₀)(z₀)(_hf : lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀)` plus the
    variety instances `[IsProper X.hom] [GeometricallyIrreducible (X ⊗ Y).hom]
    [IsReduced (X ⊗ Y).left] [IsSeparated Z.hom]`. The blueprint's encoding line
    (`lift (𝟙_X)(toUnit X ; y₀) ; f = toUnit X ; z₀`) and the instance list match the
    Lean signature exactly. The blueprint target can no longer silently drop the collapse
    hypothesis.
  - **Load-bearing antecedent is documented with a counterexample.** The lemma's
    "The collapse hypothesis is load-bearing" paragraph gives the `f = p₁` counterexample
    (agreement locus ⊆ {x = x₀}, empty interior) — the same `f = fst` witness recorded in
    the Lean docstring (`AbelianVarietyRigidity.lean:79-82`). This is exactly the iter-157
    failure mode and the chapter now pins it as unsatisfiable-without-`_hf`.
  - **Hypothesis-complete prover guide.** Between the `lem:rigidity_eqOn_dense_open` proof
    block (X complete ⇒ p₂ closed ⇒ G closed; y₀ ∉ G via collapse; slice-constancy on X×V)
    and the `rigidity_core` docstring (the two char-free Mathlib bridges:
    `IsProper.toUniversallyClosed` ⇒ closed projection, and
    `isField_of_universallyClosed` / `finite_appTop_of_universallyClosed` for
    proper-into-affine ⇒ single point), a prover lane on `rigidity_eqOn_dense_open` has an
    adequate, non-guessing roadmap. The new `rmk:rigidity_lemma_decomposition` correctly
    documents the three-helper split and warns that `_hf` must thread through all three.
  - **Axiom hygiene confirmed.** `lean_verify` on `rigidity_lemma` and `rigidity_core`:
    `{propext, sorryAx, Classical.choice, Quot.sound}` — no custom axioms; the sole
    `sorryAx` source is the one honest `rigidity_eqOn_dense_open` sorry. `rigidity_lemma`'s
    proof genuinely consumes `_hf` (passed to `rigidity_core` → `rigidity_eqOn_dense_open`
    at `:264` / `:184`), so the iter-157 "laundering" tell is gone.
  - **Deferred/headline blocks unchanged and still honestly deferred.**
    `thm:theorem_of_the_cube` (no `\lean`, explicitly "Recorded as a deferred input; no
    formal proof"), `prop:morphism_P1_to_AV_constant`
    (`\lean{...morphism_P1_to_grpScheme_const}`, Lean body `sorry`, blocked on the cube),
    `prop:genusZero_curve_iso_P1` (`\lean{...genusZero_curve_iso_P1}`, Lean body `sorry`,
    blocked on Riemann–Roch), `thm:rigidity_genus0_curve_to_AV`
    (`\lean{...rigidity_genus0_curve_to_grpScheme}`, Lean body `sorry`) — all four match
    their Lean scaffolds and remain honestly deferred. No regression.

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

The chapter `AbelianVarietyRigidity.tex` is `complete: true` / `correct: true` with no
must-fix-this-iter finding. The gate is satisfied for
`AlgebraicJacobian/AbelianVarietyRigidity.lean`.

Overall verdict: The iter-157 must-fix is fully resolved — the collapse hypothesis is now
explicit in both the Lean signature and the new `lem:rigidity_eqOn_dense_open` blueprint
block (names + hypotheses match, counterexample documented, axiom-clean modulo the one
honest sorry); a prover lane on `rigidity_eqOn_dense_open` may fire this iter.
