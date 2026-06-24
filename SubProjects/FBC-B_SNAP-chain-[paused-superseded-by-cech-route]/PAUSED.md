# ⏸ PAUSED — FBC-B_SNAP-chain (2026-06-24)

This subproject is **paused**. Do not run Archon here while paused.

## Why
The FBC leg's adjoint-mate route to `affineBaseChange_pushforward_iso` /
`flatBaseChange_pushforward_isIso` walled after ~30 iterations (kernel timeouts; the
missing `tilde ↔ extendScalars` bridge). Stacks 02KH flat base change is now pursued via
the **Čech route in the main project** (`Algebraic-Jacobian-Challenge`,
`Cohomology/CechHigherDirectImageUnconditional.lean`).

## What was salvaged into the main project (so it is NOT lost)
Copied, sorry-free and building, into `Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/`:
- `RegroupHelper.lean` (whole; `regroupEquiv`).
- `FlatBaseChangeGlobal.lean` — the **sorry-free prefix only**: the finite-cover
  equalizer presentation (`gammaTopEquivEqLocus`), the base-changed equalizer comparison
  via Mathlib's `LinearMap.tensorEqLocusEquiv` (`baseChangeGammaEquiv`), and the
  restriction plumbing (`rhoU`, `gammaResA`, `leftRes`/`rightRes`/`toCover`,
  `pullbackGroundRingAlg`).

## What stays only here (preserved on disk + in this subproject's git snapshot)
- The full FBC `FlatBaseChange.lean` (adjoint-mate machinery; the algebra-level cocycle
  `chartBaseChange_extendScalars_cocycle`) and the sorry-bearing downstream assembly of
  `FlatBaseChangeGlobal.lean` (`baseChange_sheafConditionFork_tensorIso`,
  `flatBaseChange_pushforward_isIso_of_isSeparated`, the Mayer–Vietoris /
  `gammaTensorComparison` chain).
- The **SNAP** leg: `Picard/SectionGradedRing.lean` (11 sorries, in-progress
  localized-associator refactor) and `Picard/SectionGradedRingLocalized.lean` (sorry-free).
- All `.archon/` state (proof-journal, iter logs, STRATEGY) — on disk, untouched.

## To resume
Rename the directory back (drop the `-[paused-…]` suffix) and re-enable in Archon. If
resuming FBC, prefer the concrete-tilde construction; do NOT rebuild the mate machinery
(see `.archon/USER_HINTS.md`).
