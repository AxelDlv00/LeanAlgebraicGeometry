# lean-vs-blueprint-checker directive (iter-220)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

Focus: section `sec:tensorobj_dual_infra` and the internal-hom blocks
(`def:presheaf_internal_hom_value`, `def:presheaf_internal_hom_slice_value`,
`lem:presheaf_internal_hom_restriction`, `def:presheaf_internal_hom`).

This iter the prover built (axiom-clean) the restriction maps and ASSEMBLED the presheaf internal hom:
`PresheafOfModules.InternalHom.restrictionMap` (+ functoriality/semilinearity lemmas),
`internalHomPresheaf`, and `PresheafOfModules.InternalHom.internalHom`.

Report:
(a) whether the Lean follows the blueprint (no fake/placeholder statements; signatures match);
(b) any `\lean{...}` name mismatch — NOTE: the blueprint `def:presheaf_internal_hom` pins
    `\lean{PresheafOfModules.internalHom}` but the built decl is
    `PresheafOfModules.InternalHom.internalHom` (in the `InternalHom` namespace) — confirm/flag;
(c) whether the chapter is detailed enough to guide the NEXT sub-steps (dual / eval / sheafify);
(d) any blueprint claim not yet backed by Lean.
