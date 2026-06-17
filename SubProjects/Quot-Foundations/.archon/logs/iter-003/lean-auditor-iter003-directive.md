# Lean Auditor Directive

## Slug
iter003

## Scope (files)
all

## Focus areas (optional)
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` — received edits this iter (new helper defs + a decomposed mate lemma).
- `AlgebraicJacobian/Picard/FlatteningStratification.lean` — received edits this iter (a scaffolded dévissage chain of new lemmas, several with `sorry` bodies).

Pay extra attention to: newly-added `def`s that build category-theoretic equivalences from `Equivalence.mk` with `aesop_cat`-discharged coherence; lemma signatures that bind instance-existentials (`∃ (_ : Algebra ...) ...`); and any `sorry`-bearing body whose surrounding comment might be an excuse-comment vs. an honest deferral.

## Known issues
- Multiple `sorry` bodies are present by design (scaffolded chain + deferred downstream lanes). A `sorry` alone is not a finding; flag only suspect/fake bodies, excuse-comments, or wrong-as-Lean definitions.
- Absolute project root: `/home/archon/proj/Quot-Foundations`.
