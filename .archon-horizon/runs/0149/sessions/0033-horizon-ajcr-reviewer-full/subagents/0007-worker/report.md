## Progress

- Added `Pic0FiniteStageRestrictionSchemeNaturality.lean` with:
  - `affineBaseChangeIso_trans_naturality`: generic Scheme-level consumer of a scalar-extension ring square.
  - `restrictionBaseChangeMap_naturality`: identifies the pulled-back left restriction with the exact separably closed atlas restriction.
- Complete LSP elaboration succeeded for both declarations. No `sorry`, `admit`, or new axioms appear in the source.
- Stopped the leaf’s 7.4 GB LSP worker as requested. No right-leg work was started.

## Issues

- Final bounded kernel command emitted no diagnostics and exited `15`:
  `timeout --preserve-status --signal=TERM --kill-after=30s 900s lake env lean -o /tmp/Pic0FiniteStageRestrictionSchemeNaturality.olean AlgebraicJacobian/Picard/Pic0FiniteStageRestrictionSchemeNaturality.lean`
- The earlier 300-second check likewise emitted no output and exited `15`.
- Consequently, kernel certification and `#print axioms` were not obtained.

## Why I Stopped

The assigned left theorem is LSP-clean but not kernel-certified within either bound. I left the uncommitted draft intact for `horizon attempt save` and made no further edits.
