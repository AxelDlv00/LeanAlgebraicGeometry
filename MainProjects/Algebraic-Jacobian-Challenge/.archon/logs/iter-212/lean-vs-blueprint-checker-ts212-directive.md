# lean-vs-blueprint-checker — Picard/TensorObjSubstrate

Verify exactly ONE Lean file against its blueprint chapter, bidirectionally.

## Lean file
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Blueprint chapter
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Focus

This iter the prover added two sorry-free helpers
(`PresheafOfModules.isIso_sheafification_map_of_W`,
`PresheafOfModules.W_whiskerRight_of_flat`) and left
`AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso` as a typed `sorry`.

The prover claims the blueprint PROOF of `lem:tensorobj_assoc_iso` is
MATHEMATICALLY INCORRECT: its "Flatness is free" step (chapter lines ~659-664,
"Since M,N,P are ⊗-invertible they are projective, hence flat") allegedly
conflates GLOBAL module-invertibility with SECTIONWISE flatness over EVERY open
`U` (the actual hypothesis of `lem:flat_whisker_localizer` /
`W_whiskerLeft_of_flat`, which needs `∀ U, Module.Flat (𝒪_X(U)) (P.val U)`).
The claim is that this sectionwise-over-all-opens flatness is NOT derivable from
`IsInvertible` and is false in general (invertibility is a local/affine
property; the global-sections functor over a non-affine open is not exact).

Independently assess:
1. Is the blueprint's "Flatness is free" step actually a real gap? Verify the
   signature of `lem:flat_whisker_localizer` / `W_whiskerLeft_of_flat` in the
   Lean file — what flatness hypothesis does it actually require?
2. Does `IsInvertible` (`def:scheme_modules_isinvertible`) supply that
   hypothesis? Is the prover's "false in general" assessment correct?
3. Is the blueprint's proposed three-step composite otherwise sound (modulo the
   flatness feeder)?
4. Are the two new helpers faithful to / consistent with the chapter?

Report bidirectionally (Lean → blueprint AND blueprint → Lean), per-decl, with
any must-fix-this-iter findings clearly tagged.
