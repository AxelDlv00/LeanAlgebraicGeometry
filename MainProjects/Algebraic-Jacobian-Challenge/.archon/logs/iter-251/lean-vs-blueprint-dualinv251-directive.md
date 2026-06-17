# Lean ↔ blueprint check — iter-251 — TensorObjSubstrate/DualInverse.lean

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
(This consolidated chapter `% archon:covers` TensorObjSubstrate/DualInverse.lean — line 6.)

## What this file is (the dual-inverse lane, new this iter)
The dual-inverse chain feeding `RelPicFunctor.addCommGroup`:
`dual_restrict_iso` → `dual_isLocallyTrivial` → `homOfLocalCompat` → `exists_tensorObj_inverse`.
Blueprint labels of interest: `lem:dual_isLocallyTrivial`, `lem:dual_restrict_iso`.

## State after iter-251
- `dual_isLocallyTrivial` — body assembled (chart-chase), but transitively carries `sorryAx`
  because it references `dual_restrict_iso` which still has a Step-4 `sorry` (L254).
- `dual_restrict_iso` — Steps 1–3 + H1 done; one typed `sorry` at the pushforward-commutes-with-dual
  presheaf residual.
- `homOfLocalCompat` (L420) — untouched scaffold `sorry`.
- 4 new axiom-clean infra decls: `unitDualSectionEquiv`, `dualUnitIsoGen`, `presheafDualUnitIso`,
  `dual_unit_iso`.

## Report
- Whether `lem:dual_isLocallyTrivial` and `lem:dual_restrict_iso` statements match their `\lean{...}`
  blocks (faithful signatures, not placeholders).
- Whether the chapter provides enough detail for the Step-4 pushforward-dual residual and the
  `homOfLocalCompat` gluing engine, or is too thin to guide them.
- Whether the 4 new infra decls need blueprint coverage or are correctly project-local.
- Whether any blueprint block claims `dual_isLocallyTrivial` is fully proved without flagging the
  `dual_restrict_iso` dependency.
