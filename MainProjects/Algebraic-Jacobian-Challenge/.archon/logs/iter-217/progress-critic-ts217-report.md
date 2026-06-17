# Progress Critic Report

## Slug
ts217

## Iteration
217

## Routes audited

### Route: Lane TS — `Picard/TensorObjSubstrate.lean`

- **Sorry trajectory**: 81 → 81 → 81 → 81 → 81 → 81 (iters 211–216); entering iter-217 still at 81.
  File-local sorry count: 4 → 4 → 4 → 4 → 4 → 4, unchanged for 6 consecutive prover iters. The
  4 live sorries are at L546 (`isLocallyInjective_whiskerLeft_of_W`), L1082
  (`tensorObj_restrict_iso`), and the two scaffold sorries (`exists_tensorObj_inverse`,
  `addCommGroup_via_tensorObj`).

- **Helper accumulation**: 13+ axiom-clean declarations added across iters 211–216; zero sorry
  eliminations from the 81/4 baseline across all six iters. Pattern: each iter adds genuine
  infrastructure, names one remaining ingredient, delivers PARTIAL, then the next iter reframes the
  same wall as a different single ingredient.

- **Prover dispatch pattern**: 1 of 1 active file dispatched per iter across all six iters. All
  other lanes explicitly HELD pending TS closure.

- **Recurring blockers**: The load-bearing wall — "sorry at L1082 (`tensorObj_restrict_iso`)
  unreachable without an absent Mathlib ingredient" — has been present across the 6-iter window
  under six consecutive reframings: associator gate (211), flat-whiskering bridge (212),
  sectionwise flatness false for invertibles (213), stalk port d.1/d.2 (214), d.1-bridge + d.2
  stalk-⊗ (215), H1 presheaf pushforwardPushforwardAdj + H2 packaging (216). Entering iter-217 the
  framing is again "H1 is the sole remaining linchpin." Phrase rotation without sorry-elimination
  satisfies the recurring-blocker rule.

- **Avoidance patterns**:
  1. **Pre-committed gate missed twice**: ts215 set a "FINAL, non-negotiable" escalation gate;
     iter-216 missed it. The iter-216 progress-critic issued a mandatory user-escalation order.
     The directive indicates "A USER escalation FYI is live," which is ambiguous: it may mean the
     user was notified informally rather than presented the three-option decision menu the ts216
     critic specified. A FYI-level notification is not the same as a decision-gate response.
  2. **Whiskering-deletion recommendation not actioned**: The iter-216 mathlib-analogist explicitly
     recommended deleting the vestigial whiskering apparatus (L546's sorry disappears — not filled
     but deleted — reducing the file-local sorry count from 4 to 3 and the global count from 81 to
     80). This is the ONLY concrete action from iter-216's subagents that could produce the first
     sorry elimination in 7 iters, and it was not implemented in iter-216. Failing to act on a
     specific, sorry-reducing analogist recommendation while instead proposing another infrastructure
     iter is an avoidance pattern.

- **Prover status pattern**: PARTIAL × 6 consecutive prover iters (211–216).

- **Throughput**: STRATEGY.md `Iters left ≈ 2–5` (per directive); phase entered iter-209/210;
  elapsed ≈ 7–8 iters. **OVER_BUDGET** (elapsed > 2× upper estimate). The sub-framing changes
  (route-(e), H1+H2 split, `mathlib-build` mode) do not reset the clock.

- **Verdict**: **STUCK**

  Three independent STUCK rules trigger simultaneously:
  1. *Helpers added without any sorry-elimination across K iters*: 13+ helpers, 0 sorries closed
     across 6 iters. Definitively met.
  2. *PARTIAL prover status ≥3 of last K iters*: PARTIAL × 6. CHURNING rule fires; STUCK subsumes
     per "pick the worse verdict."
  3. *Recurring blocker phrase across ≥3 iters*: "one more absent ingredient separates the linchpin
     sorry from closing" has appeared in every prover report across the 6-iter window. Fully met.

- **Addressing the directive's core question directly**:

  > "Is dispatching a `mathlib-build` round on the single named, templated ingredient H1 materially
  > different from the prior 6 `prove`-mode helper rounds, or is it the same churn under a new name?"

  **It is functionally the same churn, for two independent reasons, with one partial exception.**

  **Reason 1 — The sorry count cannot drop from H1 alone.** The sorry at L1082
  (`tensorObj_restrict_iso`) requires H1 AND the H2 presheaf-level lift (applying
  `restrictScalarsMonoidalOfRingEquiv` sectionwise over the natural iso `α`, then packaging as a
  `NatIso`-level strong monoidal comparison) AND the final construction connecting the adjunction iso
  to the closing iso chain (`H1.symm ≪≫ H2 ≪≫ defeq`). This is a minimum 3-step sequential chain;
  the sorry cannot close in a single iter even in the most optimistic scenario. Every iter since 211
  has named a single ingredient as the final one, and each time the sorry was not closed because the
  named ingredient was itself only one step in the chain.

  **Reason 2 — H1 itself decomposes into confirmed-absent Mathlib sub-infrastructure.** The file's
  own code comment (L1134–1140) states: "That analogue needs presheaf-level `pushforwardNatTrans`
  and `pushforwardCongr` (only the SHEAF versions exist)." The iter-216 progress-critic cited this
  directly. The "presheaf-level `pushforwardPushforwardAdj` with sheaf-level template" framing
  implicitly assumes the presheaf sub-lemmas are easy derivations from the sheaf versions; the code
  comment says they are absent. H1 is therefore not a single templated ingredient but itself a
  sub-chain. This is the same optimism that applied to d.1-bridge in iter-214, to the
  free-cover route in iter-216, and to "50 LOC" estimates for every prior named ingredient.

  **Partial exception that could break the churn (currently un-actioned)**: The iter-216
  mathlib-analogist confirmed that the L546 sorry (`isLocallyInjective_whiskerLeft_of_W`) is
  vestigial dead code — the whiskering apparatus was re-routed and the entire section can be
  DELETED, reducing the file-local sorry count from 4 to 3 and the global count from 81 to 80.
  This would be the FIRST sorry elimination in 7 iters and is achievable without any new Mathlib
  infrastructure. The `mathlib-build` iter-217 would be materially different only if it prioritises
  this deletion FIRST (observable sorry reduction) rather than adding more presheaf infrastructure
  around the still-open L1082.

- **Primary corrective**: **User escalation** — mandatory per the pre-committed ts215 gate, now
  missed for two consecutive iters.

  The iter-216 progress-critic issued a three-option decision menu for the user. The directive says
  "a USER escalation FYI is live," suggesting informal notification rather than a structured
  decision. The planner must obtain an explicit user decision — not a FYI acknowledgement — before
  authorizing a third unilateral infrastructure iter. If the user authorizes a bounded H1 iter, the
  prover must first delete the vestigial whiskering apparatus (confirming a sorry reduction before
  any new helpers are added) and must treat absence of presheaf `pushforwardNatTrans` /
  `pushforwardCongr` as an immediate INCOMPLETE gate, not a new sub-build target.

- **Secondary correctives** (if user authorizes one more bounded iter):
  1. Delete the vestigial whiskering apparatus (L375–667: `FlatWhisker` + `WhiskerOfW` sections
     except `isIso_sheafification_map_of_W`, plus `StalkLinearMap` section L691–807) as the
     FIRST act — this is the sorry-reduction the analogist confirmed. The sorry count must move
     before any new helpers are added.
  2. Verify via LSP or `lean_run_code` that presheaf-level `pushforwardNatTrans` and
     `pushforwardCongr` either exist in Mathlib or are trivially derivable from the sheaf versions.
     If they require their own construction, return INCOMPLETE immediately — do not add them as
     further infrastructure.
  3. Hard gate: if the sorry at L1082 does not close (or is not on a clear single-step closing path
     with all remaining pieces in hand), declare INCOMPLETE and escalate with the exact blocking
     statement.

---

## PROGRESS.md dispatch sanity

Verdict: OK — file count 1 within cap 10, no under-dispatch finding on held lanes.

*Persistent concern, now entering must-fix territory*: The "hold all lanes pending TS closure"
policy has consumed 7+ iters with no sorry movement. If TS is not resolved in iter-217, the planner
must un-gate at least one held lane independently; continued exclusive focus on TS is itself a
resource-allocation failure at this elapsed count.

---

## Must-fix-this-iter

- **Lane TS**: **STUCK** — primary corrective: **User escalation** (mandatory; pre-committed gate
  missed twice; informal FYI does not constitute the required decision-gate response). Why: 13+
  helpers added, 0 sorry-eliminations across 6 consecutive prover iters; PARTIAL × 6; two
  consecutive "FINAL" escalation gates soft-landed; `mathlib-build` on H1 cannot close L1082 alone
  (3-step chain minimum) and H1 has confirmed presheaf sub-dependencies.

- **Lane TS**: **OVER_BUDGET** — STRATEGY.md estimates 2–5 iters, elapsed 7–8. Revise the estimate
  or escalate; a third unrevised "Iters left ≈ 2–5" entry is not credible.

- **Lane TS (whiskering-deletion deferred)**: The iter-216 analogist's recommendation to delete the
  vestigial whiskering apparatus (producing the first sorry elimination in 7 iters) was not
  implemented. If a third infrastructure iter proceeds without this deletion, it is avoidance by
  omission — adding helpers while skipping the one confirmed-actionable sorry reduction.

- **Dispatch (held-lane policy)**: 7 consecutive iters with all non-TS lanes held. Must-fix:
  evaluate each held lane independently of TS closure; un-gate any lane with a complete blueprint
  chapter and open sorries that does not genuinely depend on the TS substrate.

---

## Overall verdict

One route audited: **STUCK** — verdict unchanged from ts214, ts215, and ts216, with 7 iters of
confirming evidence rather than 6. The sorry count is flat at 81/4 across 6 consecutive prover
iters (7th iter beginning with the same count); 13+ helpers have been added with zero
eliminations; the prover status has been PARTIAL for every iter in the window; and two consecutive
pre-committed "FINAL" escalation gates have been soft-landed.

The proposed `mathlib-build` mode on H1 is the same "+1 ingredient before the sorry closes"
pattern under a new label: H1 has confirmed Mathlib-absent presheaf sub-dependencies (H1 is not a
single templated port), the sorry at L1082 cannot close from H1 alone (minimum 3 sequential steps
remain), and the one concrete sorry-reducing action the iter-216 analogist recommended (delete the
vestigial whiskering apparatus, producing 81→80) has not been implemented.

The planner must obtain an explicit user decision (not a FYI) before authorizing iter-217's prover
on this route. If authorized, the whiskering-section deletion must be the first act — it is the
only confirmed-sorry-reducing action in 7 iters, and its absence in iter-217 would make the iter
indistinguishable from its predecessors.
