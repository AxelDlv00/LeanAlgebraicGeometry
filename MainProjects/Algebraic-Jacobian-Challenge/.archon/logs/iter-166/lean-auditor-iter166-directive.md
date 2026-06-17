# Lean Auditor Directive

## Slug

iter166

## Files modified this iter

- `AlgebraicJacobian/AbelianVarietyRigidity.lean` (Lane 1, refactor + proof close)
- `AlgebraicJacobian/Genus0BaseObjects.lean` (Lane 2, scaffold closures)

## Scope

Whole-project audit per your standing remit. Pay extra attention to the two iter-166 modified files
(absolute paths above). The other `.lean` files under
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/` and
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean` should
receive the standard per-file checklist.

## Specific concerns to verify (do NOT silence the alarm)

1. The new helper `morphism_P1_to_grpScheme_const_aux` in `AbelianVarietyRigidity.lean`
   contains 5 internal `sorry`s (L944, L949, L953, L1029, L1037) that propagate `sorryAx`
   into the consumer theorems `morphism_P1_to_grpScheme_const` and
   `rigidity_genus0_curve_to_grpScheme`. Confirm these are honest open math obligations
   (product geometric-irreducibility / LocallyOfFiniteType / IsReduced; ℙ¹ IsReduced;
   dominance of the open immersion `iotaGm`) — NOT propositions that should be already
   discharged elsewhere, and NOT "soft" type-class hypotheses that could be dropped.
2. Check the new `ProjectiveLineBar.{zeroPt, onePt, inftyPt}` defs for soundness — each
   constructs via `Proj.fromOfGlobalSections` of a vector evaluation; verify the unit-coordinate
   choice is consistent with the claimed point (`0 = [0:1]`, `1 = [1:1]`, `∞ = [1:0]`).
3. Detect any iter-157-style laundering: a top-level theorem with a `sorry`-free body whose
   referenced helper has a sorry that drops a load-bearing hypothesis. (Note: legitimate
   `sorryAx` propagation through honest helper sorries is NOT laundering.)
4. Check for stale narrative blocks / excuse-comments across the project. iter-164 flagged
   5 stale narratives (`Cotangent/GrpObj.lean`, `Cotangent/ChartAlgebra.lean`,
   `RigidityKbar.lean`) that were deferred to a future hygiene iter — confirm whether they
   are still in place or quietly addressed.

## Out of scope

- Do not read STRATEGY.md, PROGRESS.md, blueprint, or iter sidecars.
- Do not propose new prover work; just enumerate findings.

## Absolute paths

- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/
