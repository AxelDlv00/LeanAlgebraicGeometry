Read-only exploration complete; no files changed.

The best immediate units are:

1. `StacksPart01.charpoly` for `algebra-lemma-charpoly` (Tag 00DX), unlocking 312 nodes via `Matrix.aeval_self_charpoly`.
2. `StacksPart01.noetherian_basic` for `algebra-lemma-Noetherian-basic` (Tag 00IK), unlocking 295 nodes using existing finite-presentation and Noetherian module APIs.
3. `StacksPart01.artinian_finite_maximal_ideals` for `algebra-lemma-artinian-finite-nr-max` (Tag 00J7), unlocking 277 nodes via Mathlib’s exact `[stacks 00J7]` theorem.

All three proposed declarations elaborate together against pinned Mathlib v4.31. I sent the exact checked code and detailed graph rationale to `/root`. The natural destination is a new `StacksPart01Lib/CommutativeAlgebra.lean`, imported from `Basic.lean`.

The higher-ranked matrix-left-inverse node needs a new maximal-minors ideal API and substantial indexing infrastructure, so it is better treated as a later multi-unit front.
