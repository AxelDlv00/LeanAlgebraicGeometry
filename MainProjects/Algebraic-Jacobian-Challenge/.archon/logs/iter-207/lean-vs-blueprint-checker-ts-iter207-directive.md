# lean-vs-blueprint-checker — TS, iter-207

## The one Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Its blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## What changed this iter (for your bidirectional check)

The prover added three axiom-clean declarations implementing the chapter's
`lem:restrictscalars_laxmonoidal`:
`PresheafOfModules.restrictScalarsLaxε`, `restrictScalarsLaxμ`, and the instance
`restrictScalarsLaxMonoidal`.

Report bidirectionally:
- **Lean → blueprint**: does `lem:restrictscalars_laxmonoidal` accurately
  describe what was built? Is the `\lean{...}` pin present and correct for the
  new instance? Are the 3 remaining sorry-bearing decls
  (`tensorObj_restrict_iso`, `exists_tensorObj_inverse`,
  `addCommGroup_via_tensorObj`) faithfully represented?
- **blueprint → Lean**: the chapter's proof of `lem:tensorobj_restrict_iso`
  (and the `% NOTE` near its statement, lines ~390–400) asserts that the
  sectionwise lax instance is the **SOLE** remaining project-side ingredient
  and that closing the iso is "a bounded mathlib-build target, not a multi-file
  wall." The prover this iter reported this claim is FALSE: after building the
  lax instance, `tensorObj_restrict_iso` is still blocked because (1) the scheme
  module ring presheaf is `RingCat`-valued where there is no monoidal structure,
  and the δ-route's residual lands at that layer, while `tensorObj` itself uses
  the `CommRingCat`-valued `X.presheaf`; and (2) at the `CommRingCat` level
  `pushforward φ` and `restrictScalarsLaxMonoidal` cannot be composed by
  instance resolution (a `⋙`-vs-`forget₂` associativity mismatch). Assess
  whether the chapter's proof of `lem:tensorobj_restrict_iso` is formalizable as
  written, or whether it must be flagged as inadequate / re-routed.

## Output

Report to `task_results/lean-vs-blueprint-checker-ts-iter207.md`. State any
must-fix-this-iter findings explicitly.
