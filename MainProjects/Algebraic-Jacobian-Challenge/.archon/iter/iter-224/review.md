# Iter-224 (Archon canonical) — review

## Outcome at a glance

- **The "the bomb was never there" iter.** Sub-step 3 of the funded Decision-1 sheaf
  internal-hom build (committed iter-219; ~6–12 iter estimate; **elapsed 6**; sub-step 3
  spanning iters 221→224). One prover (opus, `prove` mode), status **SOLVED**.
- **`PresheafOfModules.internalHomEval` naturality CLOSED axiom-clean.** Re-verified
  first-hand this review: `lean_verify` = `{propext, Classical.choice, Quot.sound}` (no
  `sorryAx`); whole file compiles with 0 errors. **Project sorry 81 → 80** (file-local
  4 → 3) — the **first downward move since iter-217**.
- **The defining finding:** the iter-222/223 `whnf` heartbeat-bomb — and the entire iter-224
  `mathlib-analogist` ts224dual ALIGN escalation the plan phase built on it — was **STALE**.
  A Mathlib version bump silently removed the bomb. The prover's *first probe* found the
  "bombing" tactic now returns instantly ("pattern not found", not a timeout); the six-step
  reduction prior provers had already worked out simply compiles. **Neither ROUTE A
  (`with_reducible`) nor ROUTE B (`unit`-reshape) was needed.**
- **Build GREEN; blueprint-doctor CLEAN.** `sync_leanok` iter 224, sha `591983cc`,
  **+0 / −0, chapters_touched []** — but see the `\leanok` gap below.

## The defining tension — a clean close, bought partly by burning two prior iters on a phantom

iter-224 is unambiguously forward, but the honest reading must record the *shape* of how it
got here:

- **Forward (real, verified):** the slipped sub-step-3 obligation — open across three iters —
  is closed, axiom-clean, with a faithful proof matching the blueprint's restrict/evaluate
  commutation argument. Both review subagents return **0 must-fix**; the lean-auditor confirms
  the closure is genuine (no `sorry`/`admit`/`native_decide`/`maxHeartbeats`) and no overclaim
  survives in the touched docstrings.
- **The sting:** iters 222 (stubbed the sorry, 80→81) and 223 (mis-characterized the bomb as
  goal-wide and lemma-non-localized, 81→81) were spent fighting an obstacle that, by the time
  iter-224 ran, did not exist. iter-224's plan phase further ran a full `mathlib-analogist`
  escalation (ts224dual, producing ROUTE A/ROUTE B recipes) premised on the bomb being real.
  The close came from *none* of that machinery — just re-running the plain tactic on the
  current toolchain. Net: ~2 iters of effort were retroactively wasted on a phantom, and the
  durable takeaway is a **process lesson**, not a math advance: re-test a stale Lean-tactical
  "bomb"/timeout diagnosis on the current Mathlib before escalating.

This is not a knock on iter-224's prover (it did exactly the right thing — probed first, closed
cleanly, flagged the staleness loudly). It is a knock on the *222→223→224 arc* as a whole, and
the lesson is recorded in memory (`ts-assoc-flatness-gap.md`) and the recommendations.

## Process correctness

- **Prover: correct, in the right direction.** Closed a sorry (4→3) rather than stubbing one;
  honoured the no-sorry invariant the *productive* way. The iter-223 false-positive trap
  (empty-diagnostics → premature "closed" docstrings) did **not** recur — the close is
  authoritatively `lean_verify`'d. Did the ride-along comment refresh; touched none of the 3
  forbidden adjacent sorries.
- **Planner: pre-commitment honoured, judgement vindicated.** The iter-223 tripwire ("run the
  analogist consult BEFORE any further dispatch — not another blind retry") was satisfied; the
  planner's `## Decision made` to *dispatch the close this iter* (rather than idle a plan-only
  iter on a CHURNING/lower-bound route) paid off. The iter-225 revert-to-absent fallback is now
  **moot**. The one critique of the arc lands on 222/223, not on 224's planner.
- **No route change warranted.** The funded build advances to sub-step 4
  (`lem:internal_hom_isSheaf`), which is unblocked (independent of `internalHomEval`). STRATEGY.md
  unchanged; no live strategy fork. Sub-step 5 (`exists_tensorObj_inverse`) remains the genuine
  Mathlib-absent long pole — flagged for a strategy-critic look next plan, not a mandate.

## Two items the iter-225 planner must internalize

1. **Re-test stale "bomb" diagnoses on the current toolchain before escalating.** This iter's
   whole point. A multi-iter-old elaboration-cost wall can be silently retracted by a Mathlib
   bump. One plain-tactic probe is far cheaper than a stub + a mis-characterization + an
   analogist escalation. (Memory updated.)
2. **Sub-step 4 is the next brick and it is unblocked.** `lem:internal_hom_isSheaf` /
   `Scheme.Modules.dual` does not depend on the eval morphism. HARD GATE applies: dispatch
   blueprint-reviewer, confirm the chapter clears for that block, then a `mathlib-build` lane.
   Do **not** jump straight to sub-step 5 — its sheaf-level counit descends from `internalHomEval`
   only *after* `Scheme.Modules.dual` exists.

## Markers / infrastructure

- **Manual marker fix (review-agent domain):** updated the stale `% NOTE:` on
  `lem:internal_hom_eval` (the obligation it described is discharged; "future target name"
  language obsolete) → `% NOTE (iter-224):` recording the axiom-clean close + the stale-bomb
  finding.
- **`\leanok` under-marking (sync's domain, flagged not fixed):** the proof block of
  `lem:internal_hom_eval` lacks `\leanok` despite the axiom-clean close. sync ran on snapshot sha
  `591983cc` (+0/−0); the substrate `.lean` file is git-untracked, so sync likely processed a
  pre-closure snapshot. Next sync pass on the current tree should add it. Not laundering — the
  opposite (false-negative). I did not add it.

## Subagent skips
- None. Both highly-recommended review subagents dispatched (lean-auditor ts224,
  lean-vs-blueprint-checker ts224); both 0 must-fix.
