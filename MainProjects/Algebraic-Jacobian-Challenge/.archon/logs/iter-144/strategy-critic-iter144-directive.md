# Strategy Critic Directive

## Slug
iter144

## What you read

1. The current `STRATEGY.md` verbatim at
   `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`.
   (Edited iter-144 per user-hint; see "User-hint edits" below.)
2. `references/summary.md` (one-line index).
3. The blueprint summary at
   `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/logs/iter-144/blueprint-summary-iter144.txt`
   (chapter titles + one-line topic + project goal paragraph).

## What you do NOT read

- `iter/iter-NNN/*.md` for any N (no iter sidecars).
- `task_pending.md`, `task_done.md`, any recent `task_results/*`.
- `proof-journal/`, `PROJECT_STATUS.md`, `PROGRESS.md`.

If you accidentally encounter any of these, ignore them.

## Project stated goal

Formalize the nine protected declarations of Christian Merten's Jacobian
challenge (`references/challenge.lean`); the final target is closing
the body of `AlgebraicGeometry.nonempty_jacobianWitness` (signature
frozen at `(C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 C.hom]
[IsProper C.hom] [GeometricallyIrreducible C.hom] : Nonempty (JacobianWitness C)`).
Strategy decomposes via `by_cases h : genus C = 0` into `genusZeroWitness`
(M2) and `positiveGenusWitness` (M3).

## User-hint edits applied to STRATEGY.md this iter (iter-144)

Three substantive edits per user-hint (the user explicitly told the
autonomous loop to remove user-escalation gates AND clarified the
iter-126 "do the work" hint):

1. **M3 COMMITTED to Route A (Picard via FGA, ~6500 LOC midpoint)**.
   Route B (Symⁿ + Stein, ~9000 LOC) dropped from active consideration;
   preserved below as historical alternative.
2. **All user-escalation gates removed**: (a) the 5000-LOC hard-fallback
   gate in M3 route-pick criterion; (b) the "pivot strategy or escalate
   to user" off-track signal in M3 per-iter monitor; (c) the iter-126
   TO_USER.md escalation framing in M3 disposition. Where a gate used
   to read "escalate to user", it now reads "dispatch a fresh
   strategy-critic and commit to its own verdict".
3. **"Off-loop PR lane" framing dropped** for both M1.d
   `kaehler_quotient_localization_iso` and M3-A `RelativeSpec`. Both
   are now ordinary in-tree project material. Upstream PR extraction
   is OPTIONAL downstream lift, not a project commitment and not a
   precondition for in-tree work elsewhere.

## What you check

For each strategic route + soundness rule + sequencing block + risk
register + revert-trigger in STRATEGY.md:

1. **Goal-alignment.** Does the strategy's end-state (zero inline sorry
   PROVISIONAL on piece (iii) named-gap-sorry fallback) actually close
   the protected `nonempty_jacobianWitness` chain?
2. **Mathematical soundness.** Are the over-k commitment + the cotangent-
   vanishing pile decomposition (pieces (i)+(ii)+(iii)) genuinely
   sufficient for the M2.a body, or are there unstated dependencies?
3. **Alternative routes.** Have any been silently dropped (e.g. the
   Replacement (B) / (A) / fibre-free piece (i.a) body choice)? Is the
   fibre-free reformulation watch threshold still well-calibrated under
   the iter-138 1000-LOC renormalisation?
4. **Sunk-cost reasoning.** Especially in the over-k commitment's
   "grounds (ii) blueprint cleanliness honest as switching cost +
   ground (iv) piece (i.a) tractability honest as route-validation"
   framing. Does the iter-141 "operationally defaulted, bounded revert
   cost preserved" framing hide sunk cost behind language?
5. **User-hint edits**: are the iter-144 substantive edits internally
   consistent? Specifically:
   - Route B "historical alternative only" — does any later text still
     reference Route B as if it were active?
   - "Off-loop PR lane" framing dropped — does any remaining text still
     reference the M1.d off-loop infrastructure as load-bearing?
   - User-escalation gates removed — does any remaining clause expect
     external user input?
6. **M3 Route A commitment**: per the user-hint M3 is now COMMITTED to
   Route A (not "Route A preferred but escalate-to-user pending"). Is
   the iter-150 RelativeSpec scheduling trigger reasonable as a
   PARALLEL M3 start during M2 wait, or should the strategy say
   "strictly-after-M2-closes"?
7. **The iter-144 MANDATORY chart-algebra-vs-bundled re-evaluation gate**
   (in STRATEGY.md "Iter-142+ scheduled obligations") fires this iter
   per the iter-143 commitment. Does the gate framing match the user-
   hint reframing of in-tree work?
8. **The "operational convention" iter-142 simplification** (no pile
   piece is currently base-dependent; revert triggers are wired but
   inert): is this still the right framing post iter-143 PARTIAL on
   d_app?
9. **Multi-year wall-clock honest estimate** (~9–24 months) — under the
   user-hint reframing dropping the "post upstream PR and wait" arm of
   M3, does the wall-clock estimate need re-grounding?

## Sunk-cost-trap watchlist (iter-141 list, carry-over)

- "We've already built `RigidityKbar.tex` over `[Field k]`, so over-k
  is right" — still grounds (ii) blueprint cleanliness; verify it's
  honestly named as switching cost.
- "We've already invested in Route A audit" — would this now
  function as a sunk-cost justification under the new user-hint
  commitment, or is the commitment principled-on-LOC alone?
- The breakeven-counter rule, iter-143 Edit 2: any silent
  recalibration since landing?

## Stance reminder

You are the project's adversarial reader. Sunk cost is exactly what
you are meant to challenge. If a section's text justifies a route by
"we've already done X" rather than "X is right", call it out.

You may render PROCEED / CHALLENGE / REJECT verdicts per axis. Any
CHALLENGE or REJECT becomes a STRATEGY.md edit obligation OR an
explicit rebuttal in iter-144 sidecar; you may NOT be silently absorbed.
