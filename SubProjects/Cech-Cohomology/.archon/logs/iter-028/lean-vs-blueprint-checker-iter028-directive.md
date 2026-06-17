## Lean file

/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechToCohomology.lean

## Blueprint chapter

blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(this is a consolidated chapter; it declares `% archon:covers ... CechToCohomology.lean`. The relevant
blueprint labels for this file are the 01EO chain: `lem:face_ses_of_sheaf_ses`,
`lem:absolute_cohomology_one_vanishing`, `def:basis_cov_system`, `def:has_vanishing_higher_cech`,
`lem:absolute_cohomology_pos_vanishing`, `lem:cech_to_cohomology_on_basis`, plus the prior-iter
L1/L2 `lem:cech...short_exact_of_basis` / `lem:quotient_cech_vanishing_of_basis`.)

## What to check

Bidirectional:
- Lean → blueprint: does each landed Lean declaration faithfully realize its blueprint statement?
  Pay special attention to `BasisCovSystem`: the Lean structure carries two sheaf-theoretic fields
  (`surj_of_vanishing`, `injective_acyclic`) whereas the blueprint `def:basis_cov_system` prose
  describes condition (2) as a raw topological cofinal system + an injective-acyclicity lemma
  application. Is the Lean a faithful (possibly more-concrete) encoding, or a weakening? Is the prose
  now lagging the Lean (a blueprint must-fix), or is the Lean wrong?
- Blueprint → Lean: is the chapter detailed enough to have guided this formalization, or too thin?
- Flag any signature mismatch with the `\lean{...}` pins, and the new helpers
  (`sectionsFunctor`, `CovDatum`, `injSES`, `injSES_shortExact`) that lack blueprint blocks.

Report must-fix-this-iter findings explicitly.
