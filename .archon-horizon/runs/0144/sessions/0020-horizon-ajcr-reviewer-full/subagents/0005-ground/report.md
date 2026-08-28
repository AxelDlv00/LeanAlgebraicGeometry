Ground review complete. The work is converging only at the conditional-interface level, not at either requested endpoint.

- `3f004068a2` is a valid, axiom-clean `rfl` bridge for `PicRepDatum.toJacobianData_grpObj`; it does not construct a `PicRepDatum`, prove quasi-compactness, or connect to `Challenge.Jacobian`.
- `PicRankOneEvaluationDivisorData`, `pic0RepresentableBy`, and general `jacobianData` remain uninstantiated/absent. `rankOneAbelIso` and chart representability are conditional APIs.
- `Challenge.lean` still has `sorryAx` in the Jacobian definition, group structure, geometry, and universal property. A green `lake build AlgebraicJacobian` therefore does not establish the headline.
- Blueprint marks the relevant rank-one, representability, and Jacobian declarations `\notready`; hgraph is stale/polluted and lacks the new bridge node; task/roadmap linkage is incomplete.
- The Noetherian-free producer check ran for 7:53 with no diagnostics and about 7.2 GB RSS, then was interrupted. It has no verification credit; no process remains. Existing inbox issue I-1961 already records this blocker.

Highest-value next action: split and kernel-check a tractable part of `Pic0RankOneCanonicalDivisorFree.lean`, land affine base-change naturality, and package a genuine `PicRankOneEvaluationDivisorData` with its Abel identity. Only then proceed to openness, translated coverage/descent, `PicRepDatum`, and the Jacobian endpoints.
