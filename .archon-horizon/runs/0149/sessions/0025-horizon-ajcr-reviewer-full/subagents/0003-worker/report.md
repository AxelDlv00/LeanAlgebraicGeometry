## Progress

- Audited [GroupAffineOpen.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/GroupAffineOpen.lean), already tracked at `ecf9556a47`.
- LSP clean; narrow kernel check passed.
- Four principal declarations have axioms exactly `[propext, Classical.choice, Quot.sound]`.
- Confirmed a Picard-zero composition works only with extra `[IsAlgClosed L]`, local finite type, and irreducibility assumptions.
- No source edits or genuine untracked files in scope. Ordinary Git’s two `??` entries were poisoned-index artifacts.

## Issues

The theorem does not discharge generic finite-Galois descent: finite-stage `L/K` need not have `IsAlgClosed L`, and no finite-stage irreducibility producer exists. `Pic0FiniteGaloisRepresentable.lean` therefore correctly retains its explicit `OrbitsInAffineOpen` binder.

## Next

The honest arbitrary-field route is quasi-projectivity of algebraic groups ([Stacks 0BF7](https://stacks.math.columbia.edu/tag/0BF7)), exposed as an immersion into projective space and consumed by the existing `finiteInAffine_of_isImmersion`. Extending the algebraically closed theorem across connected components ([Stacks 0B7S](https://stacks.math.columbia.edu/tag/0B7S)) would be useful but would not close the finite-level field gap.
