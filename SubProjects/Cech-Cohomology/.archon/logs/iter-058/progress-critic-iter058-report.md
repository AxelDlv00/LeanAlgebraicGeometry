# Progress Critic Report

## Slug
iter058

## Iteration
058

## Routes audited

### Route 1 — Need#2 affine Serre vanishing (`AffineSerreVanishing.lean`)

- **Sorry trajectory**: 0 → 0 (iter-056, `AffineSerreVanishing.lean`); 1 → 1 (iter-057, `CechAcyclic.lean` — pre-existing out-of-scope dead stub). `htilde` discharged in iter-057 via `sectionCech_homology_exact_of_affineOpen`.
- **Helper accumulation**: iter-056: +7 axiom-clean decls (cover-system generalization + reduction tops); iter-057: +6 axiom-clean decls (seed builder). Total 13 helpers over 2 iters; each iter's helpers discharged the targeted sub-goal for that iter (isolation of `htilde`, then its closure). No helper-without-payoff pattern.
- **Recurring blockers**: none — the flagged IsScalarTower/semiring-diamond risk did not materialize.
- **Prover status pattern**: PARTIAL (iter-056), PARTIAL (iter-057). Both PARTIALs advanced distinct structural targets; not a same-target repeat.
- **Throughput**: ON SCHEDULE — entered iter-056, elapsed 2 iters, estimate ~3–6.
- **Verdict**: CONVERGING — seed discharged; iter-058 consumer step (~10 LOC, mirrors the already-done `_of_localizationAway` sibling) is the natural close of Need#2 end-to-end. Expect COMPLETE or near-COMPLETE status after iter-058.

---

### Route 2 — Sub-brick A / Stub 1 (`CechSectionIdentification.lean`)

- **Sorry trajectory**: 6 (iter-055, scaffold) → 5 (iter-056, Stub 3 closed + Stubs 5/6 disproved/reformulated) → 5 (iter-057, no close). Net: −1 in 3 iters; stable at 5 for last 2 iters.
- **Helper accumulation**: iter-056: Stub 3 + disproval (structural pruning); iter-057: +6 axiom-clean decls (2 mechanical sub-lemmas + coproduct leaf + 3 helpers), 0 sorries closed. Helpers added in ≥2 of last 3 iters; sorry stable for last 2.
- **Recurring blockers**: "missing-Mathlib scheme coproduct/fibre-product distribution" — appeared in iter-057; analogist corrected scope to WIDE case only. The 120–200 LOC `coproduct_distrib_fibrePower` piece was explicitly deferred in iter-057 ("NOT stubbed, per mathlib-build"). It remains unstarted.
- **Prover status pattern**: PARTIAL (iter-055), PARTIAL (iter-056), PARTIAL (iter-057) — 3 consecutive PARTIALs.
- **Throughput**: ON SCHEDULE — entered iter-055, elapsed 3 iters, estimate ~4–8.
- **Verdict**: CHURNING — 3 consecutive PARTIAL statuses; sorry stable at 5 for 2 iters despite 6 helpers added in iter-057; dominant residual `coproduct_distrib_fibrePower` was explicitly not started ("NOT stubbed") in iter-057 and is proposed as a single 120–200 LOC assignment in iter-058. Assigning a 200-LOC black-box proof in one prover cycle is the pattern that will produce a fourth PARTIAL.
- **Primary corrective**: **Blueprint expansion** — before dispatching a prover on `coproduct_distrib_fibrePower`, expand the blueprint chapter for Stub 1 to decompose the wide-extensivity induction into named sub-steps: at minimum, (a) the base case `n = 1` (trivial), (b) the inductive step using `FinitaryExtensive.sigma_desc`/`widePullback_σ` with an explicit mention of the `Over.mk` gluing site, and (c) the transport across `cechBackbone_obj_widePullback`. The iter-057 analogist has already narrowed the scope correctly; the next step is to make that scope visible to the prover as a structured proof sketch rather than a single opaque 200-LOC goal.

---

### Route 3 — Need#1 Ext-transport (`OpenImmersionPushforward.lean`)

- **Sorry trajectory**: reduced (iter-054/055 via corepresentability + `rightDerivedNatIso` reshape) → 2 → 2 (iter-057: explicit 2 → 2, unchanged).
- **Helper accumulation**: iter-054/055: structural reshape (corepresentability — these did reduce sorries); iter-057: +4 axiom-clean decls (`pushforwardEquivOfIso`, `pushforwardExtAddEquiv`, `modulesIsoSpecExtTransport`), 0 sorries closed. Pattern: a structural advance phase (054/055) followed by a helper-without-payoff phase (057).
- **Prover dispatch pattern**: dispatched iter-054, iter-055, NOT DISPATCHED iter-056, dispatched iter-057. Three dispatched iters; all PARTIAL.
- **Recurring blockers**: "jShriekOU naturality under a scheme iso" — first named in iter-057 signals, immediately flagged as "dominant multi-iter wall" (commuting pushforward with free/sheafification adjunction + yoneda transport across homeomorphism). Not yet ≥3 occurrences by the mechanical rule, but self-described as multi-iter and already blocking the assembly sorries.
- **Prover status pattern**: PARTIAL (iter-054), PARTIAL (iter-055), PARTIAL (iter-057) — 3 PARTIALs in 4 dispatched-or-active iters.
- **Throughput**: ON SCHEDULE (upper portion of window) — entered iter-054, elapsed 4 iters, estimate ~3–6. At 4 of 6 upper bound.
- **Verdict**: CHURNING — 3 PARTIAL statuses across dispatched iters; sorry stable at 2 for 2 consecutive dispatch rounds; the blocker is named a "dominant multi-iter wall" yet iter-058 proposes a mathlib-build attempt against it with an explicit escape clause ("may defer if the blueprint block doesn't clear"). The pattern of accumulating adjacent infrastructure helpers (`pushforwardEquivOfIso`, `pushforwardExtAddEquiv`, `modulesIsoSpecExtTransport`) without closing the assembly sorries, combined with a self-identified multi-iter wall, is textbook CHURNING.
- **Primary corrective**: **Blueprint expansion** — "jShriekOU naturality under a scheme iso" must be decomposed into named sub-goals in the blueprint chapter before the next prover dispatch. At minimum the chapter should name and sketch: (a) naturality of the sheafification adjunction counit under a base homeomorphism / ring isomorphism; (b) yoneda transport of `jShriekOU` across the scheme iso; (c) qcoh-module preservation under pushforward-by-iso. Each becomes its own `sorry`-gated stub. Without this decomposition the prover is attacking a composite wall as a single goal, which is why helpers accumulate at the periphery and the two assembly sorries remain unmoved.
- **Secondary corrective**: once the blueprint decomposition is written, run a Mathlib analogy consult on the qcoh-preservation sub-goal specifically (flagged as medium difficulty) before assigning it to the prover, to confirm the correct Mathlib functor-preservation API.

---

## PROGRESS.md dispatch sanity

- **File count**: 3 (cap: 10)
- **Ready but not dispatched**: none identified — all 3 active routes appear in the proposal.
- **Over the cap**: no
- **Under-dispatch finding**: no — full set of active routes dispatched.
- **Iter-over-iter trend**: insufficient data for multi-iter dispatch trend (3 routes is the full active set).
- **Verdict**: OK — file count 3 within cap 10, no under-dispatch. Note: the Route 3 hedge ("may defer if the blueprint block doesn't clear") is consistent with the CHURNING corrective above — do not dispatch the Route 3 prover until the blueprint chapter exists.

---

## Must-fix-this-iter

- **Route 2 (`CechSectionIdentification.lean`)**: CHURNING — primary corrective: **Blueprint expansion**. Why: assigning `coproduct_distrib_fibrePower` as a 120–200 LOC single-iter prover task without decomposing it into sub-steps in the blueprint chapter will produce a fourth PARTIAL with sorry still at 5. The analogist has already done the scope-narrowing (WIDE case only); the blueprint chapter needs to formalize that narrowing as named sub-steps before the prover is dispatched. Replace the iter-058 prover dispatch on this route with a blueprint-expansion assignment; re-dispatch the prover in iter-059 against the structured sub-stubs.
- **Route 3 (`OpenImmersionPushforward.lean`)**: CHURNING — primary corrective: **Blueprint expansion**. Why: the assembly sorries at 2 have been unchanged for 2 prover rounds despite helpers building toward them; the blocker is a composite multi-sub-goal wall that has been correctly identified but not decomposed. Honor the iter-058 hedge — do NOT dispatch the prover on this route until a blueprint chapter decomposing jShriekOU naturality into at least three named sub-stubs exists. Blueprint expansion is the gating action; prover dispatch follows in iter-059.

---

## Informational

- **Route 1**: consumer step is ~10 LOC, mirrors an already-complete sibling; no concerns. No corrective action required.
- **Route 3 throughput**: at 4 iters elapsed against a 3–6 estimate, the upper budget (6 iters) will be reached around iter-059/060 — the blueprint expansion this iter is necessary to avoid hitting the estimate ceiling with the assembly sorries still open.

---

## Overall verdict

One route (Route 1, `AffineSerreVanishing.lean`) is cleanly CONVERGING and within a single short iter of closing Need#2 end-to-end; proceed as planned. Two routes (Routes 2 and 3) are CHURNING: both have accumulated axiom-clean helpers across three PARTIAL iters without closing their assembly sorries, and both face hard residuals that are not yet decomposed in the blueprint. The iter-058 plan should: (a) dispatch the Route 1 consumer as proposed; (b) for Route 2, substitute the prover dispatch with a blueprint-expansion assignment that decomposes `coproduct_distrib_fibrePower` into named sub-steps; (c) for Route 3, honor the existing hedge and do not dispatch the prover — assign a blueprint-expansion task for jShriekOU naturality decomposition instead, then re-open the prover lane in iter-059. The planner must explicitly respond to these CHURNING findings in `iter/iter-058/plan.md` or rebut them with a concrete rationale; silently assigning another helper round on either churning route is the failure pattern this report exists to prevent.
