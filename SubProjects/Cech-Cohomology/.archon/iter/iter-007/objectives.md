# Iter-007 objectives

## Dispatched lane

### `AlgebraicJacobian/Cohomology/AcyclicResolution.lean` — [prover-mode: mathlib-build]
Build the 5 NEW TARGET 3 declarations (all confirmed comment-only / absent), bottom-up, axiom-clean,
no sorry. Blueprint `Cohomology_AcyclicResolution.tex` (gate-cleared complete+correct iter-007).

| # | Lean target | Blueprint label | Status entering iter | Notes |
|---|---|---|---|---|
| 1 | `Functor.cosyzygyShortExact` | `lem:cosyzygy_ses` | frontier-ready | cosyzygy SES `(Sₘ)`, acyclic middle |
| 2 | `Functor.rightDerivedOneIsoCokerOfAcyclic` | `lem:acyclic_one_iso_coker` | frontier-ready | `(R¹G)(A) ≅ coker(G(J)→G(Z))` |
| 3 | `Functor.gCosyzygyIsoCocycles` | `lem:applied_cosyzygy_cycles` | dep on #1 | `G(Zⁿ) ≅ ker(G(Jⁿ)→G(J^{n+1}))` |
| 4 | `Functor.cohomologyAppliedResolutionIso` | `lem:cohomology_of_applied_resolution` | dep on #1,#3 | `Hⁿ ≅ coker`, `H⁰ ≅ G(A)` |
| 5 | `Functor.rightDerivedIsoOfAcyclicResolution` | `lem:acyclic_resolution_computes_derived` | TARGET 3 assembly | staircase; closes P4 |

Verified-present infra (no build needed): `rightDerivedShiftIsoOfAcyclic`,
`rightDerivedShiftIsoOfSplitResolutionSES`, `InjectiveResolution.isoRightDerivedObj`,
`rightDerivedZeroIsoSelf`, `isZero_rightDerived_obj_injective_succ`,
`ShortComplex.ShortExact.homology_exact₁/₂/₃`/`.δ`/`.δIso`.

## Not dispatched (deferred)

- P5a frontier nodes (`cech_augmented_resolution`, `higher_direct_image_presheaf`,
  `cech_to_cohomology_on_basis`) — chapter `partial/partial`, gate-failed; two sketches need
  Route-A rewrites (de-spectral-sequence). First action when P4 closes.
- P3 (`CechAcyclic.affine`) — statement gap, blocked. P5b assembly — needs P3+P4+P5a.

## Subagent dispatches this iter (plan phase)
- strategy-critic `baseline` → CHALLENGE (addressed in STRATEGY.md)
- progress-critic `p4t3` → CONVERGING
- effort-breaker `staircase` → TARGET 3 decomposed
- blueprint-clean `acyclic` → 6 process-NOTE blocks stripped, source quotes validated
- blueprint-reviewer `gate` → `Cohomology_AcyclicResolution.tex` complete+correct, HARD GATE CLEARS
