# Iter-028 objectives

## ONE prover lane (mathlib-build)

### `AlgebraicJacobian/Cohomology/CechToCohomology.lean` — build the rest of the 01EO chain
Sequential targets, in dependency order, build as far as axiom-clean progress allows:

1. `faceShortComplex_shortExact_of_sheaf_ses` (`lem:face_ses_of_sheaf_ses`) — per-face SES bridge.
2. `BasisCovSystem`, `HasVanishingHigherCech` (`def:basis_cov_system`, `def:has_vanishing_higher_cech`).
3. `absoluteCohomology_one_eq_zero_of_basis` (`lem:absolute_cohomology_one_vanishing`) — L3, base case.
4. `absoluteCohomology_eq_zero_of_basis` (`lem:absolute_cohomology_pos_vanishing`) — L4, induction.
5. `cech_eq_cohomology_of_basis` (`lem:cech_to_cohomology_on_basis`) — top assembly.

Hedge: if L4 runs long, close at L3 + the two defs + per-face SES; hand off L4/top to iter-029.

Recipe: `.archon/logs/iter-027/effort-breaker-split-01eo-report.md` (L3/L4 signatures);
blueprint `chapters/Cohomology_CechHigherDirectImage.tex` (HARD GATE cleared iter-028).

## Subagents dispatched this iter
- refactor `root-import` — COMPLETE (root import added, build green).
- blueprint-writer `01eo-reconcile` — COMPLETE (prose reconciled, coverage 14→0, L3/L4/top scaffolded).
- blueprint-clean `01eo` — COMPLETE (no edits needed).
- blueprint-reviewer `iter028` — COMPLETE (HARD GATE clears the chapter, fast path).
- progress-critic `iter028` — CONVERGING.
- strategy-critic — skipped (STRATEGY.md unchanged, prior SOUND, no live challenge).
