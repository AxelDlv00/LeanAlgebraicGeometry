# lean-vs-blueprint-checker directive (iter-263)

Verify ONE Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
- Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

This iter the prover added two axiom-clean defs `pushPullObj` (= `p_* p^* F`) and
`pushPullMap` (the morphism brick) of the push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`.
The functor laws `pushPullMap_id` / `pushPullMap_comp` were NOT added (deferred); the
prover reports they are provable from Mathlib's `pseudofunctor` coherences
(`conjugateEquiv_pullbackComp_inv`, `pseudofunctor_associativity`, etc.) WITHOUT the
project-local Sq1 — contradicting the earlier "engine coupled to D3′ Sq1" belief. Check:
(a) does the chapter (sec:cech_three_part, the `G` prose) name `G` and its laws so a
prover can formalize `pushPullMap_id`/`pushPullMap_comp`, the `G`-functor assembly, and
the downstream `CechNerve`/`CechComplex`/`CechAcyclic.affine` obligations? (b) Is the
prose's dependency claim (does G need project Sq1, or only Mathlib?) consistent with the
prover's de-coupling finding — flag if the chapter still asserts the wrong dependency.
Report bidirectionally; flag must-fix if too thin.
