# progress-critic pc262 — directive

Audit convergence of the two active prover routes below. Verdict per route
(CONVERGING / CHURNING / STUCK / UNCLEAR). The iter-261 progress-critic (pc261)
armed an explicit watch on Route DUAL: "iter-261 is route-2's first genuine
dispatch; if it does not reduce the sorry count, escalate to STUCK in iter-262."
iter-261 closed ZERO sorries on both routes. Assess whether that watch fires,
and whether the monolithic-declaration measurement artifact (below) changes the
read.

## Route DUAL — `Picard/TensorObjSubstrate/DualInverse.lean`

Target: `sliceDualTransport` (the per-V O_Y(V)-linear iso, leg-A ∘ leg-B) →
`dual_restrict_iso`. Closing it closes the whole ⊗-inverse chain.

Signals (last 5 iters), decl-level sorry count for this file's two open decls:
- iter-257: sorry 2 — PARTIAL (scaffold sliceDualTransport typed body)
- iter-258: sorry 2 — INCOMPLETE (hold; import-race guard)
- iter-259: sorry 2 — INCOMPLETE (probe; confirmed goal shape)
- iter-260: sorry 2 — PARTIAL (route-1 "consume shared root" falsified as
  structurally insufficient; left typed sorry; requested route-2 sanction)
- iter-261: sorry 2 — PARTIAL (route-2 first genuine dispatch: Module-instance
  wall RESOLVED via `set β`+pinned m₁/m₂; leg-A reindex BUILT categorically via
  `.map`; the single bare sorry became a typechecking skeleton + 7 typed
  sub-sorries). NO decl closed.
- Helpers added: minimal; no dead-helper accumulation. Each iter's additions are
  structural (scaffold, instance fix, leg-A build).
- Recurring blocker phrases: iter-260 "route-1 structurally insufficient";
  iter-261 leg-B `codomainMap` blocked on TWO named frictions — (a) CommRing
  instance loss on `forget₂ CommRingCat RingCat`-imaged section rings,
  (b) `𝟙_`-vs-`restrictScalars`-unit-section defeq bridge.
- MEASUREMENT NOTE: `sliceDualTransport` is a single monolithic `≃ₗ` decl — its
  sorry count cannot drop until ALL 7 sub-holes (codomainMap, naturality, invFun,
  4 ≃ₗ laws) close together. Real per-iter structural progress (leg-A, instance
  wall) is invisible to the decl-count metric.
- STRATEGY Iters-left for the phase (A.1.c.sub): ~8–14; phase entered ~iter-236,
  elapsed ~26 iters (OVER_BUDGET, acknowledged).

## Route D3′ — `Picard/TensorObjSubstrate.lean`

Target: `pullbackTensorMap_restrict` (D3′-outer, 4-square paste) + its newly
extracted Sq1 sub-lemma `sheafificationCompPullback_comp`.

Signals (last 5 iters), file sorry count (excl. the gated, out-of-scope
`exists_tensorObj_inverse`):
- iter-256: 1 — PARTIAL (disproved mirror-premise recipe)
- iter-257: 2 — PARTIAL (Sq2 ring-map reconcile found rfl)
- iter-258: 2 — INCOMPLETE (ghost run, harness anomaly, no edits)
- iter-259: 3 — PARTIAL (decomposed; Sq2b `pullbackComp_δ` proven mod 1 residual)
- iter-260: 2 — COMPLETE (Sq2b fully closed: `pushforwardComp_lax_μ`+`pullbackComp_δ`
  axiom-clean; sorry 3→2)
- iter-261: 3 — PARTIAL (opened `pullbackTensorMap_restrict` to its 4-vs-10 factor
  identity; EXTRACTED new Sq1 lemma `sheafificationCompPullback_comp` with a real
  partial proof reduced to a concrete unit identity; sorry 2→3 = decomposition).
- Helpers: systematic, mostly closed same/next iter. Sq2b (the hardest residual)
  closed iter-260.
- Recurring blocker phrases: iter-261 "Sq1 RHS unit reassembly", "Sq4 unbuilt",
  "the four squares interleave (S1_h acts on tensorObj((pullback f).obj M))".
- pc261 noted: PARTIAL≥3 in the window mechanically borders CHURNING but the
  iter-260 COMPLETE + distinct-sub-problem-per-PARTIAL overrode it; warned that a
  4th PARTIAL with no reduction makes CHURNING mandatory. iter-261 was that 4th
  PARTIAL.
- STRATEGY Iters-left: same phase, ~8–14.

## Planner's iter-262 objective proposal (for dispatch sanity)

Two files (cap 10), serial order TensorObjSubstrate → DualInverse (import coupling):
1. `Picard/TensorObjSubstrate.lean` [prover-mode: prove] — close ONLY the Sq1
   sub-lemma `sheafificationCompPullback_comp` (the RHS unit reassembly; a concrete
   well-defined mate calculus). A focused single-sub-lemma close = measurable 3→2,
   NOT a re-open of the monolithic `pullbackTensorMap_restrict`.
2. `Picard/TensorObjSubstrate/DualInverse.lean` [prover-mode: fine-grained] — after
   a blueprint-writer fixes the chapter drift, EXTRACT the leg-B unit ε-iso as a
   named atomic lemma and close it first (resolving frictions a/b with a
   mathlib-analogist idiom consult run this iter), then the mechanical mirror/laws.

Planner's intended correctives THIS iter (not just "re-dispatch prove"):
mathlib-analogist on the two leg-B frictions; blueprint-writer to fix the 4 major
lvb-di261 adequacy failures + decompose leg-B into an atomic sentence; switch
DualInverse to fine-grained so progress becomes measurable per sub-lemma.

Tell me, per route: does the watch fire (STUCK)? Is the fine-grained-decomposition
+ analogist-consult corrective the right response, or do you name a different
corrective (route pivot to the stalkwise Plan-B, blueprint expansion, structural
refactor)? Is the 2-file dispatch sane?
