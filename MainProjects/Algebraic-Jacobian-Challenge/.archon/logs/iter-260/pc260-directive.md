# Progress-critic directive — iter-260

Assess convergence of the two active substrate routes below. Verdict per route
(CONVERGING / CHURNING / STUCK / UNCLEAR). Then a dispatch-sanity check on the
proposed iter-260 objective list.

## Route 1 — Dual chain (`Picard/TensorObjSubstrate/DualInverse.lean`), Lane TS-inv
Target: close `sliceDualTransport` → `dual_restrict_iso` (the loc-triv group inverse
`exists_tensorObj_inverse` consumes these).
Phase: A.1.c.sub. Strategy `Iters left` estimate for A.1.c.sub: **~10–16**; phase
entered (current form) ~iter-236 (elapsed ~24).

Per-iter signals:
- iter-256: `homOfLocalCompat` CLOSED axiom-clean (a prerequisite). sorry of this file: 2.
- iter-257: `sliceDualTransport` decomposed (sorry 1→2); NOT closed (~200 LOC sectionwise + cross-lane race).
- iter-258: HELD (sanctioned); empirical probe CONFIRMED the reduced `≃ₗ` is exactly the per-`V`
  localization of the shared root `overEquivalence`. sorry: 2 (unchanged).
- iter-259: HELD (sanctioned); diagnostic only — re-verified residual goal + recorded the
  `Module.compHom (β.app V)` instance gotcha + bridge `f ≅ (f.opensRange).ι`; comment cleanup. sorry: 2.
- NEW FACT (end iter-259): the shared root `SheafOverEquivalence.lean` (`restrictOverIso` + `unitOverIso`)
  is now FULLY CLOSED axiom-clean — the gating condition for the route-(1) consumer is removed. Route (1)
  is a documented consumer one-liner + a small `f ≅ U.ι` bridge.
- Proposed iter-260: dispatch DualInverse to close `sliceDualTransport` + `dual_restrict_iso` via route (1).

## Route 2 — D3′ (`Picard/TensorObjSubstrate.lean`), Lane TS-cmp
Target: `pullbackTensorMap_restrict` (Sq2 = Sq2b `pullbackComp` monoidality).
Phase: A.1.c.sub (same estimate ~10–16; elapsed ~24).

Per-iter signals:
- iter-256: 1→2 PARTIAL; the planner's "mirror premise" recipe found WRONG.
- iter-257: 2→2 PARTIAL; closed only a `rfl` reconcile; Sq2b frictions documented.
- iter-258: GHOST RAN — dispatched but produced no edits and no task_result (budget went to held consumers).
- iter-259: 2→3 (decomposition). The entire Sq2b mate calculus is now PROVEN (`pullbackComp_δ`, ~90-line
  proof, compiles), reducing Sq2b to ONE precisely-stated residual `pushforwardComp_lax_μ`
  ("pushforwardComp is monoidal", ~150-LOC ModuleCat change-of-rings coherence). The reversing signal
  fired: the recipe's "rfl/short-ext" prediction for this residual was empirically refuted.
- Proposed iter-260: **HOLD** D3′ (it edits `TensorObjSubstrate.lean`, which `DualInverse.lean` imports →
  the iter-257 cross-lane compile race; DualInverse is higher priority). D3′ runs next iter in-place once
  the tree is stable. The residual `pushforwardComp_lax_μ` is a genuine isolated ModuleCat build.

## Proposed iter-260 `## Current Objectives` (file count + basenames)
- ONE prover lane: `Picard/TensorObjSubstrate/DualInverse.lean` (close `sliceDualTransport` +
  `dual_restrict_iso`, route-1 consumer of the green shared root).
- `Picard/TensorObjSubstrate.lean` (D3′) HELD this iter (race avoidance; runs next iter in-place).
- A blueprint-writer fixes the consolidated chapter's Sq2b must-fix (gates both files); HARD-GATE
  fast-path re-gate before the DualInverse prover runs.

## Specific questions
1. Is Route 1 genuinely CONVERGING now (consumer one-liner with the gate removed), or is the "one-liner"
   framing optimistic given it was HELD-diagnostic for 2 iters?
2. Is Route 2's iter-259 result genuine convergence (Sq2b proven, residual isolated) or churn-dressed-as-
   progress? Does holding it one iter (race avoidance) risk it going stale, or is the residual cleanly
   resumable in-place?
3. Dispatch-sanity: is a single-prover-lane iter (DualInverse) under-using parallelism here, given that the
   only other ready Route-A lane (D3′) genuinely races the dispatched one via the import topology?
