# Progress Critic Directive

## Slug
ts244

## Iter
244

## Active routes / files under review

### Route: `Picard/TensorObjSubstrate.lean` (A.1.c substrate — `IsInvertible.pullback`)

- **Started at iter**: current phase (A.1.c substrate `IsInvertible.pullback`) ~iter-239
- **Iters audited**: 240–243

#### Sorry counts per iter
- iter-240: 2
- iter-241: 2
- iter-242: 2
- iter-243: 2
(The 2 are pre-existing deferred dual-bridge sorries, off the critical path; never expected to move on this route.)

#### Helpers/declarations added per iter
- iter-240: 2 (`pullbackObjUnitToUnit_comp`, `unitToPushforwardObjUnit_comp`)
- iter-241: 4 (`pullbackUnitIso` PRIMARY + 3 bricks)
- iter-242: 2 (`presheafPushforwardLaxMonoidal`, `presheafPullbackOplaxMonoidal` = comparison MAP δ)
- iter-243: 2 (`pullbackValIso`, `pullbackTensorMap` = δ_sheaf MAP)

#### Prover statuses per iter
- iter-240: PARTIAL — coherence linchpins landed; `pullbackUnitIso` not closed
- iter-241: PARTIAL — `pullbackUnitIso` PRIMARY landed; Phase-2 target absent
- iter-242: PARTIAL — 2 presheaf instances landed; `pullbackTensorIso` confirmed Mathlib-scale (concrete-P)
- iter-243: PARTIAL — `pullbackTensorMap` MAP landed; forward bridge `IsInvertible.isLocallyTrivial` confirmed Mathlib-scale; target `IsInvertible.pullback` NOT landed

#### Prover count per iter (files dispatched)
- iter-240: 2 of 2 ready
- iter-241: 2 of 2 ready
- iter-242: 2 of 2 ready
- iter-243: 2 of 2 ready

#### Recurring blocker phrases
- "Mathlib-scale" appears in iter-242 and iter-243 reports — the named substrate target keeps being declared blocked behind absent Mathlib infrastructure (iter-242: concrete inverse-image / `extendScalars`; iter-243: finite-presentation spread-out for SheafOfModules).
- The named critical-path deliverable `IsInvertible.pullback` has NOT landed across 240–243 (5 iters incl. 239); the recipe/route to it was revised each iter (concrete-P → local-trivialization → forward-bridge).

#### Route status changes per iter
- iter-240: active
- iter-241: active
- iter-242: active (route refinement: concrete-P)
- iter-243: active (route PIVOT: local-trivialization)

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.1.c row): "~7–11"
- **Elapsed iters in current phase**: ~5 (239–243) on the substrate sub-goal
- **Phase started at iter**: ~iter-239 (substrate `IsInvertible.pullback` sub-goal)

#### Planner's current proposal for this iter
The planner has discovered (reading Stacks `lemma-pullback-invertible`) that `IsInvertible.pullback`
is a 3-line proof reducing to "pullback is strong monoidal" (`pullbackTensorMap` is an ISO) +
`pullbackUnitIso` (done) — making the iter-243 local-trivialization pivot a detour. The planner is
re-routing to "prove `pullbackTensorMap` iso for general M,N", gated on a mathlib-analogist
confirmation (dispatched this iter) that the presheaf-level δ is a cheaply-provable iso. If confirmed,
blueprint-writer rewrites the section + prover dispatch on the iso upgrade.

### Route: `Cohomology/FlatBaseChange.lean` (A.2.c engine, parallel side-lane — affine close)

- **Started at iter**: re-engaged iter-236
- **Iters audited**: 240–243

#### Sorry counts per iter
- iter-240: 3
- iter-241: 2 (closed `pushforward_spec_tilde_iso`)
- iter-242: 2 (added `pullback_spec_tilde_iso` as new decl; sorry count flat)
- iter-243: 2

#### Helpers/declarations added per iter
- iter-240: broke 4-iter carrier wall (refactor, no new sorry-free decl counted)
- iter-241: `pushforward_spec_tilde_iso` (sorry 3→2)
- iter-242: `pullback_spec_tilde_iso` + `gammaPushforwardNatIso`
- iter-243: 0 (attempted `pushforwardBaseChangeMap_naturality`, hit defeq wall, REMOVED)

#### Prover statuses per iter
- iter-240: PARTIAL — carrier wall broken
- iter-241: COMPLETE-equiv — eliminated a sorry
- iter-242: PARTIAL — added a dictionary iso, target affine-close not closed
- iter-243: INCOMPLETE — 0 declarations added; both named obligations confirmed Mathlib-scale

#### Prover count per iter (files dispatched)
- iter-240..243: dispatched every iter (1 lane each, parallel to Lane 1)

#### Recurring blocker phrases
- "SheafOfModules functor-`.map`-of-composite defeq wall" (`rw` silently fails, `erw` whnf-explodes) — appears iter-237 through iter-243; same wall repeatedly.
- "Mathlib-scale" — both affine-close obligations declared Mathlib-scale iter-243.
- "#37189 bump" documented as the fallback across iter-242/243; watch-signal explicitly fired iter-243.

#### Route status changes per iter
- iter-240..243: active (parallel engine side-lane)

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.2.c-engine row): "~30–60 (focused); side-lane ~5/it"
- **Elapsed iters in current phase**: ~8 (236–243) on FlatBaseChange affine close
- **Phase started at iter**: iter-236 (re-engagement)

#### Planner's current proposal for this iter
The planner is considering HOLDING FlatBaseChange this iter: both obligations are confirmed
Mathlib-scale, the defeq wall has recurred 237–243, the watch-signal fired, and the documented
fallback (#37189 bump) is a disruptive project-wide operation not worth taking for a parallel
side-lane while the critical-path (Lane 1) re-route is being resolved. Capacity would redirect to
the Lane 1 critical path.

## PROGRESS.md proposal (this iter)

- **File count**: 1 (tentative) — `Picard/TensorObjSubstrate.lean` (Lane 1 re-route), with `Cohomology/FlatBaseChange.lean` proposed HELD.
- **Files**: TensorObjSubstrate.lean (active); FlatBaseChange.lean (held)
- **Files with complete blueprint chapters and open sorries (ready but not dispatched)**: FlatBaseChange.lean (held by deliberate decision, not under-dispatch); other Picard/engine files are blueprint-deferred or Route-C-paused per standing user directives.
- **Dispatch cap (from --max-objectives)**: 10

## Out of scope
All RR.* / Genus-0 / Rigidity files (USER ROUTE C PAUSE, permanent). RPF/FGA lanes (HELD pending `IsInvertible.pullback`). A.3+ lanes (USER directive: no A.3 before A.2.c).
