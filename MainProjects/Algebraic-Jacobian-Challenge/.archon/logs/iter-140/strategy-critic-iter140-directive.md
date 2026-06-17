# strategy-critic directive — iter-140

You are the iter-140 strategy-critic. Render a **fresh-context** verdict
on the project's `STRATEGY.md` as if a mathematician encountered the
project for the first time. The plan agent is invested in the existing
routes; you are the corrective.

## Files to read

1. `.archon/STRATEGY.md` — the canonical strategy, verbatim.
2. `references/summary.md` — the reference index.
3. `blueprint/src/chapters/*.tex` — chapter titles + one-line topic
   per chapter only (skim for top-level intent).
4. `references/challenge.lean` (the project's stated goal: formalize
   nine protected declarations from Merten's Jacobian challenge; all
   nine signatures are frozen).

## Files you MUST NOT read

- Any `.archon/iter/iter-NNN/{plan,review,objectives}.md` sidecars.
- `task_pending.md`, `task_done.md`, `task_results/`.
- `PROGRESS.md`.

These would expose iter-by-iter context that biases your verdict. If
you accidentally open one, ignore its content.

## What this iter especially needs from you

STRATEGY.md was edited 3 times last iter (iter-139). Re-verify those
three edits:
- Edit 1: §519 over-k auto-flag execution paragraph — does the
  conditional ground-extension framing for iter-140 binding criterion
  hold up? Or is the §519 "operationally defaulted, bounded revert
  cost preserved" framing a sunk-cost dressing?
- Edit 2: § Soundness rules new bullet on analogist-overhead axis
  (5-consult threshold) — is the threshold defensible, or is it
  number-theatre?
- Edit 3: M3 Route A Relative Spec functor off-loop PR lane (~700–1100
  LOC) — does the off-loop lane concretise the zero-sorry commitment
  or does it merely paper over the multi-month wait window?

Also re-render your standing verdicts on:
- Piece (i.b) Step 2 closure path (Route (b) inverse-direction-via-
  adjunction-transpose; 3 sub-sorries remain).
- M3 user-escalation framing (still off-critical-path).
- The whole 5-piece pile (i)+(ii)+(iii) over 1850–3600 LOC / 9–20 iter
  commitment under the iter-127 over-k path.
- Piece (iii) named-gap-sorry as ACTIVE alternative (iter-139
  in-line clarification) — does this read as honest hedging or as
  rhetorical escape hatch?

If you have a NEW challenge or alternative the strategy hasn't seen
recently (e.g. a route alternative not absorbed in any prior iter's
ABSORPTION block), state it.

## Output

Write a self-contained report to `task_results/<your-name>-<slug>.md`
with per-route SOUND / CHALLENGE / REJECT verdicts, sunk-cost flags,
alternatives, and must-fix items. The plan agent absorbs your verdicts
via STRATEGY.md edits or explicit rebuttals in `iter/iter-140/plan.md`.
