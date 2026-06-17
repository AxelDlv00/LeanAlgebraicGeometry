# progress-critic directive (iter-062)

Two active prover routes. Assess convergence per route from the signals below; verdict +
dispatch-sanity on the proposed objectives. Do NOT assume STRATEGY soundness or math
correctness — convergence only.

## Route A — GR-quot (`AlgebraicJacobian/Picard/GrassmannianQuot.lean`)
Phase: GR-quot bundle-cocycle (entered ~iter-051). STRATEGY `Iters left` for this phase: ~3.
- iter-058: sorry 3→4. Built scalarEnd ring-hom API + matrixEnd/matrixToFreeIso/bundleTransition infra; proved C1 (`bundleTransition_self`); C2 + 3 riders scaffolded as honest sorries.
- iter-059: 4→4. C1 matrix infra consolidated; no sorry change (build task).
- iter-060: 4→4. Cold-build OOM ceiling RESOLVED (`bundleTransition_self` leaner term; no file split). No sorry change (resource fix).
- iter-061: 4→4. **L1 (`bundleTransition_cocycle_matrix`) + L2 (`matrixToFreeIso_mul`) NEW closed theorems, axiom-clean** (BUILD task, not sorry reduction). C2 (`bundleTransition_cocycle`, the descent cocycle) still sorry; L3 transport stalled as the planner PRE-STATED ("L3 stalls → isolate standalone iter-062"). +7 ported private matrix helpers.
- Recurring blocker phrase: "L3 = ~150 LOC net-new diamond infra: (a) matrixEnd-under-pullback naturality + (b) ΓSpecIso base-change bridge."
- iter-062 proposal: effort-broke L3 into atom (`scalarEnd_pullback`) → (a) `matrixEnd_pullback` → (b) `baseChange_bridge` → residual assembly → close C2. Prover BUILDs the 3 new decls then closes C2 (one lane, sequential).

## Route B — SNAP (`AlgebraicJacobian/Picard/SectionGradedRing.lean`)
Phase: SNAP tensor-powers (ACTIVE). STRATEGY `Iters left`: ~4–8.
- iter-058/059: built `relTensorActL`/`relTensorActR`; `relTensorProj` naturality = 1 sorry.
- iter-060: sorry 1→0. `relTensorProj.naturality` closed; all three coequalizer-row nat transforms done.
- iter-061: **lane DROPPED by the no-op dispatch filter** (BUILD task on a now-0-sorry file; the objective line lacked the scaffold keyword) — prover never ran, NO edits. NOT a stall/churn — a dispatch-mechanics miss.
- iter-062 proposal: scaffold + prove the new decl `relativeTensorCoequalizerIso` (coequalizer-iso for the Ab-presheaf of P⊗_p Q), objective line now carries the scaffold keyword on the filename line. 3-step route: objectwise (`RelativeTensorCoequalizer.isColimitCofork`, DONE) → promote (`evaluationJointlyReflectsColimits`) → apex (`tensorObj_obj`).

## Proposed objectives this iter (2 files, no import/edit race — different files)
1. `GrassmannianQuot.lean` — build+prove L3 chain (atom→a→b→assembly), then close C2 (line ~891 sorry). [prove]
2. `SectionGradedRing.lean` — scaffold+prove `relativeTensorCoequalizerIso`. [prove]
