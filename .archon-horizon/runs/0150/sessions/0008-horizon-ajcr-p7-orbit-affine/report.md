## Progress

- Added axiom-clean [`finiteInAffine_sigma`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/FiniteInAffine.lean:52), closing `FiniteInAffine` under arbitrary scheme coproducts.
- Source commit: `042292a818`. Coordination and terminal ledger commits: `6a50ee00bd`, `61c0f7f728`.
- Task and roadmap are `blocked`; `042292a818` is pinned.
- No run-0149-owned source was changed.
- All authored source, task, roadmap, and inbox worktree blobs match `HEAD`.

Checks passed: pre/post LSP, direct Lean compilation, module build, `lean_verify` with only `propext`, `Classical.choice`, and `Quot.sound`, and the focused `Pic0FiniteStageOrbitAffine` target.

## Issues

The requested stable-affine-cover gate remains open. Neither project supplies `FiniteInAffine` for an arbitrary-field finite-type group scheme. This is the missing quasi-projectivity result represented by [Stacks Lemma 39.8.7](https://stacks.math.columbia.edu/tag/0BF7).

No full-project build was run while run 0149 remained active. A redundant focused rebuild was stopped after it duplicated concurrent builds.

The shared Git index remains contaminated: it shows stale staged deletions/modifications for our already-committed source and ledger files, while their worktree blobs equal `HEAD`. Concurrent `ajcr-reviewer-full` task item/history changes are also present. None were committed or altered.

## Why I Stopped

Independent Ground and janitor reviews confirmed that the coproduct theorem is sound but cannot eliminate the current `IsAlgClosed` and `IrreducibleSpace` assumptions. Completing the objective requires substantial new geometry, not another wrapper.

## Next

Prove `GroupScheme.finiteInAffine_of_finiteType` from `GrpObj`, `LocallyOfFiniteType`, and `QuasiCompact`, then remove the algebraic-closure and irreducibility hypotheses from `Pic0FiniteStageOrbitAffine`.
