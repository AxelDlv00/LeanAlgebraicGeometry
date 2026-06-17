# Progress Critic Report

## Slug
iter018

## Iteration
018

## Routes audited

### Route: FBC — AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **Sorry trajectory**: 4 → 4 → 4 → 4 across iter-014 to iter-017. Flat for four consecutive prover iters. The iter-017 prover report confirms the sorry count is unchanged at 4, though the Seam-2 sorry was structurally re-located (moved from the opaque full-reindex position into the single step-iii crux of `base_change_mate_fstar_reindex_legs`). Net change over 4 iters: 0.
- **Helper accumulation**: iter-014: 0; iter-015: +1 (scaffold, sorry-bearing); iter-016: +1 (`pullbackPushforward_unit_comp`, axiom-clean); iter-017: +4 axiom-clean (`base_change_mate_codomain_read_legs`, 3 `gammaMap_pushforward*` collapses) + structural restructure dissolving the motive wall. Helpers added in 3 of 4 audited iters; net sorry closure: 0. The iter-017 helpers DID accomplish the mandated structural corrective (the motive wall is dissolved), but no sorry was closed.
- **Prover dispatch pattern**: 1 file per iter (014–017). Single-file route; no multi-file under-dispatch applicable.
- **Recurring blockers**: The "motive is not type correct" / dependent-position wall that appeared in iter-015 and iter-016 (2 consecutive iters) was **RESOLVED in iter-017** via the subst-able legs refactor — the prior CHURNING corrective was correctly executed. New blocker: **"mate-unwinding crux / Mathlib-absent"** (step-iii of `base_change_mate_fstar_reindex_legs`) — first appearance in iter-017. NOT recurring yet (1 appearance).
- **Avoidance patterns**: none. All 4 audited iters had prover dispatches.
- **Prover status pattern**: COMPLETE (014), PARTIAL (015), PARTIAL (016), PARTIAL (017). **Three consecutive PARTIAL.**
- **Throughput**: OVER_BUDGET — Phase FBC-A entered ~iter-012; elapsed = 6 iters; STRATEGY.md says "Iters left: 2–3". Elapsed (6) equals 2 × the upper bound of remaining estimate (2 × 3 = 6), placing this at the OVER_BUDGET boundary. By the end of iter-018, elapsed will be 7 (> 2 × 3), which crosses unambiguously into OVER_BUDGET territory. The iter-017 progress-critic already flagged this and mandated a STRATEGY.md update; the estimate appears unchanged (still "2–3 iters left").
- **Verdict**: CHURNING — triggered by PARTIAL prover status in 3 of the last 4 iters, combined with sorry count net unchanged across all 4 iters despite helpers added in 3 of those iters. The structural change in iter-017 (subst-able legs refactor dissolving the motive wall) is genuine — it executed the mandated corrective — but does not override the PARTIAL ≥ 3 criterion.
- **Primary corrective**: **Blueprint expansion** — the surviving step-iii crux in `base_change_mate_fstar_reindex_legs` is characterized as "Mathlib-absent mate-unwinding" with a 4-step proof path ((a) rewrite unit factor by `pullbackPushforward_unit_comp`, (b) absorb the `e`-iso unit via `pullback_isEquivalence_of_iso`, (c) identify the `Spec ιA`-unit via Seam-1 `base_change_mate_unit_value`, (d) land on `base_change_mate_inner_value`) — this path must appear in the blueprint chapter as the proof sketch of `lem:base_change_mate_fstar_reindex_legs` before the prover is dispatched. The iter-018 plan already includes a blueprint-writer directive (`blueprint-writer-fbc-pins018-directive.md`) that adds this block with the step-iii path specified. The **critical discipline**: the FBC prover MUST be sequenced strictly after the blueprint-writer completes and its report confirms the step-iii sequence is correctly stated in the chapter. Dispatching the prover before the blueprint gate is cleared will reproduce the prior under-specification pattern that drove 3 consecutive PARTIAL outcomes.

---

### Route: GF — AlgebraicJacobian/Picard/FlatteningStratification.lean

- **Sorry trajectory**: 4 → 5 → 4 → 3 across iter-014 to iter-017. Net: −1 in 4 iters. The iter-015 +1 was a deliberate decomposition stub (a sorry-bearing helper introduced as a closure vehicle for the OreLocalization-blocked L5); it was closed in iter-016. The iter-017 −1 is the genuine L5 `exists_free_localizationAway_polynomial` closure, axiom-clean, by defusing the OreLocalization instance-presentation diamond.
- **Helper accumulation**: iter-014: 0; iter-015: +1 (`free_localizationAway_of_away_tower`, deliberate); iter-016: 0 (closed the stub); iter-017: 0 net (signature simplification only). Helpers added in 1 of 4 iters; both genuine closures happened in iters with 0 or minimal new helpers. Payoff pattern: clean.
- **Prover dispatch pattern**: 1 file per iter (014–017). Single-file route.
- **Recurring blockers**: "OreLocalization instance-presentation diamond" appeared in iter-015 and iter-016 (2 consecutive iters; the prior critic flagged it as 1 iter from the STUCK threshold). **RESOLVED in iter-017** — the redundant 6th canonical existential was dropped from `gf_torsion_reindex`, defusing the instance-transparency mismatch. No new recurring blockers.
- **Avoidance patterns**: none.
- **Prover status pattern**: COMPLETE (014), PARTIAL (015), COMPLETE (016), COMPLETE (017). Three COMPLETEs out of 4 iters; the single PARTIAL represents a purposeful decomposition step, not stall.
- **Throughput**: OVER_BUDGET — Phase GF-alg entered ~iter-010; elapsed = 7 iters; STRATEGY.md says "Iters left: 1–3". Elapsed (7) > 2 × upper bound (2 × 3 = 6). OVER_BUDGET.
- **Verdict**: CONVERGING — the CHURNING rules do not fire: helpers added in only 1 of 4 iters; PARTIAL in only 1 of 4; sorry strictly decreased (4 → 3 net over window). The STUCK rules do not fire: sorry was eliminated (−1 net), no recurring blocker across 3+ iters. The OreLocalization blocker, the prior critical watch signal, was resolved exactly on schedule. The GF route is closing; L4 `exists_localizationAway_finite_mvPolynomial` (line 516) and `genericFlatnessAlgebraic` (line 1558, gated on L4) are the two remaining algebraic-phase sorries. **The OVER_BUDGET throughput finding is a must-fix administrative item (revise the estimate), not a route-level concern.**

---

### Route: QUOT — AlgebraicJacobian/Picard/QuotScheme.lean

- **Sorry trajectory**: 4 → 4 → 4 across iter-015 to iter-017. Net: 0 across 3 audited iters. All 4 sorries are pre-existing protected stubs (lines 126, 165, 201, 228) — none can be closed until the mathematical content is assembled.
- **Helper accumulation**: iter-015: +3 axiom-clean (D5 + G1 halves, Route-1 infrastructure); iter-016: 0 (no prover — deliberate Route-2 pivot); iter-017: +13 axiom-clean (keystone D6 `subquotient_degreewise_diff` + ambient homogeneity calculus, Route-2). Helpers added in 2 of 3 audited iters with 0 sorry closures across all 3. The STUCK rule "helpers added without any sorry-elimination across K iters" technically fires: 2 iters of helper additions, 0 closures, in a K=3 window that includes the deliberate no-prover pivot.
- **Avoidance patterns**: iter-016 was a no-prover iter (Route-2 pivot — the mandated CHURNING corrective from iter-016's progress-critic). The plan-phase-only meta-pattern (≥3 consecutive no-prover iters) has NOT fired (only 1 no-prover iter).
- **Prover status pattern**: PARTIAL (015, Route-1), N/A (016, pivot), PARTIAL (017, Route-2). Route-2 prover data: **1 prover iter**.
- **Throughput**: ON_SCHEDULE — SNAP-S2 Route-2 entered iter-016 (pivot) / first prover dispatch iter-017; elapsed Route-2 prover iters = 1; STRATEGY.md says "Iters left: 2–3". 1 ≤ 2, within estimate.
- **Verdict**: UNCLEAR — Route-2 has only 1 prover iter of data, below the K = 3–5 threshold for a reliable verdict. The STUCK criterion (helpers in 2 iters, 0 closures in K-window) fires technically, but the K-window includes a deliberate no-prover pivot iter, and the Route-2 data set is a single iteration. Applying STUCK on 1 Route-2 prover result would be premature.

  **Critical watchpoint for iter-019**: if iter-018's QUOT prover (targeting the `Module.Finite (MvPolynomial (Fin r) κ) M` encoding + `subquotient_hilbertSeries_rational` P(r) induction stub) does NOT close at least 1 of the 4 protected sorries, the STUCK criterion will fire unambiguously at iter-019. The finiteness encoding has a scouted tool path (`Algebra.adjoinCommRingOfComm` → `aeval` → `Module.compHom` → `eval(t_{r-1}=0)` surjection → `restrictScalars_of_surjective`) that is concrete and Mathlib-locatable — this is not a vague hope. But the prover must close a stub this iter for the route to stay UNCLEAR rather than flipping to STUCK. The iter-018 blueprint-writer directive for QUOT (preparing 11 homogeneity-calculus blocks + the finiteness-encoding recipe) directly supports this — the same gate discipline as FBC applies: the QUOT prover must be dispatched after the blueprint-writer completes and the finiteness-encoding proof sketch is in the chapter.

---

## PROGRESS.md dispatch sanity

Verdict: OK — file count 3 (FlatBaseChange.lean, FlatteningStratification.lean, QuotScheme.lean) within cap 10; all 3 active ready lanes are proposed; no identified fourth file with complete blueprint chapter and open sorries absent from the proposal; no bloat.

- **File count**: 3 (cap: 10)
- **Ready but not dispatched**: none identified
- **Over the cap**: no
- **Under-dispatch finding**: no — all active lanes in proposal
- **Iter-over-iter trend**: 3 → 3 → 3; stable at 3 active files matching 3 active routes

**Sequencing discipline (not an under-dispatch finding, but must-execute)**: both the FBC and QUOT prover dispatches are gated on their respective blueprint-writers completing. Blueprint-writer directives for both exist (`blueprint-writer-fbc-pins018-directive.md`, `blueprint-writer-quot-route2-018-directive.md`) but neither has been dispatched as of this assessment (only the progress-critic appears in `dispatch.jsonl`). The provers MUST NOT be dispatched before the blueprint-writers return and their reports confirm the proof sketches are in the chapters.

---

## Must-fix-this-iter

- **Route FBC: CHURNING** — primary corrective: **Blueprint expansion**. The step-iii mate-unwinding sequence must be specified in `lem:base_change_mate_fstar_reindex_legs`'s blueprint proof sketch before the prover is dispatched. The blueprint-writer directive already encodes this — execute it first, confirm the 4-step path ((a) `pullbackPushforward_unit_comp`, (b) `e`-iso absorption, (c) `base_change_mate_unit_value`, (d) `base_change_mate_inner_value`) is correctly stated, THEN dispatch the prover. Do NOT dispatch the FBC prover before the blueprint-writer report lands. A second consecutive prover attempt without the blueprint gate clears will reproduce the under-specification pattern that drove 3 PARTIAL outcomes.

- **Route FBC: OVER_BUDGET** — STRATEGY.md says "Iters left: 2–3"; elapsed = 6 iters in Phase FBC-A (enters OVER_BUDGET territory during iter-018 when elapsed reaches 7). The iter-017 progress-critic also flagged this and mandated a STRATEGY.md update; the estimate appears unchanged. Revise the FBC-A `Iters left` row in STRATEGY.md to reflect the realistic remaining cost (3–4 iters: 1 for step-iii closure + Seam-3 cascade, 1–2 for the affine and flat forms). Do this before the iter-018 prover dispatch.

- **Route GF: OVER_BUDGET** — STRATEGY.md says "Iters left: 1–3"; elapsed = 7 iters in Phase GF-alg (elapsed 7 > 2 × upper bound 6). Revise the GF-alg `Iters left` row to reflect the realistic remaining cost. GF is genuinely CONVERGING (3 COMPLETEs in 4 iters, sorry net −1, no blockers), so this is an administrative estimate correction, not a route concern. Realistic remaining: 2–3 iters (L4 closure, then `genericFlatnessAlgebraic`, then `genericFlatness` gated on geo-phase).

---

## Informational

**FBC: the CHURNING corrective WAS executed.** The iter-017 subst-able-legs refactor is a genuine structural advance: the motive wall that blocked iters 014–016 is dissolved, the concrete `base_change_mate_fstar_reindex` is now sorry-free, and the Seam-2 sorry is isolated to a single well-characterized step-iii goal. The CHURNING verdict fires on the PARTIAL ≥ 3 criterion (rule applies mechanically), not because the route is making no progress. If step-iii closes in iter-018, the PARTIAL streak breaks and FBC will return CONVERGING at iter-019.

**QUOT: Route-2 entry-criteria are satisfied.** The isDefEq/whnf pathology did NOT fire in iter-017 (the memory-flagged constraint was honored throughout). The 13 axiom-clean declarations including the keystone D6 confirm that the ambient-subquotient ambient-M approach is elaboration-stable. The remaining work (finiteness encoding + P(r) induction stubs) has a concrete scouted path. UNCLEAR is the correct verdict at 1 Route-2 prover iter — but the sorry-closure pressure for iter-018 is high (see must-fix watchpoint).

**GF: OreLocalization blocker fully defused.** The prior critical watch signal (OreLocalization diamond at 2-iter threshold, 1 iter from STUCK at iter-018) was resolved exactly on schedule. L4 is the next genuine obstacle; the 2-piece decomposition (algebraic-independence descent + module-finiteness descent via `gf_clear_one_denominator` Finset-fold) is scouted in the iter-017 prover report.

---

## Overall verdict

One route CHURNING (FBC), one CONVERGING (GF), one UNCLEAR (QUOT). FBC has been at sorry-4 for four consecutive prover iters despite the iter-017 CHURNING corrective working as designed; the PARTIAL ≥ 3 criterion fires. The correct response this iter is NOT another structural escalation — the blueprint expansion (already prepared as a blueprint-writer directive) is the right move, and the FBC prover must be gated on it completing. GF is in good shape: the OreLocalization blocker was resolved on schedule, sorry dropped to 3, and 3 of 4 recent iters COMPLETE. Both FBC and GF have OVER_BUDGET throughput findings requiring STRATEGY.md estimate updates before the prover dispatches. QUOT remains UNCLEAR (1 Route-2 prover iter) with a high-pressure watchpoint: if iter-018 does not close at least 1 protected stub, the STUCK criterion fires at iter-019 without exception. Dispatch is clean (3 files, within cap, all active lanes proposed). The dominant planning risk is sequencing: both FBC and QUOT provers must be dispatched strictly after their blueprint-writers complete and the proof sketches are confirmed in the chapters.
