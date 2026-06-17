# mathlib-analogist directive — slug `pullbackspeciso-bypass`

## Mode
api-alignment

## Question

The project's `Genus0BaseObjects/GmScaling.lean` has been stuck for 5
iterations on the chart-bridge body retirement (TEMP axioms admitted
iter-177, still standing iter-179). The current diagnosis (iter-179
Lane A task_result):

- The recipe gets ~4/6 steps in (uniform-in-`i` refactor LANDED first,
  then `awayι_comp_PLB_hom`, `homogeneousLocalizationAwayIso_algebraMap`,
  `MvPolynomial.algebraMap_eq + eval₂Hom_comp_C` all fire).
- The **5th step fails**: `pullbackSpecIso_hom_base`
  (`Mathlib/AlgebraicGeometry/Pullbacks.lean:766`) does NOT fire by `rw`
  or by `simp`. Pattern is reported "not found" though the LHS appears
  verbatim in the goal.
- **Diagnostic**: the `Algebra kbar (TensorProduct kbar Away_i GmRing)`
  instance synthesis is via `Algebra.compHom` (project-side
  `algebraKbarAway`); this is defeq-equivalent to the default
  Mathlib instance on `TensorProduct.algebra`, but the elaborator
  refuses to do the unification. `erw` times out at 200k heartbeats
  doing `isDefEq` on the instance.
- `change` to retype the middle-object of one `≫` worked for an earlier
  step (Attempt 2 in iter-179 Lane A) but the multi-layer
  `pullbackSymmetry ≪≫ pullbackRightPullbackFstIso ≪≫ pullback.congrHom
  ≪≫ pullbackSpecIso` chain in `gmScalingP1_cover_X_iso` has 4 layered
  `≫`s; reshaping with explicit middle-object types blows up `change`'s
  elaboration term beyond 2KB and times out.

## What I want to know

Concrete options for bypassing the `Algebra.compHom`-based instance
synthesis heartbeat sink at the `pullbackSpecIso_hom_base` application
site. Ranked by Mathlib-idiom-cleanness:

### Sub-question 1 — Project-side wrapper

Is the suggested workaround
`pullbackSpecIso_hom_base'` (taking the algebra map as an explicit
`RingHom` parameter, bypassing instance synthesis at the application
site) (a) actually buildable in Mathlib's current pullback API; (b) does
proving the wrapper itself avoid the same heartbeat sink (or does it
just shift the failure to the wrapper's own proof)? Estimate LOC.

### Sub-question 2 — `pullback.mapIso` direct construction

Can `gmScalingP1_cover_X_iso` be reconstructed using
`pullback.mapIso` (`Mathlib/CategoryTheory/Limits/Shapes/Pullbacks/Iso`)
directly instead of going through `pullbackSymmetry ≪≫
pullbackRightPullbackFstIso ≪≫ pullback.congrHom ≪≫ pullbackSpecIso`?
That would reduce the chain depth from 4 to 1 layer and might let
`pullbackSpecIso_hom_base` fire after a shallower unfold.

### Sub-question 3 — Algebra-instance refactor (replace `Algebra.compHom`)

The project's `algebraKbarAway`
(`Genus0BaseObjects/Points.lean` or `Genus0BaseObjects/BareScheme.lean`)
uses `Algebra.compHom`. Replacing it with `Algebra.ofModule`,
`Algebra.toAlgebraOfPushforward`, or letting `TensorProduct.algebra`
trigger naturally — would that eliminate the heartbeat sink? Cost?
Does anything else in the project depend on the `compHom` form?

### Sub-question 4 — `simp_arith` / `whnf`-with-priority tactics

Mathlib has some specialized tactics for forcing the elaborator past
defeq blockers (`with_unfolding_all`, `with_reducible_and_instances`,
`set_option backward.isDefEq.respectTransparency`). Which of these
(if any) Mathlib idioms applies at this site? Does Mathlib's
`Mathlib/AlgebraicGeometry/Pullbacks.lean` show any precedent for
working around `Algebra.compHom`-typed pullback isos?

### Sub-question 5 — Alternative bridge

Is there a Mathlib lemma I'm missing that bypasses
`pullbackSpecIso_hom_base` entirely? The goal is to identify
`(pullbackSpecIso kbar Away_i GmRing).hom ≫ Spec.map (algMap kbar
(TensorProduct kbar Away_i GmRing))` with `pullback.snd _ _` (or some
equivalent canonical morphism). Maybe `Limits.pullback.fst_of_hom` /
`pullback.snd_of_hom` / a Spec-pullback symmetry lemma applies?

## Project artifacts to read

- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` — esp.
  `gmScalingP1_chart_PLB_eq` body (currently axiom-laundered + the
  iter-179 partial body chain), `gmScalingP1_cover_X_iso` (uniform-in-i
  post-refactor).
- `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean` — for the
  `Algebra` instance setup if needed.
- `AlgebraicJacobian/Genus0BaseObjects/Points.lean:50-80` — possibly
  `algebraKbarAway` definition site.
- `analogies/gmscaling-cover-bridge.md` — full Mathlib idiom analysis
  from iter-178.
- `analogies/gmscaling-deep.md` — deep analysis from iter-170+.
- `.archon/task_results/Genus0BaseObjects_GmScaling.lean.md` (iter-179
  Lane A task_result with verbatim attempt-by-attempt log).

## Decision criteria for the recommendation

Tag each sub-question's verdict:
- **PROCEED** if the option closes the blocker cleanly.
- **ALIGN_WITH_MATHLIB** if Mathlib has a canonical idiom we should
  switch to.
- **DIVERGE_INTENTIONALLY** with cost analysis if the project's path is
  still right but Mathlib's idiom is unsuitable.
- **NOT_VIABLE** if the option doesn't help.

The iter-181 RETIRE-OR-ESCALATE trigger fires at the end of iter-180 if
the axioms aren't retired; the consult feeds the iter-180 prover Lane A
attempt with the most-likely-to-succeed corrective.

## Output to

`analogies/pullbackspeciso-bypass.md` (persistent recipe file).
`.archon/task_results/mathlib-analogist-pullbackspeciso-bypass.md`
(report).
