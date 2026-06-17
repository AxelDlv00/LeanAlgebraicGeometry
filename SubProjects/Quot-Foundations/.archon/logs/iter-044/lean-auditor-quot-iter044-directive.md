# Audit — iter-044 new Lean

## Files (read in full)
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Focus
Pay extra attention to the 11 declarations added near the END of QuotScheme.lean (lines ~2550–2720):
`overRestrictUnitIsoInv`, `pullbackOpenImmersionUnitIso`, `overRestrictPresentationInv`,
`pullbackPreimageιIso`, `presentationPullbackιPreimage`, `isQuasicoherent_over_preimage`,
`coversTop_preimage`, `isQuasicoherent_pullback_of_isOpenImmersion`, `isQuasicoherent_pullback_fromSpec`,
`isLocalizedModule_basicOpen`. Check: honesty of statements (no vacuous/placeholder), correct use of
`Presentation.ofIsIso`/`Presentation.map`, the `q.shrink` universe move, the dot-notation `.IsQuasicoherent`
conclusion, the `set_option maxHeartbeats`/`backward.isDefEq.respectTransparency false` usages, and any
`eqToHom`/`Subsingleton.elim` shortcuts. In FlatBaseChange.lean inspect the new `adjL`/`hunitL` scaffolding
baked above the `sorry` @1891 (is it dead/unused or genuine progress?).

## Output
Per-file checklist + flagged issues (CRITICAL/MAJOR/MINOR). Report to task_results.
