# Strategy critic directive — iter-141

## Your inputs

You may read ONLY the following files:

1. `.archon/STRATEGY.md` (verbatim).
2. `references/summary.md` (reference index).
3. The chapter titles + one-line topic of each
   `blueprint/src/chapters/*.tex` (use `head -n 10` of each chapter file;
   not the full content).
4. The project goal as recorded in STRATEGY.md § "Project goal" and
   `references/challenge.lean` § statement of `nonempty_jacobianWitness`.

You may NOT read: any `iter/iter-NNN/{plan,review,objectives}.md` (including
iter-140's), `PROGRESS.md`, `task_pending.md`, `task_done.md`, any
`task_results/*` file, or any `proof-journal/`.

## Project goal (one paragraph)

Formalize the existence of a Jacobian variety for an arbitrary smooth proper
geometrically irreducible curve `C : Over (Spec (.of k))` over a base field
`k`, per the 9 protected declarations of `references/challenge.lean`. The
key protected theorem is `AlgebraicGeometry.nonempty_jacobianWitness`, which
quantifies over arbitrary `C` without a `k`-rational-point hypothesis. The
end-state is **zero inline `sorry` in the project, PROVISIONAL on piece
(iii) closing in-tree at tractable LOC cost** (per iter-140 STRATEGY.md
Edit 3); the named-gap-sorry alternative on piece (iii) (scheme-level
absolute Frobenius) is honest fallback if the in-tree build proves
untractable.

## Iter-140 edits to STRATEGY.md you must re-verify

The iter-140 planner made 4 substantive STRATEGY.md edits in response to
your iter-140 verdict:

- **Edit 1**: Consult-count arm of analogist-overhead axis NARROWED to a
  calibration watchpoint (line ~422 of STRATEGY.md). The original "≥5
  consults fires route-pivot question" was demoted to "current-state
  calibration; revisit-if-not-fired-by-iter-150". The envelope-widening
  arm (≥3 envelope-widening consults) remains the authoritative trigger.
- **Edit 2**: M3 Relative Spec off-loop PR lane FRAMING DOWNGRADED (line
  ~597). The iter-139 "concretises the zero-sorry commitment for M3"
  language was dropped per your CHALLENGE; honest classification is
  "post-M2 planning hook + smallest PR-extractable identification".
- **Edit 3**: End-state qualification + multi-year wall-clock framing
  (line ~22-58). End-state changed from "zero inline `sorry`" to "zero
  inline `sorry`, PROVISIONAL on piece (iii) closing in-tree at tractable
  LOC cost". Wall-clock framing corrected from "multi-month" to
  multi-year (~9–24 months).
- **Edit 4**: Iter-141+ + iter-144 obligation pinning (line ~587). Added
  iter-141 mandatory piece (iii) scheme-Frobenius scoping analogist +
  iter-144 mandatory chart-algebra-vs-bundled re-evaluation.

Re-verify all 4 edits land cleanly with no fitting-to-fire renormalisation
patterns slipped through. Also re-verify:

## NEW iter-141 question (driven by iter-140 PARTIAL outcome)

Iter-140 was the third consecutive iter the project's prover lane targeted
piece (i.b) Step 2 (iter-138 PARTIAL → iter-139 plan-only → iter-140
PARTIAL again with 0-of-3 sub-sorries closed by strict count). Per the
iter-140 pre-committed PARTIAL acceptance arm, the iter-141 planner is
required to dispatch you with the **over-k vs over-`k̄` route-pivot
question mid-iter**. The acceptance arm reads (verbatim from PROGRESS.md
§ Watch criteria #2):

> **PARTIAL arm**: 0 or 1 sub-sorries closed → CHURNING-trigger +
> mid-iter strategy-critic re-dispatch on over-k vs over-`k̄` route-pivot
> question. ALSO check the cumulative LOC arm independently —
> partial renormalisation here is forbidden per the iter-138 discipline
> rule.

Render an explicit verdict on the route-pivot question:

- **Route-pivot question**: should the project revert from the over-k
  commitment to the over-`k̄` baseline + M2.c restoration? Or should
  the over-k commitment be retained?
- **Cumulative LOC arm**: STRATEGY.md § "Sequencing" line 499 prior +
  § "Soundness rules" § LOC trigger arm renormalisation discipline name
  a cumulative-LOC arm at "> 1000 LOC cumulative (i.b)-side build
  without converging". Is this arm at-risk of firing this iter? Is
  it firing? If firing, the planner is REQUIRED to absorb it; if not,
  is the threshold itself sunk-cost-shaped (i.e., the iter-137 renormalisation
  from 600 → 1000 LOC under-justified)?

For each axis of the question, render `SOUND` / `CHALLENGE` / `REJECT`
with concrete reasoning. Quote the line(s) you challenge.

## NEW iter-141 question (piece (i.b) Step 2 prover-lane shape)

Per the iter-140 outcome, the iter-141 planner is also weighing whether
to:

- **(A)** Dispatch the prover lane on `Cotangent/GrpObj.lean` for a
  fourth consecutive iter on the same 3 sub-sorries (with refined
  closure recipes), OR
- **(B)** Defer the prover lane this iter and dispatch a blueprint-writer
  to expand the d_app / d_map / IsIso closure recipes with the explicit
  factoring-lemma + whnf-opacity-aware reformulation that the iter-140
  prover lane discovered, OR
- **(C)** Dispatch a mathlib-analogist on the d_app / d_map sub-sorries
  (the iter-140 prover lane "validated factoring-lemma standalone via
  lean_run_code"; if the analogist confirms this is the right shape,
  the prover lane has a cleaner target), OR
- **(D)** Route-pivot to (B′)/(C)/fibre-free per the strategy's
  documented pivot triggers (Q1+Q2+Q3 from STRATEGY.md § "Direct over-k
  rigidity" § "Iter-130 strategy-critic Q2 CHALLENGE" + fibre-free
  scorecard).

Which of (A)/(B)/(C)/(D) is the SOUND iter-141 choice? Surface alternative
shapes if you see them. (The planner is independently constrained to
dispatch the iter-141-mandatory piece (iii) scheme-Frobenius scoping
analogist + the slipped-from-iter-135–138 higher-Kähler-vanishing
alternative analogist this iter regardless.)

## Sunk-cost flag awareness

The iter-138/iter-139 § "operational default" reframing of the over-k
commitment (lines 540–544) tries to honestly name that the over-k
defense is now "we have been building there" rather than "the over-k
route IS better". This is exactly the sunk-cost shape you should be
adversarial about. Should the iter-141 PARTIAL outcome (zero forward
progress on a strict sorry-count basis after 3 consecutive iters of
prover lanes targeting the same 3 sub-sorries) flip the operational
default? Be explicit.

## Output

Render verdicts in the standard strategy-critic format:

- Per route: SOUND / CHALLENGE / REJECT with reasoning.
- Must-fix-this-iter items (max 6, ranked by urgency).
- Alternative routes (max 3).
- Sunk-cost flags (quote-line and 1-sentence justification each).
- Final answer to the iter-141-specific (A)/(B)/(C)/(D) prover-lane
  shape question above.
