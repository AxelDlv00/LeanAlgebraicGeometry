# lean-vs-blueprint-checker directive (iter-006)

Bidirectional verification of ONE Lean file against ONE blueprint chapter.

## Lean file

`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AcyclicResolution.lean`

## Blueprint chapter

`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_AcyclicResolution.tex`

## What changed this iter

The prover added 14 axiom-clean declarations, closing:
- `lem:injective_resolution_of_ses` → `CategoryTheory.InjectiveResolution.ofShortExact`
  (the dual Horseshoe Lemma assembly — TARGET 1).
- `lem:horseshoe_resolvesMiddle` → `...ofShortExact_resolvesMiddle`.
- `lem:acyclic_dimension_shift` → `CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic`
  (TARGET 2).
- Plus a project-local Mathlib supplement
  `HomologicalComplex.HomologySequence.quasiIso_τ₂` (no blueprint block yet).

The remaining target `lem:acyclic_resolution_computes_derived`
(`...rightDerivedIsoOfAcyclicResolution`, TARGET 3, the staircase) is NOT built.

## Verify

- Each `\lean{...}`-tagged block whose declaration now exists: does the Lean statement
  faithfully match the informal statement (signature, hypotheses, conclusion)? Flag any
  fake/placeholder/over-weak Lean statement that does not discharge the blueprint claim.
- Are there `\lean{...}` hints pointing at non-existent or renamed declarations?
- Are there substantive new Lean declarations (e.g. `quasiIso_τ₂`, the horseshoe helpers)
  with NO blueprint entry that the chapter should eventually cover?
- Is the chapter detailed enough to have guided this formalization, or did the Lean clearly
  need detail the blueprint lacks?

Report bidirectionally (Lean → blueprint AND blueprint → Lean) with severity tags.
Write your report to `task_results/lean-vs-blueprint-checker-acyclic.md`.
