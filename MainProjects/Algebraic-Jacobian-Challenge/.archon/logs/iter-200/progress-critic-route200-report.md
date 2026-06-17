# Progress Critic Report

## Slug
route200

## Iteration
200

## Routes audited

### Route: Lane WD-A4a — `WeilDivisor.lean` (`rationalMap_order_finite_support`)

- **Sorry trajectory**: 4 → 4 → 4 → 3 → 3 across iter-195 to iter-199; net −1 in 5 iters (0.2/iter); zero change in the 2 active prover iters (198–199)
- **Helper accumulation**: 8 helpers added across iter-198 (6) and iter-199 (2); 0 sorries closed during those 2 active iters
- **Prover dispatch pattern**: N/A×3, then PARTIAL (198), INCOMPLETE (199) — regression within 2-iter active window
- **Recurring blockers**: "open-immersion stalk-bridge for prime divisors (Stacks 02IZ/005X) missing in Mathlib" — iter-199 first occurrence; 1 iter only, not yet ≥3
- **Avoidance patterns**: none — route is dispatched this iter
- **Prover status pattern**: N/A, N/A, N/A, PARTIAL, INCOMPLETE — clear regression in the 2 active iters
- **Throughput**: ON_SCHEDULE — estimated ~3–6 iters, elapsed 2 iters
- **Verdict**: CHURNING
- **Primary corrective**: **Mathlib analogy consult** — the blocker is a specific missing Mathlib bridge for open-immersion stalks (Stacks 02IZ/005X). Eight helpers have been added without closing the residual sorry; more scaffolding will not resolve a genuine API gap. The prover needs to find the right Mathlib predicate or reformulate the stalk statement before adding further helpers. A Mathlib-idiom search on open-immersion stalk restriction and prime divisor stalks should precede the next prover round.

---

### Route: Lane AB — `AuslanderBuchsbaum.lean` (`auslander_buchsbaum_formula_succ_pd`)

- **Sorry trajectory**: 1 → 1 → 1 → 1 → 1 across iter-195 to iter-199 — **unchanged across the full K=5 window**
- **Helper accumulation**: 5 helpers added (iter-195: 2, iter-198: 2, iter-199: 1); 0 sorries closed across the entire K=5 window
- **Recurring blockers**: "3-gap structure (gaps 1/2/3) substrate-build" — iter-195 onwards, **5 consecutive iters**; note that "gap 1 per-syzygy step closed iter-199" describes internal approach progress, not an actual sorry closure
- **Avoidance patterns**: none — route is dispatched this iter
- **Prover status pattern**: PARTIAL, N/A, N/A, PARTIAL, PARTIAL — three PARTIAL statuses in K=5, recurring blocker present across all 5 iters
- **Throughput**: SLIPPING — elapsed 5 iters; "Iters left: ~3–8 (refreshed iter-200)" is a forward estimate reset this iter. The refresh itself warrants scrutiny: the prior estimate presumably did not account for 5 iters of no sorry movement. Refreshing the estimate at the moment of re-evaluation masks the over-budget status. Treat as SLIPPING at minimum.
- **Verdict**: STUCK

  Two STUCK rules fire independently:
  - Rule 2: recurring blocker phrase "3-gap structure" appears across ≥3 consecutive iters (5 iters).
  - Rule 3: 5 helpers added across K=5 iters with zero sorry-elimination.

  The prior corrective (blueprint expansion, iter-200 via `\subsec:ab_gap1_first_step`) was dispatched as must-fix — but blueprint expansion is a planning-phase action that does not itself close a sorry. The sorry count has not moved in 5 iters.

- **Primary corrective**: **Mathlib analogy consult** — blueprint expansion is already done. The next step is to find the right Lean/Mathlib API for the Nat-recursive iterated minimal-free-resolution. The current 1 remaining sorry has resisted 5 prover rounds; the gap-1 Nat-recursive approach needs a concrete Mathlib foothold before another prover dispatch accumulates more helpers with no closure.
- **Secondary corrective**: If Mathlib analogy consult finds no viable path within 1 iter, escalate to **User escalation** — 5 iters on a single sorry with recurring blocker warrants mathematician input on whether the AB formalization strategy is sound.

---

### Route: Lane COE — `CodimOneExtension.lean` (`isRegularLocalRing_stalk_of_smooth`)

- **Sorry trajectory**: 3 → 3 → 3 → 3 → 3 across iter-195 to iter-199 — **unchanged across the full K=5 window**
- **Helper accumulation**: 7 helpers added (iter-198: 3, iter-199: 4); 0 sorries closed across K=5 window
- **Recurring blockers**: "Stage 6 sub-gap (ii.B) Stacks 00OE Krull-dim formula" — iter-198 and iter-199 (2 iters); not yet ≥3, but the parent "Stage 6" blocker dates to the phase entry at iter-193 (7 iters total in this phase)
- **Avoidance patterns**: none — route is dispatched this iter
- **Prover status pattern**: N/A, N/A, N/A, PARTIAL, PARTIAL — two consecutive PARTIAL without sorry movement
- **Throughput**: SLIPPING — elapsed 7 iters vs estimate ~6–10. The lower bound (6) is already exceeded. The "velocity refresh iter-200 (~30/it → ~50/it)" increasing the LOC-per-iter estimate is a concern: estimate refreshes at stall points are a known signal of estimate laundering. Flag: original velocity estimate (~30/it) was in place for 7 iters with no sorry-closures.
- **Verdict**: STUCK

  Rule 3 fires: 7 helpers added across K=5 iters with zero sorry-elimination (sorry count 3 throughout all 5 iters).

  The prior corrective (blueprint expansion iter-198 with explicit (ii.A)/(ii.B) per-step LOC) produced helpers but no sorry closure. Sub-gap (ii.A) was reportedly closed in iter-199 — but the sorry count did not move (3→3). This pattern suggests (ii.A) was an internal structural preparation, not a sorry-closing step.

- **Primary corrective**: **Mathlib analogy consult** — blueprint expansion is already done. Sub-gap (ii.B) "Stacks 00OE Krull-dim formula" is a specific Stacks tag that may or may not have a direct Mathlib correspondent. The prover needs to locate the right Mathlib theorem for the Krull dimension formula before adding further helpers around the gap. If the formula is absent from Mathlib, this becomes a route pivot decision.
- **Secondary corrective**: If no Mathlib path exists for Stacks 00OE, **Route pivot** — reformulate `isRegularLocalRing_stalk_of_smooth` to avoid the Krull-dim formula step, or axiomatize the lemma and document the Mathlib gap explicitly.

---

### Route: Lane FGA — `FGAPicRepresentability.lean` (HOLD)

- **Sorry trajectory**: 7 → 7 → 7 → 7 → 7 across iter-195 to iter-199 — unchanged
- **Helper accumulation**: 0 net; iter-199 refactor closed Sorry 4 (from 8→7, but prior to the K=5 window starting at 7) — the carrier-soundness refactor is structural cleanup, not sorry-elimination within the K=5 window
- **Prover dispatch pattern**: N/A×4, then iter-199 partial refactor (carrier-soundness); 4 of 5 iters with no meaningful prover dispatch
- **Recurring blockers**: plan-phase-only stall (iter-194 onwards); rank-1 remaining sorries gated on RPF (A.1.c); rank-3 gated on Route C blocked
- **Prover status pattern**: N/A, N/A, N/A, N/A, PARTIAL (refactor only)
- **Throughput**: ON_SCHEDULE by raw numbers (4 elapsed vs ~12–16 remaining), but the sorry count has been frozen at 7 since the K=5 window start. The large "Iters left: ~12–16" estimate gives false comfort.
- **Verdict**: STUCK

  Rule 1 fires: sorry count unchanged across K=5 iters with N/A (no meaningful proof progress) statuses in 4 of 5 iters.

  The HOLD is explicitly dependency-gated (RPF rank-1, Route C rank-3). However, RPF is itself STUCK (see below) with a 12-iter recurring blocker. A HOLD that depends on a STUCK route is not a strategic hold — it is a dependency cascade. FGA is effectively indefinitely deferred unless RPF is unblocked.

- **Primary corrective**: No new corrective this iter — the HOLD is structurally justified by the RPF and Route C dependencies. **However**: the planner must acknowledge that RPF's STUCK status (below) makes FGA's re-engagement trigger indefinite. If RPF's project-side tensorObj build path (iter-200 blueprint-writer) does not produce a clear closure within 2–3 iters, the planner must either (a) find an FGA-specific workaround for the rank-1 sorries that does not require RPF to be closed first, or (b) escalate to the user.

---

### Route: Lane RPF — `RelPicFunctor.lean` (`addCommGroup`) (HOLD)

- **Sorry trajectory**: 6 → 6 → 6 → 1 → 1 across iter-195 to iter-199; dramatic drop iter-198 (6→1 via placeholder structural work), then 1→1 stall
- **Helper accumulation**: 0 helpers added across all K=5 iters; sorry drop was structural (placeholder), not incremental proof work
- **Recurring blockers**: "Scheme.Modules.tensorObj upstream Mathlib gap" — iter-188 onwards, **≥12 consecutive iters**
- **Avoidance patterns**: iter-199 held; iter-200 no-prover (blueprint-writer dispatch only). Pattern: route has had exactly 1 prover dispatch in the last 12 iters (iter-198, placeholder status)
- **Prover status pattern**: N/A, N/A, N/A, PARTIAL (placeholder), N/A — one placeholder dispatch in 12 iters
- **Throughput**: OVER_BUDGET — phase A.1.c entered iter-188, elapsed 12 iters. The current "Iters left: ~3–5 (post-SubT)" is a re-scoped estimate that resets the clock to the new A.1.c.SubT sub-phase. The total A.1.c elapsed (12 iters) with any reasonable prior estimate makes this OVER_BUDGET. The "post-SubT" qualifier is an estimate re-launch, not a genuine schedule correction.
- **Verdict**: STUCK + OVER_BUDGET

  Rule 2 fires: recurring blocker phrase "Scheme.Modules.tensorObj upstream Mathlib gap" across ≥12 consecutive iters.
  Throughput: OVER_BUDGET with Iters left > 0 (3–5 post-SubT).

  The iter-200 blueprint-writer dispatch for `Picard_TensorObjSubstrate.tex` is the current corrective — building a project-side tensorObj implementation to bypass the upstream Mathlib gap. This is the right structural response. The concern is that this extends the plan-phase-only pattern to 13 consecutive iters (iter-188 to iter-200) with only 1 actual prover round.

- **Primary corrective**: **Blueprint expansion** (in progress — iter-200 blueprint-writer dispatch). This must produce a concrete chapter with proof obligations the prover can close in iter-201. If the blueprint-writer chapter does not yield at least 1 sorry-closing prover run in iter-201, escalate to **User escalation**: 12 iters on the same blocker with no sorry closure demands mathematician input on whether the tensorObj project-side build path is feasible.
- **Note on FGA cascade**: FGA's rank-1 sorries are gated on RPF. RPF's OVER_BUDGET + STUCK status makes FGA's re-engagement timeline uncertain. The planner must address this dependency explicitly in iter-201.

---

### Route: Lane T32 — `Thm32RationalMapExtension.lean` (`isReduced_of_smooth_over_field`) (HOLD)

- **Sorry trajectory**: 2 → 2 → 2 → 2 → 2 across iter-195 to iter-199 — unchanged
- **Helper accumulation**: 0 helpers added across K=5 iters
- **Prover dispatch pattern**: N/A×3, INCOMPLETE (iter-198), N/A (iter-199 held) — only 1 prover attempt in 5 iters
- **Recurring blockers**: "no Smooth → IsReduced bridge in Mathlib" — iter-198 first surfaced, 2 iters; binding trigger: COE Stage 6.B
- **Avoidance patterns**: none — HOLD has explicit trigger condition
- **Prover status pattern**: N/A, N/A, N/A, INCOMPLETE, N/A
- **Throughput**: ON_SCHEDULE — elapsed 4 iters vs ~8–14 estimate
- **Verdict**: STUCK

  Rule 1 fires: sorry count unchanged across K=5 iters AND prover status includes INCOMPLETE (iter-198).

  The HOLD binding trigger is "COE Stage 6.B Krull-dim formula closed." COE is assessed STUCK above (7 helpers, 0 sorry-closures, ongoing blocker). If COE does not resolve sub-gap (ii.B) this iter, T32's trigger condition is not met and T32 remains deferred into iter-201.

  **Cascading dependency risk**: T32 is bound to COE, which is STUCK. The iter-200 COE prover dispatch (sub-gap (ii.B)) is the critical path. If it fails, T32 must either find an independent path to `isReduced_of_smooth_over_field` or remain deferred.

- **Primary corrective**: Conditional on COE. If COE sub-gap (ii.B) is NOT closed this iter, the planner must evaluate whether to break the binding trigger in iter-201 and dispatch T32 with an independent Mathlib analogy consult on `Smooth → IsReduced`, rather than continuing to wait on COE.

---

## PROGRESS.md dispatch sanity

- **File count**: 3 dispatched (WD, AB, COE); cap: 10 (default)
- **Held with explicit rationale**: RPF (blueprint-writer dispatch), FGA (dependency-gated), T32 (binding trigger on COE)
- **Ready but not dispatched**: All 3 held files have explicit, plausible rationale; this is not under-dispatch by the rule (holds are dependency-gated, not avoidance)
- **Over the cap**: No
- **Under-dispatch finding**: No — 3 dispatched + 3 held with rationale is a legitimate composition
- **Iter-over-iter trend**: Dispatch composition has been 3 active + 3 held for 2 iters; not growing
- **Verdict**: OK — file count 3 within cap 10, held files are dependency-gated with explicit rationale. No under-dispatch finding.

  **Note**: The 3-dispatch composition is correct given the dependency structure. However, the held routes are increasingly at risk of becoming indefinitely deferred if the active routes (WD, AB, COE) do not resolve. The planner should set explicit deadlines: if AB and COE do not produce sorry-closures by iter-202, the held route holds must be reconsidered independently.

---

## Must-fix-this-iter

- **Route WD** (Lane WD-A4a): CHURNING — primary corrective: **Mathlib analogy consult** on open-immersion stalk bridge (Stacks 02IZ/005X). Why: 8 helpers added in 2 active iters with 0 sorry-closures; PARTIAL→INCOMPLETE regression; adding more helpers will not close a genuine Mathlib API gap.

- **Route AB** (Lane AB): STUCK — primary corrective: **Mathlib analogy consult** on Nat-recursive iterated minimal-free-resolution API. Why: sorry count 1→1→1→1→1 across K=5 iters; recurring blocker 5 consecutive iters; blueprint expansion already done as prior corrective; dispatching another helper round without an API foothold repeats the same wall.

- **Route COE** (Lane COE): STUCK — primary corrective: **Mathlib analogy consult** on Stacks 00OE Krull dimension formula. Why: sorry count 3→3→3→3→3 across K=5 iters; 7 helpers added with 0 closures; blueprint expansion already done iter-198; sub-gap (ii.A) closed internally without moving the sorry count, suggesting sub-gap (ii.B) is the true blocker and it needs a Mathlib correspondent located before more helper work.

- **Route RPF** (Lane RPF): STUCK + OVER_BUDGET — primary corrective: **Blueprint expansion** (in progress, iter-200 blueprint-writer). Why: recurring blocker "tensorObj upstream Mathlib gap" for ≥12 iters; 12 iters elapsed in A.1.c phase with only 1 prover dispatch (placeholder); OVER_BUDGET with Iters left ~3–5 (post-SubT re-scope). The blueprint-writer chapter must yield at least 1 concrete sorry-closing prover round in iter-201 or escalate to User escalation.

- **Route FGA** (Lane FGA): STUCK with dependency cascade — no new corrective this iter; planner must document an explicit contingency: if RPF does not produce prover progress in iter-201, FGA's re-engagement plan must be revised independently of RPF closure.

- **Route T32** (Lane T32): STUCK — contingent: if COE sub-gap (ii.B) is NOT closed in iter-200, the binding trigger must be re-evaluated in iter-201 and T32 may need an independent path via **Mathlib analogy consult** for `Smooth → IsReduced`.

---

## Informational

- **Estimate laundering risk**: The AB estimate was "refreshed" to ~3–8 iters at the moment of a 5-iter stall; the COE estimate received a "velocity refresh" at the moment of a 7-iter stall. Refreshing estimates at stall points obscures over-budget status. If neither AB nor COE shows sorry-elimination in iter-200, their estimates should be revised upward (not refreshed forward) in STRATEGY.md.

- **RPF estimate re-scoping**: The "post-SubT" qualifier resets the A.1.c timeline by introducing a sub-phase. This is acceptable IF the SubT blueprint chapter produces concrete prover obligations. It is estimate laundering if it extends the planning horizon without new proof work closing. The iter-201 prover dispatch for RPF is the falsification test.

---

## Overall verdict

Six routes audited: 3 dispatched (WD CHURNING, AB STUCK, COE STUCK) and 3 held (RPF STUCK+OVER_BUDGET, FGA STUCK, T32 STUCK). **Zero routes are CONVERGING.** The dispatched routes have all accumulated helpers without closing sorries in their most recent active prover windows. The primary pattern across AB and COE is that blueprint expansion correctives were applied last iter but prover runs in those iters still produced 0 sorry-closures — the helpers built scaffolding without the blockers being removed. The iter-200 prover dispatches (WD Sub-build 1, AB gap-1 Nat-recursive, COE sub-gap ii.B) are the correct target work, but each needs a Mathlib-idiom foothold located *before* another helper accumulation round. The planner must invoke a Mathlib analogy consult as a pre-condition for at least AB and COE's prover objectives this iter; WD's new blocker (open-immersion stalk-bridge) warrants the same. The RPF held-route + blueprint-writer is the right corrective action but faces a falsification test in iter-201. FGA and T32 are stuck in a dependency cascade; the planner must set explicit deadline triggers for breaking those holds if the upstream routes do not clear.
