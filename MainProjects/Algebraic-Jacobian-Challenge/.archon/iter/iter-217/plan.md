# Iter-217 plan-agent run

## Headline outcome

The "make-or-break is already resolved; commit to the de-risked H1 build" iter. iter-216's prover
(the deferral did not hold — it ran and executed the queued iter-217 objective) returned the
make-or-break **NEGATIVE**: the free-cover shortcut does NOT avoid H1, because the sole consumer
`tensorObj_isLocallyTrivial` applies `tensorObj_restrict_iso W.ι M N` to **arbitrary** modules. So the
single open substrate linchpin `tensorObj_restrict_iso` rests on **H1 = presheaf-level
`pushforwardPushforwardAdj`**, genuinely on the critical path. iter-216 also closed, axiom-clean, the
**ModuleCat-level H2 core** (6 decls). This iter I:

- Dispatched **mathlib-analogist ts217** (api-alignment) as the cheapest disconfirming signal before
  funding a multi-iter build. It returned a **de-risked PROCEED**: H1 is buildable from current Mathlib
  in one bounded round (~70–90 LOC), with an exact 4-step recipe (`analogies/ts217.md`), and crucially
  **`PresheafOfModules.pullbackPushforwardAdjunction` ALREADY EXISTS** (`Presheaf/Pullback.lean:50`) —
  so the comparison is one `leftAdjointUniq` call, not a re-derivation. It verified on-disk that **no
  sub-step is itself a Mathlib-absent primitive** (explicitly contrasted with iter-214's `d.1`, which
  needed genuinely-new stalk infra). The only absent pieces — presheaf `pushforwardNatTrans` /
  `pushforwardCongr` — are mechanical de-sheafifications of existing sheaf-level decls that already
  manipulate `.val` presheaf data.
- Fixed the blueprint's 2 must-fix items (writer ts217 + clean ts217): deleted both refuted
  "free-cover-avoids-H1" paragraphs and stale `% NOTE`s; made `lem:tensorobj_assoc_iso` honest about
  the CURRENT route-(d) whiskering realization vs. the PLANNED restrict-iso re-route; pinned the 5
  iter-216 H2 decls (`lem:restrictscalars_ringiso_strongmonoidal`); cited the Stacks `(f^*,f_*)`
  adjunction verbatim from the local source.
- Cleared the HARD GATE via the same-iter fast path (blueprint-reviewer ts217fp scoped to the chapter).
- Dispatched the prover on `Picard/TensorObjSubstrate.lean`, **mode fine-grained**, to BUILD H1 per the
  analogist recipe and then CLOSE `tensorObj_restrict_iso` (target: count **81→80** — a genuine sorry
  elimination, the first in 7 iters), with the assoc re-route + vestigial-whiskering deletion as a
  budgeted bonus.

Build GREEN entering; project sorry 81; no Lean edits by plan.

## What I processed (iter-216 outcomes)

- Merged the iter-216 prover result (6 axiom-clean H2 decls + make-or-break NEGATIVE) into
  `task_done.md`; rewrote the TS lane in `task_pending.md` to the post-216 / iter-217 H1-build plan;
  cleared the processed result file.
- iter-216 review reports actioned: **lean-vs-blueprint-checker ts216** (2 must-fix on the chapter:
  assoc proof-route mismatch + "free-cover avoids H1" contradiction) → both fixed by writer ts217.
  **lean-auditor ts216** (4 major stale docstrings) → folded into the prover directive as a ride-along
  cleanup. Cleared both processed result files.

## Decision made — BUILD H1 (fine-grained), target a real sorry elimination this iter

**Fork:** (i) take the progress-critic ts217 STUCK verdict at face value → idle/await an explicit USER
decision before any further infra; (ii) dispatch a `mathlib-build`/`fine-grained` round on H1 per the
analogist's de-risked recipe, structured to DROP the count this iter; (iii) un-gate a held lane instead.

**Chosen: (ii).** Rationale and the cheapest reversal signal:
- The analogist (which actually read Mathlib on-disk) **refutes** the progress-critic's load-bearing
  technical claim that "H1 bottoms out into confirmed-absent sub-infrastructure, same as iter-214 d.1."
  Every H1 sub-step is present or a mechanical de-sheafification; `pullbackPushforwardAdjunction` exists.
  This is exactly the soundness check the deeper-think gate calls for, and it came back POSITIVE.
- The dispatch is structured to break the churn pattern the critic names: the target is **closing
  `tensorObj_restrict_iso`** (one of the 4 file-local sorries) via H1 + the bounded H2 presheaf lift —
  i.e. an observable 81→80, not "+1 helper with the count flat." Mode = **fine-grained** (atomic named
  lemmas per the de-risked decomposition) precisely because 6 prior `prove` passes moved the count 0.
- Reversal signal: if the prover finds presheaf `pushforwardNatTrans`/`pushforwardCongr` are NOT
  mechanical de-sheafifications (i.e. they need a further absent primitive), it returns INCOMPLETE with
  the exact blocker, and the next iter escalates the substrate design rather than funding a 9th round.

## Rebuttal of progress-critic ts217 (STUCK — must-fix, responded explicitly)

The STUCK verdict is correct on the raw signals (7 iters, count flat at 81, PARTIAL×6) and I honor its
two *actionable* correctives. But three of its conclusions I rebut, on the record:

1. **"`mathlib-build` on H1 is the same churn / H1 bottoms out."** Rebutted by mathlib-analogist ts217's
   on-disk verification (the critic is signals-only and explicitly did not read Mathlib). H1 is
   de-risked: ~70–90 LOC, every sub-step present, `pullbackPushforwardAdjunction` already exists. This
   is materially different from the 6 prior `prove`-mode attempts on a wall whose ingredient was
   un-located. The iter is structured to close a real sorry (restrict_iso → 81→80), not to add a helper.
2. **"Obtain an explicit USER decision (not a FYI) before dispatching."** Rebutted by the hard planner
   rule: the loop is autonomous; I decide and proceed THIS iter; I never idle awaiting a human reply.
   The USER escalation remains a live FYI (review surfaces it in TO_USER.md); the user overrides via
   USER_HINTS.md if they disagree. A "no-dispatch, awaiting decision" round is explicitly forbidden.
3. **"Delete the vestigial whiskering FIRST for a free 81→80."** Partially rebutted on a code fact the
   signals-only critic missed: `isLocallyInjective_whiskerLeft_of_W` is NOT yet dead — the green,
   `\leanok`'d `tensorObj_assoc_iso` transitively depends on it via `W_whiskerLeft/Right_of_W` (route-(d)).
   Deleting it now BREAKS `tensorObj_assoc_iso`. The deletion is correctly the LAST step (after the
   assoc re-route, which needs `tensorObj_restrict_iso` closed). I do honor the spirit: the iter targets
   a count drop via the restrict_iso closure instead, which IS achievable this iter.

**Held-lane must-fix (rebutted on the USER standing directives).** The critic flags 7 iters of all
non-TS lanes held and asks to un-gate one independently. But the USER standing directives forbid it:
(a) ROUTE C PAUSE makes H1Vanishing/RRFormula/OCofP/OcOfD/RationalCurveIso/BareScheme/GmScaling/
RigidityKbar/AbelianVarietyRigidity + all RR.* off-limits; (b) bottom-up + "no A.3 before A.2.c"
gates the Albanese/Genus0/tangent frontier-ready decls; (c) "free all prover capacity for Route A
only." The held Route-A lanes (RPF, FGA) genuinely depend on the TS iso-class group (RPF's real
construction IS `tensorObjIsoclassCommMonoid`). So there is no un-gateable lane that respects the
standing directives; TS is the sole ungated Route-A lane. This is a real constraint, not avoidance.
**OVER_BUDGET** acknowledged: STRATEGY.md SubT row re-estimated to ~2–4 iters with the de-risking noted.

## Subagent / consult summary (plan-phase)

| Subagent | Slug | Status |
|---|---|---|
| mathlib-analogist | ts217 | **PROCEED (de-risked)** — H1 buildable now (~70–90 LOC), exact 4-step recipe; `pullbackPushforwardAdjunction` EXISTS (use `leftAdjointUniq`, don't re-derive); no sub-step Mathlib-absent (unlike iter-214 d.1); H2 presheaf lift bounded. `analogies/ts217.md`. |
| progress-critic | ts217 | **STUCK** (7th iter, count flat, PARTIAL×6). Actionable correctives honored (count-drop target; held-lane review). Rebutted: "H1 bottoms out" (analogist on-disk refutes), "await USER decision" (hard planner rule), "delete whiskering first" (still backs green assoc_iso). |
| blueprint-writer | ts217 | COMPLETE — both must-fix proof blocks corrected (free-cover narrative deleted; assoc current-vs-planned honest); 5 H2 decls pinned; Stacks `(f^*,f_*)` quote added. No strategy-modifying findings. |
| blueprint-clean | ts217 | PASS — stripped 1 project-status phrase; added 3 missing `\textit{Source}` lines; verified the Stacks quote verbatim; markers untouched; envs balanced. |
| blueprint-reviewer | ts217fp | fast-path → **`complete: true, correct: true`, no must-fix → HARD GATE CLEARS**. Both prior must-fix resolved; 5 H2 pins verified on-disk (Lean L219/237/253/266/275). Caught a `soon`: STRATEGY.md `## Routes` still had the stale free-cover phrase → **fixed by plan agent this iter** (the Phases table + gaps were already updated; Routes paragraph now consistent). |

## Gate outcome + prover dispatch

HARD GATE CLEARED via the same-iter fast path. `Picard/TensorObjSubstrate.lean` is in
`PROGRESS.md ## Current Objectives` ([prover-mode: fine-grained]); the loop dispatches the prover
after this plan phase. No deferral. The reviewer also confirmed 0 unstarted-phase proposals across
all 33 chapters (every strategy phase has blueprint coverage), so no extra writer dispatch is owed.

## Subagent skips

- strategy-critic: the strategy *direction* is unchanged (build the SubT group law via the named
  linchpin) and was vetted last iter (CHALLENGE×2 incorporated, no live unaddressed challenge). This
  iter's STRATEGY.md edit only records the make-or-break resolution (a tactical narrowing to H1 within
  the vetted route) and re-estimates the SubT row — not a route swap. The sole live strategic concern
  (SubT moot under the RR fork) is unchanged and already escalated to USER. The decision-critical
  question this iter (is H1 buildable) is feasibility, answered by mathlib-analogist ts217, not a
  strategy-direction question.

## USER escalation (FYI — unchanged; override via USER_HINTS.md; the loop proceeds otherwise)

- The ⊗-substrate (Lane TS) is **route-A-specific** and would be DISCARDED if you lift the RR pause
  (then `Pic⁰` comes from divisor classes — `WeilDivisor`/`OcOfD` already exist). The narrow H1 build
  minimizes sunk cost meanwhile, and is now de-risked (one bounded round to close the linchpin).
- The PRIMARY GOAL (A.2.c representability) has **no live discharge lane** under the RR pause: keep ⇒
  ~3400–5500 LOC RR-free Quot engine; lift ⇒ ~600–1000 LOC `Sym^n`/Abel–Jacobi (~5× cheaper, also moots
  SubT). This remains the project's single highest-leverage decision.
