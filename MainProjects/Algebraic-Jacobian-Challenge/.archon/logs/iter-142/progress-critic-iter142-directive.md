# Progress Critic Directive

## Slug
iter142

## Iter
142

## Active routes / files under review

### Route: `AlgebraicJacobian/Cotangent/GrpObj.lean` — piece (i.b) Step 2 (BUNDLED d_app L624 + d_map L643 + IsIso L689)

- **Started at iter**: 134 (the lane on `mulRight_globalises_cotangent` opened iter-134 with Step 1 closure as `shearMulRight`)
- **Iters audited**: iter-137 → iter-141 (K=5)

#### Sorry counts per iter (on `Cotangent/GrpObj.lean` only, decls / inline)

- iter-137: 1 / 1 (`mulRight_globalises_cotangent` Main only; piece (i.b) Main scaffold present, Step 2 not yet attempted)
- iter-138: 3 / 4 (Step 2 attempted; decomposition refinement: `basechange_along_proj_two_inv_derivation` shipped with d_app + d_map sub-sorries; `relativeDifferentialsPresheaf_basechange_along_proj_two` IsIso `letI := sorry`; `mulRight_globalises_cotangent` Main carry-over)
- iter-139: 3 / 4 (no prover lane — intentional plan-only deferral per HARD GATE)
- iter-140: 3 / 4 (prover lane PARTIAL — 0 of 3 sub-sorries closed strict-count; structural advance via new private helper `isIso_of_app_iso_module` narrowing IsIso from `letI := sorry` to `isIso_of_app_iso_module ... (fun _ => sorry)`; d_app `change`-tactic scaffolding committed; d_map closure-recipe docstring committed)
- iter-141: 3 / 4 (no prover lane — intentional plan-only deferral per HARD GATE + CHURNING)

#### Helpers added per iter (on this route)

- iter-137: 0 (route had not opened the Step 2 sub-sorry decomposition yet)
- iter-138: +2 helpers (`basechange_along_proj_two_inv_derivation` + `basechange_along_proj_two_inv` shipped as named declarations with sub-sorries)
- iter-139: 0 (plan-only iter; Wave 3 blueprint-writer landed +125 LOC of recipes in `RigidityKbar.tex`)
- iter-140: +1 helper (`isIso_of_app_iso_module` private theorem; closed body, kernel-only; not protected, marked upstream-PR candidate)
- iter-141: 0 (plan-only iter; Wave 2 mathlib-analogist `d-app-d-map-recipe-shape` + Wave 3 blueprint-writer landed; analogies/d-app-d-map-recipe-shape.md persistent file)

#### Prover statuses per iter

- iter-137: COMPLETE — first piece (i.b) Step 2 prover-lane attempt; landed substantive Route (b) scaffolding (1 helper at the time was the Step 2 universal-property route)
- iter-138: PARTIAL — substantive structural body cut on piece (i.b) Step 2 (Route (b) skeleton landed end-to-end; d_add + d_mul closed honestly; d_app + d_map + IsIso sub-sorries remain)
- iter-139: no prover dispatch (intentional plan-only deferral per HARD GATE)
- iter-140: PARTIAL — structural advance on IsIso (per-open narrowing via new `isIso_of_app_iso_module`); d_app `change` succeeds (validated by `lean_goal`) but factoring-witness body remains `sorry`; d_map `change`-first attempt blocked by `pushforward₀` `whnf` deterministic timeout at maxHeartbeats=200000 (reverted to docstring-only commit)
- iter-141: no prover dispatch (intentional plan-only deferral per HARD GATE + CHURNING)

#### Recurring blocker phrases

- "categorical chase / factoring witness `h`" appears in iter-138, iter-140 (d_app sub-sorry remains across both attempts; closure recipe was sharpened iter-140 with the standalone-validated `Derivation.map_algebraMap` pattern; iter-141 analogist confirmed bespoke ~40–80 LOC chase is the right size).
- "`whnf` opacity / `pushforward₀` `set_option backward.isDefEq.respectTransparency false in`" appears in iter-140 (NEW d_map blocker on the `change`-first approach; iter-141 analogist resolved with **named-lemma** approach `PresheafOfModules.pushforward_obj_map_apply'` + `simp only` not `change`).
- "per-open IsIso identification (Route (b'2))" appears in iter-139, iter-140 (iter-139 analogist verdict PROCEED with Route (b'2); iter-140 landed the per-open narrowing structure via `isIso_of_app_iso_module`; residual `(fun _ => sorry)` is the per-open identification body).

#### Planner's current proposal for this iter

Fire iter-142 prover lane on `Cotangent/GrpObj.lean` BUNDLED 3-sub-sorry closure (d_app L624 + d_map L643 + IsIso L689) with the iter-141 Wave 2 + Wave 3 refined recipes (d-app-d-map-recipe-shape.md + RigidityKbar.tex 1349 LOC + d_app `Derivation.map_algebraMap`-streamlining + d_map `PresheafOfModules.pushforward_obj_map_apply'` chase + IsIso Route (b'2) per-open identification).

The iter-141 plan agent committed this iter-142 lane shape after Wave 1 (3 mandatory critics) + Wave 2 (d_app/d_map analogist) + Wave 3 (blueprint-writer) all returned and were absorbed. Iter-141 progress-critic returned CHURNING with PRIMARY corrective = mathlib-analogist consult on the d_map `whnf`-opacity blocker. That corrective was executed iter-141 Wave 2 and yielded the named-lemma resolution (`PresheafOfModules.pushforward_obj_map_apply'`).

Iter-142 pre-committed acceptance criterion (from iter-141 PROGRESS.md § Watch criteria committed for iter-142, item 2):
- **PASS arm**: ≥2 of 3 sub-sorries closed (d_app + d_map at minimum; IsIso preferred via Route (b'2)) → CONVERGING-confirmed.
- **PARTIAL arm**: 0 or 1 sub-sorries closed → CHURNING-CONFIRMED (iter-141 was CHURNING-trigger; iter-142 PARTIAL elevates to CHURNING-confirmed); mid-iter strategy-critic re-dispatch with diagnostic question (NOT pre-committed answer), surface route correctives including sub-decomposition pivot (fibre-free per L559) + structural side-step refactor + bundled Mathlib-PR detour.
- **FAIL arm**: 0 sub-sorries closed AND new opacity-family blocker phrase resurfaces → STUCK; route pivot mandatory.

## Out of scope

- `Jacobian.lean` (L197 `genusZeroWitness` + L223 `positiveGenusWitness`) — downstream scaffolds, not under prover attention this iter.
- `RigidityKbar.lean` (L87 `rigidity_over_kbar`) — downstream M2.a body, gated on the cotangent-vanishing pile.
- `Cotangent/GrpObj.lean:817` `mulRight_globalises_cotangent` Main — iter-143+ post-Step-2-closure target.
- Off-critical-path documentation lane (M3 smallest-PR-piece RelativeSpec).
