## Progress

- The general per-\(K\)/per-\(\lambda\) producer is complete in [Pic0RankOneTranslatedCoverGeneral.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneTranslatedCoverGeneral.lean:57).
- [Pic0SepClosedCover.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedCover.lean:357) supplies `baseSubtraction`, finite support, and residue-degree-one compatibility. The Pic0 consumer is at [Pic0RankOneTranslatedCoverPicZero.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneTranslatedCoverPicZero.lean:127).
- Five translated-cover targets build successfully. Four endpoint audits use only `propext`, `Classical.choice`, and `Quot.sound`; owned files contain no `sorry`, `admit`, `axiom`, or `opaque`.
- No source edits were warranted this session. Closeout metadata is committed as `d77c3cb59a` and `0e259f42f5`.

## Issues

The actual cover theorem remains blocked. `PicRankOneOpen` requires an arbitrary-affine presentation family at [Pic0RankOneLocus.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneLocus.lean:45), while `FibrePresented` has an independent factorization obligation at line 137. Missing infrastructure includes the tied native family, all-cartesian pushforward `IsIso`, and affine-wide H0/H1/rank-one data.

Build output contained existing dependency lint and `Challenge.lean` sorry warnings; no owned Phase-5 warning affected correctness.

## Why I Stopped

The task and roadmap remain `blocked`. Adding another fieldwise wrapper would not feed `PicRankOneOpen` or `FibrePresented` and would violate the reviewed contract.

## Next

Recovery owns the native arbitrary-affine producer; openness should consume its verified declaration. A separate `FibrePresented` producer is still required.
