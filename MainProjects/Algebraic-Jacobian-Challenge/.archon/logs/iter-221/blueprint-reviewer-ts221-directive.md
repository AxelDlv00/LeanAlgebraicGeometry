# Blueprint-reviewer directive — iter-221

Perform your standard whole-blueprint audit (all chapters under
`blueprint/src/chapters/`). Produce the per-chapter completeness + correctness
checklist and the must-fix / unstarted-phase-proposals sections as usual.

## Context for this iter (for prioritisation only — still audit the whole blueprint)

The single active prover lane is `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`,
backed by chapter `Picard_TensorObjSubstrate.tex` (§`sec:tensorobj_dual_infra`). This
is a funded multi-iter `mathlib-build` block (sheaf internal-hom / dual of 𝒪_X-modules).

- iter-219 built the per-object value module; iter-220 assembled the presheaf
  internal hom (`def:presheaf_internal_hom` → `PresheafOfModules.InternalHom.internalHom`,
  pin verified correct in-chapter at the time of this dispatch).
- The NEXT prover sub-step (iter-221) targets `def:presheaf_dual`
  (`PresheafOfModules.dual`) and `lem:internal_hom_eval`
  (`PresheafOfModules.internalHomEval`). Please confirm whether these two blocks are
  COMPLETE + CORRECT and detailed enough to formalize (proof sketch depth, source
  quotes present, `\lean{}` pins matching plausible Lean names).
- A prior per-file checker (iter-220) flagged a MINOR adequacy gap: `lem:internal_hom_isSheaf`
  (sub-step 4) merges two distinct Lean objects (the sheaf-condition verification AND
  the `AlgebraicGeometry.Scheme.Modules.dual` construction) under one `\lean{}` pin.
  Please assess whether that block should be split into two pinned blocks before
  sub-step 4 is dispatched, and whether the substantive helper
  `PresheafOfModules.InternalHom.internalHomPresheaf` warrants its own block/annotation.

## Gate question I need answered

For chapter `Picard_TensorObjSubstrate.tex`: is it `complete: true` and `correct: true`
with no must-fix-this-iter finding, such that the file may receive a prover this iter
on sub-step 3 (`def:presheaf_dual`, `lem:internal_hom_eval`)? Report the verdict
explicitly.

Also surface any unstarted strategy-phase blueprint proposals as usual.
