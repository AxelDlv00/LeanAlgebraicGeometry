# progress-critic directive (iter-261)

Assess convergence of the two A.1.c.sub prover routes I am considering dispatching this iter.
Both live in the Picard substrate; phase A.1.c.sub entered ~iter 236, strategy `Iters left` = ~8–14.

## Route DUAL — `Picard/TensorObjSubstrate/DualInverse.lean`
Target arc: `sliceDualTransport` → `dual_restrict_iso` → (downstream) `exists_tensorObj_inverse`
(the RPF group inverse). This proves the dual `M^∨` is a locally-trivial tensor-inverse of a
loc-triv `M`.

Signals (last 5 iters):
- iter-256: sorry stable; `homOfLocalCompat` closed; `dual_restrict_iso` guardrail not entered.
- iter-257: `sliceDualTransport` scaffold added (typed-sorry body); file sorry 1→2. Then HELD
  (cross-lane compile race: this file imports `TensorObjSubstrate.lean`).
- iter-258: HELD — empirical probe only, no edits.
- iter-259: HELD — probe re-confirming the reduced goal shape, no edits.
- iter-260: FIRST genuine prover attempt. Directive route-(1) (consume the now-green shared root
  `restrictOverIso`/`unitOverIso`) found **STRUCTURALLY INSUFFICIENT** — the shared root carries no
  internal-hom/dual content; the reduced goal's content is dual-commutation with slice reindexing.
  Prover reduced one real step (`refine LinearEquiv.toModuleIso`), left a typed sorry, and reported
  the exact failing step (armed reversing signal fired as designed). file sorry 2→2.
- sorry trajectory: 1→2→2→2→2. Helpers added: minimal (diagnostic probes), no helper churn.
- Recurring blocker phrase: "route-(1) structurally insufficient; genuine close = route-(2)
  sectionwise (leg-A Beck–Chevalley reindex ∘ leg-B `restrictScalarsRingIsoDualEquiv`); needs
  planner sanction."
- iter-261 plan: SANCTION route-(2) and dispatch this lane on it (the prover's explicit ask). This
  is a fresh, well-specified, self-contained ~150–250 LOC build, NOT a re-run of route-(1).

## Route D3′ — `Picard/TensorObjSubstrate.lean`
Target: `pullbackTensorMap_restrict` (the D3′-outer comparison-iso lemma).

Signals (last 5 iters):
- iter-256: PARTIAL (a mirror-premise recipe was disproven); file sorry 1→2.
- iter-257: found Sq2 ring-map reconcile is `rfl`; sorry 2→2.
- iter-258: dispatched but GHOST-RAN (no edits, no result).
- iter-259: `pullbackComp_δ` (Sq2b mate calculus, ~90 lines) PROVEN modulo one residual
  `pushforwardComp_lax_μ`; sorry 2→3 (genuine decomposition).
- iter-260: `pushforwardComp_lax_μ` CLOSED axiom-clean ⇒ `pullbackComp_δ` axiom-clean too. Sq2b
  fully discharged; sorry 3→2.
- sorry trajectory: 1→2→2→3→2 (net advance: Sq2b — the hardest residual — now CLOSED).
- Remaining in file: `pullbackTensorMap_restrict` (needs Sq1 `sheafificationCompPullback` + Sq4
  `pullbackValIso` composition-coherence, Sq2/Sq2b now in hand) and `exists_tensorObj_inverse`
  (gated on the dual chain — not this route).

## My proposed `## Current Objectives` for iter-261 (file count + basenames)
2 files:
1. `DualInverse.lean` — route-(2) `sliceDualTransport` + `dual_restrict_iso`.
2. `TensorObjSubstrate.lean` — `pullbackTensorMap_restrict` (Sq1/Sq4).

Note the import coupling: `DualInverse.lean` imports `TensorObjSubstrate.lean`. Assess whether
co-dispatching them risks the iter-257-style cross-lane compile race, and whether either route is
CHURNING/STUCK such that I should hold one. Give a per-route verdict and a dispatch-sanity read.
