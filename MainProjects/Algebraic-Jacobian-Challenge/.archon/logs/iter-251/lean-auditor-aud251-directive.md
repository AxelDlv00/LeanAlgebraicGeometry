# Lean audit directive — iter-251

Audit the following two `.lean` files (both received prover edits this iter). Read them
in full and produce your per-file checklist + flagged-issues block.

## Files (absolute paths)
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

## Focus areas
- New declarations added this iter — in TensorObjSubstrate.lean: `pullbackValIso_hom_natural`,
  `sheafifyTensorUnitIso_hom_eq`, `sheafifyTensorUnitIso_hom_natural`, `pullbackTensorMap_natural`.
  In DualInverse.lean: `unitDualSectionEquiv`, `dualUnitIsoGen`, `presheafDualUnitIso`,
  `dual_unit_iso`, `dual_isLocallyTrivial`, `dual_restrict_iso`, `homOfLocalCompat`.
- Pay attention to: (a) declarations whose bodies are `sorry` vs declarations that are
  closed but transitively depend on a `sorry` (e.g. `dual_isLocallyTrivial` references
  `dual_restrict_iso` which still has a Step-4 `sorry`) — flag any docstring/comment that
  describes such a decl as "CLOSED" without the transitive-sorry caveat;
  (b) non-standard `set_option` pragmas (`maxHeartbeats`, `backward.isDefEq.respectTransparency`)
  and whether they are load-bearing or could be removed; (c) excuse-comments / stale module-status
  docstrings; (d) deprecated `Sheaf.val` usage; (e) any in-file scratch leftovers.
- Report whether the two `sorry`-bearing decls in DualInverse (`dual_restrict_iso` L254,
  `homOfLocalCompat` L420) and the two in TensorObjSubstrate (`sheafifyTensorUnitIso_hom_natural`
  L1954, `pullbackTensorMap_natural` L1983) are honestly typed `sorry`s with documented residuals,
  not laundered.

Output a per-file checklist plus a flagged-issues block (must-fix / major / minor).
