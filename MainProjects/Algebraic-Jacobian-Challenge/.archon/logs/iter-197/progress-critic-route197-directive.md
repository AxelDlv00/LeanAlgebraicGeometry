# progress-critic directive — iter-197

## Slug
`route197`

## Routes audited (active routes the planner is considering for iter-197 prover dispatch)

### Route Lane H — `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`
- Sorry trajectory (last 5 iters): 4 → 4 → 4 → 3 → 3 (iter-192 → iter-196).
- Helpers added per iter (last 5 iters): 1, 1, 1, 2, 0.
- Prover statuses (last 5 iters): PARTIAL, PARTIAL, PARTIAL, done (1 closure: `shortExact_app_surjective`), done (structural advance only — empty branch of `constant_of_irreducible`, outer step of `skyscraperSheaf_eq_pushforward_const`).
- Recurring blockers: iter-196: non-empty branch of `constant_of_irreducible` blocked on Mathlib-absent sheafification-unit-iso for irreducible spaces; inner iso of `skyscraperSheaf_eq_pushforward_const` blocked on `(constantSheaf ...).Full`/`.Faithful` instance not in Mathlib `b80f227`.
- STRATEGY `Iters left` for phase RR.2.H¹: `~3–6`. Phase entered iter-184 (iter-184 → iter-196 = 13 iters elapsed). Iters left + elapsed = total of 16-19, vs STRATEGY upper bound ~10 ⟹ realistically OVER_BUDGET still even after iter-196 scope reduction.
- This iter's plan: blueprint-writer `h1v-mustfix-iter197` IN FLIGHT (3 must-fixes + 3 majors documenting the Mathlib gaps explicitly + adding `\lean{...}` pin for `injective_flasque`). Prover re-dispatch iter-197 CONDITIONAL on writer landing + scoped fastpath blueprint-reviewer clearing the gate. Target: non-empty branch of `constant_of_irreducible` via Route A (provide `Full`/`Faithful` on `constantSheaf J D` for `IrreducibleSpace X`).

### Route Lane BareScheme — `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`
- Sorry trajectory (last 5 iters): 2 → 2 → 2 → 2 → 2.
- Helpers added per iter (last 5 iters): 0, 0, 0, 0, 5 (iter-196 added 5 axiom-clean MvPolynomial substrate decls + structural reduction of smoothness body).
- Prover statuses (last 5 iters): PARTIAL, PARTIAL, PARTIAL, ERROR (API 529; no edits), done (5 substrate decls + cover-reduction landed iter-196).
- Recurring blockers: iter-196: per-chart aux `projectiveLineBar_smooth_chart_aux` gated on chart-ring iso living in downstream ChartIso.lean (import cycle). `projectiveLineBar_geomIrred` ~200-350 LOC substrate gap (Stacks 0BLW base-change of Proj NOT in Mathlib).
- STRATEGY `Iters left`: none stated (rolled into Route C genus-0 arm).
- This iter's plan: refactor `barescheme-smoothness-relocation` IN FLIGHT (relocate `projectiveLineBar_smoothOfRelDim` to ChartIso.lean or new Smooth.lean). Prover re-dispatch iter-197 to close the per-chart sorry (~10 LOC via `Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv`).

### Route Lane E — `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Sorry trajectory (last 5 iters): 3 → 3 → 3 → 3 → 3 → 3 (iter-191 → iter-196).
- Helpers added per iter (last 5 iters): 2, 4, 3, 0 (ERROR), 2 (iter-196: 2 axiom-clean Proj supplements).
- Prover statuses (last 5 iters): PARTIAL, PARTIAL, PARTIAL, ERROR, done (2 substrate primitives landed; step (ii) `Proj.awayι_app_basicOpen` BLOCKED by `Scheme.Hom.app` dependent-motive issue).
- Recurring blockers: ITER-188 through iter-196: `Proj.appIso ⊤ .inv` evaluation chain. iter-196: dependent-motive issue named precisely; workaround via `Proj.basicOpenIsoSpec_inv_app_top` helper named.
- STRATEGY `Iters left` for phase "Genus-0 rigidity — chart-bridge (III.c separated)": `~2-4`, post-pivot velocity `~30-50/it`. Realistic.
- This iter's plan: blueprint-writer `avr-barescheme-mustfix-iter197` IN FLIGHT (adds the `Proj.basicOpenIsoSpec_inv_app_top` lemma block as the missing intermediate; updates Step 1 of `lem:awayi_app_basicOpen` recipe). Prover re-dispatch iter-197 CONDITIONAL on writer landing + scoped fastpath clearing the gate. Iter-196 review identified this as "the most prescribed and shortest closure path (~25-45 LOC for 2 sorry closures)".

### Route Lane I — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- Sorry trajectory (last 5 iters): 3 → 3 → 5 (sanctioned refactor expand) → 4 → 4 → 4 (iter-192 → iter-196).
- Helpers added per iter (last 5 iters): 2, 3, 3, 3, 1 (iter-196: 1 Finsupp helper + Route 2 PID-transfer body landed ~150 LOC).
- Prover statuses (last 5 iters): PARTIAL, PARTIAL, PARTIAL, PARTIAL, done (Route 2 PID transfer body landed axiom-clean modulo 1 named residual `hy_ne_bot`).
- Recurring blockers: pre-iter-196 the L746 sorryAx instance propagation; iter-196 plan-phase must-fix-demotions RESOLVED that. Now: `hy_ne_bot : y.asIdeal ≠ ⊥` (Stacks 02IZ/005X) is the SINGLE named residual on `isRegularInCodimOneProjectiveLineBar`; ~5-10 LOC closure cost. `degree_positivePart_principal_eq_finrank` body still blocked on Hartshorne I.6.12 function-field-determines-curve gap (Mathlib-absent).
- STRATEGY `Iters left` for phase Genus-0 RR.1: `~3-7`, velocity `~10/it`. After iter-196 advance, on schedule.
- This iter's plan: prover re-dispatch iter-197 target the `hy_ne_bot` closure (~5-10 LOC topological-to-algebraic Stacks 02IZ bridge); minimal new work.

### Route Lane A — `AlgebraicJacobian/RiemannRoch/OCofP.lean`
- Sorry trajectory (last 5 iters): 3 → 3 → 3 → 3 → 3 (iter-192 → iter-196). 0 closures, 0 net delta.
- Helpers added per iter (last 5 iters): 1, 0, 0, 0, 2 (iter-196: `toFunctionField_injective` ~50 LOC + extracted helper `functionField_const_of_complete_curve_of_orderZero`).
- Prover statuses (last 5 iters): PARTIAL, PARTIAL, PARTIAL, PARTIAL, done (sub-claims (a) + (b) of `exists_nonconstant_rational_from_dim_eq_two` axiom-clean; (c) extracted to typed substrate helper).
- Recurring blockers: iter-196: closure of `functionField_const_of_complete_curve_of_orderZero` requires algebraic Hartogs (Stacks 0BCK) + `Γ(C, 𝒪_C) = k̄` (Hartshorne I.3.4) — neither in Mathlib. Project-side build: ~80-150 LOC.
- STRATEGY `Iters left` for phase Genus-0 RR.3: `~5-12`, velocity `gated`. Iter-196 unblocked the (a)+(b) substrate; (c) is a multi-iter substrate build.
- This iter's plan: prover re-dispatch iter-197 to BEGIN substrate build for `functionField_const_of_complete_curve_of_orderZero` (carve into 2 sub-helpers per iter-196 task report: algebraic Hartogs + Γ=k̄).

### Route Lane RCI — `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`
- Sorry trajectory (last 5 iters): 1 → 3 (sanctioned carve) → 3 → 3 → 3 (iter-192 → iter-196).
- Helpers added per iter (last 5 iters): 2, 2, 1, 1 (iter-195 named structural lift), 0 (iter-196: 0 new helpers; structural reformulation of helper (a) body).
- Prover statuses (last 5 iters): PARTIAL, PARTIAL, PARTIAL, PARTIAL, done (helper (a) body reformulated via `LocallyQuasiFinite.of_finite_preimage_singleton`; concrete `Set.Finite` gap exposed).
- Recurring blockers: ITER-193 onward: helper (a) per-fibre LQF Mathlib gap ("smooth-dim-1 ⟹ 0-dim fibre"). iter-196 reformulation makes it concrete `(φ.left ⁻¹' {x}).Finite`. helper (d) `IsNormalScheme` Mathlib gap unchanged.
- STRATEGY `Iters left`: "OVER_BUDGET — n/a (paused) | ~20-26 paused".
- This iter's plan: target the generic-point branch of helper (a)'s reformulated body (~30 LOC via `genericPoint_eq` functoriality + `phi_left_functionField_algEquiv_of_finrank_one`). The closed-point branch (smooth-dim-1 ⟹ 0-dim fibre) remains substrate-gated.

### Route Lane G — `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- Sorry trajectory (last 5 iters): 1 → 2 (sanctioned case split) → 1 → 1 → 1 (iter-192 → iter-196).
- Helpers added per iter (last 5 iters): 1, 3, 2, 1, 0.
- Prover statuses (last 5 iters): PARTIAL, done (n=0 closure), PARTIAL, done (`auslander_buchsbaum_formula_succ_pd` typed-helper carved), n/a (no iter-196 dispatch — off-critical-path).
- Recurring blockers: n=k+1 substrate: 4-piece decomposition documented (Krull-intersection theorem chain).
- STRATEGY `Iters left`: `~6-12`, velocity `~50/it`. ON_SCHEDULE.
- This iter's plan: OFF-CRITICAL-PATH; no iter-197 dispatch unless slack remains.

## Current Objectives proposal (iter-197 prover dispatch)

The iter-197 plan agent is considering 5 prover lanes:

1. `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean` (Lane BareScheme
   post-refactor): close per-chart smoothness via algEquiv from
   `mvPolynomialFin_isStandardSmoothOfRelativeDimension`. ~10 LOC.
2. `AlgebraicJacobian/AbelianVarietyRigidity.lean` (Lane E): close
   `Proj.basicOpenIsoSpec_inv_app_top` (new helper after blueprint
   writer lands) + 2 consumer closures. ~25-45 LOC.
3. `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (Lane I): close
   `hy_ne_bot` residual + push `degree_positivePart_principal_eq_finrank`
   structurally. ~5-10 LOC + exploration.
4. `AlgebraicJacobian/RiemannRoch/OCofP.lean` (Lane A): begin
   substrate build for `functionField_const_of_complete_curve_of_orderZero`
   via 2 sub-helpers (Hartogs + Γ=k̄). Multi-iter.
5. `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` (Lane H,
   CONDITIONAL on blueprint writer + scoped review clearing the gate):
   `constant_of_irreducible` non-empty branch Route A OR
   `skyscraperSheaf_iso_constantSheaf_punit` direct construction.
6. `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` (Lane RCI):
   close generic-point branch of helper (a). ~30 LOC.

(File count: 6 — within cap of 10.)

## My question

Verdicts per route + dispatch-sanity verdict for the proposal above.

In particular: for **Lane H** and **Lane E**, the prover re-dispatch
is CONDITIONAL on the blueprint-writer + scoped fastpath review
clearing the HARD GATE this iter. The plan agent is committing to
the writer dispatches + scoped review in plan-phase. If the gates
clear, prover dispatches go ahead. Comment on whether this
conditional-dispatch pattern is appropriate given the route trajectories.

For **Lane A**, the iter-197 plan dispatches a multi-iter
substrate-build (~80-150 LOC) on `functionField_const_of_complete_curve_of_orderZero`.
This is the lane's first explicit substrate-build round; previously
the recipe was carved but not built. Comment on whether this is
appropriate progress, or whether the lane should instead pivot.

For **Lane RCI**, the OVER_BUDGET signal from iter-196 is unchanged.
The plan agent's iter-197 dispatch targets the generic-point branch
of helper (a) (~30 LOC) — a narrow, well-scoped closure. Is this
narrow re-dispatch appropriate given the OVER_BUDGET flag, or
should RCI be HELD pending STRATEGY.md revision?

Do not read STRATEGY.md, PROGRESS.md, iter sidecars, blueprint
chapters, or any narrative file — fresh-context discipline applies.
