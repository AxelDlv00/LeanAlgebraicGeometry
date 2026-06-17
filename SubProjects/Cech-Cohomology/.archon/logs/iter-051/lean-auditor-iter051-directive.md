# Lean audit — iter-051 prover-touched files

Audit the Lean as Lean. No strategy bias.

## Files to read (absolute paths)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAcyclic.lean
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

## Focus areas
- The new decls in CechAcyclic.lean (added ~lines 880–1900):
  `AwayComparison.isLocalizedModule_comp_away`, `SectionCechModule.dDiff_exact_of_localizationAway`,
  `sectionCechAbExact_loc` (private), `sectionCech_homology_exact_of_localizationAway`.
  Check the `set_option maxHeartbeats 1600000 / synthInstance.maxHeartbeats 800000` raise is genuine
  instance-search cost, not masking a fragile/looping proof. Check the `change`/`erw`/`IsLocalizedModule.ext`
  closures are real reductions, not the spurious-rfl / subsingleton-coherence kernel-soundness trap.
- The new decls in CechHigherDirectImage.lean (added ~lines 672–797):
  `cechComplexOnX`, `cechNervePointIso`, `cechAugmentation`,
  `augmentation_comp_alternatingCofaceMap_objD_zero` (private), `cechAugmentation_comp_d`,
  `cechAugmentedComplex`. Pay attention to the `erw [Preadditive.comp_add, comp_neg, hnat 0, hnat 1, add_neg_cancel]`
  step in `augmentation_comp_alternatingCofaceMap_objD_zero` — confirm the `erw` defeq-match is sound
  (the `Augmented = Comma (const) (𝟭)` codomain `𝟭`-wrapping is a real index, not an unsound coercion).
- Note any outdated comments, dead code, or decls that look like they paper over a gap with `sorry`.
  Two pre-existing sorries are expected and off-limits: `CechAcyclic.affine` (dead/superseded) and
  `CechHigherDirectImage.cech_computes_higherDirectImage` (protected P5b).

Report a per-file checklist + flagged issues with severity.
