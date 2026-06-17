# Progress Critic Report

## Slug

iter115

## Iteration

115

## Routes audited

### Route: `Differentials.lean` — L175 unique-gluing helper (`relativeDifferentialsPresheaf_isSheafUniqueGluing_type`)

- **Sorry trajectory**: 5 → 5 → 5 → 5 → 5 across iter-110 through iter-114 (project-total 16 → 16 → 16 → 16 → 16; per-file `Differentials.lean` flat at 5). **Net change over K = 5: zero. Zero sorry-eliminations on this route in the audited window.**
- **Helper accumulation**: +3 helpers added across last 3 iters where the route received attention (iter-112: +2 with one sorry-bodied + one closed via the new sorry-bodied helper; iter-113: +1 sorry-bodied sub-helper; iter-114: 0, deeper-think). **3 helpers added, 0 sorries eliminated.** The iter-112 "closed" helper #2 is purely a downstream consequence of helper #1 — it discharges no genuine residual mathematical content; the load-bearing content sits in helper #1 (then iter-113 in the new sub-helper `_isSheafUniqueGluing_type`). The iter-113 prover self-classified that round as "reformulation rather than genuine mathematical progress" — a flag that should not be ignored.
- **Recurring blockers**:
  - "no off-the-shelf Mathlib lemma packages `Scheme.PresheafOfModules`-sheaf-on-affine-basis ⇒ sheaf on X" (or near-verbatim paraphrase) appears in iter-110 blueprint-writer report, iter-112 prover report, iter-113 prover report, and iter-114 mathlib-analogist persistent file `analogies/affine-basis-sheaf-bridge.md`. **4 of the 5 audited iters where the route received attention reference the same blocker.** The iter-114 analogist independently verified the blocker is real (NOT phantom infrastructure) — which is good for the math but does NOT change the route's signal-level status: the same wall has been hit four times.
- **Prover status pattern**: NO PROVER (iter-110, deeper-think) → NO PROVER (iter-111, validator artifact) → PARTIAL Bar B (iter-112) → PARTIAL Bar B reformulation variant, prover-self-classified as "not genuine mathematical progress" (iter-113) → NO PROVER (iter-114, HARD GATE + prior STUCK verdict). **2 of 2 dispatched prover rounds = PARTIAL. The most recent dispatch (iter-113) was self-classified as a non-substantive reformulation.**
- **Verdict**: **STUCK**.

  Both STUCK clauses fire by the verdict rules:
  - **STUCK clause 1**: sorry count unchanged across K iters (✓ 5→5→5→5→5) AND recurring blocker phrase across ≥3 iters (✓ 4 iters).
  - **STUCK clause 2**: helpers added (✓ +3) without any sorry-elimination across K iters (✓ 0 sorries closed).

  Note also: the prior progress-critic verdict at iter-114 already returned STUCK on this route, and the iter-114 planner's response was to apply correctives (blueprint expansion + mathlib-analogist consult) rather than pivot. That's a legitimate corrective sequence, but it does NOT alter this iter's signal-level verdict — the question I'm asked is "has the route eliminated a sorry yet?" and the answer is still no.

- **Primary corrective**: **Proceed with the iter-115 dispatch as proposed — but only because it IS the corrective for the prior STUCK verdict.** Treat this dispatch as a one-shot test of the iter-114 corrective package (corrected recipe + analogist-verified hand-roll path + upgraded blueprint chapter). The planner has done the right prep work in iter-114; this iter's dispatch is the only way to learn whether the corrective worked.

  **However**, the planner must commit, in `iter/iter-115/plan.md`, to a hard gate for iter-116: **if iter-115 returns PARTIAL with unchanged file-level sorry count AND any recurrence of the affine-basis-bridge blocker phrase (or a similar new bridge gap surfaces from the hand-rolled Step 2 cofinality descent), the planner does NOT dispatch another helper round on this route.** At that point the verdict becomes "the corrective failed" and the planner must either:
  1. **Route pivot** — revise STRATEGY.md to defer all of Phase B (L175 + L880 + L897 + L880-converse) by 2+ iters and pull forward a different strategic phase. Re-dispatch `strategy-critic` mid-iter to validate the pivot.
  2. **User escalation** — pause autonomous loop work on this route and request user input on whether to invest in a full hand-rolled affine-basis sheaf bridge (likely a multi-file Mathlib-style infrastructure build), or to drop the relative-differentials-sheaf milestone from the project goal.

  Either way, **no second helper round on this route without explicit user sign-off or a strategy pivot.**

- **Secondary correctives** (not for this iter, but to keep on the planner's radar):
  - **Bound on Step 2's hand-roll**: the analogist-verified recipe says "hand-rolled cofinality descent against `isSheaf_iff_isSheafOpensLeCover` (no off-the-shelf Mathlib bridge)." That hand-roll is itself non-trivial. The planner should ask the prover, in the iter-115 directive, to **time-box** Step 2 — if Step 2 alone produces more than, say, 2 new helper-shaped sub-sorries inside the route by the end of the iter, that's the same churn pattern asserting itself one layer deeper, and the prover should report PARTIAL early rather than continue spawning sub-helpers.
  - **No further reformulation rounds permitted**: iter-113 explicitly self-classified as reformulation rather than genuine progress. The iter-115 directive should forbid the prover from closing helper #1's body by delegating to yet another sorry-bodied sub-helper (i.e. no `_isSheafUniqueGluing_2_type`, no `_isSheafUniqueGluing_descent_type`, etc.). If the prover finds it can only progress by introducing such a wrapper, the verdict is INCOMPLETE, not PARTIAL.

## Must-fix-this-iter

- Route `Differentials.lean` L175 unique-gluing helper: **STUCK** — primary corrective: **proceed with the iter-115 dispatch as the one-shot test of the iter-114 corrective package; commit in `iter/iter-115/plan.md` to a hard iter-116 gate that bans a second helper round on this route without strategy pivot or user escalation.** Why: sorry count flat at 5 across K = 5 iters; recurring affine-basis-bridge blocker appears in 4 of those 5 iters; the only two dispatched prover rounds were both PARTIAL, with iter-113 self-classified as non-substantive reformulation. The iter-114 corrective work is the planner's existing answer to STUCK — this iter's dispatch tests it. A second helper round after another PARTIAL would be textbook continued churn.

## Informational

None — only one route under review this iter, and it landed STUCK.

## Overall verdict

One route audited, one STUCK verdict. The planner has already applied the canonical STUCK correctives (blueprint expansion + mathlib-analogist consult) in iter-114, and the iter-115 proposal is the natural test of those correctives — not "another helper round on a churning route," which is what STUCK normally guards against. I credit the iter-114 prep work and concur that the proposed iter-115 dispatch is the right move; but I do NOT relax the verdict, because the signal-level status of the route (sorry trajectory, recurring blocker, PARTIAL streak) has not yet improved. The iter's prover dispatch should proceed, and `iter/iter-115/plan.md` must explicitly record the hard iter-116 gate above so that another PARTIAL outcome triggers a pivot or user escalation rather than a third helper round.
