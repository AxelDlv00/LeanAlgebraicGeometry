Read-only phase-8 audit complete.

- AJCR’s `rankOneAbelIso` is genuinely consumed by `pic0_sepClosed_representableBy`, and the full separably closed chain is kernel-clean.
- No arbitrary-field `pic0_representableBy` exists. The current finite-Galois theorem remains conditional on `[OrbitsInAffineOpen]`.
- Bare representability is insufficient for `JacobianData`: the same carrier also needs locally finite type and quasi-compactness.
- Once `JacobianData` exists, group structure, Abel map and pointing law, functor maps/laws, and the datum-level base-change isomorphism are already clean generic consumers.
- Properness, geometric irreducibility, dimension equal to genus, Albanese universality, final base-change coherences, and Abel/base-change compatibility remain independent gates.
- AJCR’s frozen `Challenge.lean` has 15 `sorry` bodies. It cannot directly import the producer cone because that cone already imports `Challenge` through `ChiCurve`.
- AJC has no `Challenge.lean`; its headline uses a distinct categorical full-Picard sheaf API. AJCR’s degree-zero representer cannot discharge that gate definitionally, and AJC retains five independent `sorry` leaves.

The strongest honest bounded bridge is a conditional finite-Galois `PicRepDatum`/`JacobianData` producer. Locally finite type descends through the existing pinned quotient base-change isomorphism; quasi-compactness follows because the quotient projection is a surjective image of the compact acted scheme. I compiled the exact proof and packaging via stdin; both report only `[propext, Classical.choice, Quot.sound]`. No files or Horizon state were modified.
