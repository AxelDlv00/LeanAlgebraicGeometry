Added `Pic0FiniteGaloisDescent.lean` with the honest quotient-side bridge:

- `GaloisQuotientWitness.overHomEquiv`
- its precomposition naturality theorem
- specialization to `StableAffineOpen.gluedQuotientOver` under finite Galois and `OrbitsInAffineOpen`

Verification passed via `horizon check --lean`; all four endpoints scan clean and use only `propext`, `Classical.choice`, and `Quot.sound`.

The missing Pic0-specific theorem is the arbitrary-test natural equivalence:
`pic0TypeFunctor C(T) ≃ GaloisEquivariantOver (pic0SemilinearGalActionOfRepresentableBy C rep) T`.
Existing code supplies affine etale descent and a scheme descent cocycle, but not this invariant comparison.
