Sibling audit delivered to `/root`:

- Lake project: `AlgebraicJacobian` (`lakefile.toml:1`, `:32-33`), Lean `v4.31.0`.
- No `Challenge.lean`; headline producer is `AlgebraicJacobian/Jacobian.lean`, especially `picardJacobianWitness` (`:848-857`) and `Jacobian` (`:922-945`).
- Five headline obligations are documented at `Jacobian.lean:84-96`.
- Current explicit source census: 24 bare `sorry` occurrences across 10 files; no actual top-level `axiom` declarations found.
- Full build: `lake exe cache get && lake build`; exact project target: `lake build AlgebraicJacobian`.
