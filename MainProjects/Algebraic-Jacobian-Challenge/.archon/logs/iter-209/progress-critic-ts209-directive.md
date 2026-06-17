# Progress Critic Directive

## Slug
ts209

## Iter
209

## Active routes / files under review

### Route: Lane TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (line-bundle tensor group law, critical-path root for A.2.c)

- **Started at iter**: lane active continuously since ~iter-202; current target `tensorObj_restrict_iso` under attack since iter-205. "Route A" reset was iter-208.
- **Iters audited**: 205–208

#### Sorry counts per iter (TS file)
- iter-205: 4
- iter-206: 3   (net −1 was a dead `monoidalCategory := sorry` instance removal, NOT a critical-path closure)
- iter-207: 3
- iter-208: 3

#### Helpers added per iter
- iter-205: cone reduced to one fact (`whiskerLeft`); 0 sorries closed; 0 net new decls.
- iter-206: removed dead `monoidalCategory := sorry` instance + 2 transport lemmas; advanced `tensorObj_restrict_iso` by 2 reduction steps; 0 critical-path closures.
- iter-207: added 3 axiom-clean decls (`restrictScalarsLaxε`, `restrictScalarsLaxμ`, instance `restrictScalarsLaxMonoidal`) — later found OFF-PATH; 0 sorries closed.
- iter-208: added 1 reduction step (strip outer sheafification via `sheafification.mapIso`) inside `tensorObj_restrict_iso`; 0 new decls; 0 sorries closed.

#### Prover statuses per iter
- iter-205: PARTIAL — cone reduced to `whiskerLeft`, needs absent `MonoidalClosed (PresheafOfModules R₀)`.
- iter-206: PARTIAL — flat/line-bundle pivot premise DISPROVEN (comparison map absent).
- iter-207: PARTIAL — "sole ingredient" (`restrictScalarsLaxMonoidal`) premise DISPROVEN.
- iter-208: PARTIAL — Route-A "sectionwise unfolding ~30–60 LOC" premise DISPROVEN; residual now a ~200–300 LOC build of 4 absent Mathlib ingredients.

#### Prover count per iter (files dispatched)
- iter-205: 1 of 1 ready (TS only productive lane; all else held/paused/gated by USER directives)
- iter-206: 1 of 1
- iter-207: 1 of 1
- iter-208: 1 of 1

#### Recurring blocker phrases
- "`tensorObj_restrict_iso` residual needs an absent multi-file Mathlib monoidal/pushforward structure" — appears (renamed) in iter-205 (`MonoidalClosed (PresheafOfModules R₀)`), iter-206 (comparison map absent), iter-207 (`(PresheafOfModules.pullback φ).Monoidal` via mate-δ), iter-208 (opaque `pullback` = abstract left adjoint, no sectionwise formula; 4 absent ingredients). Same wall, renamed each iter.
- "premise DISPROVEN / reversal pre-commitment FIRED" — appears in iter-206, iter-207, iter-208 prover/review reports.

#### Route status changes per iter
- iter-205: active
- iter-206: active (flat/line-bundle pivot)
- iter-207: active (mathlib-build mate-δ)
- iter-208: active (Route-A reset)

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.1.c.SubT row, verbatim): ~2–4
- **Elapsed iters in current phase**: 4 (iter-205 → iter-208 attacking `tensorObj_restrict_iso`)
- **Phase started at iter**: ~iter-205 (current target); "route reset" relabel iter-208

#### Planner's current proposal for this iter
The planner is deciding between TWO options and wants the convergence read before committing: (A) re-route Lane TS to `[prover-mode: mathlib-build]` targeting the 4 named ingredients bottom-up (starting with ingredient (4), a self-contained ~30–50 LOC algebra lemma "ModuleCat.restrictScalars along a ring iso is strong monoidal"), per the iter-208 prover's recommendation; OR (B) PAUSE Lane TS this iter pending a structural mathlib-analogist consult on whether the `sheafification ∘ PresheafOfModules.tensorObj` construction is the wrong shape (forcing `tensorObj_restrict_iso` through the opaque `pullback`), then re-route the construction next iter.

## PROGRESS.md proposal (this iter)
- **File count**: 0 or 1 (undecided — pending your verdict + the analogist consult)
- **Files**: `Picard/TensorObjSubstrate.lean` (only if option A) — all other lanes held/paused/gated by USER standing directives (ROUTE C PAUSE; no A.3/A.4 before A.2.c).
- **Files with complete blueprint chapters and open sorries (ready but not dispatched)**: none — every other open file is under the ROUTE C PAUSE or gated by USER directive #4 (no A.3/A.4 before A.2.c closes). TS is the sole USER-permitted productive lane.
- **Dispatch cap (from --max-objectives)**: 10

## Out of scope
All held/paused/gated lanes (RPF, FGA, IdentityComponent, QuotScheme, Albanese Route-2, all Route-C / genus-0 files). Assess only Lane TS.
