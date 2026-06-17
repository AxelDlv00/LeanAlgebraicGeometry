# lean-auditor — iter-034

Audit the following four `.lean` files as Lean code (no strategy bias). Report per-file:
outdated comments, suspect/placeholder definitions, dead-end proof bodies, bad Lean practices,
and any excuse-commented stubs. Verify the headline new declarations are genuinely axiom-clean
(not laundered). Flag any retained abandoned proof body that should be deleted vs kept.

Files (absolute paths):
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

Focus areas:
- FlatBaseChange.lean: the FBC-A "conjugate-route foundation" section (~line 1163) added two new
  lemmas (`pullbackComp_inv_eq_leftAdjointCompIso_inv`, `pullbackComp_eq_leftAdjointCompIso`).
  The `base_change_mate_fstar_reindex_legs` body (~@1539) retains an ABANDONED direct-on-sections
  proof beneath its `sorry` — assess whether that dead body is appropriately documented or is rot.
- GrassmannianCells.lean: the new keystone `isSeparated` (~@1419) + `isSeparatedToSpecZ`, `toSpecZ`,
  `ι_toSpecZ`, `pullbackιIso_inv_fst/snd`, `chartTransition_comp_chartIncl`. Verify the Proj-template
  port is real (no `sorry`, no `admit`, no circular reference). Note the heavy `set_option maxHeartbeats`.
- QuotScheme.lean: 7 new decls incl. pinned keystone `isIso_fromTildeΓ_restrict_basicOpen` (~@1299).
  4 pre-existing protected stubs (lines 126/165/201/228) carry `sorry` — those are out of scope.
- FlatBaseChangeGlobal.lean: 13-15 new decls (`gammaTopEquivEqLocus`, `baseChangeGammaEquiv`, helpers).

Output the standard per-file checklist + flagged-issues block with severities.
