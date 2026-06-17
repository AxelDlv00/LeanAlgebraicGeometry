## Lean file

/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AcyclicResolution.lean

## Blueprint chapter

/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_AcyclicResolution.tex

## Task

Bidirectional verification for the declarations added this iteration (the `Cosyzygy`
section, ~lines 676–818). Check both directions:

1. Lean → blueprint: do `Functor.cosyzygyShortExact` (lem:cosyzygy_ses),
   `Functor.gCosyzygyIsoCocycles` (lem:applied_cosyzygy_cycles), and
   `Functor.cohomologyAppliedResolutionIso` + `Functor.gHomologyZeroIso`
   (lem:cohomology_of_applied_resolution) faithfully match their blueprint statements?
   Flag any signature mismatch, fake/placeholder statement, or `\lean{}` name divergence.
   In particular verify the lem:cohomology_of_applied_resolution block: it states BOTH a
   degree-0 (H⁰≅G(A)) and a positive-degree (Hⁿ≅coker) claim, and its `\lean{}` now names
   two decls (cohomologyAppliedResolutionIso for n≥1, gHomologyZeroIso for n=0). Confirm the
   two Lean decls together cover the full blueprint statement.

2. Blueprint → Lean: is the chapter detailed enough to have guided this formalization, or
   did the Lean clearly need detail the blueprint lacks?

Also report: any blueprint block still naming a decl that does not exist; any frontier leaf
(lem:acyclic_one_iso_coker = rightDerivedOneIsoCokerOfAcyclic; the TARGET-3 assembly
rightDerivedIsoOfAcyclicResolution) whose blueprint statement looks under-specified for a
prover.
