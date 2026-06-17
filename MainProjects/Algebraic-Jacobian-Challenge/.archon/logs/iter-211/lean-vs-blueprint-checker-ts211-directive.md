# Lean ↔ Blueprint Checker Directive

## Slug
ts211

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Known issues
The following are already known to the review agent — verify but do NOT re-report as new
findings:
- `lem:flat_whisker_localizer` `\lean{...}` was just corrected from
  `AlgebraicGeometry.Scheme.Modules.W_whiskerLeft_of_flat` to
  `PresheafOfModules.W_whiskerLeft_of_flat` (the gate lives in the `PresheafOfModules`
  namespace). Confirm the Lean declaration exists under the corrected name.
- `tensorObj_restrict_iso`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj` are typed
  sorries deliberately left off the critical path (the iter-209 ⊗-invertibility pivot). Their
  statement-block `\leanok` markers are legitimate (declaration formalized w/ sorry). Do not
  flag these as must-fix placeholders — they are sanctioned, blueprint-documented off-path/
  downstream sorries.
- `tensorObj_assoc_iso` is a NEW typed sorry, intentionally scaffolded this iter with its
  single residual pinned in the docstring. Sanctioned.
- The Lean module-level docstring is stale (says "iter-202 file-skeleton", lists removed
  `monoidalCategory`). Already noted; a `.lean`-only fix for a future prover.
- The `IsInvertible` (Lean) vs `LineBundle.OnProduct := {M | IsInvertible M}` (blueprint) vs the
  `IsLocallyTrivial`-based `tensorObjOnProduct` implementation — the bridge
  `IsLocallyTrivial → IsInvertible` is known to be unbuilt/unblueprinted. Already tracked.

## Focus
The point of this dispatch is to verify the FIVE declarations the prover newly proved/created
this iter (which no checker has yet compared against the blueprint): confirm signature +
proof/definition match the chapter prose for
- `PresheafOfModules.W_whiskerLeft_of_flat` (`lem:flat_whisker_localizer`),
- `AlgebraicGeometry.Scheme.Modules.IsInvertible` (`def:scheme_modules_isinvertible`),
- `AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor` / `tensorObj_right_unitor`
  (`lem:tensorobj_unit_iso`),
- `AlgebraicGeometry.Scheme.Modules.tensorObj_braiding` (`lem:tensorobj_comm_iso`).
Report any signature/prose mismatch on these, and whether the chapter was adequate to guide them.
