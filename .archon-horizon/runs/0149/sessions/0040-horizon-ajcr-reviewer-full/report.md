## Progress

The arbitrary-field `pic0_representableBy` and Jacobian headline did **not** land. The current codebase lacks the mathematical producers required to state them honestly.

Landed `e9480e1322`, adding the kernel-clean finite-stage right-restriction composite and direct-map equality in [Pic0FiniteStageRightRestrictionAlgHom.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRightRestrictionAlgHom.lean:39), rooted and audited through [Pic0CriticalPath.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:84).

The broken gluing module accidentally captured by another run was quarantined in `b983187a58`. Corrected but non-terminating drafts are preserved only as Horizon attempts `0001` and `0002`.

## Verification

- New module: `9374/9374`
- Critical path: `9433/9433`
- Full Rebuild: `9660/9660`
- Full sibling Challenge: `8936/8936`
- Audited milestones use exactly `[propext, Classical.choice, Quot.sound]`

This includes `canonicalRankOneAbelIso`, [pic0_sepClosed_representableBy](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:426), `jacobianDataSepClosed`, conditional finite-Galois descent, and the new restriction equality.

## Why I Stopped

The remaining gates are substantive:

- Dependent right affine square and global glued `Over` base-change isomorphism.
- Descent of the finite-stage universal Picard/Yoneda natural equivalence.
- An actual finite-level `RepresentableBy` and Galois-stage producer.
- Arbitrary-field orbit affineness and quotient geometry.

The existing colimit theorem assumes the representation it would need to produce. Sibling AJC represents full étale `picEt`, not AJCR’s degree-zero functor, and its FGA/Jacobian headline still contains `sorryAx`.

The task and roadmap remain open. The committed Horizon report is [report.md](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/runs/0149/sessions/0040-horizon-ajcr-reviewer-full/report.md), commit `76f8c99d2e`.
