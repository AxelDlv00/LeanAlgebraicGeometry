# Progress Critic Report

## Slug
iter004

## Iteration
004

## Routes audited

### Route: FBC-A — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: 2 → 3 → 3 (iter-002 to iter-003). File-level count flat at 3 for 2 iters, but the *content* of the 3 sorries changed fundamentally: the single monolithic `pushforward_base_change_mate_cancelBaseChange` sorry was replaced in iter-003 by a proved assembly depending on a single concrete residue (`base_change_mate_generator_trace`). The other 2 sorries (`affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`) are pre-existing downstream deferrals, not new failures.
- **Helper accumulation**: iter-002 landed `base_change_map_affine_local` (proved) + new mate-lemma stub; iter-003 landed L1 (`pullback_fst_snd_specMap_tensor`), L2 (`base_change_mate_domain_read`), L3 (`base_change_mate_codomain_read`) all axiom-clean + 2 structural helpers (`pullbackIsoEquivalenceOfIso`, `pullback_isEquivalence_of_iso`). 3 declarations formally sorry-eliminated within the iter-003 window; the parent assembly was closed as a genuine proof.
- **Recurring blockers**: none. Iter-002 blocker was "mate crux blocked on pullbackSpecIso identification"; that was resolved in iter-003 (L1 proved). Iter-003 blocker is "L4 generator trace — concrete tensor map." These are distinct walls, not a recurring phrase.
- **Avoidance patterns**: none.
- **Prover status pattern**: PARTIAL (iter-002), PARTIAL (iter-003).
- **Throughput**: ON_SCHEDULE — 2 iters elapsed against a 3–5 iter estimate from iter-002.

**Informational flag — downstream undiscounted work.** The iter-004 plan targets closing `base_change_mate_generator_trace` (L4) via the effort-breaker's 3-sub-lemma chain. Even if L4 closes cleanly, the next sorry (`affineBaseChange_pushforward_iso`) is described inline as a "multi-hundred-LOC build" requiring restriction-compatibility of `pushforwardBaseChangeMap` across affine charts — a piece that is Mathlib-absent and not currently scaffolded. Closing L4 reduces the FBC-A sorry count to 2, but `affineBaseChange_pushforward_iso` is likely ≥1 dedicated iter. Total estimated FBC-A iters from iter-002: 5–6, which reaches or exceeds the strategy estimate upper bound. Route is ON_SCHEDULE *now* but SLIPPING becomes probable after iter-004.

The sub-lemma `base_change_mate_generator_trace_eq` (the adjoint-mate trace, effort 2332) retains the three-step unit/restriction/transpose content. The effort-breaker explicitly flags it as a re-break candidate if the prover stalls on it. The prover should attempt it but is pre-authorised to leave it partially scaffolded.

- **Verdict**: CONVERGING

---

### Route: GF-alg — `AlgebraicJacobian/Picard/FlatteningStratification.lean`

- **Sorry trajectory**: 1 → 2 → 5 (iter-002 to iter-003). Count rising due to scaffolding — iter-003 added the full 5-lemma chain as stubs, then closed L1 (`exists_free_localizationAway_of_torsion`) axiom-clean and proved the L5 base case (d=0). The 5 current sorries are: L3 (`exists_free_localizationAway_of_shortExact`), L4 (`exists_localizationAway_finite_mvPolynomial`), L5 inductive step (`exists_free_localizationAway_polynomial`), `genericFlatnessAlgebraic` residue, `genericFlatness`.
- **Helper accumulation**: iter-002 proved the primary branch of `genericFlatnessAlgebraic` and the three finite-module helpers axiom-clean. Iter-003 proved L1 axiom-clean and the d=0 base of L5; scaffolded L3, L4, L5 with concrete next-step notes inside each sorry body. Sorry-elimination DID occur (L1 closed, L5 base proved); the count rose because scaffolding added more stubs than were immediately closed.
- **Recurring blockers**: none. Iter-002 blocker was "generic-point freeness" (resolved). Iter-003 blockers are "module-side localization plumbing" (L3), "instance-existential encoding" (L4), "generic-rank dévissage" (L5) — all distinct new walls.
- **Avoidance patterns**: none. The lean-auditor iter-003 confirmed the instance-existential fragility in L4's signature (3 anonymous `∃ (_ : Algebra…)` existentials) as a MAJOR finding; the blueprint-writer iter-004 has already re-encoded the L4 interface to an explicit-AlgHom signature. This addresses the fragility before the prover touches it.
- **Prover status pattern**: PARTIAL (iter-002), PARTIAL (iter-003).
- **Throughput**: ON_SCHEDULE — 2 iters elapsed against a 3–5 iter estimate from iter-002.

**Informational flag — L4/L5 depth risk.** The iter-004 plan targets closing L3 via 3 sub-lemmas (L3a: localised-SES exactness, L3b: free transport across a finer localisation, L3c: SES split with free quotient). The iter-003 prover identified Mathlib anchors for all three; these should close. L4 (Noether normalisation + clearing denominators) is re-signed in iter-004 but not expected to close — it is a non-trivial construction. L5 inductive step (generic-rank dévissage) depends on L3 and L4 being proved. Conservative projection: iter-004 closes L3 (3 sorries → 1), L4 remains sorry, L5 inductive step remains sorry. Subsequent iters: iter-005 attacks L4, iter-006 closes L4 and opens L5-step, iter-007 closes L5-step + assembly. That is 5 iters from iter-002, at the high end of estimate. Route is ON_SCHEDULE *now* but one non-trivial block on L4 would push it past the upper bound.

**Serial-lane question (addressed directly).** No serial bottleneck has been demonstrated after 2 prover iters. The L3 sub-lemmas and L4 are independent in the dependency graph; a single prover working sequentially (L3a → L3b → L3c → L3 assembly → L4 re-sign attempt) is the right structure for iter-004. Splitting into parallel files would add overhead without benefit at this stage. The PROGRESS.md already carries the standing directive: split only if a lane demonstrates it cannot clear its independent leaves in one session. Recommend maintaining the single lane for iter-004 and re-evaluating if iter-004 returns PARTIAL on L3 or INCOMPLETE.

- **Verdict**: CONVERGING

---

## PROGRESS.md dispatch sanity

Verdict: OK — file count 2 (both active routes dispatched), within default cap of 10, no ready files absent from the proposal. No QUOT-track files are in scope this iter per the PROGRESS.md gating ("BLOCKED behind FBC/GF"), so the 2-file dispatch covers the live frontier completely.

---

## Informational

Both routes are CONVERGING. The specific items worth surfacing:

1. **FBC-A post-L4 gap.** The current iter-004 plan correctly scopes to closing L4 (`base_change_mate_generator_trace`). The plan agent should prepare a blueprint-writer pass for the affine-restriction-compatibility of `pushforwardBaseChangeMap` (the "multi-hundred-LOC" block in `affineBaseChange_pushforward_iso`) before the next prover iter on FBC-A, so the prover has a concrete sub-lemma scaffold to work against rather than a blank sorry.

2. **GF-alg L4 re-sign vs close.** The iter-004 plan asks the prover to "re-sign and attack L4" (AlgHom form). A re-sign alone (changing the existential interface without closing the sorry) will likely leave L4 with a sorry. The plan agent should not count the re-sign as a sorry-elimination when reviewing iter-004 results.

3. **FBC-A `Sheaf.val` deprecation cluster.** The lean-auditor iter-003 flagged 21 sites of deprecated `CategoryTheory.Sheaf.val` (replacement: `ObjectProperty.obj`) in proved, axiom-clean declarations. These are not blocking today but will become build-breaking when Mathlib removes the field. Should be addressed before the next Mathlib pin bump; a small dedicated golf/refactor pass is sufficient.

---

## Overall verdict

Both routes are CONVERGING. FBC-A has 2 prover iters of genuine structural progress: the monolithic mate-lemma sorry was atomized and 3 of its 4 sub-lemmas proved axiom-clean; iter-004's plan to close L4 via a further 3-sub-lemma decomposition (regroupEquiv + generator trace eq + IsIso corollary) is a real advance, not a re-dispatch of the same wall. GF-alg likewise shows genuine sorry-elimination each iter (L1 and L5 base case proved in iter-003); iter-004's L3 sub-lemma approach (3 sub-lemmas with identified Mathlib anchors) should succeed. No CHURNING or STUCK verdicts. The main risk for both routes is THROUGHPUT: each is ON_SCHEDULE by raw iter count but carries undiscounted downstream work (FBC-A: affine-restriction-compatibility; GF-alg: Noether normalisation + generic-rank dévissage) that puts them at the edge of the 3–5 iter estimate. The plan agent should flag both routes as SLIPPING candidates at the next progress-critic invocation if iter-004 does not close L4 on FBC-A or L3 on GF-alg.
