# Directive — strategy-critic iter-135

## Slug

iter135

## What to review

The current `STRATEGY.md` at `.archon/STRATEGY.md` (read the whole file
verbatim).

## Mandatory reading

1. `.archon/STRATEGY.md` — the strategy to audit.
2. `references/summary.md` — reference index.
3. Blueprint summary: list of chapter titles + one-line topic by skimming
   the first few lines of each `blueprint/src/chapters/*.tex`. Use
   `Glob` + `Read` (limit ~20 lines per file) rather than full reads.
4. Project's stated final goal: the nine protected declarations of
   `references/challenge.lean` (Christian Merten's Jacobian challenge),
   listed in `STRATEGY.md` § "Project goal".

## NOT in scope (per descriptor)

Do NOT read: any `iter/iter-NNN/{plan,review,objectives}.md`,
`task_pending.md`, `task_done.md`, `PROGRESS.md`, recent
`task_results/`, `proof-journal/`, `PROJECT_STATUS.md`, or
`TO_USER.md`. If any of these were accidentally included in this
directive, ignore them. Your value is in the lack of pollution.

## Stability framing

STRATEGY.md was substantively revised in iter-134 (4 places: watchpoint
LOC trigger; fibre-free scorecard forward-merit paragraph; piece (i.a)
sequencing row corrective-overhead totals; M3 scaffold landing). The
iter-134 strategy-critic returned SOUND with 3 CHALLENGEs (all absorbed)
+ 2 minor alternatives. STRATEGY.md is unchanged entering iter-135 from
its iter-134 close state.

The iter-135 plan agent has **not changed the strategy itself** this
iter. The question for you is whether the strategy as it stands today
remains sound, and whether your iter-134 challenges have been correctly
absorbed (rather than silently dropped).

## What to assess (in priority order)

1. **Goal-alignment** of each strategic route in STRATEGY.md against the
   nine protected signatures of the Jacobian challenge.
2. **Mathematical soundness** of the active critical path (piece (i.a)
   DONE iter-132 → piece (i.b) iter-134+ → piece (i.c) iter-137+ →
   piece (ii) iter-141–143 → piece (iii) iter-144–150 → M2.a/M2.b
   closure iter-151+ → M2 closure iter-157+; M3 scaffold landed iter-134;
   piece (iv) DEFERRED named-gap).
3. **Sunk-cost / momentum smells**. Particularly: is the over-k commitment
   (iter-127, re-defended iter-132 + iter-133) holding up against the
   actual measured progress, or are the absorbed iter-134 CHALLENGEs
   (LOC trigger arm; forward-merit weighting; piece (i.a) honest framing)
   masking a deeper sunk-cost on the Replacement (B) body shape?
4. **Pivot triggers** — the trigger (a') / (a'') / (b) / (c) machinery
   in § "Direct over-k rigidity". Is it still calibrated correctly? In
   particular: piece (i.b)'s iter-134 prover lane shipped ≤ 600 LOC
   (the LOC trigger arm) and used the sheaf-level RHS — does that bind
   trigger (a') correctly, or is there a separate failure axis the
   strategy hasn't named?
5. **Alternative routes** not currently in the strategy. In particular:
   the fibre-free piece (i) reformulation, the ℙ¹-hedge analogist
   (scheduled iter-135–138), and the no-Frobenius / higher-Kähler-
   vanishing analogist (scheduled iter-135–138). Are these properly
   sequenced, or are they being deferred at a cost?

## Output

Standard strategy-critic report shape per `.archon/subagents/strategy-critic.md`.
Pay particular attention to the "iter-134 absorbed challenges" sub-section
of your report: name which iter-134 CHALLENGEs are now stale (settled),
which remain live and pending verification, and which need re-issue.
