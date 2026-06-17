# Progress Critic Directive

## Slug
ts240

## Iter
240

## Active routes / files under review

### Route: `Picard/TensorObjSubstrate.lean` — A.1.c substrate `IsInvertible.pullback`

- **Started at iter**: 239 (the `IsInvertible.pullback` substrate target specifically; the file's group-law work closed iter-238)
- **Iters audited**: 236–239

#### Sorry counts per iter (whole file)
- iter-236: 2
- iter-237: 1 (whiskering sorry closed)→ note: associator sorry-free
- iter-238: 2 (group law landed, zero new sorry; the 2 are the deferred dual-bridge sorries)
- iter-239: 2 (substrate targets left ABSENT, no sorry pinned)

#### Helpers added per iter (toward the IsInvertible.pullback substrate)
- iter-238: n/a (group law lane — different target)
- iter-239: 1 (`sheafifyTensorUnitIso`, axiom-clean); then STOPPED (honored the ≥3-helper watch)

#### Prover statuses per iter (this substrate target)
- iter-239: PARTIAL/BLOCKED — built 1 reusable brick, declared the 3 named targets (`pullbackTensorIso`, `pullbackUnitIso`, `IsInvertible.pullback`) STRUCTURALLY IMPOSSIBLE under the dispatched recipe, left them absent (no sorry-pin), handed off a concrete pivot.

#### Recurring blocker phrases
- "abstract left adjoint pullback has no sectionwise/stalkwise formula" — iter-239 (1st occurrence; the recipe `sectionwise extendScalars tensorator` was found structurally impossible).

#### Route status changes per iter
- iter-238: group law DONE (closed)
- iter-239: pivoted to `IsInvertible.pullback` substrate (fresh target); recipe found dead

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.1.c row): ~4–7
- **Elapsed iters in current phase (A.1.c)**: 1 (iter-239 was the first A.1.c substrate dispatch; iter-238 and earlier were A.1.c.SubT group law, now DONE)
- **Phase started at iter**: 239

#### Planner's current proposal for this iter
Design-pass iter: dispatching mathlib-analogist (cross-domain) on the
pullback-monoidality wall + strategy-critic on the route, rewriting the blueprint
chapter `sec:tensorobj_pullback_monoidality` to record the dead recipe and the
new route (local-chart-finality, mirroring the axiom-clean `IsLocallyTrivial.pullback`).
A prover MAY be dispatched on the corrected route via the same-iter fast path if
the rewritten chapter clears the blueprint gate; otherwise the substrate prover
is deferred one iter pending the design pass.

### Route: `Cohomology/FlatBaseChange.lean` — engine, affine flat base change (`i=0`, Stacks 02KH)

- **Started at iter**: 237 (the `affineBaseChange_pushforward_iso` affine close specifically)
- **Iters audited**: 236–239

#### Sorry counts per iter (whole file)
- iter-236: 2
- iter-237: 2
- iter-238: 2 (no prover ran — STUCK corrective was a blueprint expansion)
- iter-239: 3 (+1: a previously-dangling `\lean{}` pin `pushforward_spec_tilde_iso` realized as a real decl with a `sorry` at `hloc`)

#### Helpers added per iter
- iter-237: 3 axiom-clean route-iii decls
- iter-238: 0 (no prover; blueprint expansion only)
- iter-239: 2 axiom-clean bricks (`gammaPushforwardIsoAt`, `tildeRestriction_isLocalizedModule`)

#### Prover statuses per iter
- iter-237: PARTIAL — hard affine-close commitment MISSED; built route-iii skeleton.
- iter-238: (no prover dispatch — STUCK corrective = blueprint expansion)
- iter-239: PARTIAL — built 2 bricks, localized residual to `hloc`, but `affineBaseChange_pushforward_iso` STILL sorry; hard commitment MISSED again.

#### Recurring blocker phrases
- "smul / `Module` carrier wall" / "`Module.compHom` letI not consumed by `LinearMap.restrictScalars`" — recurs iter-234, 235, 236, 239 (the prover calls iter-239 the "FOURTH recurrence" at 3 section locations `⊤`→Γ→`D(a)`→`Module R` of a φ-restricted R'-module).

#### Deferral language per iter
- iter-237 plan: "owed the affine close; hard commitment next iter"
- iter-238 plan: STUCK corrective (blueprint expansion), prover deferred
- iter-239 plan: "ONE post-corrective attempt justified; if sorry stays flat → ROUTE PIVOT, NOT a 4th blueprint expansion" (reversing signal armed)

#### Route status changes per iter
- iter-237: active (hard commitment)
- iter-238: STUCK corrective (no prover)
- iter-239: active (one post-corrective attempt) — sorry went 2→3, hard commitment MISSED

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.2.c-engine row): ~30–60 (whole engine); this specific affine close has been the target since iter-237
- **Elapsed iters in current phase (affine close)**: 3 (237, 238, 239)
- **Phase started at iter**: 237

#### Planner's current proposal for this iter
The iter-239 reversing signal fired (sorry did NOT drop). Per the planner's own
armed contract, FlatBaseChange must NOT get a verbatim re-dispatch on `hloc`.
This iter the planner is consulting mathlib-analogist (api-alignment) on whether
Mathlib has an affine-pushforward-preserves-quasi-coherence idiom that sidesteps
the manual `hloc` carrier-wall transport entirely — a route pivot. No prover
re-dispatch on `hloc` until the pivot is decided.

## PROGRESS.md proposal (this iter)

- **File count**: 0–1 (design-pass iter; a prover on `TensorObjSubstrate.lean` MAY be dispatched via the same-iter fast path if the rewritten chapter clears the gate, otherwise 0 prover dispatch this iter with the mechanical-gate marker)
- **Files**: `Picard/TensorObjSubstrate.lean` (conditional, fast-path) — FlatBaseChange NOT re-dispatched (pivot pending analogist)
- **Files with complete blueprint chapters and open sorries (ready but not dispatched)**: FlatBaseChange (deliberately held — route pivot pending); TensorObjSubstrate chapter currently describes the DEAD recipe (HARD-GATE-blocked until rewritten this iter)
- **Dispatch cap (from --max-objectives)**: 10

## Out of scope
- All Route C / RR / Rigidity / Genus0 lanes (USER permanent pause).
- `Cohomology/HigherDirectImage.lean` (3 sorries, deep Mathlib-absent prerequisites, no frontier sub-step).
- `Picard/RelPicFunctor.lean` + `LineBundlePullback.lean` (RPF re-base — gated on `IsInvertible.pullback` landing).
