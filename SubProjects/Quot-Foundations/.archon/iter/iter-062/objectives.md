# Iter 062 — Objectives

## Lane 1 — `AlgebraicJacobian/Picard/GrassmannianQuot.lean` [prove]
BUILD + PROVE the effort-broken L3 chain, then close C2. Sequential, one lane. Attack the atom first.
- ATOM `scalarEnd_pullback` (`lem:gr_scalarEnd_pullback`) — scalarEnd naturality under pullback. SINGLE
  irreducible new claim. HARD GATE: if it stalls, leave partial, no more helpers, escalate iter-063.
- (a) `matrixEnd_pullback` (`lem:gr_matrixEnd_pullback`) — matrixEnd naturality; per-entry → atom.
- (b) `baseChange_bridge` (`lem:gr_baseChange_bridge`) — ΓSpecIso bridge to L1's ring homs.
- L3 `bundleTransition_cocycle_transport` (`lem:gr_bundleCocycle_transport`) — pure assembly (a/b/L1/L2).
- C2 `bundleTransition_cocycle` (`lem:gr_bundleCocycle_mul`, L891 sorry) — `_hC2` form for `Scheme.Modules.glue`.
Done iter-061: L1 `bundleTransition_cocycle_matrix`, L2 `matrixToFreeIso_mul` (axiom-clean).
Diamond rules: pullbackComp/pullbackId OPAQUE; term-mode not positional rw; no `maxHeartbeats 1e6`.

## Lane 2 — `AlgebraicJacobian/Picard/SectionGradedRing.lean` [prove]
scaffold + prove `relativeTensorCoequalizerIso` (`lem:relativeTensor_as_coequalizer`). 0-sorry file ⇒
"scaffold" keyword on the objective's filename line (no-op-filter compliance). 3 steps: objectwise
(`RelativeTensorCoequalizer.isColimitCofork`, DONE) → promote (`evaluationJointlyReflectsColimits`) →
apex (`PresheafOfModules.Monoidal.tensorObj_obj`). Recipe: `TensorProduct.ext'`→`Ab`(=`AddCommGrpCat`)
transport idiom from iter-060 `relTensorProj.naturality`. Friction point = apex identification.

## Gates
blueprint-reviewer iter062: BOTH PASS, doctor clean. progress-critic: GR STUCK (corrective=decomposition,
applied) / SNAP CONVERGING. Both files independent (no import/edit race).
