# Directive — strategy-critic @ iter-148

## Task

Fresh-context audit of the project strategy. Challenge or
confirm route choices, the phase ordering, the iter / LOC
estimates. Verdict per major strategic commitment: SOUND /
CHALLENGE / SUPERSEDED.

## Context

`STRATEGY.md` was restructured iter-147 to the canonical
skeleton (~178 LOC; well under the 250-line bound). The
iter-147 strategy-critic returned 4 CHALLENGEs (Route C MV-on-
`Ω^{⊕n}` framed as genuinely new instantiation; Route A merit-
based vs Route B paragraph; over-`\bar k` + descent now explicit
`## Routes` § "Alternative (still on the table)" with rolling
triggers; `## Soundness rules` dissolved into `## Mathlib
gaps`); all 4 absorbed iter-147.

The current strategy commits to:

- Route C (M2 critical path): chart-algebra envelope in
  `Cotangent/ChartAlgebra.lean` with 5 sub-pieces. 3 closed
  iter-146 + iter-147 (α, lift, β-core); 2 remaining (KDM, constants
  substep 3).
- Route A (M3 off-critical-path): Picard via FGA; LOC midpoint
  ~6070; iter-170+ realistic earliest scaffold.
- Alternative carry-over (over-`\bar k` + Galois descent for
  M2.a): documented with rolling triggers; iter-150 carries a
  scheduled symmetric audit.

## What we ask you

1. **Re-verify the iter-147 STRATEGY.md restructure stuck.** Read
   the current `STRATEGY.md` and confirm:
   - LOC under 250
   - No per-iter narrative regressed in (no "iter-148 we did X")
   - Section headings match the canonical skeleton
   - Each section's content rules followed

2. **Confirm or challenge the merit-based Route A vs Route B
   choice** in light of the current state (Route C nearing closure;
   M3 not yet started; potential to revisit before M3 scaffolding
   begins iter-170+).

3. **Confirm or challenge the over-`\bar k` carry-over alternative**.
   Iter-150 carries a scheduled symmetric audit; given Route C is
   trending toward closure (2 of 5 sub-pieces remain), does the
   rolling trigger condition (a) "chart-algebra cost exceeds upper
   LOC budget" need re-budgeting? Current trajectory: 3 sub-pieces
   closed in 2 iters of prover work; remaining 2 sub-pieces likely
   2–4 more iters at current pace. Aggregate iter-145→close LOC
   for the route to date: 89 → 342 LOC (iter-147 close) on
   `Cotangent/ChartAlgebra.lean`. Project's upper LOC budget for
   chart-algebra envelope (from `## Phases & estimations`): 400–
   800 LOC remaining as of iter-148 entry.

4. **Specific iter-148 question**: the iter-147 prover lane on
   substep 3 of `constants_integral_over_base_field` identified
   the substantive Mathlib gap as "flat base change of `Γ` for
   proper schemes (Stacks 02KH/0BUG)". The iter-148 recommended
   lane lands a thin in-tree wrapper (~50–150 LOC). Is this a
   **single-thin-wrapper** gap or does it conceal a longer chain
   (e.g. proper-flat base change of `Hⁱ` for all `i`, which in
   Mathlib would need a coherent-of-finite-type infrastructure)?
   If the gap is in fact larger than the recommendations.md
   estimate, the iter-148 prover lane could over-run; the
   strategy may need to either (a) commit to building the larger
   gap, or (b) route around it via the over-`\bar k` alternative
   for M2.a (deferring constants substep 3 indefinitely).

## What you read

- `STRATEGY.md` (verbatim)
- `references/summary.md` (1-line per source)
- `references/challenge.lean` (the authoritative goal)
- Blueprint chapter titles + 1-line topic per chapter from
  `blueprint/src/chapters/*.tex` (you may peek at chapter titles
  but NOT chapter bodies)
- Project's stated goal (from references/ challenge.lean
  module-level docstring)

## What you DO NOT read

- Iter sidecars (`iter/iter-NNN/{plan,review,objectives}.md`)
- `task_pending.md`, `task_done.md`
- Recent prover task results
- `PROJECT_STATUS.md`
- Recent review reports or session journals
- Per-iter narrative

## Output

Standard verdict-per-commitment + must-fix list per descriptor.
Write to `task_results/strategy-critic-iter148.md`.

You are mandatory every iter — even when STRATEGY.md is unchanged
from the prior iter. A stable strategy challenged last iter that
the planner adjusted may not need re-challenging on the same axis;
if you confirm the iter-147 adjustments stuck, that is a valid
verdict ("CONFIRM iter-147 adjustments; no fresh challenge this
iter") — DO NOT manufacture new challenges to satisfy mandatoriness.
