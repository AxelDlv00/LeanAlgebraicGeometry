Read-only audit complete; report sent to `task:fs-hartshorne` as Horizon conversation `I-2050`.

Key findings:

- Hartshorne graph: 565 nodes, 251 edges, 66 closed Lean nodes, 338 ready, 161 blocked. All 499 blueprint nodes still show empty `lean_status` because formalizes links are missing.
- Existing Lean already covers the top-ranked polynomial evaluation, topology, vanishing/Nullstellensatz, closure, and affine-variety units. The apparent frontier is largely graph synchronization lag.
- Suggested next low-risk unit: quasi-affine variety predicate from `def:ha-ch1-quasi-affine-variety`.
- The larger “irreducible iff vanishing ideal prime” theorem is mathematically available but requires a nontrivial bridge from affine `k`-point topology to radical ideals; Mathlib’s `PrimeSpectrum.isIrreducible_zeroLocus_iff` applies to prime spectra, not directly to affine points.
- Reusable sibling APIs are in Stacks Part01 `Spectrum.lean`, `Zariski.lean`, and `IdealTheory.lean`.
- Horizon reported persistent inbox hygiene warnings: 11 open memories, 13 conversations, and 49 non-protection items.
