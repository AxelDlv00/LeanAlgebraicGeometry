# Progress Critic Report

## Slug
route201

## Iteration
201

## Routes audited

### Route: WD-A4a (`RiemannRoch/WeilDivisor.lean`)

- **Sorry trajectory**: 3 → 3 → 3 → 3 → 3 across iter-196 to iter-200. Zero movement in 5 iters.
- **Helper accumulation**: 11 helpers added across the window (iter-196: +1, iter-197: +0, iter-198: +0, iter-199: +2, iter-200: +8). Zero sorries eliminated across the window. STUCK rule 3 fires unconditionally.
- **Prover dispatch pattern**: single lane dispatched each iter; no under-dispatch concern against other ready files given the scope fence.
- **Recurring blockers**: "RR.1 scope fence" in iter-197 and iter-198 (a design wall, not a removable blocker). "Sub-build 1/2/3" pipeline named starting iter-199; iter-200 closes Sub-build 1 (HARD BAR MET). Each iter a new sub-build or scope issue surfaces — the blocker set is evolving, not shrinking.
- **Avoidance patterns**: none — the lane has been dispatched consistently and the scope fence is user-mandated.
- **Prover status pattern**: done, done, done, done (PARTIAL), done (HARD BAR MET). No INCOMPLETE; HARD BAR MET in iter-200 is the only positive trajectory signal.
- **Throughput**: OVER_BUDGET — STRATEGY.md estimate `~3-6 iters`, phase entered iter-186, elapsed = **14 iters** (upper bound 2×6=12; 14 > 12).
- **Verdict**: **STUCK**
- **Primary corrective**: **Blueprint expansion**. The "Sub-build" naming pattern (Sub-build 1 done → Sub-build 2 in iter-201 → Sub-build 3 later) is a telescoping pipeline: each iteration reveals the next sub-build without establishing a terminal convergence condition. After 14 iters with zero sorry closure, the blueprint chapter needs an explicit end-to-end proof sketch mapping the complete Sub-build 1 → 2 → 3 → sorry closure chain before another prover substrate iteration is dispatched. Without that map, the route risks discovering Sub-build 4 after iter-201's Sub-build 2. The analogist has been used for individual sub-build recipes; what is missing is a blueprint-level synthesis confirming the sorry at L325 closes once all three sub-builds land.
- **Mode switch**: none — mathlib-build is appropriate for Sub-build 2 if the blueprint expansion confirms convergence. Consider blueprint-writer dispatch alongside the iter-201 prover lane rather than after.

---

### Route: AB (`Albanese/AuslanderBuchsbaum.lean`)

- **Sorry trajectory**: 1 → 1 → 1 → 1 → 1 across iter-196 to iter-200. Zero movement in 5 iters. Phase entered iter-167; sorry has been at 1 for the entirety of the last 33 iters.
- **Helper accumulation**: 9 helpers added across the window (iter-196: +0, iter-197: +2, iter-198: +2, iter-199: +1, iter-200: +4). The iter-200 ALIGN_WITH_MATHLIB pivot introduces `hasProjectiveDimensionLT_*` helpers, the second major structural pivot on this route (the first was the Nat-recursive reframing; prior pivots likely exist further back in the 33-iter window). Zero sorries eliminated across the window. STUCK rule 3 fires.
- **Prover dispatch pattern**: single lane dispatched each iter.
- **Recurring blockers**: "Nat-recursive" framing appears as the named gap in iter-197, iter-198, iter-199, iter-200 — **4 consecutive iters**. In iter-200 it morphed into "Stacks 00MF base case + ℕ∞ arithmetic," a re-statement of the same induction-base gap under the new Mathlib idiom. STUCK rule: recurring blocker across ≥3 iters fires independently of rule 3.
- **Avoidance patterns**: none of the discrete avoidance patterns (off-critical-path, plan-only iters, deferral language). The lane has been actively dispatched. However the 33-iter / 5.5× over-budget signal is itself an avoidance signature: successive pivots (Nat-recursive framing → HasProjectiveDimensionLT API → Stacks 00MF / ℕ∞) each look like forward motion while the sorry count stays at 1.
- **Prover status pattern**: done, done, done, done, done (HARD BAR NOT MET). Consistent "done" without HARD BAR signals incremental substrate without structural close.
- **Throughput**: OVER_BUDGET (severe) — STRATEGY.md estimate `~3-6 iters`, phase entered iter-167, elapsed = **33 iters** (upper bound 2×6=12; 33 >> 12; 5.5× over).
- **Verdict**: **STUCK**
- **Primary corrective**: **User escalation**. The severity is exceptional: 33 iters, 5.5× over the strategy estimate, recurring induction-base blocker that has survived two major API pivots. The iter-201 plan dispatches an analogist (`ab-stacks00mf`) to choose between Path A (Stacks 00MF substrate ~150-200 LOC) and Path B (LES connecting-map sidestep) — this is the right micro-step, but the macro question — whether the current Lean/Mathlib framework can close `auslander_buchsbaum_formula_succ_pd` at all within the project's axiom budget — requires the mathematician's direct input. Specifically: the `ℕ∞ arithmetic` sub-blocker identified in iter-200 may require a Mathlib PR or a proof-architecture restructure that no internal subagent can resolve. Before committing another 150-200 LOC Stacks 00MF substrate build, the mathematician should confirm the ℕ∞ arithmetic gap is surmountable and that the AB formula proof does not need to wait for an upstream Mathlib addition. File a TO_USER note.
- **Secondary corrective**: **Mathlib analogy consult** on the ℕ∞ arithmetic sub-blocker specifically (separate from the already-dispatched `ab-stacks00mf`): query whether `Module.projectiveDimension` arithmetic in `WithBot ℕ∞` has Mathlib lemmas that close the base case, or whether the project must re-state the formula in `ℕ` to avoid the issue entirely.
- **Mode switch**: consider switching the AB lane from pure mathlib-build to a **mixed blueprint-then-prover** mode for iter-201: the analogist returns its verdict first, the plan agent updates the blueprint chapter with the chosen path, and only then the prover is dispatched on the updated recipe. This avoids a 150-200 LOC substrate build landing on a strategy the blueprint chapter hasn't yet formalized.

---

### Route: COE (`Albanese/CodimOneExtension.lean`)

- **Sorry trajectory**: 3 → 3 → 3 → 3 → 3 across iter-196 to iter-200. Zero movement in 5 iters.
- **Helper accumulation**: 14 helpers added across the window (iter-196: +0, iter-197: +0, iter-198: +3, iter-199: +4, iter-200: +7; acceleration trend). Zero outer-sorry eliminations. STUCK rule 3 fires. However, the trajectory within the Stage 6 sub-decomposition is the strongest positive signal of the three routes: sub-gap (i) discharged iter-198, sub-gap (ii.A) closed iter-199, (ii.B) narrowed to Step 3 in iter-200. Sequential sub-gap closure in 3 consecutive iters with HARD BAR MET in iter-200 is genuine structural advance.
- **Prover dispatch pattern**: single lane dispatched each iter.
- **Recurring blockers**: blockers are EVOLVING not recurring — "(ii.A) + (ii.B) remain" → "narrowed to (ii.B)" → "Step 3 = Jacobian witness iter-201+". Each iter narrows the residual. This is the most favorable blocker trajectory of the three routes.
- **Avoidance patterns**: none.
- **Prover status pattern**: done, done, done (sub-gap (i) DISCHARGED), done (sub-gap (ii.A) CLOSED), done (HARD BAR MET). Every iter in the last three has discharged a named sub-gap. Pattern reads as genuinely converging within the stage decomposition despite the outer sorry count.
- **Throughput**: OVER_BUDGET (marginal) — STRATEGY.md estimate `~5-9 iters`, phase entered iter-181, elapsed = **19 iters** (upper bound 2×9=18; 19 > 18 by 1 iter). The least severe of the three over-budget findings.
- **Verdict**: **STUCK** (by rule 3: helpers added without any sorry-elimination across K iters)
  
  **Caveat for planner**: this is the weakest STUCK of the three. The sub-gap decomposition is genuinely narrowing — three sub-gaps discharged in three consecutive iters is not churn. The outer sorry count being 3 reflects the structure of the route (the sorry closes only when ALL of Stage 6.B closes), not failure of the prover strategy. The iter-201 directive (Jacobian witness + L1061 closure attempt) has the clearest path of the three routes to actually closing a sorry this iter.
  
- **Primary corrective**: **Blueprint expansion** — targeted at Step 3 specifically. The recipe involves `RingTheory.Sequence.IsRegular R'_{m'} (f_j)_{j ∈ σ}` via Stacks 00SW/00OW; the analogist recipe names `RingTheory.Sequence.isRegular_cons_iff` + `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`. Before the prover invests 30-60 LOC, the blueprint chapter should document the exact API chain from `Algebra.SubmersivePresentation.jacobian_isUnit` to `RingTheory.Sequence.IsRegular`. The `IsRegular` vs `IsWeaklyRegular` distinction mentioned in the PROGRESS.md recipe is a known friction point — the chapter should resolve which predicate the Lean proof uses and verify it matches what `ringKrullDim_add_length_eq_ringKrullDim_of_isRegular` expects, so the prover does not build 60 LOC only to discover an API mismatch at the final step.
- **Mode switch**: none. Mathlib-build is appropriate. The blueprint expansion can be dispatched as a blueprint-writer sub-agent alongside the prover lane (parallel, since it targets only the Step 3 recipe section of the chapter).

---

## PROGRESS.md dispatch sanity

- **File count**: 3 (WeilDivisor, AuslanderBuchsbaum, CodimOneExtension)
- **Cap**: not stated in directive; default 10 assumed
- **Ready but not dispatched**: Lane RPF (`Picard/RelPicFunctor.lean`) — 1 sorry (addCommGroup, L235); blueprint chapter `Picard_TensorObjSubstrate.tex` was written by blueprint-writer `tensorobj-substrate-chapter` in iter-200, making RPF newly ready. The iter-200 PROGRESS.md preliminary commitments explicitly name "Lane RPF: dispatch prover on the new chapter" as iter-201 item 5. The iter-201 proposal dispatches 3 lanes, omitting RPF.
- **Over the cap**: no
- **Under-dispatch finding**: gap = 1 file. Rules state "One or two fewer than ready is acceptable." Gap of 1 does not trigger a must-fix.
- **Iter-over-iter trend**: stable at 3 dispatched lanes; RPF gap is 1 iter (newly eligible); no multi-iter under-dispatch pattern.
- **Verdict**: **OK** — 3 files within cap, 1-file gap (RPF) is within acceptable range.

**Informational flag**: The iter-200 plan committed RPF for iter-201 dispatch. If the blueprint-writer returned a complete chapter, dispatching RPF as a 4th lane in iter-201 would honour that commitment and add a low-risk 1-sorry closure attempt (the sorry is isolated to `addCommGroup` at L235). The plan agent should confirm whether the blueprint-writer completed successfully, and if so, add RPF to the iter-201 dispatch unless there is a concrete reason to defer again.

---

## Must-fix-this-iter

- **Route WD-A4a**: STUCK — primary corrective: **Blueprint expansion**. Why: 14 iters elapsed against a 3-6 estimate; Sub-build 2 is being dispatched without a blueprint-level proof that Sub-build 2 + Sub-build 3 terminally close the sorry at L325. Risk of discovering Sub-build 4 after ~30-50 LOC investment.
- **Route WD-A4a**: OVER_BUDGET — STRATEGY.md estimates ~3-6 iters, elapsed 14. Revise the estimate in STRATEGY.md to reflect the sub-build decomposition reality (~3-6 more iters from now, i.e. total ~17-20), or escalate.
- **Route AB**: STUCK — primary corrective: **User escalation**. Why: 33 iters, 5.5× over budget, recurring "Nat-recursive / ℕ∞ arithmetic" induction-base blocker survived two API pivots. The ℕ∞ arithmetic gap may require a Mathlib upstream addition; the mathematician must confirm surmountability before a 150-200 LOC Stacks 00MF substrate build is dispatched.
- **Route AB**: OVER_BUDGET (severe) — STRATEGY.md estimates ~3-6 iters, elapsed 33. Revise estimate drastically (reality is 33 elapsed + unknown remaining) or pivot strategy. A dishonest estimate at this severity discards the throughput signal entirely.
- **Route COE**: STUCK — primary corrective: **Blueprint expansion** (targeted at Step 3 IsRegular API chain). Why: 30-60 LOC Jacobian witness investment is at risk if the `IsRegular` vs `IsWeaklyRegular` API friction is not resolved in the chapter before the prover builds it.
- **Route COE**: OVER_BUDGET (marginal) — STRATEGY.md estimates ~5-9 iters, elapsed 19 (1 iter past 2× upper bound). Revise estimate upward; the sub-gap closure trajectory suggests ~2-4 more iters to actual sorry closure if the Jacobian witness lands.

---

## Informational

**COE positive signal**: Of the three routes, COE has the most favorable trajectory. Three named sub-gaps closed in three consecutive iters (Stage 6.A, 6.B-ii.A, 6.B-ii.B partial), HARD BAR MET iter-200, and a specific 30-60 LOC recipe named for Step 3. The STUCK verdict is technically correct but the route is within striking distance of closing a sorry. The plan agent should weight COE as the highest-probability sorry closure in iter-201.

**AB analogist timing**: The iter-201 plan dispatches analogist `ab-stacks00mf` to choose between Path A and Path B. Given the STUCK + OVER BUDGET severity, the analogist's verdict should be treated as a mandatory gate: if it returns "neither path closes the sorry without upstream Mathlib additions," that triggers the User escalation immediately rather than after another substrate build.

**WD Sub-build chain risk**: The PROGRESS.md "Active monitors" flag already names "if Sub-build 1 reveals further sub-builds, re-classify as helper-churn risk." This condition has materialized: Sub-build 1 done, Sub-build 2 named, Sub-build 3 already named. Three sub-builds across a 3-6 iter estimate is structurally a helper-churn pattern regardless of individual sub-build quality.

---

## Overall verdict

All three active routes are **STUCK** by the rule "helpers added without any sorry-elimination across K iters," and all three are **OVER BUDGET** against STRATEGY.md estimates. The severity gradient is: AB (most severe — 33 iters / 5.5×, recurring induction-base blocker, User escalation required) > WD (14 iters / 2.3×, telescoping sub-build chain without convergence proof, blueprint expansion required) > COE (19 iters / marginal over 2×, but strongest sub-gap trajectory with a specific close recipe for iter-201, blueprint-API clarification needed before Step 3 build). The iter-201 dispatch of 3 lanes is sanity-checked OK, but the plan must: (1) file a TO_USER note on the AB ℕ∞ arithmetic gap before committing the 150-200 LOC Stacks 00MF build; (2) expand the WeilDivisor chapter to map the full Sub-build → sorry-closure chain before or alongside the Sub-build 2 prover dispatch; (3) expand the CodimOneExtension chapter's Step 3 section to resolve the IsRegular/IsWeaklyRegular API question before the Jacobian witness build. The strategy estimates for all three routes must be revised in STRATEGY.md this iter — the current figures are no longer defensible and suppress the throughput signal.
