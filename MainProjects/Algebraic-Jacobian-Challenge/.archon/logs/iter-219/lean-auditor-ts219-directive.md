# lean-auditor directive — iter-219

## Files to audit

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

This is the only `.lean` file edited this iter. 11 new declarations were added in a new
`namespace PresheafOfModules.InternalHom` (roughly lines 996–1129): `termRingMap`,
`termRingMap_naturality`, `globalSMul`, `globalSMul_hom_apply`, `globalSMul_one/zero/add/mul`,
`homModule`, `restr`, `internalHomObjModule`.

## Focus areas

- Audit the 11 new declarations as Lean: are the statements meaningful (not vacuous / not
  trivially-true placeholders)? Is `homModule` a genuine `Module` instance with real axiom proofs,
  or does it shortcut any axiom via `rfl`/`change` in a way that hides a gap?
- Check for outdated comments / docstrings anywhere in the file (there is a large block-comment
  header and several inline strategy comments that may name stale line numbers or superseded
  routes).
- Flag any dead-end proof scaffolding, `@[implicit_reducible]`/attribute misuse, deprecated API
  (`Sheaf.val` etc.), or bad Lean practice.
- The file has 3 pre-existing `sorry`s (around lines 632, 1559, 1603) — note them but the new work
  added none.

## Read paths

Read the file in full at the absolute path above. Do not read STRATEGY.md / PROGRESS.md / blueprint.
