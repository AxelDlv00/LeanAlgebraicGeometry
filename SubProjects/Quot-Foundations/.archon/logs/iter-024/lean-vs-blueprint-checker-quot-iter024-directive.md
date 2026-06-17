# Lean ↔ Blueprint Checker Directive

## Slug
quot-iter024

## Lean file
AlgebraicJacobian/Picard/QuotScheme.lean

## Blueprint chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Known issues
- The 4 protected stubs (`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`,
  `Grassmannian.representable`) carry `sorry` by design (gated on upstream definitions) — known.
- This iter the prover added two NEW axiom-clean theorems that have NO blueprint block yet:
  `AlgebraicGeometry.isLocalizedModule_tilde_restrict` and
  `AlgebraicGeometry.isLocalizedModule_restrict_of_isIso_fromTildeΓ`. They are the affine-Spec
  ingredients of the keystone `lem:qcoh_section_localization_basicOpen`. Please confirm they are
  coverage debt (unreferenced substantive declarations) and recommend chapter-side blocks for them.
- The keystone block `lem:qcoh_section_localization_basicOpen` pins
  `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}`, which has NO Lean decl yet
  (gated on two Mathlib-absent prerequisites). A `% NOTE (iter-024 review)` recording this was just
  added to the block — verify the note is accurate and the pin is appropriately left unmarked.

Focus: (1) coverage debt for the two new theorems, (2) keystone block's pin-without-decl status,
(3) whether the chapter's keystone proof sketch is detailed enough to guide the (still-open) general
formalization.
