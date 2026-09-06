## Progress

- `AlgebraicJacobian/Picard/DivGrassmannianH1.lean`: rechecked the durable conditional producers `grassmannianQuotientOfDivisorKernelH1` and `grassmannianClassOfKernelAbsoluteCohomologyOneSubsingleton`; the focused Lean check exits 0.
- `AlgebraicJacobian/Curve/FiniteLevelRationalPoint.lean` and `GaloisLevelRationalPoint.lean`: verified that the finite separable/Galois-level section is already represented in the Horizon ledger; no duplicate commit was made.
- Task and roadmap metadata: recorded the verified frontier in commit `5e01c0e0d0`.

## Issues

The conditional Grassmannian quotient still requires an explicit kernel `HModule`-degree-one `Subsingleton` premise. The field-fibre Cartier kernel has not yet been identified with `O(-D)`/`O(A-D)`, and no uniform relative `H1` theorem supplies that premise.

## Why I stopped

The objective is partly advanced, not complete. The source-facing `fgaPicardRepresentability` theorem remains the sole `sorry` in `FGAPicRepresentability.lean`; no unconditional `picEt` representing scheme was produced. The task remains running.

## Next

Prove the inclusion-compatible field-fibre Cartier-kernel/divisor-sheaf identification, then establish the twisted-kernel degree and uniform relative `H1` vanishing needed to remove the conditional boundary.

Claim class: proved producer (existing conditional substrate) | conditional interface (Grassmannian quotient/class) | axiom/sorry-backed (unconditional FGA headline)

Frontier before/after: unchanged at I-2327; first unmet producer is still the field-fibre kernel identification, followed by twisted degree and uniform relative `H1`.

Consumer: the natural degree-d Grassmannian divisor functor and ultimately `fgaPicardRepresentability` for `picEt`.

Evidence: `lake env lean AlgebraicJacobian/Picard/DivGrassmannianH1.lean` exited 0; source grep confirms exactly one `sorry`, at `fgaPicardRepresentability`; Horizon roadmap `AJC.picrep.divgrassmannian` remains active with the same next node. `honesty-reviewer: used`.
