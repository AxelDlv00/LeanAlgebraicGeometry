# lean-vs-blueprint-checker — AVR iter-164

## File pair

- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint chapter: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

(Note: the prover's task-prompt assigned a non-existent chapter path
`AlgebraicJacobian_AbelianVarietyRigidity.tex`; the actual chapter is
`AbelianVarietyRigidity.tex`. Use the actual chapter.)

## Iter-164 prover edits to audit

This iter was a hygiene lane. The prover:

1. Refreshed the file header (links 1 & 2) to describe the current state:
   - Link 1 = the whole Rigidity-Lemma chain is `sorry`-free / axiom-clean.
   - Link 2 = `morphism_P1_to_grpScheme_const` via the 𝔾ₘ-scaling shortcut, replacing the
     abandoned "blocked on the theorem of the cube" framing.
2. Updated ~6 status comments on the now-PROVEN chain lemmas
   (`rigidity_eqAt_closedPoint_of_proper_into_affine`, `rigidity_eqOn_saturated_open_to_affine`,
   `rigidity_eqOn_dense_open`, `rigidity_core`, `rigidity_lemma`) from "lone residual `sorry`" /
   "Status (iter-160): sorry" to "PROVEN axiom-clean (iter-162)".
3. Rewrote `morphism_P1_to_grpScheme_const`'s docstring (L909–926) to the 𝔾ₘ-scaling shortcut.
4. Dropped `[Smooth A.hom]` / `[GeometricallyIrreducible A.hom]` from the `A`-side of
   `hom_additive_decomp_of_rigidity` (L820–821) and the knock-on `B`-side of
   `av_regularMap_isHom_of_zero` (L890).

## What to check

### Lean → blueprint

- Verify every `\lean{...}` cross-reference in `AbelianVarietyRigidity.tex` still resolves and
  is faithful after this iter's edits. Pay special attention to:
  - `lem:hom_additivity_over_product` / Cor 1.5 → `hom_additive_decomp_of_rigidity` (sig changed:
    A-side instances dropped). The blueprint may have been written against the more general
    hypotheses; confirm the Lean signature is at least as general (drop = generalization, so the
    chapter remains correct).
  - `lem:av_regular_map_is_hom` / Cor 1.2 → `av_regularMap_isHom_of_zero` (B-side instances
    dropped, same generalization concern).
  - `prop:morphism_P1_to_AV_constant` → `morphism_P1_to_grpScheme_const` (docstring now matches the
    blueprint's 𝔾ₘ-scaling proof, but the body is still `sorry`).

### Blueprint → Lean

- Confirm the blueprint chapter still describes the 𝔾ₘ-scaling shortcut as the primary route
  (no leftover cube / Thm 3.2 prose). The `blueprint-reviewer avr-fastpath2` from this iter's
  plan phase already CLEARED the HARD GATE, so this should be intact — verify.
- Confirm `\uses{...}` edges remain forward-acyclic.
- Confirm no `\leanok` was added / removed by the agent (sync_leanok owns that marker).

## Severity

Report findings as must-fix-this-iter / major / minor. Pay close attention to the iter-157
laundering anti-pattern (no `sorryAx` propagating through an apparently-closed proof).
