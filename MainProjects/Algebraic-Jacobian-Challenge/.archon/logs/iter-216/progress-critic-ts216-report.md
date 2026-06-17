# Progress Critic Report

## Slug
ts216

## Iteration
216

## Routes audited

### Route: Lane TS — `Picard/TensorObjSubstrate.lean` (A.1.c.SubT, ⊗-group law)

- **Sorry trajectory**: 81 → 81 → 81 → 81 → 81 → 81 across iter-210 to iter-215. Six consecutive
  prover iters, zero net movement. File-local sorry count holds at 4 throughout. The 4 live `sorry`
  statements are at: L546 (`isLocallyInjective_whiskerLeft_of_W`, the load-bearing whiskering
  sorry), L1082 (`tensorObj_restrict_iso`, the linchpin), L1125 (`exists_tensorObj_inverse`,
  scaffold), L1164 (`addCommGroup_via_tensorObj`, scaffold).

- **Helper accumulation**: 13+ helpers added across 6 prover iters
  (iter-210: 2 restructure + misc; iter-211: 3–4; iter-212: 2; iter-213: 3; iter-214: 4;
  iter-215: 1 = `restrictScalarsRingIsoTensorEquiv`). Zero sorry-eliminations from the 81/4
  baseline across all six iters. Canonical STUCK signature: helpers accumulate, residual does not
  shrink.

- **Prover dispatch pattern**: 1 of 1 active file dispatched per prover iter across all six iters.
  All other lanes explicitly HELD pending TS closure. No under-dispatch concern per prior reports.

- **Recurring blockers**: The underlying wall — "associator sorry unreachable without absent Mathlib
  infrastructure" — has been present across six iters under six consecutive reframings:
  "associator gate" (210), "flat-whiskering bridge" (211), "sectionwise flatness false for
  invertibles" (212), "stalk port d.1/d.2" (213), "d.1-bridge + d.2 stalk-⊗" (214),
  "H1 presheaf pushforwardPushforwardAdj + H2 packaging" (215). Phrase rotation is not resolution;
  the load-bearing sorry at L1082 has been open throughout.

- **Avoidance patterns**: None in the strict sense. Dispatch has been continuous; route has not
  been reclassified. However, the pre-committed gate mechanism has been soft-landed twice:
  - ts214 gate: "d.1 + d.2 both axiom-clean THIS iter, else escalate." Result: d.1-core only
    (no d.2 attempt). Planner soft-landed to "d.2 feasibility next iter."
  - ts215 gate: "FINAL, non-negotiable — if PARTIAL again with sorry open, user escalation
    mandatory iter-216, no further infrastructure round." Result: PARTIAL again, sorry open.
    This gate has now been missed a second consecutive time.

  **Two consecutive pre-committed gates missed is itself an avoidance pattern**: the planner has
  been issuing and then overriding its own escalation triggers, which is functionally equivalent to
  deferral. The gate mechanism exists precisely to prevent this.

- **Prover status pattern**: PARTIAL × 6 consecutive prover iters (210–215).

- **Throughput**:
  - STRATEGY.md `A.1.c.SubT` row: `Iters left ≈ 2–4` (from directive).
  - Phase entered: iter-209. Elapsed: 6–7 iters. Category: **OVER_BUDGET** (elapsed > 2× upper
    estimate). The "route-(e)/H1+H2" sub-framing does not reset the clock on cumulative substrate
    cost.

- **Verdict**: **STUCK**

  Three independent STUCK/CHURNING rules trigger simultaneously:

  1. *Helpers added without any sorry-elimination across K iters*: 13+ helpers, 0 sorries closed
     across 6 iters. Definitively met.

  2. *PARTIAL prover status ≥3 of last K iters*: PARTIAL × 6. CHURNING rule fires; STUCK subsumes
     per "pick the worse verdict."

  3. *Pre-committed gate missed for the second consecutive iter*: the ts215 gate was issued as
     "FINAL, non-negotiable." Missing it twice is equivalent to persistent deferral language
     ("escalate next iter") appearing across ≥2 consecutive iter signals — STUCK by inaction.

- **Addressing the directive's framing question directly**:

  > "Is dispatching a bounded mathlib-build on the single named ingredient H1 a legitimate
  > convergence step, or is it the same '+1 helper, residual unchanged' churn pattern under
  > a new label?"

  It is the same churn pattern, for two independent reasons:

  **Reason 1 — The sorry count cannot drop from H1 alone.** Even if H1 compiles axiom-clean,
  the sorry at L1082 (`tensorObj_restrict_iso`) requires H1 PLUS the ~20 LOC H2 packaging PLUS
  the associator re-proof for locally-trivial inputs PLUS elimination of the whiskering sorry at
  L546. This is 3–4 sequential steps with no sorry dropping until the full chain closes. Prior
  iters framed each step as "the last one" and then discovered the next layer.

  **Reason 2 — H1 itself decomposes into sub-absent infrastructure.** The file's own code comment
  at L1050–1053 states explicitly that the presheaf-level adjunction requires "presheaf-level
  `pushforwardNatTrans` and `pushforwardCongr` (only the SHEAF versions exist)." The planner's
  directive says H1 is "~100–150 LOC" and a direct Mathlib port, but the presheaf-level
  `pushforwardNatTrans` and `pushforwardCongr` are themselves absent from Mathlib. H1 is not a
  single-lemma port; it is a sub-chain. The "single named bounded ingredient" framing is optimistic
  in the same way that iter-214's "concrete d.1-bridge route with specific Mathlib anchors" was
  optimistic.

  **What is genuinely different from prior iters**: H2 (`restrictScalarsRingIsoTensorEquiv`) is
  axiom-clean and landed. This is material progress — one of the four absent ingredients is
  genuinely closed. The escalation to the user should communicate this clearly: the route has
  narrowed to H1 (presheaf adjunction, sub-dependencies unknown depth) + packaging.

- **Primary corrective**: **User escalation** — mandatory per pre-committed gate.

  The gate was set precisely because the "+1 helper, one more ingredient" pattern was recognized
  as potentially unbounded. Honoring the gate is the only way to stop the recursion. Whether H1
  is truly close or has hidden sub-dependencies can only be determined by actually building it —
  and the user, not the planner, should authorize that attempt given the gate has now been missed
  twice.

  **Escalation framing for the planner's TO_USER.md entry**: This should NOT be framed as "we're
  lost." The correct framing is: "Lane TS has made genuine progress — H2 is axiom-clean, 13+
  helpers are in place, and the residual is now a single presheaf-level adjunction (H1) whose
  sheaf analogue exists in Mathlib. However, two consecutive gate deadlines have been missed and
  the sorry count has not moved in 6 iters. Before authorizing another infrastructure iter, we
  need your decision: (a) authorize one more bounded iter targeting H1 explicitly, with the
  understanding that H1 itself may have presheaf sub-dependencies; or (b) pivot to a structurally
  different associator proof strategy (locally-trivial first, avoiding the restrict-iso altogether);
  or (c) hold the substrate indefinitely and close other blueprint chapters first."

- **Secondary correctives** (if user authorizes one more iter rather than pivot):
  1. Require the prover to first verify (via LSP or `lean_run_code`) that presheaf-level
     `pushforwardNatTrans` and `pushforwardCongr` either exist in Mathlib or can be trivially
     derived — if they cannot, H1 is a multi-iter chain and the sorry count will not drop this
     iter either. Make that determination the FIRST act of the iter, not the last.
  2. Hard gate: if the presheaf-level sub-dependencies of H1 are absent and require their own
     builds, abort and return INCOMPLETE immediately; do not add more helpers.

---

## PROGRESS.md dispatch sanity

- **File count**: 1 (cap: 10)
- **Ready but not dispatched**: All other lanes explicitly HELD pending TS closure — no
  under-dispatch issue identified by prior critics; this continues.
- **Over the cap**: No.
- **Under-dispatch finding**: No — the HELD policy is documented with re-engagement gates.
- **Iter-over-iter trend**: Consistently 1 file dispatched; no under-dispatch issue on the
  dispatch metric.
- **Verdict**: **OK** — file count 1 within cap 10, no under-dispatch on held lanes.

  *However*: the "hold all other lanes pending TS closure" policy has now consumed 6+ iters. If
  the user authorizes escalation and a pivot, the planner should immediately review which held
  lanes can be un-gated independently of TS closure. This is not a dispatch-sanity finding for
  iter-216, but it will become one if the TS gate remains open into iter-217.

---

## Must-fix-this-iter

- **Lane TS**: **STUCK** — primary corrective: **User escalation** (mandatory per pre-committed
  ts215 gate, now missed twice). Why: 13+ helpers, 0 sorry-eliminations across 6 consecutive
  prover iters; PARTIAL × 6; two consecutive gate deadlines missed; "one more ingredient"
  framing has been applied every iter since iter-211 with H1 now containing its own presheaf
  sub-dependencies (pushforwardNatTrans, pushforwardCongr both Mathlib-absent at presheaf level).

- **Lane TS**: **OVER_BUDGET** — STRATEGY.md estimates 2–4 iters, elapsed 6–7. Revise the
  estimate or escalate.

- **Lane TS (gate mechanism)**: Two consecutive pre-committed escalation gates missed — this
  constitutes avoidance by soft-landing. The planner must not issue a third "final gate" for
  iter-217 without acting on the first two. The gate mechanism has lost credibility; only user
  escalation resets it.

---

## Overall verdict

One route audited: **STUCK**, verdict unchanged from ts214 and ts215 with one additional iter
of confirming evidence. The sorry count is flat at 81/4 across 6 consecutive prover iters; 13+
helpers have been added with zero eliminations; the prover status has been PARTIAL for every
iter in the window; and the pre-committed "FINAL, non-negotiable" escalation gate from ts215
has been missed for the second consecutive time.

The planner's proposed H1 ("presheaf pushforwardPushforwardAdj, ~100–150 LOC Mathlib port") is
the same "+1 helper before the sorry closes" pattern under a new label: H1 itself depends on
presheaf-level `pushforwardNatTrans` and `pushforwardCongr` that are absent from Mathlib, the
file's own code comment confirms this, and the sorry count cannot drop from H1 alone even if
it compiles — the full chain (H1 → tensorObj_restrict_iso packaging → associator re-proof →
whiskering sorry dead code) requires at minimum 3 sequential steps.

**Mandatory action**: the planner must escalate to the user (TO_USER.md) in iter-216, presenting
the three-option menu (authorize one more iter / pivot strategy / un-gate held lanes and hold TS
indefinitely). The user's decision determines the iter-217 plan. A third unilateral "one more
infrastructure iter" without user authorization would override the pre-committed gate for a
third time and is not permitted by these instructions.
