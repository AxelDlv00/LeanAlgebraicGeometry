# Progress Critic Directive

## Slug
iter036

## Iter
036

## Active routes / files under review

### Route: FBC-A — `Cohomology/FlatBaseChange.lean`
- **Started at iter**: current phase ~iter-020 (FBC mate coherence); conjugate sub-route iter-033–035.
- **Iters audited**: 032–035

#### Sorry counts per iter (file-level, FlatBaseChange.lean)
- iter-032: 4
- iter-033: 4
- iter-034: 4
- iter-035: 4

#### Helpers added per iter
- iter-032: ~several (conj prep)
- iter-033: +~2 (conj-0 foundation: pullbackComp↔leftAdjointCompIso)
- iter-034: +~2 (conj-0 device lemmas)
- iter-035: +7 (conj-1a/1b/2c, conjPullbackFactor[+eq], param[+eq_param]); `_legs` body made sorry-free
  wrapper; residual sorry MOVED into conj-2a `base_change_mate_fstar_reindex_legs_conj`

#### Prover statuses per iter
- iter-032: PARTIAL
- iter-033: PARTIAL (route ruled out — term-mode collapse landed, residual cross-layer naturality)
- iter-034: PARTIAL (conj-0 foundation landed, keystone did not close)
- iter-035: PARTIAL (conjugate chain atomized, sorry only MOVED to conj-2a — TRIPWIRE FIRED)

#### Recurring blocker phrases
- "section-composite→conjugateEquiv-component reframing" — appears iter-033/034/035 reports — the
  multi-iter wall; the explicit-factor / conjugate vehicle cannot express it.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (FBC-A row, current): "2–4" (just re-estimated post-pivot)
- **Elapsed iters in current sub-route (conjugate)**: ~5 (iter-031..035)
- **Phase started at iter**: conjugate sub-route iter-031/033

#### Planner's current proposal for this route
PIVOT executed: conjugate route ABANDONED. iter-036 dispatches the affine-local explicit-inverse +
element-`ext` route on obligation 2 (section-level identity), after a blueprint-writer rewrites the FBC
chapter for it. Do NOT re-attempt `_legs`/conj-2a.

### Route: QUOT — `Picard/QuotScheme.lean` (gap1: C→P1→D→Hfr→assembly)
- **Started at iter**: gap1 sub-build ~iter-033
- **Iters audited**: 033–035

#### Sorry counts per iter (file-level; the 4 are pre-existing protected stubs throughout)
- iter-033: 4
- iter-034: 4
- iter-035: 4
(gap1 work is all NEW axiom-clean decls, not stub fills)

#### Helpers / keystones added per iter
- iter-033: +4 slice-transport infra (overRestrictUnitIso/Presentation/...)
- iter-034: +7 (P1 keystone `isIso_fromTildeΓ_restrict_basicOpen` + general form) — COMPLETE
- iter-035: +6 (gap1-D cover-form keystone `isLocalizedModule_basicOpen_descent_of_cover` + 5 private) — COMPLETE

#### Prover statuses per iter
- iter-033: PARTIAL (infra, target deferred)
- iter-034: COMPLETE (P1 keystone landed)
- iter-035: COMPLETE (D cover-form keystone landed; named form gated on Hfr section transport)

#### Recurring blocker phrases
- "slice→Spec R_r transport" — the object form was resolved by P1 (iter-034); the SECTION form (Hfr) is
  the remaining named ingredient (`Γ(pullback ι M,⊤)≅Γ(M,image)`). Not a recurring unresolved wall — each
  iter lands a keystone and reduces the gap.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (QUOT-defs row): "3–7"
- **Elapsed in gap1 sub-build**: ~3 (iter-033..035)

#### Planner's current proposal for this route
mathlib-build the Hfr section transport `Γ((pullback ι).obj M,⊤)≅Γ(M,image)` natural in the open — the
named ingredient that makes `isLocalizedModule_basicOpen_descent` + gap1 one-liners.

### Route: GR — `Picard/GrassmannianCells.lean` (properness)
- **Started at iter**: GR-proper iter-035
- **Iters audited**: 034–035

#### Sorry counts per iter
- iter-034: 0 (GR-sep landed)
- iter-035: 0 (GR-proper reduced to single obligation; mathlib-build discipline)

#### Helpers / keystones added per iter
- iter-034: +7 (`Grassmannian.isSeparated` keystone via route (b)) — COMPLETE
- iter-035: +7 (properness reduced to single `ValuativeCriterion.Existence` obligation via
  `isProper_of_valuativeExistence` + 3 cheap ingredients + E3 algebraic core `transitionPreMap_minorDet_mul`) — COMPLETE/PARTIAL

#### Prover statuses per iter
- iter-034: COMPLETE (isSeparated)
- iter-035: PARTIAL (isProper reduced to existence E1–E4; E1 the primary missing Mathlib API, unbuilt)

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (GR-proper row): "2–4"
- **Elapsed**: ~1–2 (iter-034 sep, iter-035 proper reduction)

#### Planner's current proposal for this route
mathlib-build E1 (chart factorization: factor Spec K → scheme through a chart whose range contains the
image point; local-ring-Spec through open cover — the primary missing Mathlib API). E1 gates E2/E3/E4.

## PROGRESS.md proposal (this iter)
- **File count**: 3
- **Files**: FlatBaseChange.lean, QuotScheme.lean, GrassmannianCells.lean
- **Files with complete blueprint chapters and open sorries (ready but not dispatched)**: none additional
  (FBC-B/FlatBaseChangeGlobal gated on FBC affine; GF gated on gap1; the 4 QUOT stubs are protected)
- **Dispatch cap**: 10

## Out of scope
GF-geo (gated on gap1), FBC-B chain assembly (gated on FBC affine), SNAP, QUOT-repr, RelativeSpec.
