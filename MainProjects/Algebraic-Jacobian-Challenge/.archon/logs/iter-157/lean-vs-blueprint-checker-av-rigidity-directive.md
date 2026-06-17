# Lean ↔ Blueprint Checker Directive

## Slug
av-rigidity-iter157

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex

## Known issues (do NOT re-report these as new findings)
- `morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, and `rigidity_genus0_curve_to_grpScheme` are KNOWN bare-`sorry` scaffolds, intentionally deferred this iter (only `rigidity_lemma` was on the prover lane). Their `:= sorry` is expected; the blueprint discloses them as deferred (theorem-of-the-cube / Riemann–Roch sub-builds). Do not classify these as must-fix placeholder bodies; instead just confirm the blueprint prose honestly marks them deferred.

## What I specifically want checked
1. **Signature fidelity of `rigidity_lemma`.** The prover refined the scaffold signature, ADDING `[GeometricallyIrreducible (X ⊗ Y).hom]`, `[IsReduced (X ⊗ Y).left]`, `[IsSeparated Z.hom]`, and an explicit point `(x₀ : 𝟙_ ⟶ X)`. Does the blueprint statement `thm:rigidity_lemma` (Mumford Form I) justify these added hypotheses (the prose says "complete variety X, any varieties Y, Z")? Is the `\lean{AlgebraicGeometry.rigidity_lemma}` hint pinned to a signature the prose actually supports, or is there a mismatch?
2. **Coverage of the two new helper lemmas** `rigidity_snd_lift` and `rigidity_core` and the deferred `rigidity_eqOn_dense_open`: are they referenced from the chapter (via `\lean{...}`) or should the chapter add blocks/hints for them? The chapter's `thm:rigidity_lemma` proof prose maps onto a three-lemma decomposition — is that decomposition reflected, or is the chapter silent on the helpers?
3. **Does `rigidity_eqOn_dense_open`'s `sorry` correspond exactly to the genuine geometric gap the blueprint names** (Mumford's "non-empty open + slice constancy"), or is it broader/narrower than the chapter claims?

Report bidirectionally (Lean→blueprint and blueprint→Lean). One file pair only.
