Implemented and committed the bounded pinned-data API refactor.

Commit: `efe23f2ff44e0b6cf8338020ff7e1113a78750b5`

`TensorProductPushoutData.lean` now exposes explicit let-free `source`, `target`, algebra, forward/backward map aliases, composition laws, application laws, and equivalence projection theorems for `TensorProductPushoutPinnedData`; existing adapters remain unchanged.

Verification: `lake env lean AlgebraicJacobian/Descent/TensorProductPushoutData.lean` passed, and the staged path was clean after commit.
