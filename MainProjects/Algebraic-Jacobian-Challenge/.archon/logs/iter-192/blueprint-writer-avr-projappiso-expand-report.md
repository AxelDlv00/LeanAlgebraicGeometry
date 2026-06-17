# Blueprint Writer Report

## Slug
avr-projappiso-expand

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Changes Made

- **Added lemma** `\lemma`/`\label{lem:iotaGm_chart1_appIso_eval}`/`\lean{AlgebraicGeometry.iotaGm_chart1_appIso_eval}` (lines 1146-1219, ~74 lines)
  — extracts the `Proj.appIso` chart-1 evaluation as a named standalone sub-lemma:
    the canonical local-section `isLocElem ∈ Γ(Spec(Away 𝒜 X₁), ⊤)` maps via
    `(Proj.appIso (Proj.awayι X₁)).inv` to the homogeneous-localisation ratio
    `[X₀/X₁] ∈ HomogeneousLocalization.Away 𝒜 X₁`; composed with the chart-1 ring
    iso `forward₁` (\cref{def:proj_chart_ring_iso}) it goes to the
    `MvPolynomial {*} k̄` generator `u`; pre-composed with the `pullbackSpecIso`
    bridge of \cref{def:gmscaling_chart} with the Gm-twist collapse via
    `Algebra.TensorProduct.lid` it lands at `1 ∈ k̄`.
  - Proof sketch added: Y; 5-sentence sketch referencing the Mathlib helpers
    `Proj.appIso`, `Proj.appIso_apply`, `HomogeneousLocalization.Away`,
    `Algebra.TensorProduct.lid`, `IsOpenImmersion.lift_app`, and the
    project-side consumer `iotaGm_chart1_composition_isOpenImmersion` /
    `iotaGm_r_1_fac` (the iter-190/191 lift identity).
  - Block is Archon-original (no external textbook source) — citation discipline
    is satisfied by the bespoke comment header (no fabricated `% SOURCE QUOTE`).

- **Revised** III.c step 4 of \cref{lem:gmscaling_chart_agreement} (lines 1661-1670)
  — added an explicit `\cref{lem:iotaGm_chart1_appIso_eval}` citation at the
    "single-chart content" discharge step. The new prose names the chart-1
    instance, points out that the per-component equality threads through the
    new sub-lemma's `isLocElem ↦ [X₀/X₁] ↦ 1` evaluation, explains the budget
    motivation (iter-188 through iter-191 hit the budget wall on inline
    `(Proj.appIso).inv` evaluation), and notes the chart-0 instance is the
    symmetric statement.

## New Lean-side helper the prover should target
`AlgebraicGeometry.iotaGm_chart1_appIso_eval`

This is the named standalone hook the iter-192 `[prove]` dispatch must target to
break the iter-188-191 budget wall on
`AlgebraicGeometry.iotaGm_chart1_composition_isOpenImmersion` (file
`AlgebraicJacobian/AbelianVarietyRigidity.lean`). The expected statement type
(Lean-side) is the global-sections evaluation
`(iotaGm_chart1_composition).appTop isLocElem = 1`, with explicit dependence on
`Proj.appIso`, `Proj.appIso_apply`, the chart-1 ring iso, and
`Algebra.TensorProduct.lid`.

## Cross-references introduced
- `\uses{def:proj_chart_ring_iso, lem:chart_ring_iso_preserves_algebraMap}` on
  the new lemma block — both targets exist in this same chapter (defined earlier
  on lines 995-1026 and 1091-1145 respectively).
- `\cref{lem:iotaGm_chart1_appIso_eval}` from inside III.c step 4 of
  \cref{lem:gmscaling_chart_agreement} — forward reference within the same
  chapter (the new lemma sits earlier, near the chart-ring helpers, so this
  resolves as a backward `\cref`).

## References consulted
No external `references/<file>.md` was opened or read for this directive: the
new sub-lemma is Archon-original (project-bespoke composition of Mathlib
helpers, namely `Proj.appIso`, `Proj.appIso_apply`, `IsOpenImmersion.lift_app`,
`Algebra.TensorProduct.lid`). No `% SOURCE QUOTE` is written because no
external textbook authority is cited; the citation discipline rule explicitly
covers Archon-original blocks by allowing the source lines to be omitted.

## Macros needed (if any)
None. All notation used (`\Spec`, `\Proj`, `\mathrm`, `\mathtt`, `\mathbb`,
`\cref`, `\fatsemi`, `\bar k`) is already in the chapter's macro environment.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent

- The new lemma sits between `lem:chart_ring_iso_preserves_algebraMap` (line
  1145) and `lem:projlinebar_isReduced` (line 1220), grouping it with the other
  chart-ring / Proj-side helpers. It does NOT carry `\leanok` — sync_leanok will
  add it once the prover provides a body (per the writer's marker-no-touch rule).
- The chart-0 symmetric statement is mentioned in the III.c prose but is NOT
  extracted as its own sub-lemma. The iter-185-191 stuck-loop was specifically
  on the chart-1 evaluation (per the directive); if a future iter's prover
  finds the chart-0 case also blocks, a parallel
  `lem:iotaGm_chart0_appIso_eval` extraction may be warranted, but that should
  be a separate directive.
- The III.c step-3 prose still mentions
  `IsClosedImmersion.lift_iff_range_subset` as the targeted Mathlib helper,
  with an iter-188 review NOTE flagging that variant as NOT shipped at
  Mathlib commit b80f227. That note is OUTSIDE the iter-192 directive scope;
  it remains as-is. The new `iotaGm_chart1_appIso_eval` sub-lemma is
  orthogonal to the `lift_iff_range_subset` Mathlib gap — it discharges the
  per-component (single-chart) ring-map step that follows after the
  range-containment factorisation lands.
- I did not touch `blueprint/lean_decls`; that file is outside my write-domain
  and (per project convention) is regenerated by a deterministic phase. The
  plan agent should verify the new `\lean{AlgebraicGeometry.iotaGm_chart1_appIso_eval}`
  hint is picked up on the next regeneration so the dependency graph stays in
  sync.

## Strategy-modifying findings
None. The new sub-lemma is a pure refactoring of the III.c prose — it
extracts a named hook the prover can target, without changing the
mathematical content of the route, the substrate hooks, or the cost estimate.
The III.c separated-locus route remains the iter-187 mandatory pivot; the
new sub-lemma is a structural waypoint within step 4 of that route.
