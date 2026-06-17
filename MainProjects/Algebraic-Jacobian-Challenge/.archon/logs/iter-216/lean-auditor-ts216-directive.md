# lean-auditor directive — iter-216

## Files to audit (absolute paths)
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Focus areas
- Pay extra attention to the `RestrictScalarsRingIsoTensor` section (roughly lines 190–285):
  6 new declarations added this iter —
  `restrictScalarsRingIsoTensorEquiv_apply_tmul`, `restrictScalars_isIso_μ`,
  `restrictScalars_isIso_ε`, `restrictScalarsMonoidalOfRingEquiv`,
  `restrictScalars_isIso_μ_of_bijective`, `restrictScalars_isIso_ε_of_bijective`.
  Check: are the statements honest (no vacuous/trivial typeclass shortcuts), do the
  `erw`/`change`/`exact (…).symm` proofs actually discharge the stated goals, is the
  `@[implicit_reducible] noncomputable def …Monoidal` packaging genuine (not a disguised sorry)?
- Check the four remaining `sorry` sites (lines ~632, ~1185, ~1228, ~1267): are their
  docstrings/comments still accurate, or do they claim progress that the body does not back?
- Flag any outdated comments referencing removed routes (route-(e), `(J.W).IsMonoidal`,
  whiskering/stalk apparatus) that now contradict the in-file state.

## Output
Per-file checklist (outdated comments, suspect definitions, dead-end proofs, bad Lean practices)
plus a flagged-issues block with severities. Do NOT assume any strategy context — audit the Lean as Lean.
