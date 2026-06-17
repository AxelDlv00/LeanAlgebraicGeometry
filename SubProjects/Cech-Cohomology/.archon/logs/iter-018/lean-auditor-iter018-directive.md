# Lean Auditor Directive

## Slug
iter018

## Scope (files)
all

## Focus areas (optional)
Pay extra attention to the four files edited this iter:
- AlgebraicJacobian/Cohomology/CechAcyclic.lean (new AwayComparison / CechLocalized namespaces, ~lines 477–780)
- AlgebraicJacobian/Cohomology/FreePresheafComplex.lean (augmentation chain map + a repaired proof)
- AlgebraicJacobian/Cohomology/CechBridge.lean (erw/term-mode defeq-heavy proofs; check for fragility/dead-ends)
- AlgebraicJacobian/Cohomology/HigherDirectImagePresheaf.lean (new file; sheafify-homology engine)

Absolute project root: /home/archon/proj/Cech-Cohomology

## Known issues
- CechAcyclic.lean line ~74/109 carries a single intentional `sorry` (a superseded relative-form
  declaration the project deliberately left in place). Report it but do not treat it as new.
- CechHigherDirectImage.lean line ~771 carries a frozen intentional `sorry` (P5b assembly). Known.
- 44 prover-created helpers currently lack blueprint coverage; coverage debt is already tracked
  separately — do not re-report missing blueprint entries (that is the lean-vs-blueprint-checker's job).
