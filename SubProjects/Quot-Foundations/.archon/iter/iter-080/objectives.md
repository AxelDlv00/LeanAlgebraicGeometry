# Iter 080 — Objectives detail

## Lane 1 — FlatBaseChangeGlobal.lean (FBC-B DIRECT, GREEN)
- Scaffold+prove `flatBaseChange_isIso_iff_gammaTensorComparison` (`lem:flat_base_change_reduce_global_sections`)
  — locality on S' + tilde fully-faithful, ~20 LOC.
- Scaffold+prove `baseChangeGammaPullbackEquiv` (`thm:fbcb_global_direct`) — 3-step blueprint assembly
  on top of `baseChangeGammaEquiv`/`gammaTopEquivEqLocus`/`pullback_spec_tilde_iso`/`affine_base_change_pushforward`
  (all DONE), ~80–150 LOC.
- Out of scope: FlatBaseChange.lean (named legs — next-iter refactor, import cycle).

## Lane 2 — GlueDescent.lean (1 sorry → 0 target)
- `glueChartComponent_leg_compat` (L2081): conjugated-cocycle eq over V_ipq. 4-step route, all infra
  compiled (triple toolkit from iter-079). ~200–400 LOC, no new geometry. Closes the keystone.

## Lane 3 — GrassmannianQuot.lean (3 sorries)
- Scaffold+prove `chartLocus_rqPullback` (`lem:gr_chartLocus_rqPullback`, not yet in Lean): preimage ≤
  chartLocus of pullback, via `isIso_pullback_map_comp` + `pullbackComp` NatIso + `chartComposite_rqPullback`.
- `represents.right_inv` (L4440) + `left_inv` (L4435): ride on chartLocus_rqPullback +
  `universalQuotient_restrictionIso` (sorry-free) + `comp_chartMorphism`.
- `tautologicalQuotient_epi` (L2470): PINNED on GlueDescent=0; leave for next iter.

## Verification
- Each lane: real `lake build <module>` (LSP hides kernel timeouts). No `maxHeartbeats 1e6`. No new axioms.
- Cross-lane import transient (GrassmannianQuot imports GlueDescent): retry on transient olean deletion.
