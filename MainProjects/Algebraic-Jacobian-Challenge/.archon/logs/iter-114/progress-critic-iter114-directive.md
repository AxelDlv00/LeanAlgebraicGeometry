# Progress Critic Directive

## Slug
iter114

## Iter
114

## Active routes / files under review

### Route: AlgebraicJacobian/Differentials.lean — Phase B helper #1 / unique-gluing route (L122 → L177 → L175)

- **Started at iter**: iter-112 (helper #1 introduced at original L159; reformulated to unique-gluing form iter-113)
- **Iters audited**: iter-110 to iter-113 (4 iters)

#### Sorry counts per iter (project total; Differentials.lean per-file in parens)
- iter-110: 16 (5)  — no prover lane this iter; deeper-think
- iter-111: 16 (5)  — no prover lane this iter; blueprint-writer round
- iter-112: 16 (5)  — single Phase B prover lane on the original L122 sorry; PARTIAL Bar B (helper #1 introduced at L159 with sorry body; helper #2 fully closed at L188; main theorem L220 fully closed)
- iter-113: 16 (5)  — single Phase B prover lane on helper #1 (L177); PARTIAL Bar B variant (reformulation route): helper #1 now fully closed at L209 via Mathlib framework chain, NEW sub-helper `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` at L168 carries the sorry

#### Helpers added per iter (within Differentials.lean)
- iter-110: 0 helpers added (no prover lane; blueprint-writer + analogist iter)
- iter-111: 0 helpers added (no prover lane; blueprint-writer chapter rewrite)
- iter-112: 2 new top-level helpers added (`relativeDifferentialsPresheaf_isSheafOpensLeCover_type` at L159 with sorry body; `relativeDifferentialsPresheaf_isSheaf_type` at L188 fully closed); main theorem body L220 fully closed (was sorry)
- iter-113: 1 new top-level helper added (`relativeDifferentialsPresheaf_isSheafUniqueGluing_type` at L168 with sorry body); helper #1 body at L209 fully closed; sorry count flat in file

#### Prover statuses per iter
- iter-110: no prover dispatched (deeper-think iter)
- iter-111: no prover dispatched (blueprint-writer iter)
- iter-112: PARTIAL — Bar B achieved (Route (a) chosen; ≥2 named helpers instantiated; main theorem body fully closed; load-bearing residual exposed as helper #1 at L159). Sorry count 5 → 5.
- iter-113: PARTIAL — Bar B variant (reformulation route): helper #1 body fully closed; residual mathematical content migrated to a new top-level helper `_isSheafUniqueGluing_type` at L168. Prover's own honest assessment: "**This is a *reformulation* rather than genuine mathematical progress.** The unique-gluing form has the same mathematical content as the OpensLeCover form (they are Mathlib-verified equivalent); the iter-114 prover still has to prove the substantive claim." Sorry count 5 → 5.

#### Recurring blocker phrases
- "no off-the-shelf Mathlib lemma packages sheaf-on-affine-basis-of-Scheme ⇒ sheaf for Scheme.PresheafOfModules" — appears in iter-110 blueprint-writer report, iter-112 prover report, iter-113 blueprint chapter [gap] callout. The Mathlib-side gap is consistent across iters; the project iterates approaches to work around it.
- "Bar B (acceptable, single sub-lemma close): the residual moves into one new sub-helper" — appears in iter-112 PROGRESS.md and was the result iter-112 achieved. The iter-113 outcome matches the same Bar B shape: residual moved, no substantive closure.

#### Planner's current proposal for this iter
The planner wants to dispatch a single Phase B prover lane on `Differentials.lean` L175 `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`. Success bars:
- **Bar A (preferred)**: close L175's sorry — file sorry count 5 → 4, project total 16 → 15. The prover's iter-113 report named a concrete 3-step closure recipe in the docstring (universal property of `KaehlerDifferential` + structure-sheaf gluing + `span_range_derivation` uniqueness).
- **Bar B (acceptable, single named sub-lemma close)**: at least one of the 3 recipe steps is fully closed as a top-level sub-helper, the other residual exposed with a sorry body. File sorry count stays at 5.
- **Bar C (regression — flips route to CHURNING)**: another sorry-bodied sub-helper introduced without ANY substantive closure (i.e. another reformulation or another mathematically-equivalent reshape).

The planner explicitly intends NOT to accept a third consecutive "structural state change, no sorry-elimination" iter. The plan-phase blueprint-writer dispatch on Differentials.tex (separate task this iter) will document the unique-gluing route as the prose route, so the prover has matching prose-and-Lean for the iter-114 attack.

## Out of scope

All non-Differentials files this iter (no other prover lanes scheduled). Helper #1 is the only active route. Other Differentials sorries (L798 `h_exact`, L880 `smooth_iff_locally_free_omega`, L897 `cotangent_at_section`, L1039 `serre_duality_genus`) are off-limits this iter.
