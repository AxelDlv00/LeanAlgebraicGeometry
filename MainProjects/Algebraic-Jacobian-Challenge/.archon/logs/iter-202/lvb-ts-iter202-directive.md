# lean-vs-blueprint-checker — TensorObjSubstrate (iter-202)

Bidirectionally verify ONE Lean file against its blueprint chapter.

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Focus this iter

This is a NEW file created this iter as a file-skeleton scaffold (prove mode,
helper budget 0 — proofs intentionally NOT attempted). It contains typed
`:= sorry` stubs for the 4 blueprint-pinned declarations plus supporting
helpers:
- `Scheme.Modules.tensorObj` ← `def:scheme_modules_tensorobj`
- `Scheme.Modules.tensorObj_functoriality` ← `lem:scheme_modules_tensorobj_functoriality`
- `Scheme.Modules.monoidalCategory` ← `thm:scheme_modules_monoidal`
- `Scheme.PicSharp.addCommGroup_via_tensorObj` ← `thm:rel_pic_addcommgroup_via_tensorobj`
  (deliberately a `def`, not a global `instance`, to avoid a diamond with the
  existing `PicSharp.addCommGroup` instance in `RelPicFunctor.lean`)

Report bidirectionally:
1. Lean → blueprint: do the 6 typed-sorry stub SIGNATURES faithfully match the
   blueprint pins (shape, arguments, target type)? Any stub whose type is wrong
   or trivially satisfiable? Is the `def`-not-`instance` choice for
   `addCommGroup_via_tensorObj` defensible per the blueprint, or does the
   blueprint expect a genuine instance?
2. Blueprint → Lean: is the chapter detailed enough to guide the iter-203+ body
   fill, or too thin? Are there pinned blueprint declarations with NO Lean stub
   yet (the prover skipped `lem:pullback_compatible_with_tensorobj` / Piece 3d)?

NOTE: typed sorries are EXPECTED here (scaffold lane) — do not flag the
presence of `sorry` as a defect; flag only signature/faithfulness/coverage
issues. Write your report to task_results.
