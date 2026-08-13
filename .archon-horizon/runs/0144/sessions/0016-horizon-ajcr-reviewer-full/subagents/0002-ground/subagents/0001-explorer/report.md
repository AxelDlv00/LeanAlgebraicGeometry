No concrete mathematical or type issue found in the finite-stage rank argument.

- [Pic0RankOneCanonicalDivisorFree.lean:291](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneCanonicalDivisorFree.lean:291): the argument is sound. `A0` is literally a subalgebra of `P.cover.Carrier`, so the algebra map is injective and its map on spectra has dense image.
- Lines 287–297 give finite projective stage `H⁰`; hence finite presentation and flatness, making `rankAtStalk` locally constant.
- Lines 304–316 correctly transport `P.h0_rank_one` through `datumH0BaseChange` to every point in the dense image.
- Lines 317–322 use openness of `{p | rank p ≠ 1}` and density correctly. Thus stalk rank is one at every prime of `A0`.

This proves pointwise global rank one, not that the projective module is globally free. Downstream only needs the pointwise statement, so there is no gap.

No hidden Noetherian hypothesis on `A` or `P.cover.Carrier` was found. The only Noetherian instance is explicitly manufactured for `A0` by finite type in [RankOneFamilyCertificatesFiniteStage.lean:158](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/RankOneFamilyCertificatesFiniteStage.lean:158), installed at target line 274, and consumed at the finite stage.

Residual risk is verification/performance: the target is untracked, unrooted, and has no `.olean`; I did not compile it. Its finite-stage and glued-divisor dependencies already have `.olean` files. The faithful final check remains compiling this target module; a small generic lemma isolating “locally constant rank + dense image” could separately verify the topology block.
