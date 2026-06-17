# Progress Critic Report

## Slug
ts215

## Iteration
215

## Routes audited

### Route: Lane TS — `Picard/TensorObjSubstrate.lean` (A.1.c.SubT, ⊗-group law)

- **Sorry trajectory**: 81 → 81 → 81 → 81 → 81 across iter-210 to iter-214. Five consecutive prover
  iters, zero net movement. The TS-file sorry count holds at 4 throughout the same window.

- **Helper accumulation**: 9+ helpers added across the 5-iter window (restructure pair iter-210;
  +1 iter-211; +2 iter-212; +2 iter-213; +4 iter-214). Zero sorry-eliminations from the 81 baseline
  across all five iters. This is the canonical STUCK signature: the helper count grows, the residual
  does not shrink.

- **Prover dispatch pattern**: 1 of 1 active file dispatched per prover iter. All other lanes are
  explicitly HELD pending TS closure; no under-dispatch concern applies.

- **Recurring blockers**: The underlying block — "associator sorry not closeable without absent
  Mathlib infrastructure" — has been present in every iter since 210, under five consecutive
  reframings: "associator gate" (210), "flat-whiskering bridge" (211), "sectionwise flatness false
  for invertibles" (212), "stalk port d.1/d.2" (213), "d.1-bridge + d.2 stalk-⊗ commutation"
  (214). Each reframing reflects a genuine route pivot, but the same wall is reached every time.
  Phrase rotation is not resolution.

- **Avoidance patterns**: None in the strict sense. Route (e) pivot at iter-214 was purposive, not
  a deflection. Dispatch has been continuous across all prover iters.

- **Prover status pattern**: PARTIAL × 5 consecutive prover iters (210–214).

- **Throughput**:
  - Route (e) specifically: ON SCHEDULE — 1 iter elapsed against an estimate of ~3–6; within range.
  - Substrate as a whole (routes c/d/e on this file since iter-209): 6 iters elapsed. The ts214
    report already flagged OVER_BUDGET against the prior "~2–5 iters left" estimate. The route-(e)
    framing resets the clock, but the cumulative cost must be weighed in the escalation decision.

- **Verdict**: **STUCK**

  Two independent STUCK rules trigger simultaneously:

  1. *Helpers added without any sorry-elimination across K iters*: definitively met — 9+ helpers
     added in 5 prover iters; 0 sorries eliminated. The count is unchanged from the ts214 STUCK
     verdict, with one additional iter of evidence.

  2. *PARTIAL prover status ≥3 of last K iters*: PARTIAL × 5 independently triggers CHURNING, which
     STUCK subsumes per the "pick the worse verdict" rule.

  **Mitigating factors — do not change the verdict, but bear on the corrective choice.**

  - Route (e) is genuinely fresh (pivoted at iter-214 — only 1 iter old). The CHURNING rule's
    "no structural change in approach" clause is therefore not cleanly applicable to the sub-window.
    But the STUCK rule on helper accumulation is topology-agnostic; it fires regardless.

  - The d.1-core landing (4 axiom-clean decls: `stalkLinearMap`, `stalkLinearMap_germ`,
    `stalkLinearMap_bijective_of_isIso`, `stalkLinearEquivOfIsIso`) is the first non-bridge,
    non-wrapper progress since route (e) began. The lean-auditor confirmed all four are
    axiom-clean with no `sorry`, no `axiom`, no `Classical.choice`. This IS a material
    de-risk: the infra is no longer "entirely absent" — the R_x-linear stalk map layer is built.
    Iter-211/212/213 helpers were navigating around the gap; iter-214 bricks are the gap's interior.

  - The directive correctly identifies the STRATEGY.md reversal trigger: "no route exists." A
    concrete d.1-bridge route DOES currently exist, with specific Mathlib anchors
    (`WEqualsLocallyBijective`, `app_injective_iff_stalkFunctor_map_injective`,
    `locally_surjective_iff_surjective_on_stalks`; ~80–150 LOC; tractable). The PROGRESS.md's own
    reversal condition ("all four associator realizations exhausted") is therefore NOT yet met.

  - The ts214 gate ("if d.1+d.2 both compile axiom-clean THIS iter, proceed; else escalate") was
    NOT met — d.2 was not attempted. However, strictly reading that gate: it required d.1 AND d.2.
    The d.1-core is not the same as d.1 (which also requires d.1-bridge). d.2 is zero-attempted.
    The gate was missed on two counts.

- **Primary corrective**: **Address deferred infrastructure** — dispatch the proposed
  d.1-bridge + d.2-feasibility iter as planned. Rationale:

  (a) The STRATEGY.md reversal trigger is "no route exists"; a concrete, anchored route does exist
      for d.1-bridge. Escalating to the user when a tractable route is identified and partially
      built would be premature.

  (b) The d.1-core having landed axiom-clean makes iter-215 qualitatively different from iter-212
      or iter-213: the prover is not assembling bridges over absent infrastructure; it is assembling
      the next layer on infrastructure that is now present. This is the Mathlib-gradient strategy
      functioning as intended.

  (c) d.2 has never been attempted. A feasibility attempt on d.2 (even if partial) will finally
      size the largest, least-certain piece. That information is needed for the escalation decision
      regardless of outcome.

  **This corrective comes with a NON-NEGOTIABLE, FINAL one-iter gate:**

  `isLocallyInjective_whiskerLeft_of_W` must be closed axiom-clean — or a concrete, axiom-clean
  specialisation to `Opens X` must compile — within iter-215. The sorry count must decrease.
  Partial progress (d.1-bridge compiles but d.2 still absent, sorry still open) is NOT sufficient
  to justify a further infrastructure iter. The ts214 gate was soft-landed once (d.1-core instead
  of d.1+d.2); repeating the soft-land in iter-215 would convert STUCK into avoidance-CHURNING.

  If the iter-215 prover returns PARTIAL again with the sorry open, the planner must escalate to
  the user in iter-216 without a further infrastructure round, regardless of how much partial
  progress was made on d.2.

---

## PROGRESS.md dispatch sanity

Verdict: **OK** — 1 file (cap: 10), all other lanes explicitly HELD with documented re-engagement
gates pending TS closure; no ready-but-unblocked files are absent from the proposal; not over cap.

---

## Must-fix-this-iter

- **Lane TS**: **STUCK** — primary corrective: **Address deferred infrastructure** (dispatch
  d.1-bridge + d.2-feasibility as proposed). Why: 9+ helpers across 5 iters, 0 sorry-eliminations,
  PARTIAL × 5; "associator not closeable" wall hit under five consecutive reframings. The
  STRATEGY.md reversal trigger ("no route exists") is not yet met; the d.1-bridge route has
  concrete Mathlib anchors. Dispatch this iter. **FINAL gate**: if `isLocallyInjective_whiskerLeft_of_W`
  is not closed (or axiom-clean specialised to `Opens X`) after iter-215, user escalation is
  mandatory in iter-216 — no planner-side restructure permitted. The ts214 gate was soft-landed
  once; a second soft-landing is avoidance.

---

## Overall verdict

One route audited; **STUCK** verdict. The sorry count has been flat at 81 across 5 consecutive
prover iters while 9+ helpers were added and the prover status remained PARTIAL throughout. The
underlying wall — "associator unreachable without absent Mathlib infrastructure" — has been reached
under five different framings since iter-210. The ts214 gate (d.1+d.2 both axiom-clean in one iter)
was not met: d.1-core landed clean but d.2 was not attempted.

Despite the STUCK verdict, the proposed d.1-bridge + d.2-feasibility iter is the correct action —
not user escalation — because the STRATEGY.md's own reversal trigger ("no route exists") is not
satisfied: a concrete, anchored d.1-bridge route exists, and the d.1-core infra is now present.
This distinguishes iter-215 from iter-212 and iter-213, where the prover was bridging over a
completely absent ingredient. The planner should dispatch as proposed.

The dispatch is OK (1 file, all held lanes gated, no under-dispatch issue). The phase estimate for
route (e) is ON SCHEDULE (1 iter elapsed, 3–6 estimated), though the cumulative substrate cost
(6 iters across routes c/d/e) should be acknowledged when revising STRATEGY.md.

**The hard constraint**: this is the last infrastructure iter. If the prover returns PARTIAL again
with the sorry open, user escalation is non-negotiable in iter-216. The planner must not commission
a third "one more bridge" round. The ts214 gate was soft-landed once; landing it again would
confirm avoidance-CHURNING and override the STUCK corrective.
