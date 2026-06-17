# Strategy Critic Report

## Slug
iter178

## Iteration
178

## Routes audited

### Route: A — Picard scheme via FGA (positive-genus arm)

- **Goal-alignment**: PASS — `J := Pic⁰_{C/k}` is the canonical Albanese / Jacobian object for positive genus and matches the protected signature `Jacobian C : Over (Spec (.of k))`.
- **Mathematical soundness**: PASS — Kleiman §4–§5 + Nitsure §5 + Milne III §6 is the standard route; A.1 → A.2 → A.3 → A.4 dependency chain is mathematically faithful.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: no — every UNOWNED-in-Mathlib piece (RelativeSpec, FlatteningStratification, Quot, GroupScheme.IdentityComponent, Sym^g) has an explicit project-side path with LOC band and Iters-left, not "deferred upstream".
- **Effort honesty**: reasonable on most rows after iter-177's revision (A.4.a 40–80 iters, A.2.b.iii 36–72 iters, etc.) — but **A.1.c is internally inconsistent**: `Iters left ~4–8`, `~300–500 LOC · ~30/it`, which arithmetically demands ~10–17 iters; the iter band should bump to ~10–17 or the rate needs justification.
- **Parallelism under-exploited**: no — A.4.b explicitly noted independently startable; A.1.b/A.1.c skeletons landed and gated only on A.1.a body.
- **Verdict**: CHALLENGE — single LOC/iter inconsistency on A.1.c row must be corrected (raise Iters left to ~10–17, or document the higher realized rate that makes ~4–8 plausible).

### Route: C — genus-0 rigidity via Milne §I.3

- **Goal-alignment**: PASS — for genus 0 the universal Albanese object is `Spec k` (trivial group scheme), exactly the terminal-object case carved out by the `by_cases h : genus C = 0` split.
- **Mathematical soundness**: PASS — Milne §I.3 (Rigidity Lemma + Cor 1.5 + Cor 1.2) is char-general; the `𝔾_m`-scaling shortcut for `ℙ¹→A const` is well-known.
- **Sunk-cost reasoning detected**: no.
- **Infrastructure-deferral detected**: **yes — chart-bridge body for `gmScalingP1`** is currently staged behind temporary axioms `gmScalingP1_*_temp`. The deferral IS required by the goal (genus-0 arm cannot close without it) but has a concrete project-side plan (chart-bridge body OR separated-locus alt route) and a concrete timeline (iter-182 status review). Below the CHALLENGE threshold because it has both plan and deadline; flagged here to keep visible.
- **Effort honesty**: reasonable; the RR.1–RR.4 bands (4–8 / 8–12 / 8–12 / 8–12) match the realized ~30/it pace on the active body.
- **Parallelism under-exploited**: no — RR.1 marked "parallel-startable".
- **Verdict**: SOUND, with a watch on the iter-182 temp-axiom retirement deadline (see Infrastructure-deferral findings below).

## Format compliance

- **Size**: 171 lines / 12037 bytes — within line budget, at byte budget cap (target ~12 KB).
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: **yes**. Concrete examples (verbatim):
  - `iter177 finding 1` (line 22, in the explanatory preamble to the table)
  - `chapter + skeleton landed iter-176` (A.1.c row)
  - `iter-177 NEW skeleton` (A.4.a, A.4.d.ii, RR.4 rows)
  - `skeleton landed iter-175` (A.4.b row)
  - `HARD STOP fired iter-177` (genus-0 chart-bridge row)
  - `(5 iters realized)` (chart-bridge row)
  - `Lane A1 HARD STOP FIRED iter-177` + `iter-176 returned the trigger condition` + `iter-177 dispatches Lane GM-AXIOM` (Open Q block)
  - `Iter-178+ planner re-evaluates`, `iter-178+ plan dispatches a mathlib-analogist consult`
  - `Clarified scope per strategy-critic finding 3`
  - `(iter-177 skeleton)` annotations sprinkled across the `Mathlib gaps & new material` list (A.4.a, A.4.b, A.4.c, A.4.d.ii)

  Forward-looking trigger references like `Trigger: iter-182 status review` are acceptable (they name a future reversal threshold, not history); the long tail above are pure history-in-status and are exactly what the canonical skeleton excludes.

- **Accumulation detected**: no — no completed-and-still-listed phases or excised routes.
- **Table discipline**: PASS — table form intact, both LOC figures present in every cell, single-line cells.
- **Format verdict**: DRIFTED — same finding as iter-177 (item 4), only partially addressed. The size/headings/table-discipline pieces of finding 4 are now fixed; the per-iter-reference piece is not.

## Infrastructure-deferral findings

### Deferred: chart-bridge body for `gmScalingP1` (`σ_×:ℙ¹×𝔾_m→ℙ¹`)

- **Required by goal**: yes — the genus-0 arm produces the witness object `Spec k` trivially, but `Jacobian.exists_unique_ofCurve_comp` for genus 0 needs the rigidity statement `rigidity_genus0_curve_to_grpScheme`, which (per Milne §I.3) goes through the Cor 1.5 chain, which needs the `𝔾_m`-scaling morphism `σ_×`. Without `σ_×` the genus-0 universal property is not provable in the current strategy.
- **Current plan for building it**: TWO plans recorded. (a) Original chart-bridge body, waiting on a Mathlib `cover-vs-Proj.awayι` API decision (mathlib-analogist consult dispatched iter-178). (b) Pre-committed replacement: separated-locus universal extension (extend `𝔸¹→A` via valuative criterion of properness on `A`, then collapse on a closed fibre); mathlib-analogist consult also dispatched iter-178.
- **Timeline**: concrete — iter-182 status review. If the temp axioms cannot be retired by then (~5 iters), replacement route (b) ships in place of (a).
- **Verdict**: CHALLENGE (not REJECT, because plan AND deadline are concrete). Two action items the planner must keep visible:
  1. The end-state contract is "kernel-only axioms"; temp axioms `gmScalingP1_*_temp` violate this contract while alive. Restate this contract in the iter-178 plan so the deadline is internalised, not just recorded.
  2. The alt-route "collapse on a closed fibre" wording is under-specified — the valuative criterion gives extension of a rational map to a morphism, but going from "morphism" to "constant" still needs a separate constancy argument (rigidity, fibre-rigidity, or a divisor argument). The mathlib-analogist consult should confirm which constancy argument the alt route uses, not just confirm the extension step.

## Sunk-cost flags

(None this iter — strategy presents routes on current merits.)

## Must-fix-this-iter

- Route A: CHALLENGE — A.1.c row's `Iters left ~4–8` against `~300–500 LOC · ~30/it` arithmetically resolves to ~10–17 iters. Either bump the iter band, or document a per-row velocity (e.g. `~50/it` on RelPic skeleton work) that makes ~4–8 plausible. Cell-internal consistency was finding 1's whole point in iter-177; A.1.c slipped through.
- Format: DRIFTED — strip per-iter references from `## Phases & estimations` row annotations (e.g. `chapter + skeleton landed iter-176`, `iter-177 NEW skeleton`, `(5 iters realized)`), from the explanatory paragraph at lines 22–26 (`iter177 finding 1`), from the Open Q rebuttal block (`Lane A1 HARD STOP FIRED iter-177`, `iter-176 returned ...`, `iter-178+ planner re-evaluates`), and from the per-bullet annotations in `## Mathlib gaps & new material` (`iter-177 skeleton`, `skeleton landed iter-175`). Forward triggers like `Trigger: iter-182 status review` are fine to keep. The history belongs in `iter/iter-NNN/plan.md`. If a row's status needs to communicate "skeleton landed, body pending", say `skeleton landed; body pending` without naming the iter.
- Genus-0 infrastructure-deferral CHALLENGE — `gmScalingP1` body required by goal, temp axioms violate end-state contract; restate the iter-182 retirement deadline in the iter-178 plan and have the mathlib-analogist consult confirm the alt-route's constancy step, not just its extension step.

## Overall verdict

The strategy is fundamentally sound and the iter-177 findings are mostly addressed: LOC bands have been widened to honest per-row figures, the user-gate rebuttal is supportable under the loop's "you decide; you never wait" rule (asynchronous USER_HINTS.md override channel preserves user agency), the `Sym^g` framing is now coherent (rejected AS Jacobian object, still used in A.4.d.i for Albanese UP wiring), and the separated-locus replacement candidate is scoped with both a feasibility consult dispatched iter-178 and a concrete iter-182 reversal trigger. Two CHALLENGE items remain: (a) A.1.c's iter band is arithmetically inconsistent with its LOC/velocity figures and needs the same per-row honesty pass that fixed the other rows, and (b) the per-iter-reference half of iter-177's format finding is still unresolved — STRATEGY.md still carries `iter-175` / `iter-176` / `iter-177` / `iter-178+` annotations throughout row cells and the Open Q block, which is exactly the canonical-skeleton violation flagged previously. The strategy defers the chart-bridge body for `gmScalingP1`, which is required for the stated goal; this deferral has a concrete plan and a concrete iter-182 deadline so it is below the REJECT threshold, but the planner should restate the kernel-only-axioms end-state contract in the iter-178 plan so the deadline is internalised rather than merely recorded, and the mathlib-analogist consult should confirm the alt-route's constancy step (not just its extension step) before iter-182.
