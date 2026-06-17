# Progress Critic Report

## Slug
ts241

## Iteration
241

## Routes audited

### Route A — `Picard/TensorObjSubstrate.lean` (A.1.c, `IsInvertible.pullback`, Route Z)

- **Sorry trajectory**: 2 → 2 → 2 across iter-238 to iter-240 (flat; this sub-step started iter-239, so only 2 iters of meaningful trajectory data on `IsInvertible.pullback` itself)
- **Helper accumulation**: 3 helpers added in 2 active iters (iter-239: +1 `sheafifyTensorUnitIso`; iter-240: +2 `unitToPushforwardObjUnit_comp` + `pullbackObjUnitToUnit_comp`); 0 sorries closed across those 2 iters
- **Prover status pattern**: COMPLETE (iter-238, picCommGroup sub-step — different objective), PARTIAL (iter-239), PARTIAL (iter-240) — for the current sub-step: PARTIAL, PARTIAL
- **Recurring blockers**: Different blocker phrase each iter (iter-239: "no sectionwise pullback formula"; iter-240: "pbu instance non-canonicity") — no verbatim recurrence. Each blocker localized with a concrete next step.
- **Avoidance patterns**: None detected. Structural pivot from sectionwise-extendScalars to Route Z (local-chart finality) occurred between iter-239 and iter-240 — a genuine change of approach, not avoidance.
- **Throughput**: ON SCHEDULE — STRATEGY.md estimates ~5–9 iters for A.1.c; elapsed 2 iters (phase began iter-239).

**Verdict: UNCLEAR**

Only 2 iters of data on `IsInvertible.pullback` specifically (the prior two signals, iter-237 and iter-238, are for different sub-steps and should not be weighted in this sub-step's trajectory). The CONVERGING rules require sorry count strictly decreasing across K iters — that fails (2→2→2 flat). The CHURNING rules require ≥2 iters of helper accumulation with no structural change — the approach DID structurally pivot (Route Z). Insufficient trajectory to call CHURNING definitively.

**However, flag for planner: design-shape suspected (conditional).**

The iter-240 blocker — `infer_instance` failing for `IsIso (pbu φ)` in a multi-hypothesis context while succeeding standalone — is consistent with two distinct root causes:

1. **Lean plumbing only**: `pbu` synthesizes correctly in isolation; the in-proof context accumulates competing instances. Fix = type-ascribed named `Iso` or `@[instance] lemma`. One-time. Does NOT recur in Phase 2/3.

2. **Definition-level canonicity gap**: `pbu`'s type shape doesn't participate cleanly in the `IsIso` typeclass search tree under composition. If this is the cause, Phase 2 (`pullbackTensorIso`) and Phase 3 (`IsInvertible.pullback`) will hit the same wall each time they use `pbu` as a component. Each Phase will need its own workaround.

The prover's report cannot distinguish (1) from (2) from its current evidence. The planner should run the re-dispatch as proposed, but also dispatch a **Mathlib-analogist consult concurrently** (not blocking) to examine whether the `pbu` definition's instance-shape matches how analogous adjunction-mate `IsIso` proofs are structured in Mathlib (e.g., `Adjunction.ofEquiv` → `isIso_unit` chains). If (2) is confirmed, a one-iter refactor of `pbu`'s signature before Phase 2 dispatch is cheaper than three Phase repetitions of the same wall.

Dispatch-sanity for this route: the re-dispatch is NOT a verbatim repeat — it targets a differently-characterized residual (instance plumbing, not the recipe-dead sectionwise approach). Acceptable.

---

### Route B — `Cohomology/FlatBaseChange.lean` (`pushforward_spec_tilde_iso`)

- **Sorry trajectory**: flat→2→2→3→3 across iter-236 to iter-240. Net trend: INCREASING (+1 sorry across the K-iter window). No sorry eliminated across 5 iters.
- **Helper accumulation**: helpers added in all 4 dispatched iters (iter-236: +3; iter-237: +3; iter-239: +2; iter-240: large verified scaffold). Iter-238 was a blueprint-only corrective (no prover dispatch). Total: ≥10 new declarations, 0 sorries eliminated, sorry count increased by 1.
- **Prover status pattern**: PARTIAL, PARTIAL, (no dispatch), PARTIAL, PARTIAL — all 4 dispatched iters are PARTIAL. This satisfies the CHURNING rule (PARTIAL ≥3 of last K iters) AND the STUCK rule (helpers added without any sorry-elimination across K iters; sorry count actually went up).
- **Recurring blockers**: "Module.compHom carrier wall" explicitly tagged as "(4th recurrence)" in iter-239's signal — meaning it appeared in at least 3 prior iters before being broken in iter-240. Now replaced by "restrictScalarsComp'App rewrite-matching pathology" in iter-240. The wall morphed but did not resolve: the sorry count did not drop.
- **Avoidance patterns**: Iter-238 was a plan-only corrective (blueprint expansion) — one occurrence, not a pattern. No consecutive plan-only iters. No off-critical-path reclassification. Avoidance is NOT the primary issue here.
- **Throughput**: ON SCHEDULE by raw numbers (8 of 30–60 iters elapsed since ~iter-233), but the sorry trajectory is the wrong direction: ON SCHEDULE labels conceal that 8 iters bought a sorry count INCREASE, not convergence.

**Verdict: STUCK**

Applicable rules:
- *"Helpers added without any sorry-elimination across K iters"* — YES: 4 dispatched iters, 0 sorry eliminations, count increased.
- *"PARTIAL prover status ≥3 of last K iters"* — YES: 4 of 4 dispatched iters.
- *"Recurring blocker phrase across ≥3 iters"* — the Module.compHom wall reached 4+ recurrences before breaking in iter-240; the replacement pathology arrived immediately in the same iter.

STUCK takes precedence over CHURNING (worse verdict rule applies).

**Primary corrective: Structural NatIso-refactor — ONE attempt, explicit trip-wire.**

The planner's proposed NatIso-refactor (`NatIso.ofComponents`) is structurally sound reasoning: by making naturality definitional rather than proved via rewrites, the `restrictScalarsComp'App` unification pathology is sidestepped at the type level rather than fought at the rewrite level. This is the correct kind of structural fix for a rewrite-matching pathology — it is NOT another helper round on the same approach.

However, the route is STUCK by the rules, which means the planner cannot simply proceed to another prover round without committing to a hard exit condition. The recommended action:

1. Dispatch the NatIso-refactor as proposed — this is the structural attempt.
2. **Commit explicitly in `iter/iter-241/plan.md`**: if the sorry count on `pushforward_spec_tilde_iso` does not strictly decrease after iter-241's prover run, Route B pauses immediately and the next step is the Mathlib bump (#37189), not another in-tree rewrite round. This must be written as a hard condition, not a suggestion.
3. Do NOT dispatch a second attempt at the rewrite-matching pathology if iter-241's sorry count stays flat. The planner has already armed this trip-wire implicitly; making it explicit in the plan prevents another "we'll try one more approach" iter.

The alternative — "go straight to the bump now" — is not viable if the bump is not yet available/merged. The NatIso-refactor is the correct interim structural attempt. But it must be the LAST in-tree attempt, not the first of another helper series.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 (`TensorObjSubstrate.lean`, `FlatBaseChange.lean`)
- **Cap**: 10 (default)
- **Over the cap**: no
- **Under-dispatch finding**: no — directive does not identify additional files with complete blueprint chapters and open sorries beyond these two.
- **Verdict**: OK — file count 2 within cap 10, no under-dispatch identified.

---

## Must-fix-this-iter

- **Route B (`FlatBaseChange.lean`)**: STUCK — primary corrective: NatIso-refactor as a ONE-SHOT structural attempt with an explicit written trip-wire in `iter/iter-241/plan.md`. Why: 4 dispatched iters of PARTIAL, 0 sorries eliminated, sorry count increased; Module.compHom blocker persisted 4+ recurrences; replacement pathology appeared immediately. Without the trip-wire, iter-242 risks another "structural approach" with no sorry drop.

---

## Informational

**Route A design-shape flag**: the UNCLEAR verdict with "design-shape suspected" is a conditional warning, not a must-fix. The re-dispatch is appropriate. The Mathlib-analogist consult is a low-cost concurrent investment that buys confidence before Phase 2. If the planner has bandwidth for only one prover dispatch this iter, prioritize TensorObjSubstrate.lean; the analogy consult can be folded into the same dispatch directive as a concurrent sub-task.

**Route B sorry count interpretation**: the strategy's "~30–60 iters left" estimate conceals that the sorry count INCREASED across the A.2.c engine phase. ON SCHEDULE by iteration count is misleading when the trajectory is negative. If the NatIso-refactor does not move the sorry count, revise the strategy estimate to reflect the Mathlib-bump dependency.

---

## Overall verdict

Two routes audited. Route A is UNCLEAR with a design-shape flag (2 iters of data, linchpin landed, residual well-characterized, but `pbu` instance-canonicity may propagate to Phase 2/3 — mathlib-analogist consult recommended concurrent with re-dispatch). Route B is STUCK (4 PARTIAL dispatches, 0 sorries eliminated, sorry count increased; the Module.compHom wall recurred 4+ times before being replaced by a new rewrite-matching pathology in the same iter). The planner's proposed objectives are structurally reasonable — the NatIso-refactor for Route B is the correct structural corrective — but the planner must commit a hard trip-wire in `iter/iter-241/plan.md`: if Route B's sorry count does not strictly decrease after this iter, the route pauses and waits for the Mathlib bump. Silently dispatching another rewrite round on Route B after a flat sorry count would be the failure pattern this critic exists to prevent.
