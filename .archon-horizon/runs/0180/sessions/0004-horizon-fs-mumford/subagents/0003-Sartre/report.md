Implemented [Lattice.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/AbelianVarieties/Mumford/MumfordLib/Lattice.lean) and added its root import.

It now provides:

- Generic `PeriodLatticeQuotient` certificate and quotient additive equivalence.
- `[simp] quotientAddEquiv_mk` computation rule.
- Standard `ℝ^(2g) → (ℝ/ℤ)^(2g)` exponential, surjectivity, exact integer-lattice kernel, and quotient equivalence.
- Transport of that certificate through any existing `GenusTorusUniformization`.

Verification passed:

- Clean LSP diagnostics.
- `lake build MumfordLib.Lattice` succeeded, 1556 jobs.
- Aggregate `MumfordLib.lean` elaboration succeeded.
- No `sorry`, `admit`, or `axiom`.
- No commit made.
