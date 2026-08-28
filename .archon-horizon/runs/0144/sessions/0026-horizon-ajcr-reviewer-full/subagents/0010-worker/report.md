Completed [Pic0GaloisInvariantComparison.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0GaloisInvariantComparison.lean).

Strongest endpoint:

- `pic0GaloisInvariantEquiv`: arbitrary-test equivalence between Pic0 classes and the exact deck-invariant subtype.
- `pic0GaloisInvariantEquiv_precomp`: naturality under arbitrary morphisms of `K`-tests.
- Effective descent is proved through the étale sheaf property of `pic0SigmaFunctor`.
- No existing files, Horizon state, or commits were touched.

Verification passed: zero LSP diagnostics, standalone `lake env lean` exit 0, and `lean_verify` reports only `propext`, `Classical.choice`, and `Quot.sound`, with no source warnings. The explicit scan found no `sorry`, `admit`, `axiom`, or `unsafe`.

The remaining bridge to `GaloisEquivariantOver` is precisely a Pic0 analogue of sibling AJC’s `isInvariantMatch_canonical`: an iff transporting deck invariance through `pic0ThetaType` and `rep.homEquiv.symm` to equivariance for `pic0SemilinearGalActionOfRepresentableBy`. AJCR currently constructs that action but has no predicate-match theorem.
