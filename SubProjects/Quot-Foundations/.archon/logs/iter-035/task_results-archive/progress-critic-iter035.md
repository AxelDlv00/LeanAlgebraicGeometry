# Progress Critic Report

## Slug
iter035

## Iteration
035

## Routes audited

### Route 1 — FBC-A (`Cohomology/FlatBaseChange.lean`, `_legs` crux)

- **Sorry trajectory**: 4 → 4 → 4 → 4 across iter-031 to iter-034 (5 consecutive iters of no `_legs` closure, net zero)
- **Helper accumulation**: ~1–2 helpers per iter across all 4 audited iters; ~6–8 total added; zero net sorry reduction. iter-034 delivered 2 axiom-clean foundation lemmas (`pullbackComp_eq_leftAdjointCompIso{_inv}`) — real progress on the conjugate scaffolding, but `_legs` did not close.
- **Prover dispatch pattern**: 1 file dispatched per iter across iters 031–034 (no under-dispatch issue; only 1 lane is unblocked in FBC-A — this is not an avoidance signal).
- **Recurring blockers**: "X.Modules instance diamond" appears across iters 031–034 (≥4 iters). "cross-layer naturality of gammaPushforwardIso" appears across iters 031–034 (≥4 iters). Both phrases span ≥3 iters — rule trigger satisfied.
- **Avoidance patterns**: none. Each iter dispatched a prover. The iter-033 HARD-COMMIT (direct-on-sections abandoned) and iter-034 pivot to conjugate route are structural decisions, not avoidance. No consecutive plan-only iters observed on this route.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL — four consecutive PARTIALs.
- **Throughput**: OVER_BUDGET — STRATEGY.md estimates 2–4 iters for FBC-A's current phase (entered the conjugate phase at iter-034). Route-level FBC-A has been in active work since well before iter-031; sorry at 4 for ≥5 iters against a 2–4 iter estimate. Note: the CONJUGATE sub-phase itself has only 1 prover iter (iter-034), so the sub-phase estimate clock just started.
- **Verdict**: **STUCK**
- **Primary corrective**: **Structural refactor** — but with a sequencing constraint: the prescribed "route pivot to conjugate" corrective from iter-034 was correctly taken, and the conjugate sub-phase has had exactly 1 prover iter (iter-034 was foundation-only; iter-035 is the first full closure attempt). The iter-035 proposal (one round + effort-breaker atomizing conj-1/conj-2 into a `\uses`-linked sub-lemma chain) is the correct last attempt on this approach. HOWEVER: if iter-035 does not close at least one of `_legs`/`gstar_transpose`, the iter-036 structural refactor of the comparison-object encoding MUST be treated as a hard commitment, not a contingency. The plan agent must write this as a scheduled deliverable in the iter-036 objectives block, not as a "fallback if needed" note.

**Special-focus answer (from the directive):**

*Is conj-0 → conj-1 a genuine advancing pivot or reworded churn?*

Genuine pivot, not rotation churn — with a caveat. The evidence for genuine: (a) iter-034 delivered real lemmas using `leftAdjointCompIso` natively, a qualitatively different API surface than the old section-level `rw`/`simp`/`erw` approach; (b) the mathlib-analogist confirmed that the "X.Modules diamond" blocker architecturally does not form at the functor layer; (c) this is the first full closure attempt on the new approach — the prior STUCK corrective (route pivot) was only just executed. The evidence for rotation churn: same sorry count for 5 iters, same helper-accumulation cadence. Net read: the conjugate pivot is structurally distinct enough to warrant one prober round, but the 5-iter stall means it earns zero additional runway after this round.

*Is pairing with effort-breaker (structural sub-lemma chain) an adequate corrective, or should refactor happen now?*

The effort-breaker pairing is adequate for iter-035 specifically. The reason is sequencing: the effort-breaker provides exactly what was missing in iter-034 — not more helpers, but decomposed granularity on conj-1/conj-2 that lets the prover attack one step at a time. Doing a full comparison-object refactor before testing conj-1/conj-2 with this structure would waste the conjugate machinery already built. BUT the iter-036 fallback language in the current proposal ("structural REFACTOR of the comparison-object encoding, not user escalation") must be hardened from "if this fails" to "scheduled iter-036 task." The plan agent should not leave this as a conditional note — it should pre-write the refactor objective so iter-036 does not require another planning round to decide.

---

### Route 2 — QUOT (`Picard/QuotScheme.lean`, gap1 chain)

- **Sorry trajectory**: Protected stubs 4 → 4 across iter-033 to iter-034. The protected count is structurally frozen (protected signatures not meant to change until assembly). P1 keystone items transitioned from deferred → COMPLETE at iter-034 — this is real sub-sorry closure within the gap1 chain.
- **Helper accumulation**: +4 iter-033, +7 iter-034 — 11 axiom-clean helpers in 2 iters, with the P1 keystone (`isIso_fromTildeΓ_restrict_basicOpen` + `isIso_fromTildeΓ_presentationPullback`) COMPLETE. Helpers are paying off: each iter unlocks the next layer.
- **Recurring blockers**: none identified.
- **Avoidance patterns**: none. P1 keystone was deferred on iter-033 budget (legitimate), then targeted and closed iter-034.
- **Prover status pattern**: PARTIAL, PARTIAL — but with a meaningful sub-completion each iter (not static churn).
- **Throughput**: SLIPPING — strategy estimates 3–7 iters for this phase (entered ~iter-030). 5 iters elapsed. Inside the estimate window; no finding.
- **Verdict**: **UNCLEAR** (only 2 iters of data, below K=4 threshold). Signals are positive — sub-keystones closing, no recurring blockers, helpers paying off. Trending toward CONVERGING. Proceed with keystone D.

---

### Route 3 — GR (`Picard/GrassmannianCells.lean`, properness sub-phase)

- **Sorry trajectory**: isSeparated sub-phase: 0 → 0 at iter-034 (COMPLETE — lane closed). New properness sub-phase (`lem:gr_proper`): 0 iters of data.
- **Helper accumulation**: N/A for properness — it's a fresh dispatch.
- **Recurring blockers**: none for the new sub-phase.
- **Avoidance patterns**: none. The isSeparated phase converged correctly; opening the properness sub-phase is the natural next step.
- **Prover status pattern**: isSeparated CONVERGING (closed at iter-034); properness = no prover history.
- **Throughput**: ESTIMATE_FREE — STRATEGY.md says 1–2 iters for the sep phase (that phase is done). Properness is a fresh sub-phase; no elapsed count yet.
- **Verdict**: **UNCLEAR** (0 prover iters on the properness target; blueprint complete but no execution signal yet). Dispatching is correct. This is a fresh, well-scoped sub-phase with a concrete source reference (valuative criterion, Nitsure §1) and a completed blueprint chapter.

---

## PROGRESS.md dispatch sanity

- **File count**: 3 (cap: 10)
- **Ready but not dispatched**: FBC-B's remaining chain work is legitimately gated on FBC-A's affine sorry (not under-dispatch — gate is real). GF is gated on gap1 (not under-dispatch). The independent FBC-B ModuleCat-over-A eqLocus sub-lane was completed in iter-034 (no remaining independent work exists). No known ready files are absent from the proposal.
- **Over the cap**: no (3 of 10)
- **Under-dispatch finding**: no
- **Iter-over-iter trend**: iter-033 = 4 lanes; iter-034 = 4 lanes; iter-035 = 3 lanes. The reduction from 4 to 3 is explained by FBC-B's independent sub-lane completing, not by under-dispatch. Appropriate.
- **Verdict**: **OK** — file count 3 within cap 10, no ready files un-dispatched, no bloat pattern.

---

## Must-fix-this-iter

- **Route FBC-A**: STUCK — primary corrective: structural refactor (hardened commitment). The prescribed corrective (route pivot to conjugate) was taken at iter-034. The iter-035 proposal (one round + effort-breaker) is the last authorized attempt on the current encoding. **Must-fix action for the plan agent:** pre-write the iter-036 structural refactor of the comparison-object encoding as a scheduled objective in the iter-035 plan, not as a conditional note. If `_legs` closes this iter, the refactor task can be dropped; if it does not, iter-036 must start the refactor immediately without a planning-round detour.

- **Route FBC-A**: OVER_BUDGET — STRATEGY.md estimates 2–4 iters for the current phase (entered iter-034 on the conjugate sub-phase; route-level stall extends further). The route has been at sorry=4 for 5 consecutive iters. Revise the strategy estimate to reflect the actual conjugate sub-phase clock (1 elapsed of 2–4 estimated) while explicitly marking the route-level overrun.

---

## Informational

**QUOT (UNCLEAR → trending CONVERGING):** The sub-keystone pattern (iter-033: P1 deferred; iter-034: P1 COMPLETE + general form landed) is the textbook gap-closing cadence for this type of chain. Keystone D (`isLocalizedModule_basicOpen_descent`) is the correct next target. The only watch item: the blueprint-reviewer flagged the Stacks tag for D as unconfirmed ("01HA attribution uncorroborated") — the iter-035 plan correctly calls out source-verification before blueprint-quoting. No action needed from me; just confirm the prover consults the verified source tag, not the unverified "01HA."

**GR properness (UNCLEAR, fresh):** The isSeparated closure in iter-034 is the strongest convergence signal in the whole project this window. The properness sub-phase is a substantial new target (valuative criterion involves scheme-theoretic machinery beyond the ring heart). Monitor for scope creep — if the prover produces a large scaffold but no properness closure, treat iter-036 as the first real data point, not a second helper round.

**FBC-B (not dispatched, legitimately gated):** No avoidance pattern. The independent sub-lane completed; the remaining chain is genuinely blocked on FBC-A's affine sorry. When FBC-A's affine closes, FBC-B's chain assembly must be the IMMEDIATE next dispatch — do not let it drift to "next iter."

---

## Overall verdict

Three routes audited: FBC-A is **STUCK** (sorry 4×4 for ≥5 iters, recurring blockers in ≥4 iters, all PARTIAL statuses) with the prescribed route-pivot corrective already taken at iter-034. The conjugate sub-route is genuinely new and warrants one full closure attempt paired with the effort-breaker — this is the correct iter-035 structure. However, the iter-036 structural refactor must be pre-committed as a scheduled objective (not a contingency note) in the iter-035 plan. QUOT and GR-proper are both **UNCLEAR** (below K-iter threshold) with positive signals — dispatch is correct for both. Dispatch sanity is **OK** (3 of 10 cap, no ready files absent). The single must-fix is hardening the iter-036 refactor commitment for FBC-A so the plan agent cannot defer it for a second "one more round" cycle.
