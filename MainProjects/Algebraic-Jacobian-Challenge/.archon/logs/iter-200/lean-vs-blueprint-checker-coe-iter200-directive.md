# Lean ↔ blueprint check — `Albanese/CodimOneExtension.lean` vs
# `Albanese_CodimOneExtension.tex`

## Files

- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/CodimOneExtension.lean`
- Blueprint: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Albanese_CodimOneExtension.tex`

## Iter-200 edits (Lane COE-stage6-iiB, mathlib-build)

7 new axiom-clean **private** substrate theorems added (lines
~688–~790, all in `namespace AlgebraicGeometry.Scheme`):

1. `ringKrullDim_localization_eq_height_atPrime` (L~688) — Step 1
   bridge.
2. `MvPolynomial.maximalIdeal_height_ge_card_of_field` (L~696) — Step
   2 lower bound (Fin n), induction via `finSuccEquiv` +
   Jacobson-contraction.
3. `MvPolynomial.maximalIdeal_height_le_natCard_of_field` (L~717) —
   Step 2 upper bound (general `[Finite ιx]`).
4. `MvPolynomial.maximalIdeal_height_eq_card` (L~727) — Step 2
   combined (Fin n).
5. `MvPolynomial.maximalIdeal_height_eq_natCard` (L~738) — Step 2
   combined (general).
6. `ringKrullDim_localization_atMaximal_MvPolynomial` (L~767) —
   capstone Steps 1+2.
7. `ringKrullDim_quotient_add_eq_of_regular_sequence` (L~790) —
   Step 3 additive form.

Sorries: 3 → 3 (unchanged at L1061
`isRegularLocalRing_stalk_of_smooth`, L1258
`extend_of_codimOneFree_of_smooth`, L1333
`indeterminacy_pure_codim_one_into_grpScheme`).

## What I need from you

Bidirectional check, per your descriptor:

1. **Lean → blueprint**: are the 7 new substrate decls reflected in
   the chapter? The prover's handoff explicitly recommends:
   (a) ADD new `\lean{...}` pins for the 7 substrate lemmas
   (prefixed with `AlgebraicGeometry.Scheme.`);
   (b) ADD new subsection `\subsec:stage6_iib_substrate_iter200`
   documenting Step 1+2 closures + iter-201+ residual (Jacobian-
   regular-sequence witness, Stacks 00SW / 00OW);
   (c) UPDATE Stage 6.A description to note the Step 2 polynomial-
   side computation has now landed axiom-clean.
2. **Blueprint → Lean**: confirm the iter-199 chapter additions
   (`lem:smooth_to_regular_local_ring` `\lean{...}` pin to
   `AlgebraicGeometry.Scheme.isRegularLocalRing_stalk_of_smooth`;
   the in-body assembly NOTE replacing the stale `_aux` pin) still
   resolve correctly.
3. **Chapter completeness for iter-201+ prover**: the iter-201+
   substantive Lane COE main effort is the Jacobian-regular-sequence
   witness + scheme-to-algebra bridge for the L1061 body. Does the
   chapter currently sketch a recipe for this? If not, flag for
   plan-agent expansion.

## Severity rating

- `must-fix-this-iter` blocks downstream prover work next iter.
- `soon` should be addressed within 1-2 iters.
- `major` / `minor` are advisory.

## Output

Write to `.archon/task_results/lean-vs-blueprint-checker-coe-iter200.md`.
