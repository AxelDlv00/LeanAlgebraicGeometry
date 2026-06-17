# Directive: blueprint-writer — AbelianVarietyRigidity Proj.appIso expansion

## Target chapter

`blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Background

Lane E (file `AlgebraicJacobian/AbelianVarietyRigidity.lean`) has had its
Part 2 body close blocked for 4 consecutive iters (iter-188/189/190/191).
Each iter the prover hits the same `Proj.appIso` evaluation step on the
chart-1 basic open and exceeds budget.

Per `blueprint-reviewer iter192` finding MF-1 (FAIL), the chapter
documents the III.c separated-locus route with `IsClosedImmersion.lift_iff_range_subset`
and range containment, but the **`Proj.appIso` evaluation step
(`isLocElem ↦ [X_0/X_1] ↦ 1`)** is missing from the prose. Without it the
prover cannot construct the explicit ring-map element.

Per `progress-critic route192` STUCK verdict, the corrective is:

> blueprint expansion — the `Proj.appIso` chart-1 evaluation has hit the
> LOC budget wall 4 consecutive times. A `[prove]` mode dispatch will
> hit the same wall. The plan agent must first expand the blueprint
> chapter by extracting the `Proj.appIso` basic-open evaluation as a
> **named standalone sub-lemma** with its own `\lean{...}` hint
> (e.g., `iotaGm_chart1_appIso_eval : ...`).

## Required edit (precise)

In `AbelianVarietyRigidity.tex`, **section III.c** (separated-locus
chart-bridge), where the proof prose describes the lift through
`pullbackSpecIso → Spec.map → chart-ring iso → Proj.awayι`:

1. Extract a **named standalone sub-lemma** capturing the
   `Proj.appIso` evaluation. Suggested label
   `lem:iotaGm_chart1_appIso_eval` with `\lean{...}` hint pointing to
   a Lean-side helper name that the prover can target. Suggested Lean
   name: `AlgebraicGeometry.iotaGm_chart1_appIso_eval`.

2. Provide a 3-5 sentence proof sketch explaining the evaluation:
   - The `Proj.appIso` for the homogeneous chart map
     `Proj.awayι (X_1) : Spec(Away 𝒜(X_1)) → Proj 𝒜` sends the
     local-section `isLocElem` (a section in `Γ(Spec(Away 𝒜(X_1)), ⊤)`)
     to the homogeneous-localization element `[X_0/X_1] ∈
     HomogeneousLocalization.Away 𝒜 (X_1)` (the ratio of two
     degree-1 generators).
   - The chart-1 ring identification (the iso
     `gmScalingP1_cover_X_iso kbar 1`) then takes this element to the
     polynomial-ring generator (after `Algebra.TensorProduct.lid`
     elimination of the trivial `Gm` factor at the identity section).
   - The pre-image under the `pullbackSpecIso` factor is `1` in the
     codomain ring (because the `Gm`-twist of the identity section
     leaves the chart-1 generator invariant).

3. Reference relevant Mathlib helpers: `Proj.appIso`, `Proj.appIso_apply`,
   `HomogeneousLocalization.Away`, `IsOpenImmersion.lift_app`.

4. After the new sub-lemma block, update the existing III.c proof
   prose to **explicitly cite** `\cref{lem:iotaGm_chart1_appIso_eval}`
   at the step where the ring-map element threading is described.

## Out of scope

- Do NOT add `\leanok` or `\mathlibok` markers; these are managed by
  `sync_leanok` and the review agent respectively.
- Do NOT modify the existing III.a / III.b coverage or the chapter's
  high-level structure.
- Do NOT make changes outside `AbelianVarietyRigidity.tex`.

## Report

Write a short summary to `task_results/blueprint-writer-avr-projappiso-expand.md`
naming the lines added + the new lemma label + the Lean-side helper
name the prover should target.
