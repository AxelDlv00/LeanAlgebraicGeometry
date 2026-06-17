# Progress Critic Report

## Slug
iter105

## Iteration
105

## Routes audited

### Route: `cechCofaceMap_pi_smul` trailing sorry in `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

- **Sorry trajectory** (BasicOpenCech.lean only): 6 → 6 → 7 → 6 → 6 → 6 → 7 across iter-100, 101, 102, 103, 104, 105, 106. Net over 7 iters: +1. The specific target sorry on `cechCofaceMap_pi_smul` (L988 → L1147 → L1179 across rewrites) has **never closed** since iter-099. Every "closure" in the window was on a helper or a different slot (e.g. iter-104 L536 `cechCofaceMap_summand_family_R_linear`), not on the trailing target. The audited residual on the actual route is unchanged-or-worse across 6 consecutive iters.

- **Helper accumulation**: 6 helpers introduced across the last 5 iters (iter-102 `alternating_zsmul_pi_smul_aux_sum_comp`; iter-104/Archon `cechCofaceMap_summand_family` + `cechCofaceMap_summand_family_R_linear`; iter-105 `cechCofaceMap_summand_family'` + `cechCofaceMap_summand_family'_R_linear`; iter-106 `cechCofaceMap_summand_family_comp_eqToHom_eq_summand_family'`). Each iter closes the previous iter's helper body and then adds the next one. Iter-105 even produced **two fully proved helpers** yet the trailing target did not move. Helpers are accumulating; the target residual is not.

- **Recurring blockers** (all named verbatim in the prover reports):
  - "anonymous-closure Pi.lift codomain" — **6 of 6 audited iters** (100, 101, 103, 104, 105, 106). Identified as structural root cause.
  - "discrim-tree pattern-unification" / "discrim-tree blocker" — 5 of 5 audited iters (100, 101, 103, 105, 106).
  - "whnf timeout at 1600000 heartbeats" — 3 of 5 iters (101, 103, 106).
  - "eqToHom-vs-Pi.π transport" — 3 iters (103, 105, 106).
  - "Fin index mismatch `Fin ((prev n) + 2)` vs `Fin (n+1)`" — multi-iter (097, 102/Archon, 105, 106).

- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL, PARTIAL, PARTIAL across iter-099, 100, 101, 103, 105, 106 (iter-102 was a refactor, iter-104 closed a *different* slot). **6 of 6 audited prover-bearing iters returned PARTIAL on this route.**

- **Verdict**: **STUCK**

  Both rules fire:
  - STUCK rule (a): recurring blocker phrases "anonymous-closure Pi.lift codomain" and "discrim-tree pattern-unification" appear in ≥5 iters each — far above the ≥3 threshold.
  - STUCK rule (b): helpers added across last 5 iters without any sorry-elimination on the route's actual target.

  Worse-verdict tiebreak: STUCK > CHURNING (and CHURNING also fires: helpers in ≥4 of last 5 iters, sorry count net **+1** over 7 iters, PARTIAL in 6 of 6).

- **Primary corrective**: **Route pivot**, escalated by re-dispatching `strategy-critic` mid-iter.

  Six consecutive iters of PARTIAL on the same target, with the same three structural blocker phrases ("anonymous-closure Pi.lift codomain", "discrim-tree", "eqToHom-vs-Pi.π transport") each iter, is no longer a tactic-budget problem. It is a definition/encoding problem the current strategy cannot route around. The planner's proposed iter-107 plan (option 1 heartbeat lift + option 2 lemma rework keeping the wrapper chain) is functionally another helper round on the same scaffolding — exactly the pattern this verdict exists to interrupt. The iter-106 prover's option 3 ("discard the wrapper approach entirely and re-attempt R-linearity of unwrapped per-summand directly via `Pi.hom_ext` + per-coord scalar pullback — would discard iter-105/iter-106 helpers") is itself a partial route pivot recommendation; the fact that it is being deferred under "discards helpers" reasoning is the sunk-cost signal that triggers this verdict.

  The planner must do ONE of the following this iter, NOT another wrapper-helper prover round:
  1. Adopt the iter-106 prover's option 3 (discard wrappers, attempt direct `Pi.hom_ext` per-coord scalar pullback). This is the smallest pivot — keep the route, drop the scaffolding.
  2. Refactor the underlying `cechCofaceMap_summand` / Pi.lift definition so it is not an anonymous closure (the recurring structural blocker named in 6 of 6 reports). Dispatch the `refactor` subagent to extract a named function that the discrim tree can handle.
  3. Re-dispatch `strategy-critic` to validate whether the entire R-linearity-via-pi_smul route should be replaced with a different proof of the same downstream obligation.

- **Secondary correctives** (priority order):
  - **Mathlib analogist** on `Pi.hom_ext`, `Pi.lift`, `ModuleCat.Hom.Pi` / `LinearMap.pi` to determine which mathlib API normally proves R-linearity of a Pi-valued morphism without hitting anonymous-closure discrim-tree issues. The persistence of the same blocker phrase across 6 iters suggests the project is fighting an idiom mathlib already resolved elsewhere.
  - **Refactor** the `cechCofaceMap_summand` definition (or the surrounding Pi.lift construction in `BasicOpenCech.lean`) so the codomain projection is a named/eta-expanded form rather than an anonymous closure. This addresses the "anonymous-closure Pi.lift codomain" root cause structurally rather than per-attempt.
  - **User escalation** if 1–3 above are deemed too costly to attempt: six iterations on one target with named structural blockers crosses the threshold where the human author can resolve in minutes what the autonomous loop has not resolved in days.

## Must-fix-this-iter

- Route `cechCofaceMap_pi_smul`: **STUCK** — primary corrective: **route pivot** (adopt iter-106 prover's option 3, OR dispatch refactor on the anonymous-closure root, OR re-dispatch strategy-critic). Why: 6 consecutive PARTIAL iters with three structural blockers re-appearing each iter and net sorry count UP by 1 over 7 iters. The proposed iter-107 plan (heartbeat lift + wrapper-lemma rework) is another iteration of the pattern this verdict exists to interrupt.

## Informational

No CONVERGING or UNCLEAR routes in this directive — only the one stuck route is under review.

## Overall verdict

One route audited; one STUCK verdict; zero healthy routes in scope. The planner's tentative iter-107 plan (heartbeat lift + lemma rework while keeping the wrapper chain) does not address the named recurring blockers — it is approximately the same shape as the iter-103, iter-105, and iter-106 plans, all of which produced PARTIAL with the same three blocker phrases. The iter must NOT dispatch another wrapper-helper prover round on this route. Acceptable iter-107 shapes: (a) prover round on iter-106 option 3 (discard wrappers, direct `Pi.hom_ext` per-coord), (b) refactor subagent to eliminate the anonymous-closure Pi.lift form named as structural root cause in 6 of 6 prover reports, (c) re-dispatched `strategy-critic` to validate a route replacement. The planner must pick one of these or rebut this read in `iter/iter-105/plan.md` (or whatever the active iter-NNN slug is) naming why six iters of recurring blockers do not constitute STUCK.
