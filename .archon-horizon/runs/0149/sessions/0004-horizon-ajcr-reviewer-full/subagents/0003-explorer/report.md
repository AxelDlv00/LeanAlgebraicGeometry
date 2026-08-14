Read-only audit complete; no source or metadata edited.

- AJC’s actual headline is `AlgebraicGeometry.picardJacobianWitness` in `AlgebraicJacobian/Jacobian.lean:848-857`, with no rational-point binder. It uses `Scheme.Pic0SchemeEt C`.
- The central AJC obligation is `Scheme.fgaPicardRepresentability` in `Picard/FGAPicRepresentability.lean:955-963`; it is a literal `sorry`. `instHasPicSchemeEt` at `:994-998` projects it unconditionally.
- AJC axiom frontier confirms `fgaPicardRepresentability`, `picardJacobianWitness`, `Jacobian`, and related leaves contain `sorryAx`; only the basic `Pic0Et` group/irreducibility/LFT/separatedness declarations are clean.
- AJCR’s narrow root builds successfully. `rankOneAbelIso`, `pic0_sepClosed_representableBy`, `picRepDatumSepClosed`, and `jacobianDataSepClosed` all report only `[propext, Classical.choice, Quot.sound]`.
- AJCR currently has no `pic0_representableBy`; it is explicitly listed as missing in `Pic0CriticalPath.lean:148-150`. Remaining descent gaps are finite-stage spread, semilinear invariant/equivariant matching, orbit-in-affine-open input, and arbitrary-field representability.
- The smallest honest endpoint after `pic0_representableBy` is `JacobianData.ofRepresentableBy` in `Picard/JacobianDataCharts.lean:71-78`, requiring the same `J`, `RepresentableBy` certificate, `LocallyOfFiniteType J.hom`, and `QuasiCompact J.hom`. `PicRepDatum.toJacobianData` provides the equivalent packaging.
- AJC and AJCR have identical `lakefile.toml` package/library names and no cross-project dependency. Direct import is not configured and would require renaming/splitting the shared `AlgebraicJacobian` library.
- Verified targets: `lake env lean AlgebraicJacobian/Picard/Pic0CriticalPath.lean` (AJCR) and `lake env lean scripts/axiom-frontier.lean` (AJC).
