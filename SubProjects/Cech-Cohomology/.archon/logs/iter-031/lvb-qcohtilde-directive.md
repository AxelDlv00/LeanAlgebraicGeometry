# Lean-vs-blueprint — QcohTildeSections.lean

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated `% archon:covers` chapter)

## Focus
This iter added one lemma `exists_finite_basicOpen_subcover` (P0 of the Route-P 01I8 decomposition). The
blueprint should already carry `lem:exists_finite_basicOpen_subcover` with a matching `\lean{}` pin —
confirm statement + proof-sketch fidelity. Also: the planned P1 `qcoh_localized_sections`
(`lem:qcoh_localized_sections`) was deliberately NOT formalized (genuine multi-hundred-LOC Mathlib gap;
prover recommends splitting into P1a affine-restriction infra + P1b IsLocalizedModule-local-on-span
patching). Report whether the blueprint's `lem:qcoh_localized_sections` proof is detailed enough to guide
formalization or is too thin / needs the planner to decompose it (P1a+P1b). Report bidirectionally.
