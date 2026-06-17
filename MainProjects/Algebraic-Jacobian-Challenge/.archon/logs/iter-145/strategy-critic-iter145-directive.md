# Strategy-critic directive — iter-145

## Iteration

145

## Scope

Fresh-context strategy audit. Verdict per route: SOUND / CHALLENGE / REJECT. Pay particular attention to whether iter-144's chart-algebra pivot is honestly committed (not silently preserved as a parallel option) and whether the post-pivot end-state framing is internally consistent.

## STRICT CONTEXT DISCIPLINE

Read ONLY:

- `STRATEGY.md` (verbatim) at `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`
- `references/summary.md` at `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md`
- Blueprint chapter titles + one-line topic per chapter from `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/*.tex` (open each, read the `\chapter{...}` and first paragraph; that's it)
- The project goal as stated in `STRATEGY.md` § Project goal

You may NOT read:
- iter sidecars (`iter/iter-NNN/{plan,review,objectives}.md`)
- `task_pending.md`, `task_done.md`, recent prover task results
- `PROJECT_STATUS.md`, `proof-journal/`
- recent review reports

## Specific iter-145 question (pre-committed at iter-144 close)

**The iter-144 chart-algebra pivot re-verification.** STRATEGY.md was substantively edited iter-144 with 5 edits (per `iter/iter-144/plan.md` § Iter-144 STRATEGY.md edits — but you do NOT read the sidecar; you read STRATEGY.md fresh and audit it on its own merits). Specifically: § "Iter-144 chart-algebra pivot — COMMITTED" + § Iter-145+ chart-algebra obligations + § Iter-150 over-k vs over-`k̄` sunk-cost guardrail. The iter-141 strategy-critic flagged a sunk-cost-shaped "preservation-of-bundled" framing; iter-145 must verify the chart-algebra pivot is honestly committed in the prose, not silently undercut.

Questions:

1. **Internal consistency of the chart-algebra pivot.** Does STRATEGY.md present chart-algebra as the committed route for piece (ii)+(i.c)+(iii) with bundled-route artefacts honestly demoted to "auditable record"? OR does the prose still treat the bundled route as a parallel option / "preserved for future re-prioritisation"? If the latter, that is the iter-141 anti-pattern recurring and should be CHALLENGED.

2. **Zero-sorry PROVISIONAL end-state under chart-algebra.** STRATEGY.md says chart-algebra preserves zero-sorry PROVISIONAL at the lower envelope (no residual named-gap on piece (iii)). Is this honestly defended? Does it require any new Mathlib gaps that chart-algebra introduces and STRATEGY.md doesn't list (in § Mathlib gaps & new material)?

3. **The M2.a `df = 0` derivation chain.** Iter-144 added a three-layer bullet to § Soundness rules articulating the chain (chart-local Kähler-derivation + char-p Frobenius-iteration via `RingHom.iterateFrobenius_comm` + no-Serre-duality). Audit this bullet on its merits: is the chart-local argument actually char-0-tractable? Does the Frobenius-iteration patch in char-p actually compose with the chart-local argument as claimed? Is the no-Serre-duality claim sound (or does the chain secretly invoke `H^0(C, Ω_C) = 0`)?

4. **M3 Route A commitment hygiene.** STRATEGY.md commits M3 to Route A per iter-144 user-hint. The iter-123 audit underpinning the LOC estimate is 21 iters old. Iter-145 dispatches `mathlib-analogist-m3-route-a-refresh-iter145` in parallel with you. Independent of that refresh: is the Route A commitment surface-level honest in STRATEGY.md? Any "PR-and-wait" residue you can spot? Any unexamined dependency on Mathlib pieces STRATEGY.md doesn't list?

5. **STRATEGY.md size and structure.** The canonical structure rule says "the whole file stays under ~250 lines / ~12 KB". STRATEGY.md is 666 lines. Iter-144 plan-agent flagged a compaction opportunity. Is the file's content load-bearing at 666 lines, or has historical decision context accumulated past what's actually informing current planning? You may recommend a compaction directive for the planner to absorb iter-145+; but flag the bound, don't enforce it.

6. **Iter-150 over-k vs over-`k̄` sunk-cost guardrail.** STRATEGY.md commits to iter-150 dispatch of a fresh-context strategy-critic with "one question — If a fresh mathematician audited the over-k vs over-`k̄` choice with iter-150 empirical data, would the choice still be made?" Is this guardrail well-formed? Will the iter-150 critic have enough independent data to answer? Or is it a soft trigger that always resolves to "default-keep"?

7. **Iter-145 reverse-burden check on bundled route preservation.** STRATEGY.md preserves Route 1 (bundled piece (i.b) Step 2 d_app + IsIso + Main; ~600 LOC of sorry-bodied scaffolding). The iter-144 plan says "preserved as auditable record". Reverse burden: under iter-141 strategy-critic precedent (don't preserve bundled framing as silent option), would a fresh mathematician argue these artefacts should be **deleted from the tree** to enforce the chart-algebra commitment? OR is "auditable record" a legitimate disposition? Surface the trade-off; the planner will decide. CHALLENGE if you think deletion is the honest call; SOUND if "auditable record" is defensible.

## Output expectations

Per dispatcher_notes strategy-critic descriptor: emit per-route audit (SOUND / CHALLENGE / REJECT) with reasoning. Mandatory: at least one rebuttal-or-update item per CHALLENGE. Report goes to `task_results/strategy-critic-iter145.md`.

## What NOT to do

- Do NOT read iter sidecars, task_pending.md, task_done.md, prover reports, review reports.
- Do NOT silently sign off; the iter-141 strategy-critic missed the "preservation of bundled framing" sunk-cost pattern — your job is to do that audit again, fresh, on iter-144's edits.
- Do NOT recommend strategy pivots without verifying STRATEGY.md actually claims what you're challenging.
