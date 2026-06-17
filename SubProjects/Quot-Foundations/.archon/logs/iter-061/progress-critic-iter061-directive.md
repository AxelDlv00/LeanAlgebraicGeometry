# Progress-critic directive — iter-061

Assess convergence of the two active prover routes. Verdict per route + dispatch sanity on the proposed objectives.

## Route A — SNAP (`Picard/SectionGradedRing.lean`)

Phase: SNAP-S0 (section graded ring). STRATEGY estimate: 3–5 iters left; phase active since ~iter-053.

Signals (last 4 iters):
- iter-057: relTensorActL/ActR groundwork; sorry ~4.
- iter-058: 4→1 sorries. Closed 4 functoriality fields; built `relTensorActL`/`relTensorActR` axiom-clean (carrier refactor `objRestrict`); added `relTensorProj` (data proven, naturality = 1 sorry). Status COMPLETE-with-progress.
- iter-059: untouched (blueprint prep only). No prover run.
- iter-060: 1→0 sorries. Closed `relTensorProj.naturality` (via `TensorProduct.ext'`+`rfl`, the feared forget₂-carrier blocker was illusory). Status COMPLETE. File now 0 sorries.
- Recurring blocker phrases: "forget₂ CommRingCat→RingCat carrier" (iters 056–059) — RESOLVED iter-060.
- Helpers added per iter: iter-058 +3 (actL/actR/proj), iter-060 +0.

Proposed iter-061 objective: BUILD + PROVE new decl `relativeTensorCoequalizerIso` (`lem:relativeTensor_as_coequalizer`) — promote the objectwise coequalizer to the presheaf functor category (3-step sketch: objectwise → evaluationJointlyReflectsColimits promotion → apex identification). First lane on this decl (does not exist in Lean yet).

## Route B — GR-quot (`Picard/GrassmannianQuot.lean`)

Phase: GR-quot taut.quotient + representability. STRATEGY estimate: 5–10 iters left; phase active since ~iter-051.

Signals (last 4 iters):
- iter-056: `Scheme.Modules.glue` closed (equalizer-of-pushforwards).
- iter-059: built GL_d matrix infra (scalarEnd ring-hom API, matrixEnd/matrixToFreeIso, bundleTransition) + proved C1 (`bundleTransition_self`); scaffolded C2 + 3 riders. 3→4 sorries. Status COMPLETE-with-progress.
- iter-060: RESOLVED cold-build OOM ceiling (`bundleTransition_self` re-proven leaner, override dropped, 227s→22s). 4→4 sorries (resource fix, not a sorry reduction). Status COMPLETE.
- Recurring blocker phrases: "cold-build OOM / exit137" (iters 058–060) — RESOLVED iter-060; "term-mode only under Modules diamond" (persistent idiom, not a blocker).
- Helpers added per iter: iter-059 +16 (matrix infra), iter-060 +1 (`pullbackFreeIso_trans_symm_eqToIso`).

Proposed iter-061 objective: BUILD + PROVE the effort-broken C2 chain — `bundleTransition_cocycle_matrix` (L1, matrix Cramer cocycle) → `matrixToFreeIso_mul` (L2, one-liner) → `bundleTransition_cocycle_transport` (L3, ~50-100 LOC term-mode transport bookkeeping, the hard step) → close `bundleTransition_cocycle` (C2). All have detailed blueprint blocks; the 3 stepping stones are net-new decls. Deep lane, one prover, sequential.

## Questions for you
- Is either route CHURNING (helpers multiply, residual unchanged)? Note GR added 16+1 helpers across iters 059-060 but those were genuine infra/resource-fix, not churn around a stuck sorry.
- Is the GR C2 chain dispatch correctly scoped (build+prove 4 decls in one lane), or should L3 (the hard transport step) be isolated?
- Dispatch sanity: 2 lanes, distinct files, no import/edit race.
