# lean-vs-blueprint-checker directive — iter-247 — RelPicFunctor

Bidirectionally verify ONE Lean file against its blueprint chapter.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RelPicFunctor.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_RelPicFunctor.tex

## What changed this iter (context only — verify independently)
The import cycle TensorObjSubstrate ↔ RelPicFunctor was resolved by a refactor; RelPicFunctor now imports
the upstream substrate. The 4 local typed-`sorry` bridges and 5 local pure-Mathlib substrate copies were
DELETED and rewired to upstream `Modules.*` decls. `PicSharp.addCommGroup` is now a real construction whose
only `sorryAx` is the upstream `Modules.exists_tensorObj_inverse`. `PicSharp.functorial` remains a `0` stub.

## Report
- Lean → blueprint: do the chapter's `\lean{...}` pins point at decls that still exist with the stated
  signatures? Any fake/placeholder statement?
- Blueprint → Lean: is the chapter detailed enough to have guided this construction? Is there prose
  describing the (now-deleted) local copies as if current?
- Note the blueprint-doctor flagged a broken `\uses{\leanok thm:relative_pic_quotient_well_defined}` in
  this chapter (label undefined, and a `\leanok` appears stuck inside the `\uses{}` braces). Confirm and
  report whether the intended target label exists under another name.
