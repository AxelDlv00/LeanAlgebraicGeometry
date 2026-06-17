# Progress-critic directive — pc264

Assess convergence of three active prover routes over the last K=4 iters (260–263). For each route:
per-iter sorry signal, helpers added, prover status, recurring blocker phrase, plus the strategy's
Iters-left and phase-entry iter. Then judge my proposed iter-264 objectives (end of this directive).

## Route DUAL — `Picard/TensorObjSubstrate/DualInverse.lean` (`sliceDualTransport` ≃ₗ-packaging)
- iter-260: leg-B codomainMap route opened; decl-level sorry 2; internal ≃ₗ holes ~7; PARTIAL.
- iter-261: leg-A built categorically + module-instance wall resolved; decl-sorry 2; internal 7; PARTIAL.
- iter-262: leg-B ε-iso closed (2 axiom-clean helpers `isIso_ε_restrictScalars_appIso`/`dualUnitRingSwap`);
  internal 7→6; decl-sorry 2; PARTIAL.
- iter-263: `map_add'` closed axiom-clean (verified ma-ihom263 recipe); internal 6→5; decl-sorry 2; PARTIAL.
- Helpers added per iter: ~2 / ~1 / ~2 / ~0 (iter-263 closed an existing field, added none).
- Recurring blocker phrase: "decl-level sorry stays 2 — monolithic `≃ₗ` packaging masks sub-hole progress."
  iter-263 new blocker on `map_smul'`: "`{app:=…}.app W` RHS projection is defeq-but-not-syntactic;
  `rw`/`show`/`conv` report pattern-not-found" (tactic mechanics, all ingredients verified to fire).
- pc263 verdict: STUCK. Sanctioned corrective (mathlib-analogist consult BEFORE re-dispatch) was applied
  and WORKED (closed `map_add'` as predicted).

## Route D3′ Sq1 — `Picard/TensorObjSubstrate.lean` (`sheafificationCompPullback_comp`)
- iter-260: Sq2b (`pushforwardComp_lax_μ`+`pullbackComp_δ`) closed; file-sorry 2→3 (genuine decomposition).
- iter-261: `pullbackTensorMap_restrict` opened to factor identity; Sq1 extracted as new lemma; file-sorry 3.
- iter-262: Sq1 R0 factor `(pullbackComp h f).inv` peeled in compiling code; file-sorry 3.
- iter-263: Sq1 main lemma `sheafificationCompPullback_comp` CLOSED sorry-free; residual RELOCATED to new
  helper `sheafificationCompPullback_comp_tail`; file-sorry 3 (net unchanged; auditor confirms honest, not
  laundered). Transposition route proved CIRCULAR by hand and reverted (dead-end eliminated).
- Helpers added per iter: ~2 / ~1 / ~1 / ~1.
- Recurring blocker phrase: "R1/R5 collapse tail" (×3 across 261–263); file-sorry pinned at 3.
- pc263 verdict: UNCLEAR, "one PARTIAL from STUCK"; escalation trigger = cross-domain mathlib-analogist
  on the bicategorical-cocycle / pseudofunctor-unit-composition shape if a 4th PARTIAL with no close.

## Route ENGINE — `Cohomology/CechHigherDirectImage.lean` (push-pull functor `G`)
- iter-261: NEW file scaffolded (6 decls); file-sorry 5; UNCLEAR (fresh).
- iter-262: `CechComplex` given genuine body + 3 axiom-clean decls; file-sorry 5→4.
- iter-263: 2 axiom-clean bricks `pushPullObj`/`pushPullMap` added; file-sorry 4→4 (no new sorry);
  DISCOVERED the functor laws are DE-COUPLED from D3′ Sq1 (provable from Mathlib pseudofunctor coherences).
- Helpers added per iter: 6 / 3 / 2 (all axiom-clean). Status: advancing; healthy.
- Recurring blocker phrase: none persistent; the 4 file-sorries are honestly gated on absent Mathlib
  infrastructure (`Rⁱf_*` spectral sequences, affine acyclicity, flat base change).

## Strategy Iters-left / phase-entry (verbatim from STRATEGY.md `## Phases & estimations`)
- A.1.c.sub (covers DUAL + D3′ Sq1): Iters-left `~8–14`; LOC `~80–250 · ~0/it (monolith metric artifact)`;
  note "budget elapsed 26 vs orig ~6–11; monolithic decls mask sub-progress → decompose."
- A.2.c-engine (covers ENGINE): Iters-left `≈85–140 at an UNDEMONSTRATED ~40/it`; entered iter-261.

## My proposed iter-264 objectives (3 files)
1. `DualInverse.lean` [fine-grained] — close `map_smul'` (the exposed crux `d.hom (s•u)=c•d.hom u` via the
   β-naturality ring identity + `restrictScalars.smul_def'` + a projection-tolerant `exact`), then build
   `invFun` + round-trips.
2. `TensorObjSubstrate.lean` [fine-grained] — close `sheafificationCompPullback_comp_tail` (the Sq1 mate
   calculus), now informed by the engine's Mathlib-pseudofunctor finding (try the same
   `conjugateEquiv_pullbackComp_inv` / `pseudofunctor_*` coherences adapted through the sheafification
   adjunction `B_f = (PrPbPushAdj φ').comp sheafAdj`).
3. `CechHigherDirectImage.lean` [fine-grained] — close `pushPullMap_id`/`pushPullMap_comp` via the Mathlib
   pseudofunctor coherences (de-coupled; independent parallel pole).

## What I need from you
Per-route verdict (CONVERGING / UNCLEAR / CHURNING / STUCK) with the corrective TYPE for any
CHURNING/STUCK. Specifically: is DUAL's sub-hole progress genuine convergence or a sub-hole grind that
won't terminate at this granularity? Is D3′ Sq1 STUCK now (3rd PARTIAL) or does "main lemma closed +
named tail + dead-end eliminated + Mathlib-pseudofunctor angle now available" count as advance? Is the
3-file dispatch sane? Flag any lane where I should pivot granularity or route instead of re-dispatching.
