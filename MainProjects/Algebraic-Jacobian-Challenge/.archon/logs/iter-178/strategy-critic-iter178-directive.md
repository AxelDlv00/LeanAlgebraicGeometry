# strategy-critic — iter-178 directive

## Context

You audited STRATEGY.md in iter-177 with slug `iter177` and returned
**CHALLENGE** with 4 must-fix-this-iter findings + 1 major alternative:
1. A.1.a/A.2.a/A.2.b/A.4.a LOC iter band under-counted (anchored on
   ~50 LOC/it from A.1.a, deeper substrate likely ~10–25 LOC/it).
2. Lane A1 HARD STOP user-gate finding (rebutted by planner per
   "You decide; you never wait").
3. `Sym^g` framing contradiction (rejected AS Jacobian object, but
   still used in A.4.d.i UP wiring) — clarified scope.
4. Format DRIFTED + iter-177-only per-iter references — required cleanup.
5. (Alternative) Separated-locus universal extension pre-committed
   replacement candidate.

The iter-177 plan-agent address each:
- (1) LOC bands widened per-row (A.2.a.i ~500-800; A.2.a.ii ~800-1300;
  etc.); positive-genus arm Route A revised to ~280-500 iters from
  ~185 (was even lower).
- (2) Rebutted explicitly in STRATEGY.md Open Q with citation of
  `plan.md` rule "You decide; you never wait". User async override
  via USER_HINTS.md if disagree.
- (3) Clarified in Open Q with the two-role explanation.
- (4) STRATEGY.md restructured under 12 KB; per-iter refs removed.
- (5) Recorded in Open Q as pre-committed replacement candidate;
  iter-178+ plan dispatches a mathlib-analogist consult to scope
  feasibility (THIS iter the consult fires).

## STRATEGY.md status entering iter-178

SHA `8f31d9f998d2d40b3d82da9b08bc78d99069faa589bd1d7d07cfebed1456b30f`
(unchanged from iter-177's verdict-target). No edits this iter
(or: minor planner edits to absorb iter-177 prover outcomes — see
the "Planner-edits" section below).

## Question for you

Re-verify the iter-177 CHALLENGE addresses. Specifically:

1. Is the revised LOC band on A.1.a/A.2.a/A.2.b/A.4.a now realistic?
   Look at the velocity figures (`LOC · realized/it`) in the Phases &
   estimations table. Does `remaining ÷ realized` roughly match
   Iters-left?
2. Was the planner's rebuttal of your user-gate finding (finding 2)
   sound, given the loop's "You decide; you never wait" rule? The
   iter-177 prover phase landed 2 named temp axioms; iter-178 fires
   the mathlib-analogist consult on the named reversal trigger
   (cover-vs-Proj.awayι API). Does this honor the spirit of your
   challenge, or is something further owed?
3. Is the `Sym^g` framing now coherent (rejected as Jacobian object;
   used in A.4.d.i)? STRATEGY.md Open Q records it under
   "REJECTED alternatives".
4. Format check: STRATEGY.md should be under ~250 lines / ~12 KB,
   no per-iter narrative.
5. Is the pre-committed replacement candidate (separated-locus
   universal extension) sufficiently scoped, or does it need an
   explicit reversal trigger like the others?

## Planner-edits this iter (will land after your verdict)

Likely minor edits:
- A.1.a row may add "mathlib-analogist consult LANDED iter-178" — depends on consult outcome.
- Genus-0 chart-bridge row may say "ALT route (separated-locus) consult LANDED iter-178" — depends on consult outcome.
- No structural changes to Phases & estimations expected; LOC bands stable.

## Inputs

Use the standard fresh-context inputs:
- Read STRATEGY.md (verbatim from disk).
- references/summary.md (for citation index).
- Chapter titles + one-line topic per chapter in blueprint/src/chapters/ (just the `\chapter{...}` / first-paragraph).
- The project's stated goal (from references/challenge.lean.ref or top of STRATEGY.md).

Do NOT read iter sidecars, task_pending.md, task_done.md, recent prover task results, or review reports. Treat the strategy as a fresh mathematician would.

Return SOUND | CHALLENGE | REJECT per challenge; one verdict per challenge in your report. End with overall verdict.
