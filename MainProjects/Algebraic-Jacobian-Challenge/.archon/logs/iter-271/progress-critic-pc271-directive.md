# Progress-critic directive — iter-271

Assess convergence on the three ACTIVE prover lanes on the Picard/cohomology
critical path. NOTE: iters 266–270 were DAG-only (blueprint graph cleanup); the
last prover round was iter-265. So "last K iters of prover data" = iters 262–265.

## Route DUAL — `Picard/TensorObjSubstrate/DualInverse.lean` (`sliceDualTransport`)
Strategy phase: A.1.c.sub. Iters-left estimate: ~12–20. Entered current phase ~26 iters ago.
Signals (prover rounds):
- iter-262: built leg-A (toFun). PARTIAL.
- iter-263: `map_add'` CLOSED. PARTIAL. internal holes 7→6.
- iter-264: `map_smul'` CLOSED. PARTIAL. internal holes 6→5→4.
- iter-265: built 4 axiom-clean leg-B swap helpers (`dualUnitRingSwapInv`, `dualUnitRingSwapHom`, 2 cancellation lemmas, `isIso_ε_restrictScalars_appIso_hom`). `invFun`/`left_inv`/`right_inv`/`naturality` still sorry. PARTIAL. decl-sorry flat at 2; internal holes flat at 4 this iter (helpers built, fields not closed).
Recurring blocker phrase: "monolithic ≃ₗ artifact"; "invFun needs standalone helper extraction".
Helpers added per iter: +1, +1, +1, +4. Fields closed: add', smul', then 0 fields iter-265 (only infrastructure).

## Route D3′ — `Picard/TensorObjSubstrate.lean` (`sheafificationCompPullback_comp_tail`)
Strategy phase: A.1.c.sub. Iters-left estimate: ~12–20. Entered current phase ~26 iters ago.
Signals:
- iter-262: Sq1 R0 peeled. PARTIAL. file-sorry 3→3.
- iter-263: tail recovery; "transpose whole tail back through homEquiv is CIRCULAR" found by hand. PARTIAL. 3→3.
- iter-264: recovery brick `leftAdjointUniqUnitEta_app` axiom-clean. PARTIAL. 3→3.
- iter-265: bridge `forget_map_pushforward_map` axiom-clean + 2 wiring steps committed; sentence-4 "R1/R5 recovery" BLOCKED (no homEquiv head; the composite sheafify∘pushforward unit-mate step is genuinely novel, NOT rfl). PARTIAL. 3→3.
Recurring blocker phrase: "R1/R5 collapse tail" / "genuinely-novel sheafification-laden mate step" (×3–4 iters).
Helpers added per iter: +1, +1, +1, +1. file-sorry flat 3→3 for 4 consecutive iters.

## Route ENGINE — `Cohomology/CechHigherDirectImage.lean` (`pushPullMap_comp`)
Strategy phase: A.2.c-engine. Iters-left estimate: ~85–140. DE-COUPLED from D3′ (uses only Mathlib pseudofunctor coherences). Entered current phase recently (~iter-260).
Signals:
- iter-264: `pushPullMap_id` LANDED axiom-clean. PARTIAL (target was comp).
- iter-265: `pushPull_unit_mate` axiom-clean (mate-calculus core, a one-liner now). `pushPullMap_comp` BLOCKED — NOT by mate calculus but by a KERNEL whnf blow-up on the `eqToHom` over-triangle transports baked into the *definition* of `pushPullMap`. sorry 4→4. Prover recommends: make `pushPullMap` transport-light (def refactor) OR build a kernel-cheap generalized eqToHom-cancellation lemma.
Recurring blocker phrase: "kernel whnf timeout on eqToHom transports".
Helpers added: +1, +1. Target `pushPullMap_comp` not closed; blocker is now DEFINITIONAL/kernel, not mathematical.

## This iter's proposed prover objectives (3 files)
1. DualInverse.lean — extract `sliceDualTransportInv` as a top-level def, close `invFun`+round-trips.
2. TensorObjSubstrate.lean — R1/R5 recovery (D3′), informed by a cross-domain analogist consult dispatched this iter.
3. CechHigherDirectImage.lean — mathlib-build a generalized eqToHom-transport cancellation lemma (option b), keeping `pushPullMap_id` intact.

For each route return CONVERGING/CHURNING/STUCK/UNCLEAR + the corrective TYPE if not converging.
