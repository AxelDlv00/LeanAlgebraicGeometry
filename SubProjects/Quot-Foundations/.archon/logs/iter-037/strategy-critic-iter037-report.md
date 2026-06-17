# Strategy Critic Report

## Slug
iter037

## Iteration
037

## Routes audited

### Route: FBC (affine lemma + globalization)

- **Goal-alignment**: PARTIAL — the route closes `gstar_transpose`, but the stated affine lemma `lem:affine_base_change_pushforward` (= `affineBaseChange_pushforward_iso`, the goal's named node) is NOT reducible to `gstar_transpose` alone; it carries a second, un-named sorry.
- **Mathematical soundness**: PASS — the conjugate-counit `huce` calculus is mathematically genuine (`conjugateEquiv_counit_symm` transports the geometric counit to the algebraic extend/restrict counit; step (b) closes against that algebraic counit).
- **Sunk-cost reasoning detected**: no (borderline) — see treadmill note below; the dead `_legs` cluster is correctly declared off-path, not defended on "we already built it" grounds.
- **Infrastructure-deferral detected**: yes — the **affine/locality reduction** in `affineBaseChange_pushforward_iso` (`FlatBaseChange.lean:2348`) is a distinct, un-scoped sorry. The source itself labels it *"itself Mathlib-absent and is the remaining multi-hundred-LOC build for the unconditional general theorem"* (lines 2336–2347). The strategy's FBC route names only `gstar_transpose` as the affine lemma's "live residual."
- **Phantom prerequisites**: none for FBC (`conjugateEquiv_counit_symm` resolves — the file compiles up to the 2167 sorry).
- **Effort honesty**: under-counted — FBC-A is `Iters left 1–2 / ~80–150 LOC`, but even with `gstar_transpose` closed, `affineBaseChange_pushforward_iso` still needs the multi-hundred-LOC restriction-compatibility build (2348). The estimate silently omits it.
- **Parallelism under-exploited**: no.
- **Verdict**: CHALLENGE

The route's claim — *"the domain read + codomain read + g^*-transpose triangle, whose live residual is `gstar_transpose`"* — is verifiably incomplete. There are **four** real (tactic-blocking) sorries in `FlatBaseChange.lean`: `1700` (dead `_legs`/conj-2a cluster — genuinely off-path, confirmed: `gstar_transpose` reproves step (a) inline and does not consume `base_change_mate_fstar_reindex`), `2167` (`gstar_transpose` — the strategy's focus), `2348` (`affineBaseChange_pushforward_iso` — the **affine/locality reduction**, un-scoped), and `2370` (`flatBaseChange_pushforward_isIso` — FBC-B global). The strategy treats `2348` as if it does not exist. Closing `gstar_transpose` makes `pushforward_base_change_mate_cancelBaseChange` axiom-clean but leaves `affineBaseChange_pushforward_iso` — the goal's actual affine lemma — still sorry-backed at 2348.

On the directive's question (1) — *is the FBC close honestly characterized as assembly-of-proved-atoms?* For `gstar_transpose` **specifically: yes, with a caveat.** `huce` is genuinely assembled in-body, step (b) (`base_change_mate_extendScalars_inner_value_counit`) is a real standalone proven lemma, and the step-(a) atoms (`base_change_mate_fstar_reindex_legs_unitExpand`, `…_gammaDistribute`, `base_change_mate_inner_eCancel_*`) are all sorry-free. The dead 1700 cluster is off the new critical path. So this is not pure re-encoding. **The caveat (treadmill risk):** step (a)'s content `Γ_R(θ_in)=ρ` is, by the source's own admission (2089), *exactly* what the now-abandoned `base_change_mate_fstar_reindex` was built to assert — the same inner-reindex obligation has now been encoded three ways (`_legs` → `_legs_conj` → inline). The explicit iter-038 mathlib-analogist tripwire is the right guard, but the planner should **prune the dead 1700 cluster** so a sorry-bearing abandoned apparatus stops masquerading as live infrastructure.

### Route: GF (geometric generic flatness)

- **Verdict**: SOUND — algebraic core `genericFlatnessAlgebraic` is done; the geometric wrapper is honestly gated on gap1 (G1), and the shared-infra decision (build once QUOT-side) is sensible. Correctly BLOCKED, not deferred-by-inaction.

### Route: QUOT (defs + gap1 + repr)

- **Goal-alignment**: PASS.
- **Mathematical soundness**: PASS — the gap1 ingredient lemmas (`isLocalizedModule_restrict_of_isIso_fromTildeΓ` and the `IsLocalizedModule.of_linearEquiv`/`of_linearEquiv_right` transport at `QuotScheme.lean:354–516`) are real, compiling, sorry-free code. The 8 file sorries are the 4 protected typed stubs (126/165/201/228) plus their docstrings.
- **Phantom prerequisites**: none — (I) ring-iso-semilinear `IsLocalizedModule` transport and (II) base-change-of-localization rest on `IsLocalizedModule.of_linearEquiv*` and `IsLocalization`, both real.
- **Effort honesty**: reasonable for gap1; QUOT-repr (`Iters left 6–12 / ~400–1000+`) is honestly the deepest, openly BLOCKED.
- **Verdict**: SOUND — ingredients (I)/(II) are correctly scoped and referenced (directive question 2, QUOT half: confirmed).

### Route: GR-proper (valuative criterion)

- **Goal-alignment**: PASS — `isProper_of_valuativeExistence` is proven conditional on `ValuativeCriterion.Existence`; remaining work is building that existence (E3-full → E4).
- **Mathematical soundness**: PASS — E3 ratio-core (`existence_lift_transitionPreMap_minorDet_mul`) is proven; the open gap (the cofactor "free-entry-as-minor" helper) matches the source comment at `GrassmannianCells.lean:1617–1618` exactly.
- **Phantom prerequisites**: `Matrix.det_updateColumn` — **MISSING as named** (see Prerequisite verification). The capability exists via `Matrix.det_succ_column` + `Matrix.cramer_apply`; the route is not broken, but the anchor name is wrong.
- **Effort honesty**: optimistic but defensible (`1–3 iters / ~120–280 LOC`) given E1/E2/E3-core are done.
- **Verdict**: SOUND (with a corrected anchor) — E3-full is correctly scoped (directive question 2, GR half: confirmed); fix the phantom lemma name.

## Format compliance

- **Size**: 155 lines / 15,305 bytes — within line budget, **over the ~12 KB byte budget** (~15.3 KB).
- **Headings**: PASS — exactly `Goal`, `Phases & estimations`, `Completed`, `Routes`, `Open strategic questions`, `Mathlib gaps & new material`, in order.
- **Per-iter narrative detected**: no (bare iter numbers in the `## Completed` ledger cells are permitted).
- **Accumulation detected**: no — `## Completed` is 8 rows (within bound); no completed phase lingers in the active table.
- **Table discipline**: PASS.
- **Format verdict**: DRIFTED — only the byte budget is exceeded (~3 KB over); trim prose in the Routes section.

## Infrastructure-deferral findings

### Deferred: affine/locality reduction of `pushforwardBaseChangeMap` (restriction-compatibility over an affine open)

- **Required by goal**: yes — it is the body of `affineBaseChange_pushforward_iso`, which *is* the goal's `lem:affine_base_change_pushforward`. The affine lemma does not hold (is not sorry-free) without it.
- **Current plan for building it**: none in STRATEGY.md — the FBC route and the FBC-A phase row name only `gstar_transpose`. The construction is described only inside the `.lean` source (2336–2347) and an `informal/` doc, neither of which the strategy references.
- **Timeline**: absent — folded into FBC-A's "1–2 iters" with no LOC allocation, despite the source calling it "multi-hundred-LOC."
- **Verdict**: CHALLENGE — add a dedicated phase row / route paragraph for the affine-reduction (restriction-compatibility) build with its own iter+LOC estimate, OR re-scope FBC-A to explicitly exclude it and name the follow-on phase. Do not leave it implicit.

## Prerequisite verification

- `conjugateEquiv_counit_symm`: VERIFIED (used in compiling `gstar_transpose` body up to the 2167 sorry).
- `Matrix.det_succ_column`: VERIFIED.
- `Matrix.det_updateColumn`: MISSING — no such Mathlib lemma (nor `det_updateCol`). The intended content (det of a column-substituted matrix) is `Matrix.cramer_apply` (`cramer A b i = det (updateColumn A i b)`) combined with `Matrix.det_succ_column` for cofactor expansion. Correct the GR-proper "Key Mathlib needs" anchor.

## Must-fix-this-iter

- Route FBC: CHALLENGE — the affine lemma's live residual is NOT just `gstar_transpose`. `affineBaseChange_pushforward_iso` (`FlatBaseChange.lean:2348`) carries a separate, un-scoped, source-acknowledged "multi-hundred-LOC, Mathlib-absent" affine/locality reduction. Add it to the route + phase table with an honest estimate, or re-scope FBC-A and rebut explicitly in `plan.md`.
- Route FBC: infrastructure-deferral CHALLENGE — the affine/locality reduction is required by the goal and has no project-side plan or timeline. Build it or produce a concrete plan with an iter estimate.
- Route FBC: prune the dead `_legs`/conj-2a cluster (`base_change_mate_fstar_reindex_legs_conj` sorry at 1700, and its sorry-backed consumers `base_change_mate_fstar_reindex` / `base_change_mate_inner_value_eq`) so an abandoned apparatus stops carrying a live sorry on the off-critical path.
- Phantom prerequisite `Matrix.det_updateColumn`: does not exist; replace with `Matrix.cramer_apply` + `Matrix.det_succ_column` in GR-proper's Key Mathlib needs.
- Format: DRIFTED — ~15.3 KB exceeds the ~12 KB budget; trim Routes prose (not blocking, but address opportunistically).

## Overall verdict

Three of the four live routes (GF, QUOT, GR-proper) are SOUND: their estimates are honest, their gap1/(I)/(II) ingredient builds are real compiling code rather than phantom infra, and their open gaps match the source. The FBC route, however, **defers the affine/locality reduction of `pushforwardBaseChangeMap` (the restriction-compatibility build at `FlatBaseChange.lean:2348`), which is required for the stated goal** — it is the body of `affineBaseChange_pushforward_iso`, the goal's own `lem:affine_base_change_pushforward`. The strategy presents `gstar_transpose` as the affine lemma's sole live residual and prices FBC-A at "1–2 iters / ~80–150 LOC," but the source itself flags a second multi-hundred-LOC, Mathlib-absent obligation that the strategy never names. The `gstar_transpose` close itself is honestly characterized as assembly-of-proved-atoms (huce assembled, step (b) proven, step-(a) atoms sorry-free, dead cluster off-path, tripwire in place) — answering the directive's question (1) affirmatively for that node — but the route's framing of the *whole affine lemma* as nearly done is the dishonest part. Fix: add an honest phase row/route paragraph for the affine reduction, prune the dead 1700 cluster, and correct the `Matrix.det_updateColumn` anchor.
