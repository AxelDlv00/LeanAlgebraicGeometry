# Progress Critic Report

## Slug
ts228

## Iteration
228

## Routes audited

### Route: A.1.c.SubT — ⊗-group-law substrate (`Picard/TensorObjSubstrate.lean`)

- **Sorry trajectory**: 81 → 80 → 80 → 80 → 80 across iter-223 to iter-227. Net movement on the project sorry counter since iter-224 = **zero**. The iter-224 drop (81→80) closed a self-introduced `internalHomEval` stub, not a pre-existing project obligation. Since the route entered its current descent re-route phase (iter-219), project sorry has been flat for **9 consecutive iters**.

- **Helper accumulation**: +0 (iter-223) / +1 (iter-224) / +1 (iter-225) / +1 (iter-226) / +3 (iter-227) = **6 helpers across 4 prover iters**, all axiom-clean, zero sorry-elimination on new content.

- **Prover dispatch pattern**: 1 of 1 file dispatched each iter (all other lanes gated by design). No under-dispatch finding.

- **Recurring blockers**:
  - "A-bridge `homOfLocalCompat` not landed" — iter-227 (first explicit failure)
  - "no project-sorry-elim since iter-217" — iter-226, iter-227
  - "bridge accretion" — iter-227
  - "build SIZE not d.2" — iter-227
  The A-bridge non-landing is the dominant load-bearing blocker. It does not reappear in iter-226 (B landed instead, off critical path), but it re-surfaces immediately when B shifts focus: iter-227 made A primary, A did not land. The tripwire fired.

- **Avoidance patterns**:
  - The tripwire mandated by ts227 fired explicitly: "if the A-bridge does NOT land axiom-clean this iter … the RR-pause fork escalates to the USER as the live decision — no further grace." The A-bridge did NOT land. The planner responded with a **LIVE FYI escalation** (informational note in PROGRESS.md with "override via USER_HINTS.md; loop proceeds on the plan above otherwise"), then proposed another prover round. This is **not** the hard escalation the tripwire specified. Continuing without a blocking user decision, while technically allowed by the constraint ("cannot pivot unilaterally"), slides the FYI into de facto "one more grace window" — the same pattern the tripwire was designed to prevent.
  - Proposal this iter pivots from "A primary, C probe secondary" (iter-227) to "C primary, A only secondary". The reason is sound (C mirrors a closed lemma, lower risk, H2′ built), but the effect is: if C lands and A does NOT land next iter, the route will have produced a third complete bridge while the project sorry counter remains at 80. The sorry counter does not care which bridge lands first; it only moves on full assembly.

- **Prover status pattern**: PARTIAL (iter-225) → PARTIAL (iter-226) → PARTIAL (iter-227) — **3 consecutive PARTIAL**.

- **Throughput**: OVER_BUDGET — original estimate ~3–5 iters, elapsed 9 iters (iter-219 → iter-228). The iter-227 strategy revision elevated the estimate to ~4–8 iters, but: (a) the lower bound (4) is already exceeded (9 elapsed), (b) the revised upper bound (8) is already exceeded. The revised estimate was produced *after* the OVER_BUDGET finding was already established and does not reflect new evidence — it reflects accumulated optimism. STRATEGY.md `Iters left` = ~4–8 as of iter-227; elapsed in current phase = 9.

- **Verdict**: **STUCK**

  Matching rules (all apply; worst wins):
  1. *Helpers added without any sorry-elimination across K iters* — 6 helpers, zero project-sorry-elim since iter-219.
  2. *PARTIAL prover status ≥3 of last K iters* — qualifies CHURNING; STUCK trumps.
  3. *Sorry count unchanged across K iters AND recurring blocker phrase ≥3 iters* — "no sorry-elim since iter-217" in iter-226 and iter-227; "A-bridge not landed" is the operative blocker across the entire post-iter-217 arc.

- **Primary corrective**: **User escalation — hard block, not informational FYI.**

  The tripwire mandated in ts227 specified an escalation to the USER as a *live decision*, not a `USER_HINTS.md` override note that the loop silently bypasses. The PROGRESS.md post is informational: "override via USER_HINTS.md; loop proceeds on the plan above otherwise." That reads as "the user can stop us if they want." A hard escalation reads as "the user must act before we dispatch another prover on this route." The planner cannot force that without blocking the iter — which means the corrective "user escalation" in this context means: the iter's prover dispatch may proceed as described (C primary is the right tactical choice under the no-pivot constraint), but the plan for this iter **must include an explicit statement that the next iter will NOT dispatch a prover on this route regardless of C's outcome unless the user responds**. The "LIVE FYI" already in PROGRESS.md is a necessary precondition; what is missing is the forward commitment that binds the *next* iter.

  Concretely: the planner should add to `iter/iter-228/plan.md` a locked forward condition — "if C lands axiom-clean this iter AND the user does not lift the RR pause, iter-229 dispatches on A (the sole remaining non-assembly bridge); if A also does not land axiom-clean in iter-229, the loop halts this route — no further grace at all." This is not a pivot; it is a binding termination condition that gives the route exactly one more slot after the current iter, matching the single remaining bridge.

- **Secondary correctives**:
  1. *Decomposition honesty*: The iter-228 proposal labels "C primary, A secondary" as a genuine convergence step. It is — IF C is genuinely lower risk than A (it is: H2′ built, mirrors a closed lemma) and IF completing C meaningfully reduces the remaining risk (it does: C + B done means only A remains). However, if C's restrict-iso step reveals an unexpected complication, the same "probe succeeded, full build did not" pattern from the A-bridge will repeat. The success bar must be sharper: C either lands **full and axiom-clean** this iter, or it does not count toward route progress — a partial C build with helpers-only outcome is identical to iter-227's outcome.
  2. *Estimate hygiene*: STRATEGY.md's `Iters left` estimate has been revised upward mid-route in response to OVER_BUDGET findings. This practice converts the estimate from a forecast into a post-hoc rationalization. The critic does not recommend a further revision. The estimate should be frozen at its current value; any further elapsed iters reduce it by 1 per iter — not reset.

---

## PROGRESS.md dispatch sanity

- **File count**: 1 (cap: 10)
- **Ready but not dispatched**: none — all other lanes are gated by hard dependencies (RPF gated on TS; FGA gated on RPF; Albanese gated on A.2.c; WD terminal-gated; RCI route-C paused). The 1-file dispatch reflects real lane availability, not planning throttle.
- **Over the cap**: no
- **Under-dispatch finding**: no — there are no identifiable lanes with complete blueprint chapters and open sorries that are being withheld. The single-lane dispatch is structurally correct.
- **Verdict**: OK — 1 file, cap 10, no under-dispatch against available lanes.

---

## Must-fix-this-iter

- **Route A.1.c.SubT**: STUCK — primary corrective: **User escalation (hard block, not FYI).** Why: tripwire mandated by ts227 fired (A-bridge did not land); the PROGRESS.md escalation is informational only; the loop is proceeding without a binding user decision or a locked forward termination condition.

- **Route A.1.c.SubT**: OVER_BUDGET — STRATEGY.md `Iters left` ~4–8 (revised), elapsed 9 in current phase. The revision itself was triggered by the OVER_BUDGET finding, not by new evidence of route acceleration. Freeze the estimate; do not revise upward again.

---

## Informational

**On the proposed decomposition (directive question 1):** "C primary, A secondary (localSection)" is NOT the same helper-accretion pattern under a new label — *if C lands fully axiom-clean*. C landing would mean two of the three bridges (B + C) are done, and only the ~120–190 LOC A-engine stands between the current state and `exists_tensorObj_inverse`. That is a genuine risk-reduction step. The concern is not the choice of C as primary; it is the pattern where "build the easier bridge" is accepted as progress-equivalent to "close the sorry," which it is not. The project sorry counter will move only on full A + C + assembly; completing C this iter buys a cleaner next-iter target but does not itself converge the route.

**On whether 11-iter flat counter warrants STUCK (directive question 2):** Yes. The STUCK verdict rules do not carve out an exception for "infrastructure building expected to converge eventually." The argument that bottom-up infra-building naturally produces a flat sorry counter until final assembly is structurally correct, but it has been available as a rebuttal since iter-217 and has not changed the observable signal. The rules are applied mechanically to the signal, not to the intended architecture. The "correct" rebuttal would be: "we landed a bridge-closing helper *on the critical path*." B was explicitly off the critical path (iter-227 plan notes it). C will be on the critical path, but only once it lands. The STUCK verdict is correct under the rules; whether to override it in planning is the planner's call (and must be explicitly rebutted in `iter/iter-228/plan.md`).

**On dispatch sanity (directive question 3):** Clean. 1 file, all other lanes gated. The constraint is structural, not a planning deficiency.

---

## Overall verdict

One route audited (A.1.c.SubT / `TensorObjSubstrate.lean`), verdict **STUCK** plus **OVER_BUDGET**. The route is not mathematically blocked — d.2 is confirmed avoided, B is closed, H2′ is built, C mirrors a closed lemma — but the project sorry counter has been flat at 80 for 9 iters and no bridge on the critical path has fully landed since iter-217. The primary corrective is **user escalation elevated from informational FYI to a hard forward commitment**: the plan for this iter must bind the next iter, stating explicitly that no further prover dispatch occurs on this route after iter-229 (or after C + A both land, whichever comes first) without a user decision on the RR-pause fork. The iter-228 prover dispatch itself (C primary, `localSection` secondary) is the right tactical choice given the no-pivot constraint and should proceed — but it must be the last sanction-free round. Dispatch sanity: OK.
