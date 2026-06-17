# Iter-158 plan-agent run

## Headline outcome

Iter-158 is the **soundness-repair iter**. The iter-157 prover landed `rigidity_lemma`
as "proven modulo one geometric sorry", but the iter-157 review (two independent
subagents) found the decomposition **UNSOUND**: the helpers `rigidity_core` and
`rigidity_eqOn_dense_open` had **dropped the collapse hypothesis `_hf`** and were FALSE
as stated (counterexample `f = fst` on `X=Y=Z=ℙ¹`, all instances satisfied); the proof
never consumed `_hf` (laundering a true headline through an unsatisfiable sorry).

This iter executed the prescribed corrective end-to-end via the **sanctioned same-iter
fast path** and re-aimed the prover lane:

1. `refactor thread-hf` — re-signed `rigidity_eqOn_dense_open` + `rigidity_core` to carry
   `(y₀) (z₀) (_hf)`, threaded `_hf` through `rigidity_lemma`. Now
   `rigidity_eqOn_dense_open` is TRUE as stated; the categorical + gluing layers are
   genuinely closed. Build GREEN (8332); axiom-clean (`{propext, sorryAx, Classical.choice,
   Quot.sound}`, sorryAx only via the one honest sorry); `rigidity_snd_lift` stays
   sorryAx-free; `_hf` consumed (no dead-hypothesis).
2. `blueprint-writer eqon-block` — added `lem:rigidity_eqOn_dense_open` (collapse
   hypothesis explicit + `f=fst` counterexample) + `rmk:rigidity_lemma_decomposition`,
   so the dropped-hypothesis regression cannot recur. Reused the in-file Mumford verbatim
   quote.
3. `blueprint-reviewer avr-recheck` (scoped fast-path) — `AbelianVarietyRigidity.tex`
   **complete + correct, 0 must-fix → HARD GATE CLEARS**.
4. **Prover lane retargeted** from the now-closed `rigidity_lemma` to the genuine
   geometric heart `rigidity_eqOn_dense_open` (progress-critic's must-fix dispatch catch).

Net: global sorry count unchanged (4→4 in-file), but the unit of progress is
**soundness** — iter-157's laundering became a verified-sound chain with all residual
geometry isolated in one true-as-stated sorry.

## Subagent verdicts (absorbed)

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| refactor | thread-hf | COMPLETE | `_hf` threaded; build green; axiom-clean; `_hf` consumed. The two false helpers are now true. |
| progress-critic | rigidity-soundness | **CONVERGING (qualified)** | Not churn: zero new helpers, re-signed + proved existing ones; false→true conversion is the genuine unit. Greenlights the prover. **Binding fallback:** if the lane returns PARTIAL because the two bridges must be BUILT not FOUND, OR iter-159 is prover-free on this route, escalate to a `mathlib-analogist` consult scoped to the two bridges before another prover round. **Dispatch must-fix:** retarget lane from closed `rigidity_lemma` → `rigidity_eqOn_dense_open` (done). |
| blueprint-writer | eqon-block | COMPLETE | `lem:rigidity_eqOn_dense_open` + decomposition remark added; markers/`% NOTE:`/deferred blocks untouched. No strategy-modifying findings. |
| blueprint-reviewer | avr-recheck | **PASS — gate clears** | Chapter complete+correct; new block's `\lean{}` + hypotheses match the corrected Lean signature; deferred/headline blocks un-regressed. |

## Decision made

**Repair the unsoundness (refactor thread-`_hf`), then fire the prover at the corrected
geometric heart `rigidity_eqOn_dense_open` — do NOT pivot the route.**

- **Why.** The route-(c) commitment (char-free AV rigidity) is unchanged and was
  re-affirmed sound by the iter-157 strategy-critic; the iter-157 failure was a Lean-side
  laundering error, not a strategic dead end. The fix is exactly the corrective both
  review subagents prescribed (thread `_hf`), and it is mechanical (signature wiring).
  The categorical + gluing layers are now permanent assets; the entire residual content
  is one true, hypothesis-complete sorry with two concretely-located Mathlib bridges.
- **LOC/risk trade-off.** The refactor was ~10 LOC of wiring (cheap). The remaining
  `rigidity_eqOn_dense_open` is genuine multi-iter geometry, but it is necessary regardless
  of route and shared with Route A's Albanese UP — not throwaway.
- **Cheapest signal that would reverse it.** If the prover reports that bridge 1 (the
  monoidal-`snd`-as-`Limits.pullback.snd` identification + `IsClosedMap` transport) needs a
  BUILT lemma absent from Mathlib, that does not reverse route (c) — it triggers a scoped
  `mathlib-analogist` consult (per the progress-critic fallback), still on route (c).

## Hard checkpoint status (progress-critic, iter-157 → iter-158)

iter-157's binding checkpoint ("iter-158 MUST fire a prover at the rigidity lane") is
**SATISFIED**: the lane fires this iter at `rigidity_eqOn_dense_open` (the honest residual
of the lane). Carried forward to iter-159 (see `task_pending.md`): a prover-free iter-159
on this route OR a bridges-must-be-built PARTIAL → `mathlib-analogist` consult.

## Subagent skips

- strategy-critic: STRATEGY.md SHA unchanged from iter-157 (no edit this iter); the iter-157
  CHALLENGE on route-(c) architecture was addressed in the iter-157 STRATEGY.md re-cost (no
  longer live); this iter is a Lean-side soundness repair within the committed route, no
  strategic change. Skip per the descriptor's stated conditions.

## Tool substitutions

- None.
