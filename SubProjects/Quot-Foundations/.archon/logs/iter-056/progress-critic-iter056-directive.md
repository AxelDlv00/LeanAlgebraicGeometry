# Progress-critic directive — iter-056

Assess convergence per active route. Signals are the last 5 iters (051–055).

## Route GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean` (`genericFlatness`)
- Phase: GF-geo (source-span descent), entered ~iter-053. STRATEGY `Iters left`: 2–4.
- Active sorry per iter: 051=1, 052=1, 053=1, 054=2, 055=1.
- Helpers added per iter: 053 +2 (B1.0,B1); 054 +3 (B2.1/2/3); 055 +2 (span_descent, flat_of_isBaseChange_id) AND closed the 2-iter-STUCK `gf_common_basicOpen_basis`.
- Prover statuses: PARTIAL every iter; `genericFlatness` never fully closed.
- Recurring blocker phrases: "missing Mathlib ingredient", "open-immersion base change", iter-055 "STUCK / hard deadline iter-055 MISSED".
- NEW this plan phase (planner finding): the supposedly-absent base change IS in Mathlib (`Mathlib.Algebra.Algebra.Epi`: `Algebra.IsEpi`/`TensorProduct.lid'`; `CommRingCat.epi_iff_isEpi`). Gap shrinks to ONE bridge lemma (open immersion of affine opens ⟹ `Algebra.IsEpi`). Planner is re-speccing + dispatching a mathlib-build lane.

## Route GR — `AlgebraicJacobian/Picard/GrassmannianQuot.lean`
- Phase: QUOT-repr / GR-quot. STRATEGY `Iters left`: 6–12.
- Active sorry per iter: 052=5, 053=5, 054=6, 055=4.
- Helpers added: 053 +8; 054 +2 (closed `functor.map_id`); 055 +2 (closed `functor` FULLY — `pullbackObjUnitToUnit_comp` keystone + `map_comp`).
- Prover statuses: PARTIAL→ iter-054 dropped `functor.map_id` → iter-055 DROPPED `functor` entirely.
- Remaining 4 sorries (glue, universalQuotient, tautologicalQuotient, represents) ALL ride on `Scheme.Modules.glue`, an undecomposed multi-hundred-line from-scratch module-descent construction.
- Planner proposal: NO prover this iter; effort-breaker decomposes `glue` into sub-lemmas (prover next iter).

## Route SNAP — `AlgebraicJacobian/Picard/SectionGradedRing.lean`
- Phase: SNAP `def:sectionGradedRing`. STRATEGY `Iters left`: 4–8.
- Active sorry per iter: 0,0,0 (file stays 0-sorry; progress = adding declarations).
- Helpers added: 053 +22 (objectwise coequalizer DONE); 054 ZERO committed output (no-op-filter dropped the objective); 055 +1 (`relTensorDomainPresheaf` Step-1 brick) + resolved the central CommRing-routing unknown.
- Prover statuses: 051 DROPPED (no-op filter), 054 NO output (no-op filter), 055 PARTIAL (Step-1 brick + CommRing discovery; next brick `T` hit a 200k-heartbeat perf wall).
- Recurring blocker: no-op-filter drops (FIXED iter-055), then a perf wall (engineering, not a math gap). Recipe is concrete + ingredients verified present in pin.
- Planner proposal: mathlib-build prover on `T` + promotion + crux, with `maxHeartbeats` headroom + the build-`T`-as-`relTensorDomainPresheaf`-twice recipe.

## Proposed `## Current Objectives` for iter-056 (file count + basenames)
1. `FlatteningStratification.lean` [mathlib-build] — build `Algebra.IsEpi` bridge + re-route descent + close `genericFlatness`. (gated on this iter's blueprint re-spec clearing the gate)
2. `SectionGradedRing.lean` [mathlib-build] — `T` + presheaf promotion + crux.
(GR = blueprint-decomposition only this iter, no prover.)

Give a per-route verdict (CONVERGING/CHURNING/STUCK/UNCLEAR) + named corrective for any CHURNING/STUCK.
