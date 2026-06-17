# Iter 011 — Objectives (per-lane detail)

Four prover lanes. All gate-cleared. Each lane makes the Lean match the (already-correct) blueprint.

## Lane 1 — FBC-A (`Cohomology/FlatBaseChange.lean`) [prove]
Gate: blueprint-reviewer `iter011` GREEN. Lean is in the PRE-swap state; execute the swap.
- (a) Rebuild `base_change_mate_regroupEquiv` (~854) on `Algebra.IsPushout.cancelBaseChange` →
  kills `map_smul'` + the 2 zero-branch sorries (~951, ~960).
- (b) Create `base_change_mate_section_identity` (`Γ(θ)=lTensor R' η_M`).
- (c) Repoint `base_change_mate_generator_trace` (~1040); delete orphan
  `base_change_mate_generator_trace_eq` (~1000) + the stale `% NOTE` at ~851–853.
- (d) Close `affineBaseChange_pushforward_iso` (~1128).
- Leave `flatBaseChange_pushforward_isIso` (~1168, FBC-B, unblueprinted).
Recipe: `analogies/fbc-base-change-square-transparent-module.md`.

## Lane 2 — GF-alg (`Picard/FlatteningStratification.lean`) [mathlib-build]
Gate: GREEN (all 4 chain nodes). Build bottom-up; sub-lemmas do not exist yet.
- Build `gf_torsion_annihilator` → `gf_nagata_monic_lastVar` → engine
  `gf_mvPolynomial_quotient_finite_monic`.
- Close `gf_torsion_reindex` (~634) → `exists_free_localizationAway_polynomial` (L5, ~664,
  strong induction reverting base `A`) → `gf_noether_clear_denominators` /
  `exists_localizationAway_finite_mvPolynomial` (~486) → `genericFlatnessAlgebraic` (~771).
- Leave `genericFlatness` (~833, GF-geo). Recipe: `analogies/gf-generic-rank-ses.md`.

## Lane 3 — QUOT-A (`Picard/QuotScheme.lean`) [mathlib-build]
Gate: GREEN on `lem:qcoh_section_localization_basicOpen` only.
- Build `Scheme.Modules.isLocalizedModule_basicOpen` from quasicoherence +
  `IsAffineOpen.isLocalization_basicOpen` + landed `Module.annihilator_isLocalizedModule_eq_map`.
- Then `Scheme.Modules.annihilator` if budget.
- NOT targets: `def:sectionGradedRing` (BLOCKED), the 4 skeleton sorries (~123/161/198/225).
Recipe: `analogies/quot-predicates.md`.

## Lane 4 — GrassmannianCells (`Picard/GrassmannianCells.lean`) [mathlib-build]
Gate: scoped re-review `grcells-rereview` CLEARS for the bottom leaves. Scaffold+build NEW decls.
- Bottom-up: `universalMatrix` → `minorDet` → `universalMinor` → `isUnit_det_universalMinor` →
  `universalMinorInv` → `universalMinorInv_mul_cancel` → upward (`imageMatrix`, `transitionPreMap`,
  `isUnit_transitionPreMap_minorDet`, `transitionMap`) as far as budget allows.
- Delete stale `affineChart` docstring (~59). Hand off a decomposition if blocked (no sorry).
- This is the corrective for the 2-iter zero-output STUCK; targets are now small concrete atoms.

## Subagent dispatch log (iter-011)
- blueprint-reviewer `iter011` (whole-blueprint HARD GATE) — DONE.
- progress-critic `iter011` — DONE.
- strategy-critic `iter011` — DONE.
- effort-breaker `gr-transition` (split `def:gr_transition`) — DONE (8 blocks + 5 anchors).
- blueprint-clean `gr-cells` — DONE.
- blueprint-reviewer `grcells-rereview` (fast-path scoped) — DONE (GATE CLEARS).
