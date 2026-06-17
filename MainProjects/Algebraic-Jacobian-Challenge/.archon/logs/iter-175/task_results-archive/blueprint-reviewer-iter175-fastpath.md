# Blueprint Review Report

## Slug
iter175-fastpath

## Iteration
175

## Scope

Same-iter scoped re-review per directive. Two chapters audited:

1. `blueprint/src/chapters/AbelianVarietyRigidity.tex` — gates Lane A1 on
   `Genus0BaseObjects/GmScaling.lean`.
2. `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — gates Lane D on
   `RiemannRoch/WeilDivisor.lean`.

Every other chapter was audited in `iter175-whole` and is out of scope here
per the directive's explicit instruction. The third must-fix from
`iter175-whole` (Picard_RelativeSpec.tex stale `\leanok` markers) is
out-of-scope for this fast path; it is the deterministic `sync_leanok`
phase's responsibility per project CLAUDE.md and is queued to iter-176.

## Verification of the iter175-whole must-fix items

### `AbelianVarietyRigidity.tex` — `g0bo-helper-pins` writer landings

Both iter-174 helper pins flagged by `iter175-whole` are now present on
distinct, mathematically coherent lemma blocks:

- `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_algebraMap}` at
  line 1187, on the new lemma `lem:chart_ring_iso_preserves_algebraMap`
  ("Chart-ring iso preserves `algebraMap k`"). Block carries full prose,
  source comment characterising the cited Mathlib fact
  `HomogeneousLocalization.algebraMap_eq` (no external textbook quote — this
  is structural Mathlib infra, project-bespoke), `\uses{}` resolving to
  `def:proj_chart_ring_iso`, `lem:proj_chart_ring_iso_aux_left`,
  `lem:mvPoly_to_homogeneousLocalization_away_surjective` (all three present
  in the chapter), a proof sketch identifying it as the load-bearing input
  to Step (B) of `lem:gmscaling_chart_PLB_eq`.
- `\lean{AlgebraicGeometry.gmScalingP1_chart_PLB_eq}` at line 1441, on the
  new lemma `lem:gmscaling_chart_PLB_eq` ("Per-chart bridge
  `gmScalingP1_chart i ; P^1.hom`"). Block carries full prose, an explicit
  three-step proof reduction (A: collapse `Proj.awayι ; PLB.hom` via the
  project-side `awayι_comp_PLB_hom` bridge; B: merge `Spec.map`s using the
  iso's `algebraMap` preservation; C: chase source-side pullback isos via
  `pullbackSpecIso_hom_base`, `pullbackRightPullbackFstIso_hom_fst`,
  `pullbackSymmetry_hom_comp_fst`), a status paragraph naming the two
  residual scaffold sorries on the i=0/i=1 cases owing to a syntactic
  `Fin`-literal mismatch, and `\uses{}` resolving to `def:gmscaling_chart`,
  `def:gmscaling_cover`, `lem:chart_ring_iso_preserves_algebraMap`,
  `def:gaTranslationP1` (all four labels present in the chapter).

No regressions visible. The new lemmas integrate into the surrounding
prose without breaking adjacent blocks; the chapter's prose flow from
`def:proj_chart_ring_iso` through the chart-ring iso aux lemmas to the
chart-glue scaffold (`def:gmscaling_cover` → `def:gmscaling_chart` →
`lem:gmscaling_chart_agreement` → `lem:gmscaling_chart_PLB_eq` →
`lem:gmscaling_over_coherence` → `def:gaTranslationP1`) is coherent and
matches the iter-171/iter-174/iter-175 chart-glue split.

### `RiemannRoch_WeilDivisor.tex` — `weildivisor-doc-updates` writer landings

All three iter175-whole findings are closed:

- **`def:divisor_closed_point` Lean signature scope (lines 412–447).** New
  "Lean signature scope (iter-174 pin)" paragraph documents the junk-branch
  convention on `Scheme.WeilDivisor.ofClosedPoint`: junk-defined outside
  the codim-1 regime via a dependent `if`-branch on
  `Order.coheight P = 1`, returning `0 ∈ Div(C)` on the off-branch (e.g.
  generic point of an integral scheme, or higher-codim point of a
  higher-dimensional scheme). Names the bridge equation lemmas
  `lem:ofClosedPoint_eq_single` and `lem:ofClosedPoint_eq_zero` as the
  consumer-side handles for exposing each branch.
- **Bridge equation lemmas pinned (lines 449–496).** Both new lemmas
  present with full `\lean{...}` hints:
  - `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_single}`
    at line 452; statement, `\uses{def:divisor_closed_point, def:prime_divisor}`,
    one-sentence proof (dependent-`if` unfold on positive branch).
  - `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_zero}`
    at line 476; statement, `\uses{def:divisor_closed_point}`, one-sentence
    proof (dependent-`if` unfold on negative branch).
  Both `\uses` resolve to labels present in the chapter.
- **`def:order_at_point` Lean signature scope (lines 297–378).** New
  "Lean signature scope (iter-175 pin, per analogist
  `dvr-rationalmap-order`)" paragraph names the analogist-recommended
  Mathlib API path verbatim: body is
  `WithZero.log (Ring.ordFrac (X.presheaf.stalk Y.point) f)` with
  `[Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]` as an explicit typeclass
  argument on the signature, exactly the form the directive requires. The
  paragraph additionally enumerates the supporting Mathlib instances that
  the body synthesises (`IsDomain`/`IsFractionRing`/`IsNoetherianRing` on
  the stalk via the named `instIsDomainCarrierStalk…` /
  `instIsFractionRingCarrierStalk…` /
  `instIsNoetherianRingCarrierStalk…` instances), documents the
  junk-on-`f = 0` convention (`Ring.ordFrac 0 = 0 ⇒ WithZero.log 0 = 0`,
  so `order Y 0 = 0` with no explicit nonzero hypothesis), and flags the
  in-tree gap-fill (no Mathlib bridge from topological
  `Order.coheight Y.point = 1` to algebraic
  `Ring.KrullDimLE 1 (stalk)`; Stacks tag 02IZ/005X), pointing at the
  Mathlib pieces (`IsLocalization.AtPrime.ringKrullDim_eq_height`,
  `IsAffineOpen.isLocalization_stalk`) that a future upstream PR would
  use to retire the explicit typeclass argument.

No regressions visible. The earlier "Standing hypothesis $(*)$ in the
Lean encoding (iter-173 pin)" paragraph at the chapter head (lines 79–136)
remains intact and consistent with the new per-block scope paragraphs;
the layered typeclass disciplines now have concrete signature-level
referents at `def:divisor_closed_point` and `def:order_at_point`.

## Per-chapter

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Both iter-174 helper pins
    (`homogeneousLocalizationAwayIso_algebraMap`,
    `gmScalingP1_chart_PLB_eq`) landed on distinct lemma blocks with full
    prose, source-comment characterisation, resolved `\uses{}` edges, and
    a three-step proof reduction on the chart-bridge lemma. HARD GATE
    clears for Lane A1.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:divisor_closed_point` now carries the iter-174 junk-branch "Lean
    signature scope" paragraph; the two bridge equation lemmas
    `ofClosedPoint_eq_single` and `ofClosedPoint_eq_zero` are pinned with
    full `\lean{...}` hints. `def:order_at_point` carries the iter-175
    analogist-recommended "Lean signature scope" paragraph naming
    `WithZero.log (Ring.ordFrac (X.presheaf.stalk Y.point) f)` with
    explicit `[Ring.KrullDimLE 1 (...)]` and documenting the
    junk-on-`f = 0` convention. HARD GATE clears for Lane D.

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

Overall verdict: The two `iter175-whole` timing-artifact findings on
`AbelianVarietyRigidity.tex` and `RiemannRoch_WeilDivisor.tex` are
both closed by the iter-175 writer passes; both chapters are
`complete: true`, `correct: true`, with no must-fix-this-iter findings.
The HARD GATE for Lane A1 (`Genus0BaseObjects/GmScaling.lean`) and
Lane D (`RiemannRoch/WeilDivisor.lean`) clears for this iteration.
