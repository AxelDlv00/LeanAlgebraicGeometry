# Blueprint reviewer directive — iter-194 fast-path (scoped to 2 chapters)

You are dispatched for the iter-194 **same-iter fast-path** scoped
blueprint review. The full whole-blueprint review (slug `iter194`)
already completed earlier this iter and flagged 2 HARD GATE failures:

- Lane H — `RiemannRoch_H1Vanishing.tex` (WD-1, iter-193 substrate
  helpers lacked `\lemma` blocks with `\lean{...}` pins).
- Lane M↓ — `Albanese_CodimOneExtension.tex` (WD-2, 3-item corrective
  on `lem:smooth_to_regular_local_ring` NOTE + iter-193 Stage 5a/5b
  helper pins + `thm:weil_divisor_obstruction` `\lean{...}` pin).

Iter-194 plan-phase dispatched 2 blueprint-writers that have now
landed:

- `blueprint-writer h1v-substrate-pins`: added 2 `\lemma` blocks
  + `\lean{...}` pins to `RiemannRoch_H1Vanishing.tex` and removed the
  stale "ancillary lemmas not given their own pin" disclaimer.
- `blueprint-writer codimoneext-stage6-pins`: addressed WD-2's 3-item
  corrective on `Albanese_CodimOneExtension.tex`.

## Scope (NARROW — only these 2 chapters)

Re-audit **ONLY** the following 2 chapters:

1. `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex` — verify that
   WD-1's specific corrective items are addressed:
   - 2 new `\lemma` blocks with `\lean{...}` pins exist (verify against
     the actual Lean declarations in
     `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`).
   - The stale "Out of Scope" disclaimer is removed.
2. `blueprint/src/chapters/Albanese_CodimOneExtension.tex` — verify
   that WD-2's specific corrective items are addressed:
   - M-1: NOTE block on `lem:smooth_to_regular_local_ring` documenting
     the Stacks 00TT gap.
   - M-2: 2 new `\lemma` blocks with `\lean{...}` pins for iter-193
     Stage 5a/5b helpers (`module_free_kaehlerDifferential_localization`
     + `rank_kaehlerDifferential_localization_eq_relativeDimension`).
   - M-3: `\lean{...}` pin restored on `thm:weil_divisor_obstruction`
     (or documented gap if no Lean correspondent exists).

**Do NOT audit other chapters.** The whole-blueprint audit (slug
`iter194`) already cleared the rest.

## Per-chapter verdict format

For each of the 2 chapters, render exactly:

```yaml
- chapter: <slug>
  complete: <true | partial | false>
  correct: <true | partial | false>
  must-fix-this-iter: <list; empty if the writer's corrective is
    complete; otherwise enumerate residual items>
  notes: <one short paragraph on any residual observation>
```

## HARD GATE decision

For each chapter, render a one-line **HARD GATE** verdict:

- `H1Vanishing` HARD GATE: ✅ PASS / ❌ FAIL
- `CodimOneExtension` HARD GATE: ✅ PASS / ❌ FAIL

A PASS verdict for both clears Lane H + Lane M↓ to enter iter-194
prover dispatch via the same-iter fast path (the planner will add them
back to PROGRESS.md `## Current Objectives`). A FAIL on either keeps
that lane deferred to iter-195.

## Outputs

Write your report to
`.archon/task_results/blueprint-reviewer-iter194-fastpath.md`.

Render:
1. The 2 per-chapter verdict blocks (yaml).
2. The 2 HARD GATE verdicts.
3. Any residual issues (must-fix-this-iter list).

Do NOT re-audit chapters beyond the 2 named above.

## Time budget

This is a narrow scoped re-review; expected ~3-5 min sonnet.
