# Progress Critic Report

## Slug
iter021

## Iteration
021

## Routes audited

---

### Route: FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: 4 → 4 → 4 → 4 (iter-017 to iter-020). Flat across the full K=4 window. However, the sorry decomposition changed structurally in iter-020: the `fstar_reindex` assembly sorry (@~1421) is now dead code (bypassed by route swap); the live FBC-A sorry is solely `gstar_transpose` @1525 (never previously attempted); sorries @1698 and @1720 are FBC-B scope (affine reduction and `flatBaseChange_pushforward_isIso`, deliberately deferred to a later phase). Effective FBC-A working sorry count: 1 (new crux only).
- **Helper accumulation**: iter-017: +4 (sub-lemmas for fstar_reindex seam); iter-018: +1 (scaffold); iter-019: +2 (unitExpand, gammaDistribute); iter-020: refactor built `base_change_mate_domain_read` axiom-clean and rerouted `section_identity`. The iter-020 contribution is a genuine route swap, not a helper stub.
- **Recurring blockers**: "Seam-2 fstar_reindex literal-form lock" was active iters 014–019 (6 iters); BYPASSED in iter-020 by the route swap. The new crux `gstar_transpose` @1525 has **zero prior prover attempts** — no recurring blocker exists on it.
- **Avoidance patterns**: None. The single no-prover iter (iter-020) was the mandated structural corrective from the iter-020 critic ("refactor must land no later than iter-021"); one no-prover iter does not constitute an avoidance pattern (threshold ≥3 consecutive).
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, [NO PROVER — refactor] (iters 017–020).
- **Throughput**: OVER_BUDGET on original phase timeline — phase entered pre-iter-014, ≥7 iters elapsed on the FBC-A phase; original estimate was 3–4 iters. The STRATEGY.md has been updated to "Iters left = 2–3" for the post-swap crux. The new 2–3 estimate is the planner's revised post-swap figure; it is credible for a first attempt at a blueprint-complete crux. Mark as OVER_BUDGET relative to original entry but acknowledge the revised estimate.
- **Verdict**: **UNCLEAR**

The verdict rules do not cleanly resolve to CHURNING or STUCK for this route in iter-021.

- CHURNING requires "no structural change in approach" — the route swap IS a structural change (STRATEGY.md explicitly marks it "ROUTE SWAPPED iter-020"; the fstar_reindex apparatus is dead code; the proof path was rerouted through a newly built axiom-clean intermediary).
- STUCK requires "recurring blocker phrase across ≥3 iters" on the CURRENT crux — the new crux `gstar_transpose` has never been attempted and carries no prior blocker.
- CONVERGING requires "sorry count strictly decreasing" — the file-level count is flat (4→4→4→4), so CONVERGING does not apply.

UNCLEAR is the honest verdict: the structural corrective has been executed correctly and on the prescribed timeline; the new crux is genuinely fresh; there is 0 prover data on it. Dispatch the iter-021 prover and reassess at iter-022 with real prover data.

- **Primary corrective**: N/A (UNCLEAR verdict; dispatch prover as proposed).
- **Secondary note**: The dead-code `fstar_reindex` sorry (@1421) should be removed in the iter-021 refactor pass or during the prover session if the prover touches that region — leaving dead sorries inflates the file-level count and masks real progress. If it is not removed, the iter-022 critic will see 4→4→? and incorrectly weigh the dead sorry as live signal.

---

### Route: GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean`

- **Sorry trajectory**: 3 → 3 → 3 → 3 (iter-017 to iter-020). Flat for 4 iters. Underlying sorry decomposition: @754 (L4 finiteness leaf, GF-alg), @1810 (dévissage B/𝔭 obligation, depends on @754), @1898 (geometric assembly, GF-geo scope — intentionally deferred). Closing @754 cascades to eliminate @1810, reducing the file count to 1 (only the GF-geo @1898 remains, which is a later phase).
- **Helper accumulation**: iter-017: +1 (modest); iter-018: +6 (F1–F6 foundation); iter-019: +1 (isLocalization_lift_injective); iter-020: +modest (dévissage obligations). 9+ helpers added over 4 iters; 0 file-level sorries eliminated. Each helper was load-bearing for its iter, but the top-level sorry metric is flat because the dependency chain (@754 → @1810) keeps the count pinned.
- **Recurring blockers**: "L4 finiteness leaf @754 unchanged" / "deliberate budget scope-call" appears in iter-018, iter-019, and iter-020 reports (3 consecutive iters). This is the signal that triggers the STUCK rule (same deferral phrase persisting across ≥2 consecutive iters).
- **Avoidance patterns**: No off-critical-path reclassification. No consecutive plan-only iters (GF prover dispatched every iter in the window). The deferral pattern is budget-internal to GF's active session, not a route-level reclassification.
- **Prover status pattern**: PARTIAL × 4 (iters 017–020).
- **Throughput**: OVER_BUDGET — phase entered ~iter-007; ~14 iters elapsed; STRATEGY.md currently states "Iters left = 1–2." The original estimate at phase entry is not directly recoverable, but 14+ elapsed iters with "1–2 remaining" implies a total phase duration of 15–16 iters, well above any plausible original 3–5 iter estimate for GF-alg. The STRATEGY.md estimate of "1–2" is the planner's current revised figure.
- **Verdict**: **STUCK**

Two rules fire simultaneously, and STUCK is the worse:

1. *Helper accumulation + flat sorry:* helpers added in 4 of 4 iters, 0 file-level sorries eliminated across the K=4 window. CHURNING fires.
2. *Deferral phrase ≥2 iters:* "L4 finiteness leaf @754 unchanged / deliberate budget scope-call" in iters 018, 019, 020. STUCK fires.

STUCK > CHURNING: verdict is STUCK.

**Qualification**: This STUCK is a planning metric artifact, not an approach failure. The route has made genuine progress each iter (L5 closed, F1–F6 built, injectivity crux closed after 5-iter stall, dévissage 2/3 obligations closed). The @754 finiteness leaf has a concrete, verified recipe (`IsIntegral.exists_multiple_integral_of_isLocalization`, denominator-clearing fold). It has never been directly attempted. The STUCK verdict is the correct label given the rules, but the corrective is short: execute the recipe this iter.

- **Primary corrective**: **Address deferred infrastructure** — the L4 finiteness leaf @754 (`exists_localizationAway_finite_mvPolynomial`) must be proved in iter-021. No further budget deferral is permitted. The iter-021 proposal correctly targets this. The recipe is: refine `g := g0 * g1` (where `g1` clears the K[X]-coefficients of the monic integral-dependence relations via `gf_clear_one_denominator` folded over the generators), pull back the cleared monic relations through the injective `ν`, then close via `Algebra.finite_adjoin_of_finite_of_isIntegral`. If @754 closes, @1810 closes by cascade. The prover should not scope out before touching @1810.

---

### Route: QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean` (out of scope for this iter's prover)

Not assessed for a prover verdict (no prover lane proposed). The route completed its live-math leaf in iter-020 (keystone `gradedModule_hilbertSeries_rational` closed axiom-clean). Remaining 4 sorries are protected skeleton stubs (gated on QUOT-defs predicates). The iter-021 refactor plan is structurally sound and does not raise convergence concerns.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 prover lanes (FlatteningStratification.lean, FlatBaseChange.lean) + 1 refactor (QuotScheme.lean). Total prover dispatches = 2.
- **Dispatch cap**: 10 (default).
- **Over the cap**: No.
- **Ready but not dispatched**: None identified. QUOT's 4 protected stubs are not provable by a prover lane. New files (RegroupHelper.lean, GrassmannianCells.lean) are untracked scaffolds without confirmed complete blueprint chapters. No further GF-alg or FBC-A ready files are available beyond the 2 dispatched.
- **Under-dispatch finding**: No — cap is 10, 2 files dispatched, available ready lanes = 2. No gap.
- **Iter-over-iter trend**: Stable at 2 prover lanes (GF + FBC) for this iter, consistent with prior iter (iter-020: 2 lanes, GF + QUOT). No bloat.
- **Verdict**: **OK** — file count 2 within cap 10; no under-dispatch relative to ready files; no bloat.

---

## Must-fix-this-iter

- **Route GF: STUCK** — primary corrective: Address deferred infrastructure. The L4 finiteness leaf @754 must close iter-021. The iter-021 proposal correctly targets it; the must-fix is enforcement: if @754 does NOT close this iter, it must not be deferred to iter-022 again — escalate to user escalation or route pivot.
- **Route GF: OVER_BUDGET** — STRATEGY.md currently estimates "Iters left = 1–2" for GF-alg; ~14 iters have elapsed since phase entry at ~iter-007. Revise the GF-alg estimate in STRATEGY.md to reflect total elapsed + remaining, or document that the estimate was updated mid-phase due to the 5-iter injectivity stall (iter-019 resolved). A revised "0–1 iters left post-iter-021" would be honest if @754 closes.
- **Route FBC: OVER_BUDGET** — STRATEGY.md shows "Iters left = 2–3" for FBC-A; ≥7 iters elapsed since pre-iter-014 phase entry vs. 3–4 original estimate. The route swap resets the effective approach, making the current "2–3" a post-swap estimate. Document in STRATEGY.md that this "2–3" is the post-swap remaining estimate (not a continuation of the original count), so future progress-critic iterations compare elapsed against the correct baseline.

---

## Informational

**FBC dead-code sorry cleanup.** The `base_change_mate_fstar_reindex` sorry (@~1421) is now dead code (bypassed by route swap). It should be removed in iter-021 — either in the QUOT refactor pass (if that subagent touches FlatBaseChange.lean) or as a first action in the FBC prover session before tackling `gstar_transpose`. Leaving it inflates the file-level sorry count to 4 and will cause the iter-022 critic to misread the trajectory.

**GF cascade opportunity is real.** If @754 closes, @1810 closes by cascade (dévissage B/𝔭 obligation), taking the file from 3 sorries to 1. The remaining @1898 is GF-geo scope (geometric flatness assembly) — correctly deferred to a later phase. The iter-021 prover directive should explicitly state "close @754, then verify @1810 closes, then stop (do not attempt @1898 which is GF-geo)."

**FBC gstar_transpose blueprint quality.** The iter-020 blueprint reviewer rated the `lem:base_change_mate_gstar_transpose` chapter "complete and correct" with a 3-step counit-factorization recipe. This is a strong positive signal for first-attempt success. No idiom-gap risk has been identified for this crux (unlike fstar_reindex, which had the literal-form lock). Medium-high confidence estimate: `gstar_transpose` closes in 1 iter.

---

## Overall verdict

One route (GF) is **STUCK** by the deferral-language rule (L4 finiteness @754 deferred in 3 consecutive iters, 018–020); the iter-021 proposal correctly addresses it and the corrective is execution of an already-specified recipe. One route (FBC) is **UNCLEAR** — the iter-020 route swap is a genuine structural reset, and iter-021 is the first prover attempt at the new crux (`gstar_transpose`); there is 0 prover data on the new crux and no recurring blocker to report. Both routes carry OVER_BUDGET findings on their phase estimates that should be documented in STRATEGY.md. The 2-lane dispatch proposal (GF + FBC) is correctly scoped and within cap. The planner should add explicit cascade-stop language to the GF directive ("close @754 and verify @1810 cascade; do not enter @1898") and dead-code-removal language to the FBC directive, then proceed.
