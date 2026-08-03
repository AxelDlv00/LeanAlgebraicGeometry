**Progress**

Completed the parameter decoupling. The tower now separates genus `gamma` from divisor degree `n` while preserving diagonal APIs in [DivRepChartClassUnivAffRepresentable.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivRepChartClassUnivAffRepresentable.lean:132).

[DivRepAffChallenge.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivRepAffChallenge.lean:127) now provides the unconditional admissible-parameter representer. [Pic0AtlasFromDivRepAffChallenge.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0AtlasFromDivRepAffChallenge.lean:105) feeds it directly to `abelSigmaChartAff`, and the umbrella import is landed.

No rational-point premise, `IsDivisorDegree`, certificate field, assumed witness, or new `rep` binder was added.

Key commits: `088c5cb0c9`, `6e2613fa2b`, `09e9e2eef0`, `89d7019f9d`, `6dd6742828`, `dda5b51987`.

**Verification**

Per-module builds passed through `9198/9198`. Kernel audits report exactly `[propext, Classical.choice, Quot.sound]`, with no `sorryAx`. Final `lake build AlgebraicJacobian` passed at `9468/9468`; the tracked source hash remained unchanged afterward.

Intermediate consumer timeouts were repaired by replacing an expensive definitional equality with explicit chart equalities. Remaining umbrella warnings are pre-existing and outside the changed modules.

**Closeout**

The task row and completed `divrep` parent are marked `done`. Horizon closeout is committed as `4921248deb` and `20b9f5e88`. The pre-existing untracked `ScratchChartLocal.lean` was left untouched.
