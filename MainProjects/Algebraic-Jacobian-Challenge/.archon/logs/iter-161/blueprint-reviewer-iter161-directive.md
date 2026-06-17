# Blueprint Reviewer Directive

## Slug
iter161

## Task

Whole-blueprint audit (read every chapter under `blueprint/src/chapters/`). Produce your
standard per-chapter completeness + correctness checklist and the HARD-GATE verdict per
chapter.

## Context for this iter (do NOT let it narrow your whole-blueprint read)

The only chapter edited this iteration is `AbelianVarietyRigidity.tex`. It received a
plan-authorized round addressing two iter-160 must-fix findings (from the iter-160
lean-vs-blueprint-checker + lean-auditor):

1. **Signature under-specification fixed.** The Lean Rigidity-Lemma chain now carries
   `[LocallyOfFiniteType (X ⊗ Y).hom]` (in addition to `[IsAlgClosed kbar]`) on all five chain
   lemmas (`rigidity_lemma`, `rigidity_core`, `rigidity_eqOn_dense_open`,
   `rigidity_eqOn_saturated_open_to_affine`, `rigidity_eqAt_closedPoint_of_proper_into_affine`).
   The chapter prose was updated to state this hypothesis and retire the now-false
   "[IsAlgClosed] is the only added instance" claim.
2. **Two new `\lean{}` blocks added** for the sub-lemmas that bridge 2's body decomposed into:
   `lem:morphism_eq_of_eqAt_closedPoints` (Step 2, proven, project-bespoke) and
   `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` (Step 1, the residual `sorry`, reusing
   the existing Mumford verbatim quote), with forward (acyclic) `\uses` edges from the proof of
   `lem:rigidity_eqOn_saturated_open_to_affine` to both. The "lone residual sorry" prose was
   refreshed to name Step 1 as the chain's single deep residual.

Please verify specifically (as part of your normal audit, not in place of it):
- whether `AbelianVarietyRigidity.tex` is now `complete: true` AND `correct: true` with the
  iter-160 must-fix items resolved (finite-type hypothesis stated; the two new sub-lemma blocks
  present, well-formed, with resolving `\lean{}` targets);
- that the `\uses` graph for the rigidity chain is forward-acyclic (no backward edge from the two
  new leaf lemmas up to `saturated_open`/`dense_open`, and `thm:rigidity_lemma`'s proof still
  carries its forward edge — the iter-160 review caught a backward 2-cycle, confirm it has not
  recurred);
- that no chapter currently feeding a prover lane carries a live must-fix.

The Lean build is GREEN (verified after the signature refactor this iter). The five chain
signatures in `AlgebraicJacobian/AbelianVarietyRigidity.lean` carry `[LocallyOfFiniteType
(X ⊗ Y).hom]`; the two new top-level theorems exist (`morphism_eq_of_eqAt_closedPoints` proven,
`rigidity_eqAt_closedPoint_of_proper_into_affine` `sorry`).
