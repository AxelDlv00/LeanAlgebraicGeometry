# progress-critic directive — iter-243

Assess convergence per active route. Two routes are under consideration for this iter's prover dispatch.

## Route A — `Picard/TensorObjSubstrate.lean` (critical path: substrate `IsInvertible.pullback` for A.1.c)

Strategy estimate: phase `A.1.c — RelPic functor on IsInvertible`, **Iters-left ~7–11**; the route entered
its current phase (the `IsInvertible.pullback` substrate) at **iter-239** (so ~4 iters elapsed in-phase).

Target = `IsInvertible.pullback` (pullback preserves tensor-invertibility). Per-iter signals (file sorry
count is **2→2 every iter** — the two are pre-existing deferred dual-bridge sorries, FORBIDDEN to touch;
the target is a NEW decl, so "sorry unchanged" is expected, not a stall signal by itself):

- iter-239 PARTIAL: the original "sectionwise-`extendScalars`" recipe proven structurally DEAD; 1 axiom-clean
  brick (`sheafifyTensorUnitIso`) landed. Route revised (recipe #1 → #2).
- iter-240 PARTIAL: 2 axiom-clean coherence lemmas landed (`pullbackObjUnitToUnit_comp` = the named
  "genuinely-new ingredient", `unitToPushforwardObjUnit_comp`). `pullbackUnitIso` blocked on a TC-synthesis
  accident (no sorry pin).
- iter-241 PARTIAL→milestone: Phase-1 PRIMARY `pullbackUnitIso` LANDED axiom-clean + 3 bricks. KEY finding:
  chart-chase unnecessary.
- iter-242 PARTIAL: 2 axiom-clean instances landed (`presheafPushforwardLaxMonoidal`,
  `presheafPullbackOplaxMonoidal` = the presheaf comparison map `δ`). The Phase-2 target `pullbackTensorIso`
  confirmed **Mathlib-scale** under the concrete-`P` recipe (recipe #2 dead); route revised again (#2 → #3).
- Recurring pattern: the TARGET decl (`IsInvertible.pullback`) has NOT landed across iters 239–242; the
  RECIPE for it has been revised 3× (sectionwise-extendScalars → concrete-`P` mirror → local-trivialization).
  BUT each iter landed genuine axiom-clean reusable bricks toward it (unit-iso, the δ map, etc.).

Proposed iter-243 dispatch (mathlib-build): PIVOT to recipe #3 = local trivialization. Build `δ_sheaf`
(sheaf-level comparison MAP, transporting the landed presheaf δ), then the forward bridge
`IsInvertible⇒IsLocallyTrivial`, then assemble `IsInvertible.pullback` on the invertible-only case. The
general `pullbackTensorIso` is descoped (only the invertible case is needed; `IsLocallyTrivial.pullback`
and `tensorObj_isLocallyTrivial` are already proven, de-risking the route).

Question for you: is this CHURNING (recipe revised each iter, target never lands, bricks accumulating around
a definition whose shape is the bottleneck)? Or CONVERGING (staged multi-phase build with a genuine milestone
closure each iter)? Name the corrective TYPE if CHURNING/STUCK.

## Route B — `Cohomology/FlatBaseChange.lean` (engine, parallel/de-gated)

Strategy estimate: phase `A.2.c-engine`, **Iters-left ~30–60**; FlatBaseChange is the active sub-lane.

Target = `affineBaseChange_pushforward_iso` (affine base change of pushforward). Per-iter signals:

- iter-239 PARTIAL: 2 bricks; `pushforward_spec_tilde_iso` pin realized with an `hloc` sorry. sorry 3→3.
- iter-240 PARTIAL: 4-iter carrier wall broken (`algebraize`); residual moved within the decl to `hsq`. sorry 3→3.
- iter-241 milestone: `pushforward_spec_tilde_iso` CLOSED axiom-clean. sorry 3→2.
- iter-242 PARTIAL→milestone: `pullback_spec_tilde_iso` (the pullback-of-tilde dictionary, TARGET 1) LANDED
  axiom-clean + `gammaPushforwardNatIso` brick. `affineBaseChange_pushforward_iso` (TARGET 2) left as a
  documented partial — blocked on TWO Mathlib-absent multi-hundred-LOC obligations: (1) affine reduction /
  base-change-map open-restriction naturality, (2) adjoint-mate ↔ `cancelBaseChange` identification. sorry 2→2.

Proposed iter-243 dispatch (mathlib-build): do NOT re-run a rewrite round on the existing `affineBaseChange`
body. First decompose the two obligations into named sub-lemmas (blueprint, this plan phase), then dispatch
the prover on the first tractable obligation (the affine-reduction naturality). The `#37189` Mathlib bump
remains the documented fallback if the in-tree close walls.

Question for you: is this CONVERGING (steady dictionary-building, milestone each iter)? Or has the affine
close itself become STUCK (the two remaining obligations are each genuinely multi-hundred-LOC and may resist
in-tree closure)? Should the plan take the bump fallback now rather than continue in-tree?

## Dispatch-sanity
Proposed `## Current Objectives`: 2 files — `Picard/TensorObjSubstrate.lean`, `Cohomology/FlatBaseChange.lean`.
Both mathlib-build. Comment on whether 2 files is the right load.
