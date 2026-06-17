# Blueprint Reviewer Directive — ts240 scoped re-review (same-iter fast path)

You audit the whole blueprint as always, but this dispatch exists to re-clear the
HARD GATE for ONE chapter that was rewritten this iter after a must-fix finding.

## Focus chapter (gate decision needed THIS iter)
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`, section
`sec:tensorobj_pullback_monoidality` (the three lemmas `lem:pullback_tensor_iso`,
`lem:pullback_unit_iso`, `lem:isinvertible_pullback`).

## Why
The iter-239 lean-vs-blueprint check flagged `sec:tensorobj_pullback_monoidality`
as **must-fix**: its proof sketches described a route (sectionwise `extendScalars`
tensorator on the abstract left-adjoint `PresheafOfModules.pullback`) that cannot
be formalized (the pullback has no sectionwise/stalkwise value formula). This iter
the section was rewritten to **Route Z = local-chart finality** and `lem:pullback_tensor_iso`
was DESCOPED to a pointwise comparison iso (the full `CoreMonoidal.ofOplaxMonoidal`
strong-monoidal packaging — which needs a hand-built `OplaxMonoidal` instance, not
free — is explicitly recorded as off the critical path). A prover (`mathlib-build`)
is queued to attack Phase 1 (`pullbackUnitIso`) + the pointwise Phase 2 this iter
IF this chapter clears.

## The question for the focus chapter
Is `sec:tensorobj_pullback_monoidality` now **complete: true** AND **correct: true**
with **no must-fix-this-iter** finding? Specifically check:
- The proof sketches no longer describe the dead sectionwise-`extendScalars` route;
  the route is now local-chart finality (Phase 1 globalizes the proven
  `IsLocallyTrivial.pullback` `pullbackObjUnitToUnit` Final-chart chase via
  `isIso_of_isIso_restrict`; Phase 2 builds `pullbackObjTensorToTensor` and proves
  it iso by the same chart-chase, taken pointwise).
- The descope is coherent: `lem:isinvertible_pullback` (the Stacks composite
  `pullbackTensorIso⁻¹ ≫ f^*e ≫ pullbackUnitIso`) consumes only the pointwise iso,
  and the off-path note about full monoidal packaging is not load-bearing.
- The Mathlib facts cited (`instIsIsoPullbackObjUnitToUnitOfFinal`,
  `final_of_representablyFlat`, `sheafificationCompPullback`,
  `isIso_of_isIso_restrict`) are the right tools and the proof is formalizable as
  written.
- `\uses{}` are acyclic and the Stacks `% SOURCE QUOTE` blocks are intact.

## Also (whole-blueprint, normal pass)
Report your usual per-chapter checklist for the rest of the blueprint, but the
gate decision I act on this iter is for `Picard_TensorObjSubstrate.tex` only.
Note also whether `Cohomology_FlatBaseChange.tex` (two new pinned blocks
`lem:gammaPushforwardIsoAt`, `lem:tildeRestriction_isLocalizedModule` + the
natural-in-open notes added to `lem:pushforward_spec_tilde_iso`) remains
complete+correct (it cleared the gate last iter; confirm the additive edits did
not regress it).
