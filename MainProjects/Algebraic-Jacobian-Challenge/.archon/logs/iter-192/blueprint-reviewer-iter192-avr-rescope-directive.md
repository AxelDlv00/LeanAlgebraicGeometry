# Directive: blueprint-reviewer (scoped re-review)

## Scope

You are doing a **single-chapter rescope review** as part of the HARD
GATE same-iter fast path. Review **only**:

`blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Background

The full iter-192 blueprint-reviewer dispatch (slug `iter192`) flagged
this chapter as **MF-1 (FAIL)** — the `Proj.appIso` evaluation step
(`isLocElem ↦ [X_0/X_1] ↦ 1`) was missing from III.c prose, blocking
Lane E Part 2 prover dispatch.

This iter the `blueprint-writer avr-projappiso-expand` subagent has
landed a writer edit that extracts the `Proj.appIso` chart-1 evaluation
as a named standalone sub-lemma:

- New block at lines 1146-1219: `\lemma` /
  `\label{lem:iotaGm_chart1_appIso_eval}` /
  `\lean{AlgebraicGeometry.iotaGm_chart1_appIso_eval}` with a 5-sentence
  proof sketch referencing `Proj.appIso`, `Proj.appIso_apply`,
  `HomogeneousLocalization.Away`, `Algebra.TensorProduct.lid`,
  `IsOpenImmersion.lift_app`.
- Revised III.c step 4 (lines 1661-1670) with `\cref{lem:iotaGm_chart1_appIso_eval}`
  citation explaining the budget motivation.

## Task

Confirm the HARD GATE for `AbelianVarietyRigidity.tex` is now **CLEARED**:

- Is the chapter `complete + correct`?
- Does the new `lem:iotaGm_chart1_appIso_eval` block provide enough
  detail for a `[fine-grained]` prover to construct the Lean-side
  helper `AlgebraicGeometry.iotaGm_chart1_appIso_eval`?
- Is the III.c prose update at step 4 sufficient to direct a prover
  to use the new sub-lemma when closing the `iotaGm_chart1_composition_isOpenImmersion`
  body?
- Are there any leftover MF-1-style omissions on the chart-1
  evaluation route?

## Required output

A short report (1-2 pages max) with:

1. HARD GATE verdict: PASS / PARTIAL / FAIL.
2. Any remaining must-fix items on this chapter specifically.
3. Recommended prover dispatch mode for Lane E Part 2: `prove` /
   `fine-grained` / mathlib-build / defer.

Do NOT re-review other chapters; this is a single-chapter rescope.

Report to `task_results/blueprint-reviewer-iter192-avr-rescope.md`.
