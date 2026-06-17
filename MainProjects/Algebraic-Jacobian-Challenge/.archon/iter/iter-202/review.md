# Iter-202 (Archon canonical) — review

## Outcome at a glance

- **The "first iter to break the iters-199/200/201 net-0 substrate-only
  streak with a genuine top-level theorem closure: Lane AB Path B closed
  `auslander_buchsbaum_formula_succ_pd` axiom-clean (Nat-induction
  restructuring + 4 new helpers + base-case matrix-collapse consuming the
  iter-201 substrate), making `RingTheory.auslander_buchsbaum_formula` fully
  axiom-clean and OBVIATING Stacks 00MF; the 3 `private` removals landed
  (`_succ_pd`, and the `RingTheory.CohenMacaulay`-namespaced
  `isDomain_of_regularLocal` + `regularLocal_quotient_isRegularLocal_of_notMemSq`)
  for iter-203 Lane COE Step A1 cross-file consumption + Lane WD-A4a
  Sub-build 3 HARD BAR MET (both `functionFieldIso_compat` morphism-level
  naturality AND `order_eq_order_restrict` order-on-curve naturality
  axiom-clean) + Lane COE Step B HARD BAR exceeded (3 of 4 scheme-to-algebra
  bridges axiom-clean — `exists_submersivePresentation_…`,
  `isLocalization_atPrime_stalk_of_affineOpen`, `gammaSpecField_ringEquiv` +
  helper `open_eq_top_of_subsingleton`; B.d regular-stalk close NOT added,
  genuinely gated on the fenced Step A1 + open Stacks 00OE Krull-dim formula,
  no-sorry invariant respected) + Lane TS scaffold landed GREEN (new file
  `Picard/TensorObjSubstrate.lean` with 4 blueprint-pinned typed-sorry stubs +
  supporting helpers + import in `AlgebraicJacobian.lean`,
  `addCommGroup_via_tensorObj` deliberately a `def` not `instance` to avoid a
  diamond) + iter-202 review-phase 5 subagents dispatched (lean-auditor
  iter202 + 4 lean-vs-blueprint-checker {ab,coe,wd,ts}-iter202)" iter.**

- **`lake build AlgebraicJacobian` GREEN** — per `logs/iter-202/meta.json`
  `prover.status: done`, `planValidate.objectives: 4`. **4/4 prover lanes
  returned `done` clean** (no API 529 errors). **22nd consecutive zero-axiom
  build streak** (0 → 0 project axioms). Every new declaration + the now-closed
  AB formula `lean_verify` to `{propext, Classical.choice, Quot.sound}`.

- **Sorry trajectory**: iter-201 baseline **78** → iter-202 exiting **83**.
  **Net delta +5.** Breakdown: Lane AB **−1** (`_succ_pd` body closed); Lane WD
  0 (2 new decls fully proven; pre-existing file sorries untouched); Lane COE 0
  (4 axiom-clean bridges, 3 pre-existing sorries unchanged); Lane TS **+6**
  (new scaffold file, typed-sorry stubs **by design**). **The +5 is entirely
  the intentional TS scaffold; the substantive proof movement is the AB
  closure.** Per-file: AB 1→0, WD 3→3, COE 3→3, TS new file 0→6.

  This is the **best meaningful outcome band** for proof movement — the iter
  delivered the realistic-band target (AB body closure) that 3 prior iters had
  been building substrate toward, plus two further HARD BARs. The raw +5 sorry
  delta is a scaffold artifact and should NOT be read as regression; the
  iter-203 planner should treat the TS stubs as the body-fill work-list, not as
  new debt.

- **HARD BAR landings**: **3 of 4 lanes MET** (AB, WD, COE-Step-B), the 4th
  (TS) met its scaffold HARD BAR.
  - Lane AB-Path-B-Close: **MET** — body axiom-clean + 3 private removals +
    main formula axiom-clean. The 16+-iter gap is closed.
  - Lane WD-A4a Sub-build 3: **MET** — both steps axiom-clean (the iter-201
    plan agent had reclassified the HARD BAR to require BOTH steps; satisfied).
  - Lane COE-Step-B-Bridges: **MET & exceeded** — 3 of 4 bridges (HARD BAR was
    ≥2). B.d deferred with sound, documented gating (not a search failure).
  - Lane TS-Scaffold: **MET** — file GREEN with typed sorries + import.

- **Plan trajectory** entering iter-202 (per iter-202 plan): best 78 → ~72-75,
  realistic 78 → ~76-77, worst 78 → ~78. The proof-movement reality is the
  **best-to-realistic band** (AB body closed — a −1 closure plus the main
  theorem now complete; WD HARD BAR met), but the *sorry count* reads +5
  because the planner's projection bands did not net out the TS scaffold's new
  stubs (the plan's own "Informational" note acknowledged "the Lane TS scaffold
  adding ~4 typed-sorry stubs is not a sorry-elimination signal and should not
  be counted"). Reconciling: proof-progress = best-band; headline count = +5
  scaffold artifact.

- **Conditional pre-commitments — both cleared**:
  - Progress-critic's "0-net-movement across all 3 routes → user escalation"
    pre-commitment **did NOT fire** (AB closed a top-level theorem; WD met HARD
    BAR). No escalation.
  - The AB-specific "if `_succ_pd` returns PARTIAL → mandatory user escalation
    before iter-203 AB dispatch" trigger **did NOT fire** — `_succ_pd` closed.
    Discharged. (No TO_USER banner filed.)

- **Reviewer-phase subagents** — 5 dispatched (lean-auditor iter202 + 4
  lean-vs-blueprint-checker per prover-touched file). Findings landed into
  `recommendations.md`; see `## Subagent dispatches` below.

- **`sync_leanok` iter=202**: 11 added / 0 removed / 3 chapters touched
  (`Albanese_AuslanderBuchsbaum`, `Picard_TensorObjSubstrate`,
  `RiemannRoch_WeilDivisor`). The 11 additions are the legitimate deterministic
  verdict (AB formula + `_succ_pd` + helpers closed; WD new decls; TS stubs at
  statement level). No headline-laundering concern — `sync_leanok-state.json`
  `iter` == 202, and the AB/WD closures are first-hand-verified axiom-clean.

- **Blueprint doctor**: no structural findings (all chapters `\input`'d, all
  `\ref`/`\uses` resolve, no new `axiom`). See `logs/iter-202/blueprint-doctor.md`.

## Manual blueprint markers

- `Albanese_AuslanderBuchsbaum.tex`, `lem:auslander_buchsbaum_formula_succ_pd`:
  removed the stale iter-199/200/201 `% NOTE` chain requesting `private`
  removal — now RESOLVED (private dropped, body closed). Replaced with a
  one-line iter-202 RESOLVED note. (`\leanok` left to sync_leanok.)

## Held lanes (unchanged rationale)

- Lane RPF — HELD; unblocks iter-204+ after TensorObjSubstrate body fill
  (the iter-202 TS scaffold is the first link).
- Lane FGA — HELD; iter-205+ post Lane RPF body fill.
- Lane T32 — HELD; iter-203+ post Lane COE Stage 6.B closure.
- Lane RCI — HELD; Route C PAUSED per USER 2026-05-28.

## Subagent dispatches

Dispatched 5 in parallel (semaphore-capped, so they ran a few at a time):

- `lean-auditor iter202` — **0 must-fix**; AB closure verified genuinely sound
  (no accidental sorry, no circular dep, helpers axiom-clean). Major: ~10 stale
  "typed sorry" comments in `AuslanderBuchsbaum.lean` (closed bodies described
  as open) + the `monoidalCategory := sorry` **instance** contamination risk in
  `TensorObjSubstrate.lean`.
- `lean-vs-blueprint-checker ab-iter202` — 0 must-fix; closure faithful; 6 major
  blueprint-staleness (gap-(2)/00MF OBVIATED, stale iter-budget, "currently
  private" + namespace, 2 missing pins).
- `lean-vs-blueprint-checker coe-iter202` — **1 must-fix**: the iter-203 Step A1
  recipe used un-namespaced helper names (`RingTheory.isDomain_of_regularLocal`
  etc.) that won't resolve. **Resolved in this review** — all 6 occurrences
  corrected to `RingTheory.CohenMacaulay.*` + a `% NOTE` flagging stale prose.
  Remaining major: no §3.B blueprint section / 2 public bridges unpinned.
- `lean-vs-blueprint-checker wd-iter202` — 0 must-fix; both new decls faithful;
  2 major missing `\lean{...}` pins.
- `lean-vs-blueprint-checker ts-iter202` — 0 must-fix; 3/4 stubs faithful; 1
  major (`MonoidalCategory` vs blueprint's `SymmetricMonoidalCategory`).

**Net: no live must-fix remains** (the single must-fix was resolved in-review).
All other findings are blueprint-staleness / pin-additions for the iter-203 plan
agent + the HIGH-2 soundness note before TS body fill. Findings actioned at the
top of `recommendations.md`; reports under `task_results/`, archived to
`logs/iter-202/`.

## Notable forward items (detail in recommendations.md)

1. **iter-203 Lane COE Step A1 is now unblocked** — the two AB helpers it needs
   are public. **Critical**: they are in the `RingTheory.CohenMacaulay`
   namespace, NOT bare `RingTheory.` (the plan prose and PROGRESS used the wrong
   un-namespaced names). Use fully-qualified names.
2. **WD blueprint gap**: `functionFieldIso_compat` and `order_eq_order_restrict`
   are axiom-clean but the chapter has only prose, no `\lean{...}`-pinned blocks
   → sync_leanok cannot mark them. Plan agent should add the blocks (informal
   prose + `\lean{...}` is plan-agent territory).
3. **AB chapter prose** still describes Stacks 00MF as a needed gap in
   `\subsec:succ_pd_gap_sequence` / gap tables — now OBVIATED. Plan agent should
   refresh to "all gaps CLOSED iter-202".
4. **TS body fill** is the iter-203+ work-list (`tensorObj` via
   `PresheafOfModules.Monoidal.tensorObj` + sheafification, `monoidalCategory`,
   `addCommGroup_via_tensorObj`); `lem:pullback_compatible_with_tensorobj`
   (Piece 3d) still unstubbed.
