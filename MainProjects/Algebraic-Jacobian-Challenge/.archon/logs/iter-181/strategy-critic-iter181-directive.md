# strategy-critic directive (iter-181, slug: iter181)

This is the scheduled iter-181 re-dispatch per the iter-178 commitment recorded in `PROGRESS.md`. STRATEGY.md is being amended this iter to reflect the iter-180 outcome (chart-bridge axioms RETIRED, 2 honest sorries remain on chart-bridge sub-targets). I want a fresh-context audit of whether the long-arc strategy is still well-shaped.

## What's in your bundle

- `STRATEGY.md` — current copy at the project root (verbatim).
- `references/summary.md`.
- Blueprint chapter titles + one-line topic per chapter (you may scan `blueprint/src/chapters/*.tex` for the `\chapter{...}` line).
- Project goal: formalise Christian Merten's Jacobian challenge — see top of `STRATEGY.md`.

## What's explicitly **not** in your bundle

- Iter sidecars (`iter/iter-NNN/{plan,review,objectives}.md`).
- `task_pending.md`, `task_done.md`, recent prover task results.
- Per-iter narrative.

## Things to challenge specifically

1. **Chart-bridge `Iters left` re-estimation**. The row currently reads "1 (axiom-laundered; iter-181 RETIRE-OR-ESCALATE)". Post-iter-180, the 2 TEMP axioms are RETIRED and the PRIMARY lemma is axiom-clean, but 2 honest sorries remain (`gmScalingP1_chart_agreement` cross case + `gmScalingP1_collapse_at_zero`). The planner intends to re-estimate to ~2–4 iters. Audit whether this is honest given that (a) the recipe is empirically validated twice on the load-bearing lemma, and (b) the remaining sorries require different ring-level identities (cocycle bridge) NOT the `respectTransparency` recipe.
2. **Genus-0 alternative route — pre-committed "separated-locus universal extension"**. The strategy still lists this in Open strategic questions as a replacement candidate with deadline iter-182 status review pending analogist confirmation of the constancy step. Given iter-180 closed the PRIMARY axiom-clean, is the alternative route still warranted, or should it be downgraded from "pre-committed replacement candidate" to "off-path fallback"?
3. **Route A axiomatise-then-replace lever**. The strategy currently lists this as TRACKED, NOT COMMITTED with trigger "Route A velocity stays ~0/it on file-skeleton lanes for two consec iters." iter-179 + iter-180 saw RelativeSpec progress (1 sorry closed iter-180 Lane C). Is the trigger condition met or not?
4. **A.4.c row (`Albanese/Thm32RationalMapExtension.lean`)**. iter-180 Lane G honest-deviated from the directive — Lemma 3.3 alone insufficient for `CodimOneFree`; the codim-≥2 piece of Milne 3.1 must be exposed as a standalone lemma first (currently bundled inside `extend_of_codimOneFree_of_smooth`). Does the A.4.c row need a sub-phase split (codim-≥2 exposure → CodimOneFree-helper → Thm 3.2 assembly), or is this within current row's estimate?
5. **Critic instruction discipline**. The auditor surfaced an inflated "axiom-clean" claim (Lane E inherits transitively from upstream `eulerCharacteristic_eq_degree_plus_one_minus_genus` sorry). Should the strategy's iter-181 directive shape adopt a "transitively-clean / kernel-clean modulo upstream" distinction to prevent the pattern recurring?
6. **Goal correctness check**. The protected `Jacobian.*` signatures take `[Field k]` only (no `CharZero`). Genus-0 arm is char-general via Milne §I.3 + the Decision-4 recipe. Does the current `Phases & estimations` table honestly reflect that the Genus-0 arm is far closer to closure (~3–6 iters now estimated) than the Positive-genus arm (~280–500 iters per the audited Route A)?

## Soundness anchors to verify

- The Goal section's wording: "Christian Merten's Jacobian challenge … nine protected declarations". Audit count: 1 in `Genus.lean` + 5 in `Jacobian.lean` + 3 in `AbelJacobi.lean` = 9. Check.
- Two-arm spine: pointed vs. unpointed; the witness OBJECT `J` is unconditional. Genus-0 = `Spec k` trivial. Positive-genus = `Pic⁰_{C/k}` via Route A. Check.

## Reminder of strictness

When you find the project chose a parallel API where Mathlib has the canonical idiom, treat your verdict as a refactor obligation, not a suggestion. When you find a phase's `Iters left` cell is unanchored from its realized velocity, flag as CHALLENGE. When the strategy's narrative dresses up sunk cost (e.g. defending the chart-bridge route after the recipe-aligned closure), be willing to recommend route-swap.

Report under `task_results/strategy-critic-iter181.md` (auto-written by the wrapper).
