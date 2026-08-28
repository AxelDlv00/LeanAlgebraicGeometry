Found a direct existing construction in `Picard/DivisorSubschemeTensorOverlap.lean`:

- `isPullback_opens_inf` produces the intersection pullback.
- `isIso_pushoutSection_of_isAffineOpen` turns it into an isomorphism on sections.
- `isIso_pushoutSection_iff` yields an `IsPushout` of restriction maps.
- `CommRingCat.isPushout_tensorProduct` gives the desired tensor-product `AlgEquiv`.

The compiled pattern is at lines 40–88 and 186–198 of that file. I sent the parent the exact declarations, assumptions, map directions, and `pullbackSpecIso` fallback details.
