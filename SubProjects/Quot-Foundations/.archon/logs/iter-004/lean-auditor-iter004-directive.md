# Lean Auditor Directive

## Slug
iter004

## Scope (files)
all

## Focus areas (optional)
Two files received prover edits this iter — audit the whole project but pay
extra attention to:
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (a new L4 sub-lemma chain
  landed; one helper `base_change_regroup_linearEquiv` was proved axiom-clean,
  two sibling decls carry `sorry`; check the docstrings around the `sorry`s do
  not understate what is open).
- `AlgebraicJacobian/Picard/FlatteningStratification.lean` (four GF L3 lemmas
  closed; L4 was re-signed; L5 has a torsion sub-case closed with a residual
  `sorry`). Check the re-signed `exists_localizationAway_finite_mvPolynomial`
  signature is honest, and that the `by_cases htors` split in L5 is genuine
  content rather than a vacuous dodge.

Absolute paths:
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/FlatteningStratification.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/RelativeSpec.lean

## Known issues
- The four `sorry`s in FlatBaseChange.lean and four in FlatteningStratification.lean
  are known, documented scaffolding — do NOT re-report each `sorry` as a finding
  on its own. Report only if a `sorry`-bearing decl's docstring/comment
  misrepresents what is proved, or if a body looks like fake content.
- QuotScheme.lean's 4 `sorry`s are deliberate stubs (no prover ran there this
  iter).
