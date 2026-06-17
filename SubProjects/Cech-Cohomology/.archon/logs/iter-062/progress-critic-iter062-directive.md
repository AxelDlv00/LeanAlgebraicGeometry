# Progress-critic directive — iter-062

Assess convergence of the TWO active prover routes. Per-route verdict
(CONVERGING / CHURNING / STUCK / UNCLEAR) with the corrective TYPE if not converging.

## Route A — `CechSectionIdentification.lean` (Sub-brick A, Stub 2 `pushPull_sigma_iso`)

Phase entered: ~iter-056 (Sub-brick A). STRATEGY `Iters left`: ~3–5.

Last 5 iters' signals:
- iter-057: sorry 5; +helpers (Stub-1 bricks); PARTIAL. Blocker: Stub-1 distributivity.
- iter-058: sorry 5; +8 helpers (Stub-1 distributivity leaves + Over-S); PARTIAL. Blocker: universe reduction.
- iter-059: sorry 5; +8 helpers (widePullback_coproduct_iso etc.); PARTIAL. Blocker: assembly + universe.
- iter-060: sorry 5→4; +3 helpers; PARTIAL — **Stub 1 `cechBackbone_left_sigma` CLOSED** (universe reduction). Keystone closure.
- iter-061: sorry 4→4; +3 helpers (L1 `isIso_modules_of_toPresheaf` closed + 2 prep helpers); PARTIAL — L2 `pushPull_binary_coprod_prod` BLOCKED, removed rather than sorry'd. Handoff: precise known fix (switch to `SheafOfModules.evaluation V`; reflect `isProductOfDisjoint` Ab-limit to ModuleCat).
- Recurring blocker phrase: "instance-inference on composite functor / disjoint-union module-sheaf iso". L2 is the genuine ~60–100 LOC node.
- Note: the route is executing a decompose-then-build cadence (iter-058 break → iter-059 build bricks → iter-060 assemble closed Stub 1; iter-061 broke Stub-2 monolith + closed L1 → now L2 has a precise fix).

This iter's PROGRESS proposal: re-dispatch CSI lane (mathlib-build) at L2 `pushPull_binary_coprod_prod` with the known instance-fix now written into the blueprint, then `pushPull_coprod_prod` + `pushPull_sigma_iso`.

## Route B — `OpenImmersionPushforward.lean` (Need#1 `hqc`)

Phase entered: ~iter-056. STRATEGY `Iters left`: ~2–3.

Last 5 iters' signals:
- iter-057: sorry ~3; PARTIAL (Ext-transport infra).
- iter-059: sorry 2 (after intentional factoring); +5 helpers; PARTIAL — homological half DONE.
- iter-060: sorry 2→2; +2 helpers; PARTIAL — **`hjt` CLOSED** (`jShriekOU_transport_along_iso`). Sole residual = `hqc`.
- iter-061: sorry 2→2; +2 helpers (`coversTop_preimage_of_iso`, `pushforward_iso_qcoh_of_slice_qcoh` reduction); PARTIAL — `hqc` REDUCED to per-slice presentation transport. Residual sharpened to a single Mathlib gap: cross-ring slice structure-sheaf hom `ψ_r` (~100–150 LOC, genuinely absent from Mathlib). Prover found a SIMPLER route (`SheafOfModules.pullback ψ_r`, single left-adjoint hom) than the blueprint's `pushforwardPushforwardEquivalence` quadruple.
- Recurring blocker phrase: "cross-ring slice ring hom ψ_r absent from Mathlib".

This iter's PROGRESS proposal: blueprint-retarget to the `pullback ψ_r` route + effort-break `ψ_r` into sub-lemmas, then dispatch CSI/OpenImm provers as `mathlib-build` to build `ψ_r` and close `hqc`.

## What I need from you
For each route: is this genuine convergence (residual shrinking, blockers non-recurring, concrete handoff) or churning (helpers accumulating, residual static)? If CHURNING/STUCK, name the corrective TYPE (blueprint expansion / Mathlib-idiom consult / structural refactor / route pivot). Note whether the planned correctives (blueprint NOTE for Route A's instance-fix; blueprint-retarget + effort-break ψ_r for Route B) are the right structural actions, or whether a bare re-dispatch is being dressed up.
