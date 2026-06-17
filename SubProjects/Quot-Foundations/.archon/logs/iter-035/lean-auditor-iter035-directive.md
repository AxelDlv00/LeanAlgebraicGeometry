# lean-auditor — iter-035

Audit the following three Lean files as Lean (no strategy bias). Report outdated comments,
suspect/placeholder definitions, dead-end proofs, bad Lean practices, and whether each new
declaration's proof is honest (no vacuous/circular statements).

Files (absolute):
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean

Focus areas:
- FlatBaseChange.lean: the iter-035 conjugate chain near lines ~1480–1700
  (`conjPullbackFactor`, `base_change_mate_codomain_read_legs_param`/`_eq_param`,
  `base_change_mate_codomain_read_legs_conj`/`_conj_eq`, `base_change_mate_reindex_conj_pushforwardCollapse`,
  and `base_change_mate_fstar_reindex_legs` + `_legs_conj`). Verify: is the `_legs` wrapper body
  genuinely sorry-free while `_legs_conj` carries the only residual `sorry`? Are the conj-1a/1b/2c
  statements faithful (not weakened to make them provable)? Flag any decl whose statement was
  shaped to avoid the real obstruction.
- QuotScheme.lean: the gap1-D descent near lines ~1320–1650 (`isLocalizedModule_basicOpen_descent_of_cover`
  and its 5 private helpers `iSup_basicOpen_subtype_eq_top`, `res_comp`, `descent_smul_eq_zero`,
  `descent_overlap_agree`, `descent_surj`). Verify the keystone statement is the honest descent (the
  `Hfr` hypothesis is a real per-cover-element localization hypothesis, not a disguised assumption of
  the conclusion).
- GrassmannianCells.lean: the properness scaffold near lines ~1438–1545
  (`compactSpace_scheme`, `quasiCompact_toSpecZ`, `locallyOfFiniteType_toSpecZ`,
  `quasiSeparated_toSpecZ`, `valuativeUniqueness_toSpecZ`, `transitionPreMap_minorDet_mul`,
  `isProper_of_valuativeExistence`). Verify `isProper_of_valuativeExistence` genuinely reduces to the
  existence obligation and does not smuggle it.

Note all three files build green; FlatBaseChange/QuotScheme carry pre-existing `sorry`s (4 each;
QuotScheme's 4 are protected stubs at L126/165/201/228). Report any NEW sorry or any axiom leak.
