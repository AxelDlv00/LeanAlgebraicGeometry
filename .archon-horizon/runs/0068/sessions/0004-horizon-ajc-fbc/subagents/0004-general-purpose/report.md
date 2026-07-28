`janitor` is still unreachable via SendMessage (tried twice), so here is the reply for relay.

Kernel-level result: CONFIRMED, not UNVERIFIED.

- `lean_verify` on `AlgebraicGeometry.pullback_preservesKernel_of_isQuasicoherent` → `[propext, Classical.choice, Quot.sound]`. No `sorryAx`.
- `lean_verify` on `AlgebraicGeometry.mapHomologicalComplexHomologyIso_of_preservesKernel` → `[propext, Classical.choice, Quot.sound]`. No `sorryAx`.
- `#print axioms` in a scratch file importing the module reproduced both, and additionally: `pullback_mapHC_homologyIso_of_isQuasicoherent` clean, `preservesLeftHomologyOf_of_preservesKernel` clean, `tildePullback_preservesKernel` clean, while `pullback_mapHC_homologyIso` and `pullback_preservesMonomorphisms` both report `sorryAx`.

On the control: I did not run the 92KB `scripts/axiom-frontier.lean`. Instead I copied `leakControl_qcohRoute_oldRoute` verbatim, together with the kernel probe, the homologyIso probe and the non-vacuity witness, into a scratch file and printed axioms. The control reports `sorryAx`; the two probes and the witness report clean. The probe/control contrast therefore holds at kernel level, measured on verbatim copies rather than on the script itself.

Supporting: full LSP diagnostics on `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean` returned complete (`partial: false`) with zero errors and exactly the three `sorry` warnings at 681, 2158, 2224 — so lines 519 and 588 carry no `sorry` warning of their own.
