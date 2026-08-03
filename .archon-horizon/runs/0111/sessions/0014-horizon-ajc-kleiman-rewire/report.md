## Progress

- Part 1 remains closed: both Kleiman consumers import and term-use `CurveProjectivity`; import-only probes resolve the theorem.
- [RigidPushforwardRank.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardRank.lean:258) now owns kernel transport and quotient-range finrank transport across field algebra equivalences. The coherent two-file subset is in `b814b201c2`.
- [SchemeEulerIndex.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/SchemeEulerIndex.lean:63) joins intrinsic fibre Euler index to the family Cech index, residue-field transport, and finite-replacement virtual rank. Landed in `38686217d3`; rooted by `045d179a75`.
- Roadmap and task state were updated in `a4aa380390`, `6c7642ad62`, and `d85d14ae3f`. Hgraph nodes are `lean_ok`; `a8c0b886d4` plus `d85d14ae3f` records exact ownership and provenance.
- Stop-checkpoint commit `4e4705e9dd` records exactly nine immutable run-0111 conversation comments with full Archon trailers. No session-authored comment remains untracked. The final inbox operation only marked an acknowledgment read and created no new authored checkpoint file.
- Verification passed: narrow builds `8702/8702` and `8697/8697`; umbrella build `8934/8934`; import probes resolved every new declaration. `#print axioms` reports only `propext`, `Classical.choice`, and `Quot.sound`.
- Fresh private-index verification found zero tracked AJC hgraph residue. Eleven concurrent Plücker nodes were preserved untouched.

## Issues

- Metrics remain PicEt producers `+0`, strict `(rep :)` consumers `+0`, seam `+0`; `fgaPicardRepresentability` remains untouched.
- The virtual-rank theorem still consumes an explicit finite replacement. The arbitrary Picard-family instance, finite-pushforward H¹/Euler equality, and Riemann–Roch degree identification remain open.
- Full graph sync exposed existing debt: 28 duplicate declarations, 32 unresolved blueprint references, two status inconsistencies, and 4,288 declarations unattached to blueprint nodes.
- H0 LSP reported stale imports, but the authoritative narrow kernel build passed.

## Why I Stopped

The objective is partly advanced and the task remains running. Part 1 is complete; Part 2 now reaches the intrinsic scheme-Euler/finite-replacement boundary, but does not yet construct actual `Pic^d` pieces or their very-ample/`FiniteInAffine` witnesses.

## Next

- Export and instantiate the campaign finite replacement.
- Prove full finite-pushforward Euler comparison, including H¹/cokernel finrank equality, then apply Riemann–Roch.
- Establish descent, pullback naturality, local constancy, and the arbitrary-test Abel pin before assembling genuine `Pic^d` pieces.
