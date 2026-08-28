## Progress

- Replaced the failed public ring equality with:
  - `rightRestrictionBaseChangeAlgHom`
  - `rightRestrictionBaseChangeMap`
  - `rightRestrictionBaseChangeMap_naturality`
- The theorem uses `affineBaseChangeIso_trans_naturality` and constructs its ring square locally from the transition and reversed-left naturality equations.

## Issues

The prior `Semiring` statement errors are gone. However, standalone Lean remained CPU-bound without diagnostics; attempts were interrupted with exit `130` after approximately 31 minutes and 3 minutes respectively. No axiom check could be completed.
