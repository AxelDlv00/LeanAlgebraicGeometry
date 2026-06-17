# Lean ↔ Blueprint Checker Directive

## Slug

avr-iter166

## File pair to audit

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Scope

iter-166 Lane 1 landed:
- import of `AlgebraicJacobian.Genus0BaseObjects` (L7);
- refactor of `morphism_P1_to_grpScheme_const` to drop the abstract `P1` parameter and use the
  concrete `ProjectiveLineBar kbar` (signature + proof body, L1098, with private helper
  `morphism_P1_to_grpScheme_const_aux` at L931);
- refactor of `genusZero_curve_iso_P1`'s target (signature only; body remains `sorry`, L1131);
- proof body of `rigidity_genus0_curve_to_grpScheme` (L1162) via iso transport.

Verify bidirectionally:

(A) **Lean → Blueprint.** Does the refactored Lean (new signatures + proof structure) match
the informal statements in `AbelianVarietyRigidity.tex`? In particular:
- `prop:morphism_P1_to_AV_constant` (chapter L1199–1278) — should match the new Lean signature
  using concrete `ProjectiveLineBar` and the 𝔾ₘ-scaling shortcut.
- `prop:genusZero_curve_iso_P1` (L1282–1335) — signature `C ≅ ProjectiveLineBar kbar`.
- `thm:rigidity_genus0_curve_to_AV` (L1339–1384) — proof via iso transport.
- The proof body of `morphism_P1_to_grpScheme_const_aux` follows the chapter's "𝔾ₘ-scaling
  shortcut" sketch (W-axis collapse via `gmScalingP1_collapse_at_zero`, Cor 1.5, dominance of
  `iotaGm`).

(B) **Blueprint → Lean.** Is the chapter sufficiently detailed for the iter-166 Lane 1 refactor?
- Are the 5 honest helper sorries (product geom-irred / LocallyOfFiniteType / IsReduced of
  `ProjectiveLineBar.left`; dominance of `iotaGm`) reflected in the chapter prose as named
  subordinate lemmas, or are they implicit "obvious" steps the chapter glosses over?
- Does the blueprint pin all `\lean{...}` hooks correctly post-refactor (especially for
  `morphism_P1_to_grpScheme_const_aux` — the new private helper)?

(C) Look for iter-157-style laundering: a `sorry`-free top-level body whose helper has a
sorry that drops a load-bearing hypothesis. Confirm this is NOT happening.

(D) Check axiom hygiene assertions: I have independently verified that
`morphism_P1_to_grpScheme_const` and `rigidity_genus0_curve_to_grpScheme` have axioms
`{propext, sorryAx, Classical.choice, Quot.sound}` — confirm sorryAx propagation is genuinely
through the 5 helper sorries + `genusZero_curve_iso_P1` sorry (no surprise extra axioms).

## Out of scope

- Do not read STRATEGY.md, PROGRESS.md, iter sidecars, or other Lean files.
- Restrict to the one file pair named above.
