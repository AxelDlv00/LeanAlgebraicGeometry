# Lean Auditor Directive

## Slug
ts242

## Scope (files)
Audit the whole project, but the two files that received edits this iteration are:
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Focus areas (optional)
Pay extra attention to the two edited files above. In `FlatBaseChange.lean` examine the newly added
`AlgebraicGeometry.gammaPushforwardNatIso` and `AlgebraicGeometry.pullback_spec_tilde_iso`, and the modified
`AlgebraicGeometry.gammaPushforwardIso`. In `TensorObjSubstrate.lean` examine the two new instances
`presheafPushforwardLaxMonoidal` and `presheafPullbackOplaxMonoidal`, plus the status comment block that
replaced an earlier HANDOFF block. Check that the surrounding `sorry`-bodied declarations
(`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`, `exists_tensorObj_inverse`, and the
`PicSharp` `addCommGroup`) carry accurate, non-excuse documentation of why they remain open.

## Known issues
- `FlatBaseChange.lean` and `TensorObjSubstrate.lean` each carry 2 known, pre-existing `sorry` bodies that
  were intentionally NOT in scope this iter; do not re-report them as new — but DO flag any excuse-comment
  language attached to them.
- Deprecation warnings for `CategoryTheory.Sheaf.val` and long-line style warnings are known; no need to
  report them.
