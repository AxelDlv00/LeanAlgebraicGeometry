# Lean ↔ Blueprint Checker Directive

## Slug
openimm

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

## Blueprint chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

(Consolidated chapter; it declares
`% archon:covers AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`. Focus only on blocks
whose `\lean{...}` targets live in OpenImmersionPushforward.lean — the open-immersion acyclicity
family: `higherDirectImage_openImmersion_acyclic`, `higherDirectImage_openImmersion_comp`,
`ext_jShriekOU_eq_zero_of_specIso`, the jShriekOU-transport sub-lemma chain
(`jShriekOU_transport_along_iso` and its corepresentability helpers), and the Ext-transport bridge.)

## Known issues
- `case hqc => sorry` inside `higherDirectImage_openImmersion_acyclic` and the trailing `sorry` in
  `higherDirectImage_openImmersion_comp` are intentional frontier holes — do not flag their
  existence, only a type/blueprint mismatch.
- This iter the prover closed the `hjt` leaf via `jShriekOU_transport_along_iso` (now axiom-clean),
  built as a corepresentability iso using new helpers `sectionsCorep` and `sectionsCorepPushforward`.
  These two helpers currently have NO blueprint block (coverage debt, already noted for the
  planner) — report under blueprint-adequacy but they are not a must-fix.
- The remaining `hqc` (qcoh-preservation along the scheme iso) is a known geometric residual flagged
  in the strategy as needing `pushforward_commutes_restriction` (absent in Mathlib). Confirm the
  blueprint adequately previews this residual.
