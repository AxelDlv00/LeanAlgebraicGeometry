# Lean ↔ Blueprint Checker Directive

## Slug
affineserre

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; it carries `% archon:covers ... AffineSerreVanishing.lean` near its top.)

## Focus
This iter added 7 declarations implementing "Need #2" — enlarging the affine cover system basis from
distinguished opens {D f} to ALL affine opens, and reducing general-affine-open Serre vanishing to a
single change-of-scheme "seed" hypothesis. Verify: (a) each new declaration's signature matches the
blueprint's intent; (b) the blueprint actually contains (or adequately specifies) these new
declarations, or flag them as coverage debt; (c) whether the residual `htilde`/`hseed` hypotheses
faithfully represent the blueprint's stated remaining gap, and whether the blueprint adequately
describes the change-of-scheme seed route. Report bidirectionally.
